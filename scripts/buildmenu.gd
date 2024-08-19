extends ColorRect

func _on_button_toggled(toggled_on):
	if toggled_on == true:
		show()
	else:
		hide()

func _on_wall_selection_button_toggled(toggled_on):
	if toggled_on == true:
		$grid_rect/wall_selection_grid.show()
	else:
		$grid_rect/wall_selection_grid.hide()

func _on_floor_selection_button_toggled(toggled_on):
	if toggled_on == true:
		$grid_rect/floor_selection_grid.show()
	else:
		$grid_rect/floor_selection_grid.hide()

func _on_furniture_selection_buton_toggled(toggled_on):
	if toggled_on == true:
		$grid_rect/furniture_selection_grid.show()
	else:
		$grid_rect/furniture_selection_grid.hide()

func _on_workbench_selection_button_toggled(toggled_on):
	if toggled_on == true:
		$grid_rect/worbench_selection_grid.show()
	else:
		$grid_rect/worbench_selection_grid.hide()

func _on_power_selection_button_toggled(toggled_on):
	if toggled_on == true:
		$grid_rect/power_selection_grid.show()
	else:
		$grid_rect/power_selection_grid.hide()

func _on_plant_selection_button_toggled(toggled_on):
	if toggled_on == true:
		$grid_rect/plant_selection_grid.show()
	else:
		$grid_rect/plant_selection_grid.hide()
