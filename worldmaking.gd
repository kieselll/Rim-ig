extends Control
func _ready():
	$MarginContainer2.hide()
	$MarginContainer3.hide()
	$MarginContainer4.hide()
	
func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")

func _on_button_pressed():
	get_tree().change_scene_to_file("res://control.tscn")

func _on_world_options_toggled(toggled_on):
	if toggled_on == true:
		$MarginContainer2.process_mode = Node.PROCESS_MODE_ALWAYS
		$MarginContainer2.show()
	else:
		$MarginContainer2.process_mode = Node.PROCESS_MODE_DISABLED
		$MarginContainer2.hide()

func _on_colonists_toggled(toggled_on):
	if toggled_on == true:
		$MarginContainer3.process_mode = Node.PROCESS_MODE_ALWAYS
		$MarginContainer3.show()
	else:
		$MarginContainer3.process_mode = Node.PROCESS_MODE_DISABLED
		$MarginContainer3.hide()

func _on_difficulty_toggled(toggled_on):
	if toggled_on == true:
		$MarginContainer4.process_mode = Node.PROCESS_MODE_ALWAYS
		$MarginContainer4.show()
	else:
		$MarginContainer4.process_mode = Node.PROCESS_MODE_DISABLED
		$MarginContainer4.hide()
