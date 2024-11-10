extends CharacterBody2D
@export var speed = 1
@onready var state_machine = $state_machine
var moving : bool = false
@export var characteristics : PawnStats
@onready var raycast : RayCast2D = $RayCast2D
@onready var current_state = state_machine.states.IDLE
var random_pos = null
var healthy = true
var building_tile
var tile_data : TileData
var path
var stopped = false
var build_timer = Timer.new()
var build_timer_stopped = true

@onready var layers : Dictionary = {
	ground = $"../TileMap/ground",
	terrain = $"../TileMap/terrain",
	walls = $"../TileMap/walls",
	light_masked = $"../TileMap/light_masked",
	terrain_queued = $"../TileMap/terrain_queued",
	walls_queued = $"../TileMap/walls_queued",
	light_masked_queued = $"../TileMap/light_masked_queued",
	terrain_queued_d = $"../TileMap/terrain_queued_d",
	walls_queued_d = $"../TileMap/walls_queued_d",
	light_masked_queued_d = $"../TileMap/light_masked_queued_d"
}

func _ready() -> void:
	Global.astar.cell_size = Vector2(32,32)
	Global.astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	Global.astar.region = $"../TileMap/ground".get_used_rect()
	Global.astar.jumping_enabled = false
	Global.astar.update()

	build_timer.wait_time = 2.5 * pow(0.9, characteristics.abilities["building"])
	build_timer.name = "building_timer"
	build_timer.one_shot = true
	add_child(build_timer)
	
	for i in Global.world_size:
		for j in Global.world_size:
			tile_data = $"../TileMap/walls".get_cell_tile_data(Vector2(i,j))
			if tile_data:
				Global.astar.set_point_solid(Vector2(i,j),Global.class_reference[tile_data.get_custom_data("class_reference")].wall)

func find_nearest_tile(call_coords: Vector2i, tiles: Array):
	var lengths: Array = []
	var tile_array: Array
	var tile_arrays: Array = []
	for i in range(tiles.size()):
		var layer: TileMapLayer = tiles[i].get_layer_node(layers)
		tile_array = layer.get_used_cells_by_id(tiles[i].source_id, tiles[i].atlas_coords)
		tile_arrays.append_array(tile_array)
		for j in range(tile_array.size()):
			lengths.append((tile_array[j] - call_coords).length())
	if lengths.size() > 0:
		var min_index = lengths.find(lengths.min())
		return tile_arrays[min_index]
	else:
		return null

func find_nearest_tile_coord(call_coords: Vector2i, tiles: Array):
	var lengths: Array = []
	var tile_arrays: Array = []
	for i in range(tiles.size()):
		tile_arrays.append_array(tiles)
		for j in range(tiles.size()):
			lengths.append((tiles[j] - call_coords).length())
	if lengths.size() > 0:
		var min_index = lengths.find(lengths.min())
		return tile_arrays[min_index]
	else:
		return null

func goto(speed : float):
	if not path.is_empty() and stopped == false:
		moving = true
		if moving == true:
			if $"../TileMap/walls".get_cell_atlas_coords(path[0]) == Vector2i(Global.buildables.doors.regular.atlas_coords) and $"../TileMap/walls".get_cell_source_id(path[0]) == Global.buildables.doors.regular.source_id:
				print("There is a door...")
			position = position.move_toward($"../TileMap/walls".map_to_local(path[0]),speed)
			if global_position == $"../TileMap/walls".map_to_local(path[0]):
				print(path)
				print(building_tile)
				position = Vector2(round(position.x/32)*32,round(position.y/32)*32) - Vector2(16,16)
				path.pop_front()
	else:
		moving = false

func _physics_process(_delta):
	var local_position = $"../TileMap/walls".local_to_map(position)
	if current_state == state_machine.states.IDLE:
		if random_pos == null:
			random_pos = Vector2i(randi_range(local_position.x - 4, local_position.x + 4),randi_range(local_position.y - 4, local_position.y + 4))
			path = Global.astar.get_id_path(local_position,random_pos,true).slice(1)
			goto(speed)
		if moving == true:
			goto(speed)
		if moving == false:
			random_pos = Vector2i(randi_range(local_position.x - 4, local_position.x + 4),randi_range(local_position.y - 4, local_position.y + 4))
			path = Global.astar.get_id_path(local_position,random_pos,true).slice(1)
			goto(speed)
	elif current_state == state_machine.states.REST:
		random_pos = null
		if $"../TileMap/walls".get_cell_source_id(local_position) != -1:
			if $"../TileMap/walls".get_cell_tile_data(local_position).get_custom_data("can_rest") == true:
				position = $"../TileMap/walls".map_to_local(local_position)
		else:
			if find_nearest_tile(local_position,[Global.buildables.objects.furniture.chair,Global.buildables.objects.furniture.armchair,Global.buildables.objects.furniture.sofa]):
				if moving == false:
					path = Global.astar.get_id_path(local_position,find_nearest_tile(local_position,[Global.buildables.objects.furniture.chair,Global.buildables.objects.furniture.armchair,Global.buildables.objects.furniture.sofa]))
				goto(speed)
	elif current_state == state_machine.states.BUILD:
		building_tile = find_nearest_tile_coord(local_position,Global.building_queue.keys())
		if building_tile:
			if moving == false:
				path = Global.astar.get_id_path(local_position,building_tile)
			goto(speed)
			if ([
				$"../TileMap".map_to_local(building_tile)+Vector2(32,32),
				$"../TileMap".map_to_local(building_tile)+Vector2(32,0),
				$"../TileMap".map_to_local(building_tile)+Vector2(32,-32),
				$"../TileMap".map_to_local(building_tile)+Vector2(0,32),
				$"../TileMap".map_to_local(building_tile)+Vector2(0,-32),
				$"../TileMap".map_to_local(building_tile)+Vector2(-32,32),
				$"../TileMap".map_to_local(building_tile)+Vector2(-32,0),
				$"../TileMap".map_to_local(building_tile)+Vector2(-32,-32)
				]).has(position):
				for i in [
					building_tile+Vector2i(1,1),
					building_tile+Vector2i(1,0),
					building_tile+Vector2i(1,-1),
					building_tile+Vector2i(0,1),
					building_tile+Vector2i(0,0),
					building_tile+Vector2i(0,-1),
					building_tile+Vector2i(-1,1),
					building_tile+Vector2i(-1,0),
					building_tile+Vector2i(-1,-1)
				]:
					path.erase(i)
				if build_timer_stopped:
					$building_timer.start()
					$Panel.show()
					build_timer_stopped = false
				print($building_timer.time_left)
				$Panel/Panel2.size = Vector2(-37 / $building_timer.wait_time * $building_timer.time_left + 38,4)
				if build_timer.is_stopped():
					$Panel.hide()
					if Global.building_queue[building_tile] is Global.BuildableTerrain:
						$"../building_agent".fill_area(building_tile,building_tile,Global.BuildableTerrain.new(
							-1,false,false,
							Global.building_queue[building_tile].layer,
							Global.building_queue[building_tile].queued_layer,
							true,
							Global.building_queue[building_tile].terrain_set,
							-1),true)
						$"../building_agent".fill_area(building_tile,building_tile,Global.building_queue[building_tile],false)
						Global.astar.set_point_solid(building_tile,Global.building_queue[building_tile].wall)
					elif Global.building_queue[building_tile] is Global.BuildableItem:
						$"../TileMap/walls_queued".erase_cell(building_tile)
						$"../building_agent".fill_area(building_tile,building_tile,Global.building_queue[building_tile],false)
					Global.building_queue.erase(building_tile)
					build_timer_stopped = true
	elif current_state == state_machine.states.KNOCKED:
		if $"../TileMap/walls".get_cell_source_id(local_position) != -1:
			if $"../TileMap/walls".get_cell_tile_data(local_position).get_custom_data("can_heal") == true:
				position = $"../TileMap/walls".map_to_local(local_position)
		else:
			if find_nearest_tile(local_position,[Global.buildables.objects.furniture.sofa]):
				if moving == false:
					path = Global.astar.get_id_path(local_position,find_nearest_tile(local_position,[Global.buildables.objects.furniture.sofa]))
				goto(speed)
	elif current_state == state_machine.states.DEAD:
		pass
func _on_alert_timer_timeout():
	current_state = state_machine.states.IDLE

func _process(delta: float) -> void:
	if $"../TileMap/walls".get_cell_tile_data($"../TileMap/walls".local_to_map(position)) and\
	$"../TileMap/walls".get_cell_tile_data($"../TileMap/walls".local_to_map(position)).get_custom_data("can_rest") == true and\
	current_state == state_machine.states.REST:
		characteristics.stats["tiredness"] = clamp((characteristics.stats["tiredness"] - delta/5),0,100)
		characteristics.stats["health"] = clamp((characteristics.stats["health"] + delta/50),0,100)
	elif $"../TileMap/walls".get_cell_tile_data($"../TileMap/walls".local_to_map(position)) and\
	$"../TileMap/walls".get_cell_tile_data($"../TileMap/walls".local_to_map(position)).get_custom_data("can_heal") == true and\
	current_state == state_machine.states.UNCONCIOUS:
		characteristics.stats["tiredness"] = clamp((characteristics.stats["tiredness"] - delta/20),65,100)
		characteristics.stats["health"] = clamp((characteristics.stats["health"] + delta/15),0,100)
	elif current_state == state_machine.states.UNCONCIOUS:
		characteristics.stats["tiredness"] = clamp((characteristics.stats["tiredness"] - delta/20),65,100)
	else:
		characteristics.stats["tiredness"] = clamp((characteristics.stats["tiredness"] + delta/10),0,100)
		characteristics.stats["health"] = clamp((characteristics.stats["health"] + delta/50),0,100)
	$building_timer.wait_time = 2.5 * pow(0.9, characteristics.abilities["building"])

func _input(event: InputEvent) -> void:
	if event is InputEventKey and Input.is_physical_key_pressed(KEY_P):
		print(characteristics.stats["tiredness"])
		print(characteristics.stats["health"])
		print(current_state)
		print(moving)
	elif Input.is_physical_key_pressed(KEY_U):
		characteristics.stats["health"] = 5
	elif Input.is_physical_key_pressed(KEY_K):
		characteristics.stats["health"] = 0
	elif Input.is_physical_key_pressed(KEY_O):
		stopped = !stopped
	elif Input.is_physical_key_pressed(KEY_KP_ADD):
		characteristics.abilities["building"] = clampi(characteristics.abilities["building"] + 1,0,9)
		print(characteristics.abilities["building"])
	elif Input.is_physical_key_pressed(KEY_KP_SUBTRACT):
		characteristics.abilities["building"] = clampi(characteristics.abilities["building"] - 1,0,9)
		print(characteristics.abilities["building"])
