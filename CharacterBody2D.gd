extends CharacterBody2D
@export var speed = 200
var path = []
var target
var button
var approach
var astar = AStarGrid2D.new()
var tile_data : TileData

func _ready():
	astar.cell_size = Vector2(32,32)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar.region = Rect2(Vector2(0,0),Vector2(WorldCreation.world_size,WorldCreation.world_size))
	astar.jumping_enabled = false
	astar.update()
	
	for i in WorldCreation.world_size:
		for j in WorldCreation.world_size:
			tile_data = $"../TileMap".get_cell_tile_data(1,Vector2(i,j))
			if tile_data:
				astar.set_point_solid(Vector2(i,j),tile_data.get_custom_data("walls"))

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
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and button == true and WorldCreation.button_hover == false and astar.is_point_solid($"../TileMap".local_to_map(get_global_mouse_position())) == false:
		if event.pressed:
			path = astar.get_id_path($"../TileMap".local_to_map(position),$"../TileMap".local_to_map(get_global_mouse_position()))
			path.append($"../TileMap".local_to_map(event.position))
			target = path.pop_front()

func _on_button_2_toggled(toggled_on):
	button = toggled_on
	print(button)
