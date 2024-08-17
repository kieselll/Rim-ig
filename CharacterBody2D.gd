extends CharacterBody2D
@export var speed = 200
var path = []
var target
var button
var approach
var astar = AStarGrid2D.new()
var tile_data : TileData
@export var current_state = states.IDLE

enum states {
	IDLE,
	ALERT,
	ATTACK
}

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
	elif target != null and not position == $"../TileMap".map_to_local(target):
		position = position.move_toward($"../TileMap".map_to_local(target),3)
	elif path.is_empty():
		if current_state == states.IDLE:
			path = astar.get_id_path($"../TileMap".local_to_map(position),Vector2(randi_range($"../TileMap".local_to_map(position).x - 4,$"../TileMap".local_to_map(position).x + 4),randi_range($"../TileMap".local_to_map(position).y - 4,$"../TileMap".local_to_map(position).y + 4)))
			target = path.pop_front()

func _on_button_2_toggled(toggled_on):
	button = toggled_on
	print(button)


func _on_area_2d_body_entered(body):
	current_state = states.ATTACK


func _on_area_2d_body_exited(body):
	current_state = states.ALERT
