extends Control
func _ready():
	$ColorRect/HBoxContainer/Container3/VBoxContainer.show()
	$ColorRect/HBoxContainer/Container3/VBoxContainer2.hide()
	$ColorRect/HBoxContainer/Container3/VBoxContainer3.hide()
	
func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/control.tscn")

func _on_world_options_toggled(toggled_on):
	if toggled_on == true:
		$ColorRect/HBoxContainer/Container3/VBoxContainer.process_mode = Node.PROCESS_MODE_ALWAYS
		$ColorRect/HBoxContainer/Container3/VBoxContainer.show()
	else:
		$ColorRect/HBoxContainer/Container3/VBoxContainer.process_mode = Node.PROCESS_MODE_DISABLED
		$ColorRect/HBoxContainer/Container3/VBoxContainer.hide()

func _on_colonists_toggled(toggled_on):
	if toggled_on == true:
		$ColorRect/HBoxContainer/Container3/VBoxContainer2.process_mode = Node.PROCESS_MODE_ALWAYS
		$ColorRect/HBoxContainer/Container3/VBoxContainer2.show()
	else:
		$ColorRect/HBoxContainer/Container3/VBoxContainer2.process_mode = Node.PROCESS_MODE_DISABLED
		$ColorRect/HBoxContainer/Container3/VBoxContainer2.hide()

func _on_difficulty_toggled(toggled_on):
	if toggled_on == true:
		$ColorRect/HBoxContainer/Container3/VBoxContainer3.process_mode = Node.PROCESS_MODE_ALWAYS
		$ColorRect/HBoxContainer/Container3/VBoxContainer3.show()
	else:
		$ColorRect/HBoxContainer/Container3/VBoxContainer3.process_mode = Node.PROCESS_MODE_DISABLED
		$ColorRect/HBoxContainer/Container3/VBoxContainer3.hide()


func _on_h_slider_value_changed(value):
	WorldCreation.world_size = value
