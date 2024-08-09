extends CharacterBody2D
@export var speed = 200
var astar = AStarGrid2D.new()
var path = []
var target
@onready var cells = $"../TileMap".get_used_cells_by_id(0)

func _ready():
	var current = cells.pop_back()
	astar.cell_size = Vector2(16,16)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar.region = $"../TileMap".get_used_rect()
	astar.jumping_enabled = false
	astar.update()
	for i in cells.size():
		if $"../TileMap".get_cell_tile_data(0,current).get_custom_data("walls") == true:
			astar.set_point_solid(current,true)
		current = cells.pop_back()
func _physics_process(delta):
	if path.is_empty():
		path = astar.get_id_path($"../TileMap".local_to_map(position),Vector2i(randi_range(0,astar.region.size.x),randi_range(0,astar.region.size.y)))
		target = path.pop_front()
	elif not $"../TileMap".local_to_map(position) == target:
		velocity = (target - $"../TileMap".local_to_map(position)) * speed
		move_and_slide()
	else:
		if not path.is_empty():
			for i in $"../TileMap".local_to_map(target).x - position.x:
				for j in $"../TileMap".local_to_map(target).y - position.y:
					position = Vector2(i,j)
		target = path.pop_front()
