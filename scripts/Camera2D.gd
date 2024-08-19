extends Camera2D
@export var speed = 10
@export var zoom_speed:float = 1

func _process(_delta):
	if Input.is_action_pressed("up"):
		move_local_y((-1*speed)/get_zoom().x)
	if Input.is_action_pressed("left"):
		move_local_x((-1*speed)/get_zoom().x)
	if Input.is_action_pressed("right"):
		move_local_x((speed)/get_zoom().x)
	if Input.is_action_pressed("down"):
		move_local_y((speed)/get_zoom().x)
	if Input.is_action_pressed("zoom_in"):
		set_zoom(get_zoom()+Vector2(zoom_speed,zoom_speed))
	if Input.is_action_pressed("zoom_out"):
		set_zoom(get_zoom()-Vector2(zoom_speed,zoom_speed))

