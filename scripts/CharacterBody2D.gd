extends CharacterBody2D
@export var speed = 1
@onready var state_machine = $state_machine
var moving : bool
var astar = AStarGrid2D.new()
var tile_data : TileData
@export var characteristics : PawnStats
@onready var raycast : RayCast2D = $RayCast2D
@onready var current_state = state_machine.states.IDLE

@onready var layers : Dictionary = {
	ground = $"../TileMap/ground",
	terrain = $"../TileMap/terrain",
	walls = $"../TileMap/walls",
	light_masked = $"../TileMap/light_masked"
}

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

func goto(from : Vector2, to : Vector2, speed : float):
	var path = astar.get_id_path(from,to,true).slice(1)
	if not path.is_empty():
		position = position.move_toward($"../TileMap/walls".map_to_local(path[0]),speed)
		if global_position == $"../TileMap/walls".map_to_local(path[0]):
			path.pop_front()

func _ready():
	astar.cell_size = Vector2(32,32)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar.region = Rect2(Vector2(0,0),Vector2(Global.world_size,Global.world_size))
	astar.jumping_enabled = true
	astar.update()

	for i in Global.world_size:
		for j in Global.world_size:
			tile_data = $"../TileMap/walls".get_cell_tile_data(Vector2(i,j))
			if tile_data:
				astar.set_point_solid(Vector2(i,j),Global.class_reference[tile_data.get_custom_data("class_reference")].wall)

func _physics_process(_delta):
	var local_position = $"../TileMap/walls".local_to_map(position)
	if current_state == state_machine.states.IDLE:
		pass
		#goto(local_position,Vector2i(randi_range(local_position.x - 4, local_position.x + 4),randi_range(local_position.y - 4, local_position.y + 4)),speed)
	elif current_state == state_machine.states.REST:
		if $"../TileMap/walls".get_cell_source_id(local_position) != -1:
			if $"../TileMap/walls".get_cell_tile_data(local_position).get_custom_data("can_rest") == true:
				position = $"../TileMap/walls".map_to_local(local_position)
		else:
			if find_nearest_tile(local_position,[Global.buildables.objects.furniture.chair,Global.buildables.objects.furniture.armchair,Global.buildables.objects.furniture.sofa]):
				goto(local_position,find_nearest_tile(local_position,[Global.buildables.objects.furniture.chair,Global.buildables.objects.furniture.armchair,Global.buildables.objects.furniture.sofa]),1)

func _on_alert_timer_timeout():
	current_state = state_machine.states.IDLE
