extends CharacterBody2D
@export var speed = 200
var path = []
var target
var button

func _ready():
	WorldCreation.astar.cell_size = Vector2(16,16)
	WorldCreation.astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	WorldCreation.astar.region = $"../TileMap".get_used_rect()
	WorldCreation.astar.jumping_enabled = false
	WorldCreation.astar.update()

	for i in WorldCreation.world_size:
		for j in WorldCreation.world_size:
			if $"../TileMap".get_cell_tile_data(0,Vector2(i,j)).get_custom_data("walls") == true:
				WorldCreation.astar.set_point_solid(Vector2(i,j))

func _physics_process(_delta):
	if not $"../TileMap".local_to_map(position) == target and not path.is_empty():
		velocity = (target - $"../TileMap".local_to_map(position)) * speed
		move_and_slide()
		position = $"../TileMap".map_to_local(target)
	else:
		if not path.is_empty():
			target = path.pop_front()
			print(path)
			print(target)
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and button == true:
		if event.pressed:
			path = WorldCreation.astar.get_id_path($"../TileMap".local_to_map(position),$"../TileMap".local_to_map(get_global_mouse_position()))
			target = path.pop_front()
			
			print(target)

func _on_button_2_toggled(toggled_on):
	button = toggled_on
	print(button)
