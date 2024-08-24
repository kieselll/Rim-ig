extends CharacterBody2D
@export var speed = 200
var approach_speed
var path = []
var target
var focus
var astar = AStarGrid2D.new()
var tile_data : TileData
@onready var raycast : RayCast2D = $RayCast2D
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
	approach_speed = roundi(speed / 67)
	if focus:
		raycast.target_position = focus.global_position - global_position
	if target and not $"../TileMap".local_to_map(position) == target and not path.is_empty():
		if current_state == states.IDLE or current_state == states.ALERT:
			velocity = position.direction_to($"../TileMap".map_to_local(target)) * speed
			move_and_slide()
		elif current_state == states.ATTACK:
			velocity = position.direction_to(position) * speed
			move_and_slide()
	elif not path.is_empty():
		target = path.pop_front()
	elif target != null and not position == $"../TileMap".map_to_local(target):
		position = position.move_toward($"../TileMap".map_to_local(target),approach_speed)
	else:
		if current_state == states.ATTACK: 
			path = astar.get_id_path($"../TileMap".local_to_map(position),$"../TileMap".local_to_map(position))
			position = position.move_toward($"../TileMap".map_to_local(target),approach_speed)
		if current_state == states.IDLE:
			speed = 100
			path = astar.get_id_path($"../TileMap".local_to_map(position),Vector2(randi_range($"../TileMap".local_to_map(position).x - 1,$"../TileMap".local_to_map(position).x + 1),randi_range($"../TileMap".local_to_map(position).y - 1,$"../TileMap".local_to_map(position).y + 1)))
		if current_state == states.ALERT:
			speed = 130
			if focus:
				path = astar.get_id_path($"../TileMap".local_to_map(position),$"../TileMap".local_to_map(focus.position))

func _on_area_2d_body_entered(body):
	if get_tree().get_nodes_in_group("enemies").has(body):
		print(get_tree().get_nodes_in_group("enemies"))
		print(raycast.get_collider())
		focus = body
		if get_tree().get_nodes_in_group("enemies").has(raycast.get_collider()): 
			current_state = states.ATTACK
			print("WOW")
			$alert_timer.start()
			$alert_timer.stop()

func _on_area_2d_body_exited(body):
	if get_tree().get_nodes_in_group("enemies").has(body):
		print("OH, NVM")
		current_state = states.ALERT
		$alert_timer.start()

func _on_alert_timer_timeout():
	current_state = states.IDLE
