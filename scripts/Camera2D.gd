extends Camera2D
@export var speed = 1000
@export var zoom_speed = 15

func _process(delta):
	if Input.is_action_pressed("up"):
		move_local_y(delta*(-1*speed)/get_zoom().x)
	if Input.is_action_pressed("left"):
		move_local_x(delta*(-1*speed)/get_zoom().x)
	if Input.is_action_pressed("right"):
		move_local_x(delta*(speed)/get_zoom().x)
	if Input.is_action_pressed("down"):
		move_local_y(delta*(speed)/get_zoom().x)
	if Input.is_action_pressed("zoom_in"):
		var mouse_position = get_global_mouse_position()
		set_zoom((get_zoom()+(Vector2(zoom_speed,zoom_speed)/1000)).clamp(Vector2(0.5,0.5),Vector2(5,5)))
		position += mouse_position - get_global_mouse_position()
	if Input.is_action_pressed("zoom_out"):
		var mouse_position = get_global_mouse_position()
		set_zoom((get_zoom()-(Vector2(zoom_speed,zoom_speed)/1000)).clamp(Vector2(0.5,0.5),Vector2(5,5)))
		position += mouse_position - get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_released():
		var mouse_position = get_global_mouse_position()
		set_zoom((get_zoom()+(Vector2(zoom_speed,zoom_speed)/50)).clamp(Vector2(0.5,0.5),Vector2(5,5)))
		position += mouse_position - get_global_mouse_position()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_released():
		var mouse_position = get_global_mouse_position()
		set_zoom((get_zoom()-(Vector2(zoom_speed,zoom_speed)/50)).clamp(Vector2(0.5,0.5),Vector2(5,5)))
		position += mouse_position - get_global_mouse_position()
