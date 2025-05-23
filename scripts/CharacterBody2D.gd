# Мой код ужасен. Сорри. Удачи.

# My code is terrible. Sorry. Good luck.

# ОНО ЭВОЛЮЦИОНИРУЕТ

# IT'S GETTING BETTER

extends CharacterBody2D

@export var speed = 50
@onready var state_machine = $state_machine
var moving: bool = false
@export var characteristics: PawnStats
@onready var raycast: RayCast2D = $RayCast2D
@onready var current_state = state_machine.states.IDLE
@onready var movement_component = $Movement_component
@onready var building_component = $BuildingComponent

var random_pos = null
var healthy = true
var tile_data: TileData
var path: Array
var local_position: Vector2
var front_texture = load("res://man.png")
var left_texture = load("res://man_left.png")
var back_texture = load("res://man_back.png")
var right_texture = load("res://man_right.png")
var right_front_texture = load("res://man_diag4.png")
var left_front_texture = load("res://man_diag3.png")
var right_back_texture = load("res://man_diag2.png")
var left_back_texture = load("res://man_diag.png")

@onready var layers: Dictionary = {
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

signal arrived_at_destination(coords)
signal died()

func _ready() -> void:
	$Label.text = name
	var children := get_children()

func idle_process():
	if velocity == Vector2.ZERO:
		random_pos = Vector2i(randi_range(local_position.x - 4, local_position.x + 4), randi_range(local_position.y - 4, local_position.y + 4))
		movement_component.move_to_coord(random_pos)

func rest_process():
	if $"../TileMap/walls".get_cell_tile_data(local_position).get_custom_data("can_rest") == true:
		position = $"../TileMap/walls".map_to_local(local_position)
	else:
		movement_component.move_to_nearest_tile()

func build_process(delta):
	if building_tile == null: #if there's no tile to be built
		if find_nearest_tile_coord(local_position, Global.building_queue.keys()): #if there's a path to a tile that needs to be built
			building_tile = Global.get_building_tile(find_nearest_tile_coord(local_position, Global.building_queue.keys())) #request tile
	
	
	
	
	
	
	
	
	
	if not Global.to_be_built_queue.keys().has(building_tile):
		building_tile = find_nearest_tile_coord(local_position, Global.building_queue.keys())
		if find_nearest_tile_coord(local_position, Global.building_queue.keys()):
			Global.get_building_tile(find_nearest_tile_coord(local_position, Global.building_queue.keys()))
	if building_tile:
		if get_neighbor_tiles($"../TileMap".map_to_local(building_tile)).any(func(element): return position.distance_to(element) < 0.5):
			path.clear()
			rotate_sprite(Vector2(local_position).direction_to(building_tile))
			if not Global.progressbar_tiles.any(func(tile): return Vector2(tile.map_coords) == building_tile):
				var progressbar = load("res://scenes/progressbar.tscn").instantiate()
				$"../TileMap".add_child(progressbar)
				progressbar.position = $"../TileMap".map_to_local(building_tile)
				print_rich("[color=green]Added a progressbar tile at ", building_tile, " ", Time.get_time_string_from_system(), " - [/color]", name)
				Global.progressbar_tiles.append(Global.ProgressbarTile.new(building_tile, $"../TileMap".map_to_local(building_tile), progressbar))
			if current_progress_tile:
				current_progress_tile.progressbar.change_progress((current_progress_tile.progressbar.progress + (0.25 * characteristics.abilities["building"] + 0.75) * delta / Global.to_be_built_queue[building_tile].build_time * 100))
				if current_progress_tile.progressbar:
					if current_progress_tile.progressbar.progress >= 100:
						print_rich("[color=red]Erased a progressbar tile at ", building_tile, " with progress = ", current_progress_tile.progressbar.progress, " ", Time.get_time_string_from_system(), " - [/color]", name)
						current_progress_tile.progressbar.queue_free()
						Global.progressbar_tiles.erase(current_progress_tile)
						current_progress_tile = null
						if Global.to_be_built_queue[building_tile] is Global.BuildableTerrain:
							$"../building_agent".fill_area(building_tile, building_tile, Global.BuildableTerrain.new(
							-1, false, false, 
							Global.to_be_built_queue[building_tile].layer, 
							Global.to_be_built_queue[building_tile].queued_layer, 
							true, 
							Global.to_be_built_queue[building_tile].terrain_set, 
							-1), true)
							$"../building_agent".fill_area(building_tile, building_tile, Global.to_be_built_queue[building_tile], false, true)
							Global.astar.set_point_solid(building_tile, Global.to_be_built_queue[building_tile].wall)
						elif Global.to_be_built_queue[building_tile] is Global.BuildableItem or Global.to_be_built_queue[building_tile] is Global.BuildableLightSource:
							$"../TileMap/walls_queued".erase_cell(building_tile)
							$"../building_agent".fill_area(building_tile, building_tile, Global.to_be_built_queue[building_tile], false, true)
						Global.to_be_built_queue.erase(building_tile)
			else:
				current_progress_tile = Global.progressbar_tiles[Global.progressbar_tiles.find(func(element): return element.map_coords == building_tile)]
				print_rich("[color=yellow]Got a progressbar tile at ", building_tile, " ", Time.get_time_string_from_system(), " - [/color]", name)
		if velocity == Vector2.ZERO and not get_neighbor_tiles(building_tile, true).has(local_position):
			path = Global.astar.get_id_path(local_position, find_nearest_tile_coord(local_position, get_neighbor_tiles(building_tile, true).filter(func(tile): return $"../TileMap/walls".get_cell_source_id(tile) == -1)))
		if Global.astar.get_id_path(local_position, find_nearest_tile_coord(local_position, get_neighbor_tiles(building_tile, true).filter(func(tile): return $"../TileMap/walls".get_cell_source_id(tile) == -1)), false).is_empty():
			pass

	if first_time_building == true:
		path.slice(1, 1)
		path = Global.astar.get_id_path(local_position, building_tile).slice(0, -1)
		first_time_building = false
	goto()

#func demolish_process(delta):
	#if not Global.to_be_demolished_queue.keys().has(demolition_tile):
		#demolition_tile = find_nearest_tile_coord(local_position, Global.demolition_queue.keys())
		#if find_nearest_tile_coord(local_position, Global.demolition_queue.keys()):
			#Global.get_demolition_tile(find_nearest_tile_coord(local_position, Global.demolition_queue.keys()))
	#if demolition_tile:
		#if get_neighbor_tiles($"../TileMap".map_to_local(demolition_tile)).any(func(element): return position.distance_to(element) < 0.5):
			#path.clear()
			#rotate_sprite(Vector2(local_position).direction_to(demolition_tile))
			#if not Global.progressbar_tiles.any(func(tile): return Vector2(tile.map_coords) == demolition_tile):
				#var progressbar = load("res://scenes/progressbar.tscn").instantiate()
				#$"../TileMap".add_child(progressbar)
				#progressbar.position = $"../TileMap".map_to_local(demolition_tile)
				#print_rich("[color=green]Added a progressbar tile at ", demolition_tile, " ", Time.get_time_string_from_system(), " - [/color]", name)
				#Global.progressbar_tiles.append(Global.ProgressbarTile.new(demolition_tile, $"../TileMap".map_to_local(demolition_tile), progressbar))
			#if current_progress_tile:
				#current_progress_tile.progressbar.change_progress((current_progress_tile.progressbar.progress + (0.25 * characteristics.abilities["building"] + 0.75) * delta / Global.to_be_demolished_queue[demolition_tile].build_time * 100))
				#if current_progress_tile.progressbar:
					#if current_progress_tile.progressbar.progress >= 100:
						#print_rich("[color=red]Erased a progressbar tile at ", demolition_tile, " with progress = ", current_progress_tile.progressbar.progress, " ", Time.get_time_string_from_system(), " - [/color]", name)
						#current_progress_tile.progressbar.queue_free()
						#Global.progressbar_tiles.erase(current_progress_tile) 
						#current_progress_tile = null
						#if Global.to_be_demolished_queue[demolition_tile] is Global.BuildableTerrain:
							#$"../building_agent".fill_area(demolition_tile, demolition_tile, Global.BuildableTerrain.new(
							#-1, false, false, 
							#Global.to_be_demolished_queue[demolition_tile].layer, 
							#Global.to_be_demolished_queue[demolition_tile].queued_layer, 
							#true, 
							#Global.to_be_demolished_queue[demolition_tile].terrain_set, 
							#-1), true, true)
							#$"../building_agent".fill_area(demolition_tile, demolition_tile, Global.to_be_demolished_queue[demolition_tile], false, true)
							#Global.astar.set_point_solid(demolition_tile, Global.to_be_demolished_queue[demolition_tile].wall)
						#elif Global.to_be_demolished_queue[demolition_tile] is Global.BuildableItem or Global.to_be_demolished_queue[demolition_tile] is Global.BuildableLightSource:
							#$"../TileMap/walls_queued".erase_cell(demolition_tile)
							#$"../building_agent".fill_area(demolition_tile, demolition_tile, Global.to_be_demolished_queue[demolition_tile], false, true)
						#Global.to_be_demolished_queue.erase(demolition_tile)
			#else:
				#current_progress_tile = Global.progressbar_tiles[Global.progressbar_tiles.find(func(element): return element.map_coords == demolition_tile)]
				#print_rich("[color=yellow]Got a progressbar tile at ", demolition_tile, " ", Time.get_time_string_from_system(), " - [/color]", name)
		#if velocity == Vector2.ZERO and not get_neighbor_tiles(demolition_tile, true).has(local_position):
			#path = Global.astar.get_id_path(local_position, find_nearest_tile_coord(local_position, get_neighbor_tiles(demolition_tile, true).filter(func(tile): return $"../TileMap/walls".get_cell_source_id(tile) == -1)))
		#if Global.astar.get_id_path(local_position, find_nearest_tile_coord(local_position, get_neighbor_tiles(demolition_tile, true).filter(func(tile): return $"../TileMap/walls".get_cell_source_id(tile) == -1)), false).is_empty():
			#pass
#
	#if first_time_building == true:
		#path.slice(1, 1)
		#path = Global.astar.get_id_path(local_position, demolition_tile).slice(0, -1)
		#first_time_building = false
	#goto()
#
#func knocked_process():
	#if $"../TileMap/walls".get_cell_source_id(local_position) != -1:
		#if $"../TileMap/walls".get_cell_tile_data(local_position).get_custom_data("can_heal") == true:
			#position = $"../TileMap/walls".map_to_local(local_position)
		#else:
			#if find_nearest_tile(local_position, [Global.buildables.objects.furniture.sofa]):
				#if velocity == Vector2.ZERO:
					#path = Global.astar.get_id_path(local_position, find_nearest_tile(local_position, [Global.buildables.objects.furniture.sofa]))
				#goto()
	#return


func rotate_sprite(direction: Vector2):
	if direction.angle() > -0.3839724 and direction.angle() < 0.3839724:
		$Sprite2D.texture = right_texture
	elif direction.angle() > 0.3839724 and direction.angle() < 1.16937:
		$Sprite2D.texture = right_front_texture
	elif direction.angle() > 1.16937 and direction.angle() < 1.95477:
		$Sprite2D.texture = front_texture
	elif direction.angle() > 1.95477 and direction.angle() < 2.74017:
		$Sprite2D.texture = left_front_texture
	elif direction.angle() > 2.74017 or direction.angle() < -2.74017:
		$Sprite2D.texture = left_texture
	elif direction.angle() > -2.74017 and direction.angle() < -1.95477:
		$Sprite2D.texture = left_back_texture
	elif direction.angle() > -1.95477 and direction.angle() < -1.16937:
		$Sprite2D.texture = back_texture
	elif direction.angle() > -1.16937 and direction.angle() < -0.3839724:
		$Sprite2D.texture = right_back_texture

func _physics_process(delta):
	local_position = $"../TileMap/walls".local_to_map(position)
	match current_state:
		state_machine.states.IDLE:
			idle_process()
		state_machine.states.REST:
			rest_process()
		#state_machine.states.BUILD:
			#build_process(delta)
		#state_machine.states.DEMOLISH:
			#demolish_process(delta)
		#state_machine.states.KNOCKED:
			#knocked_process()
		#state_machine.states.DEAD:
			pass
func _on_alert_timer_timeout():
	current_state = state_machine.states.IDLE
func _process(delta: float) -> void :
	if $"../TileMap/walls".get_cell_tile_data($"../TileMap/walls".local_to_map(position)) and \
	$"../TileMap/walls".get_cell_tile_data($"../TileMap/walls".local_to_map(position)).get_custom_data("can_rest") == true and \
	current_state == state_machine.states.REST:
		characteristics.stats["tiredness"] = clamp((characteristics.stats["tiredness"] - delta / 5), 0, 100)
		characteristics.stats["health"] = clamp((characteristics.stats["health"] + delta / 50), 0, 100)
	elif $"../TileMap/walls".get_cell_tile_data($"../TileMap/walls".local_to_map(position)) and \
	$"../TileMap/walls".get_cell_tile_data($"../TileMap/walls".local_to_map(position)).get_custom_data("can_heal") == true and \
	current_state == state_machine.states.UNCONCIOUS:
		characteristics.stats["tiredness"] = clamp((characteristics.stats["tiredness"] - delta / 20), 65, 100)
		characteristics.stats["health"] = clamp((characteristics.stats["health"] + delta / 15), 0, 100)
	elif current_state == state_machine.states.UNCONCIOUS:
		characteristics.stats["tiredness"] = clamp((characteristics.stats["tiredness"] - delta / 20), 65, 100)
	else:
		characteristics.stats["tiredness"] = clamp((characteristics.stats["tiredness"] + delta / 10), 0, 100)
		characteristics.stats["health"] = clamp((characteristics.stats["health"] + delta / 50), 0, 100)



func _input(event: InputEvent) -> void :
	if event is InputEventKey and Input.is_physical_key_pressed(KEY_P):
		print(characteristics.stats["tiredness"])
		print(characteristics.stats["health"])
		print($"../TileMap".local_to_map(position))
		print(path)
	elif Input.is_physical_key_pressed(KEY_U):
		characteristics.stats["health"] = 5
	elif Input.is_physical_key_pressed(KEY_K):
		characteristics.stats["health"] = 0
	elif Input.is_physical_key_pressed(KEY_KP_ADD):
		characteristics.abilities["building"] = clampi(characteristics.abilities["building"] + 1, 0, 9)
		print(characteristics.abilities["building"])
	elif Input.is_physical_key_pressed(KEY_KP_SUBTRACT):
		characteristics.abilities["building"] = clampi(characteristics.abilities["building"] - 1, 0, 9)
		print(characteristics.abilities["building"])

func _on_state_changed(state) -> void :
	match state:
		state_machine.states.IDLE:
			movement_component.speed = 50
		_:
			movement_component.speed = 75
