extends Node

var astar = AStarGrid2D.new()

func _ready() -> void:
	var tile_data
	astar.cell_size = Vector2(32, 32)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar.region = $"../TileMap/ground".get_used_rect()
	astar.jumping_enabled = false
	astar.update()

	for i in Global.world_size:
		for j in Global.world_size:
			tile_data = $"../TileMap/walls".get_cell_tile_data(Vector2(i, j))
			if tile_data:
				astar.set_point_solid(Vector2(i, j), Global.class_reference[tile_data.get_custom_data("class_reference")].wall)

func request_path(from : Vector2i, to : Vector2i, partial : bool):
	var path : Array = []
	assert(astar.is_in_bounds(from.x, from.y) and astar.is_in_bounds(to.x, to.y), ("Error in {name}: coordinate out of bounds").format({"name" : name}))
	path = astar.get_id_path(from, to, partial)
	return path

func mark_tile_solid(coords : Vector2i, solid : bool = true):
	astar.set_point_solid(coords, solid)
