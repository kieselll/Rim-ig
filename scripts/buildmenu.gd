extends ColorRect

func _on_button_toggled(toggled_on):
	if toggled_on == true:
		show()
	else:
		hide()

func _on_wall_selection_button_toggled(toggled_on):
	if toggled_on == true:
		$HBoxContainer/list_rect/wall_selection_list.show()
	else:
		$HBoxContainer/list_rect/wall_selection_list.hide()

func _on_floor_selection_button_toggled(toggled_on):
	if toggled_on == true:
		$HBoxContainer/list_rect/floor_selection_list.show()
	else:
		$HBoxContainer/list_rect/floor_selection_list.hide()

func _on_furniture_selection_buton_toggled(toggled_on):
	if toggled_on == true:
		$HBoxContainer/list_rect/furniture_selection_list.show()
	else:
		$HBoxContainer/list_rect/furniture_selection_list.hide()

func _on_workbench_selection_button_toggled(toggled_on):
	if toggled_on == true:
		$HBoxContainer/list_rect/workbench_selection_list.show()
	else:
		$HBoxContainer/list_rect/workbench_selection_list.hide()

func _on_power_selection_button_toggled(toggled_on):
	if toggled_on == true:
		$HBoxContainer/list_rect/power_selection_list.show()
	else:
		$HBoxContainer/list_rect/power_selection_list.hide()

func _on_plant_selection_button_toggled(toggled_on):
	if toggled_on == true:
		$HBoxContainer/list_rect/plants_selection_list.show()
	else:
		$HBoxContainer/list_rect/plants_selection_list.hide()
