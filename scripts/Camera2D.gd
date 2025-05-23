extends Camera2D
@export var speed = 1000
@export var zoom_speed = 2
var global_delta

func _process(delta):
	global_delta = delta
	if Input.is_action_pressed("up"):
		move_local_y(delta * (-1 * speed) / get_zoom().x)
	if Input.is_action_pressed("left"):
		move_local_x(delta * (-1 * speed) / get_zoom().x)
	if Input.is_action_pressed("right"):
		move_local_x(delta * (speed) / get_zoom().x)
	if Input.is_action_pressed("down"):
		move_local_y(delta * (speed) / get_zoom().x)
	if Input.is_action_pressed("zoom_in"):
		set_zoom((get_zoom() + (Vector2(zoom_speed, zoom_speed) / 1000)).clamp(Vector2(0.5, 0.5), Vector2(5, 5)))
		reset_smoothing()
	if Input.is_action_pressed("zoom_out"):
		set_zoom((get_zoom() - (Vector2(zoom_speed, zoom_speed) / 1000)).clamp(Vector2(0.5, 0.5), Vector2(5, 5)))
		reset_smoothing()

func _input(event: InputEvent) -> void :
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_released() and Global.button_hover == false:
		var zoom_tween = create_tween().set_ease(Tween.EASE_IN_OUT)
		zoom_tween.tween_property(self, "zoom", (Vector2(8, 8) - zoom) / 8, 0.1).as_relative()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_released() and Global.button_hover == false:
		var zoom_tween = create_tween().set_ease(Tween.EASE_IN_OUT)
		zoom_tween.tween_property(self, "zoom", (Vector2(0.3, 0.3) - zoom) * zoom_speed / 8, 0.1).as_relative()

func _on_control_joystick_moved(x: float, y: float) -> void :
	move_local_x(global_delta * (x * speed) / get_zoom().x)
	move_local_y(global_delta * (y * speed) / get_zoom().x)
