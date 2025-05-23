extends Node
var time = 1200
enum times_of_day{
	MORNING, 
	NOON, 
	EVENING, 
	NIGHT
}
var time_of_day: times_of_day

func check_mouse_collision(rect: Rect2):
	if rect.has_point($"..".get_local_mouse_position()):
		return true
	else:
		return false

func _ready() -> void :
	pass

func _process(delta: float) -> void :
	time = fposmod(time + delta, 2400)
	if time <= 600:
		time_of_day = times_of_day.NIGHT
		$"../fancy_thing/CanvasModulate".color = lerp(Color(0.1, 0.1, 0.15), Color(0.4, 0.35, 0.35), time / 600)
	elif time <= 1200:
		time_of_day = times_of_day.MORNING
		$"../fancy_thing/CanvasModulate".color = lerp(Color(0.4, 0.4, 0.35), Color(1, 0.9, 0.7), (time - 600) / 600)
	elif time <= 1800:
		time_of_day = times_of_day.NOON
		$"../fancy_thing/CanvasModulate".color = lerp(Color(1, 0.9, 0.7), Color(1, 1, 1), (time - 1200) / 600)
	elif time <= 2400:
		time_of_day = times_of_day.EVENING
		$"../fancy_thing/CanvasModulate".color = lerp(Color(1, 1, 1), Color(0.1, 0.1, 0.15), (time - 1800) / 600)

	$"../Control/CanvasLayer/fps".text = str(Engine.get_frames_per_second())

	if check_mouse_collision(Rect2($"../Control/CanvasLayer/selection_buttons_rect".position, $"../Control/CanvasLayer/selection_buttons_rect".size))\
or check_mouse_collision(Rect2($"../Control/CanvasLayer/selection_buttons_rect/HBoxContainer/list_rect".position, $"../Control/CanvasLayer/selection_buttons_rect/HBoxContainer/list_rect".size))\
or check_mouse_collision(Rect2($"../Control/CanvasLayer/ui_buttons".position, $"../Control/CanvasLayer/ui_buttons".size))\
or check_mouse_collision($"../Control/CanvasLayer/joystick_container/Control/Sprite2D2".get_rect()):
		Global.button_hover = true
	elif OS.get_name() == "Android":
		if check_mouse_collision(Rect2($"../Control/CanvasLayer/movement_buttons".position, $"../Control/CanvasLayer/movement_buttons".size))\
or check_mouse_collision(Rect2($"../Control/CanvasLayer/zoom_buttons".position, $"../Control/CanvasLayer/zoom_buttons".size))\
or check_mouse_collision(Rect2($"../Control/CanvasLayer/joystick_container/Control/Sprite2D2".position, $"../Control/CanvasLayer/joystick_container/Control/Sprite2D2".size)):
			Global.button_hover = true
	else:
		Global.button_hover = false
