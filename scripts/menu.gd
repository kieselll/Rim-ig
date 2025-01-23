extends Control
var previous_position : Vector2i
var window_velocity

func _ready() -> void:
	get_window().title = "Radioid: Main menu"

func _process(delta: float) -> void:
	$Node2D/right_border.position.x = get_window().size.x
	$Node2D/bottom_border.position.y = get_window().size.y
	window_velocity = ((get_window().position - previous_position)/delta)*-0.7
	previous_position = get_window().position
	
	$Node2D/RigidBody2D.apply_central_force(window_velocity)
	$Node2D/RigidBody2D2.apply_central_force(window_velocity)
	$Node2D/RigidBody2D3.apply_central_force(window_velocity)
	$Node2D/RigidBody2D4.apply_central_force(window_velocity)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/worldmaking.tscn")

func _on_button_3_pressed():
	get_tree().quit()

func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://scenes/options.tscn")

func _on_button_mouse_entered() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button,"scale",Vector2(1.2,1.2),0.3).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button,"position",$MarginContainer/CanvasLayer/VBoxContainer/Button.position - Vector2(11,2.7),0.3).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button.get_theme_stylebox("normal"),"bg_color",Color("86c900"),0.3)

func _on_button_mouse_exited() -> void:
	var tween = create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button,"scale",Vector2(1,1),0.3).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button,"position",Vector2(0,31),0.3).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button.get_theme_stylebox("normal"),"bg_color",Color("1a1a1a"),0.3)

func _on_button_2_mouse_entered() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button2,"scale",Vector2(1.2,1.2),0.3).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button2,"position",$MarginContainer/CanvasLayer/VBoxContainer/Button2.position - Vector2(11,2.7),0.3).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button2.get_theme_stylebox("normal"),"bg_color",Color("86c900"),0.3)

func _on_button_2_mouse_exited() -> void:
	var tween = create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button2,"scale",Vector2(1,1),0.3).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button2,"position",Vector2(0,62),0.3).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button2.get_theme_stylebox("normal"),"bg_color",Color("1a1a1a"),0.3)

func _on_button_3_mouse_entered() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button3,"scale",Vector2(1.2,1.2),0.3).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button3,"position",$MarginContainer/CanvasLayer/VBoxContainer/Button3.position - Vector2(11,2.7),0.3).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button3.get_theme_stylebox("normal"),"bg_color",Color("90000e"),0.3)

func _on_button_3_mouse_exited() -> void:
	var tween = create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button3,"scale",Vector2(1,1),0.3).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button3,"position",Vector2(0,93),0.3).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button3.get_theme_stylebox("normal"),"bg_color",Color("1a1a1a"),0.3)

func _on_button_4_mouse_entered() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button4,"scale",Vector2(1.2,1.2),0.3).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button4,"position",$MarginContainer/CanvasLayer/VBoxContainer/Button4.position - Vector2(11,2.7),0.3).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button4.get_theme_stylebox("normal"),"bg_color",Color("86c900"),0.3)

func _on_button_4_mouse_exited() -> void:
	var tween = create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button4,"scale",Vector2(1,1),0.3).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button4,"position",Vector2(0,0),0.3).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property($MarginContainer/CanvasLayer/VBoxContainer/Button4.get_theme_stylebox("normal"),"bg_color",Color("1a1a1a"),0.3)
