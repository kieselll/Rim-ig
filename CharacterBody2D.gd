extends CharacterBody2D
@export var speed = 200
var path = []
var target
var button
var approach

func _ready():
	WorldCreation.astar.cell_size = Vector2(16,16)
	WorldCreation.astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	WorldCreation.astar.region = $"../TileMap".get_used_rect()
	WorldCreation.astar.jumping_enabled = false
	WorldCreation.astar.update()

func _physics_process(_delta):
	if not $"../TileMap".local_to_map(position) == target and not path.is_empty():
		velocity = position.direction_to($"../TileMap".map_to_local(target)) * speed
		move_and_slide()
	elif not path.is_empty():
		target = path.pop_front()
		print(path)
		print(target)
	else:
		if target != null and not position == $"../TileMap".map_to_local(target):
			position = position.move_toward($"../TileMap".map_to_local(target),3)
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and button == true:
		if event.pressed:
			path = WorldCreation.astar.get_id_path($"../TileMap".local_to_map(position),$"../TileMap".local_to_map(get_global_mouse_position()))
			path.append($"../TileMap".local_to_map(event.position))
			target = path.pop_front()
			
			print(target)

func _on_button_2_toggled(toggled_on):
	button = toggled_on
	print(button)
