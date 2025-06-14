extends Node2D

@export var x_value: float
@export var y_value: float
var joystick_index = null
signal joystick_moved(x: float, y: float)

func _process(delta: float) -> void :
	x_value = (($Sprite2D.position - $Sprite2D2.position) / 64).x
	y_value = (($Sprite2D.position - $Sprite2D2.position) / 64).y
	if x_value != 0 and y_value != 0:
		joystick_moved.emit(x_value, y_value)

func _input(event: InputEvent) -> void :
	if event is InputEventScreenDrag:
		if joystick_index == event.index:
			if get_local_mouse_position().distance_to($Sprite2D2.position) < 64:
				$Sprite2D.position = event.position - $Sprite2D2.global_position
			elif joystick_index == event.index:
				$Sprite2D.position = $Sprite2D2.position + $Sprite2D2.global_position.direction_to(event.position) * 64
	if event is InputEventScreenTouch:
		if event.is_pressed():
			if get_local_mouse_position().distance_to($Sprite2D2.position) < 64:
				joystick_index = event.index
		if not event.is_pressed():
			$Sprite2D.position = $Sprite2D2.position
			joystick_index = null
