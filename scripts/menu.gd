extends Control
var previous_position: Vector2i
var window_velocity
var fade_in_tween
var fade_out_tween

func _ready() -> void :
	get_window().title = "Radioid: Main menu"
	fade_in_tween = create_tween().set_ease(Tween.EASE_IN)
	fade_in_tween.tween_property($MarginContainer / CanvasLayer / ColorRect2, "color", Color(0, 0, 0, 0), 1.0).from(Color(0, 0, 0, 1))

func _process(delta: float) -> void :
	$Node2D / right_border.position.x = get_window().size.x - 26
	$Node2D / bottom_border.position.y = get_window().size.y - 24
	window_velocity = ((get_window().position - previous_position) / delta) * -0.4
	previous_position = get_window().position

	$Node2D / RigidBody2D.apply_central_force(window_velocity)
	$Node2D / RigidBody2D2.apply_central_force(window_velocity)
	$Node2D / RigidBody2D3.apply_central_force(window_velocity)
	$Node2D / RigidBody2D4.apply_central_force(window_velocity)
	$Node2D / RigidBody2D5.apply_central_force(window_velocity)
	$Node2D / RigidBody2D6.apply_central_force(window_velocity)

func animate_button(button: Button, scale: Vector2, position: Vector2, color: Color) -> void :
	var tween = create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(button, "scale", scale, 0.3).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(button, "position", position, 0.3).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(button.get_theme_stylebox("normal"), "bg_color", color, 0.3)

func _on_button_pressed():
	fade_out_tween = create_tween().set_ease(Tween.EASE_OUT)
	fade_out_tween.tween_property($MarginContainer / CanvasLayer / ColorRect2, "color", Color(0, 0, 0, 1), 1.0).from(Color(0, 0, 0, 0))
	await fade_out_tween.finished
	get_tree().change_scene_to_file("res://scenes/worldmaking.tscn")

func _on_button_3_pressed():
	fade_out_tween = create_tween().set_ease(Tween.EASE_OUT)
	fade_out_tween.tween_property($MarginContainer / CanvasLayer / ColorRect2, "color", Color(0, 0, 0, 1), 1.0).from(Color(0, 0, 0, 0))
	await fade_out_tween.finished
	get_tree().quit()

func _on_button_2_pressed():
	fade_out_tween = create_tween().set_ease(Tween.EASE_OUT)
	fade_out_tween.tween_property($MarginContainer / CanvasLayer / ColorRect2, "color", Color(0, 0, 0, 1), 1.0).from(Color(0, 0, 0, 0))
	await fade_out_tween.finished
	get_tree().change_scene_to_file("res://scenes/options.tscn")

func _on_button_mouse_entered() -> void :
	animate_button($MarginContainer / CanvasLayer / VBoxContainer / Button, Vector2(1.2, 1.2), $MarginContainer / CanvasLayer / VBoxContainer / Button.position - Vector2(11, 2.7), Color("86c900"))

func _on_button_mouse_exited() -> void :
	animate_button($MarginContainer / CanvasLayer / VBoxContainer / Button, Vector2(1, 1), Vector2(0, 31), Color("1a1a1a"))

func _on_button_2_mouse_entered() -> void :
	animate_button($MarginContainer / CanvasLayer / VBoxContainer / Button2, Vector2(1.2, 1.2), $MarginContainer / CanvasLayer / VBoxContainer / Button2.position - Vector2(11, 2.7), Color("86c900"))

func _on_button_2_mouse_exited() -> void :
	animate_button($MarginContainer / CanvasLayer / VBoxContainer / Button2, Vector2(1, 1), Vector2(0, 62), Color("1a1a1a"))

func _on_button_3_mouse_entered() -> void :
	animate_button($MarginContainer / CanvasLayer / VBoxContainer / Button3, Vector2(1.2, 1.2), $MarginContainer / CanvasLayer / VBoxContainer / Button3.position - Vector2(11, 2.7), Color("90000e"))

func _on_button_3_mouse_exited() -> void :
	animate_button($MarginContainer / CanvasLayer / VBoxContainer / Button3, Vector2(1, 1), Vector2(0, 93), Color("1a1a1a"))

func _on_button_4_mouse_entered() -> void :
	animate_button($MarginContainer / CanvasLayer / VBoxContainer / Button4, Vector2(1.2, 1.2), $MarginContainer / CanvasLayer / VBoxContainer / Button4.position - Vector2(11, 2.7), Color("86c900"))

func _on_button_4_mouse_exited() -> void :
	animate_button($MarginContainer / CanvasLayer / VBoxContainer / Button4, Vector2(1, 1), Vector2(0, 0), Color("1a1a1a"))
