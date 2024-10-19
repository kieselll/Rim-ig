extends Control

var dir_access = DirAccess.open(Global.game_location)
var file_access : FileAccess

@onready var settings = {
	"window_type" = $Tabs/Graphics/ScrollContainer/VBoxContainer/window_type/window_type_selector.selected,
	"window_resolution" = $Tabs/Graphics/ScrollContainer/VBoxContainer/window_resulotion/window_resulotion_selector.selected,
	"frame_rate_limit" = $Tabs/Graphics/ScrollContainer/VBoxContainer/frame_rate_limit/frame_rate_limit_selector.selected,
	"particle_amount" = $Tabs/Graphics/ScrollContainer/VBoxContainer/particle_amount_slider.value,
	"brightness" = $Tabs/Graphics/ScrollContainer/VBoxContainer/brightness_slider.value,
}
var json_settings

func _ready() -> void:
	if dir_access.file_exists(Global.game_location+"/options.cfg"):
		file_access = FileAccess.open(Global.game_location+"/options.cfg",FileAccess.READ)
		$Tabs/Graphics/ScrollContainer/VBoxContainer/window_type/window_type_selector.selected = JSON.parse_string(file_access.get_as_text())["window_type"]
		$Tabs/Graphics/ScrollContainer/VBoxContainer/window_resulotion/window_resulotion_selector.selected = JSON.parse_string(file_access.get_as_text())["window_resolution"]
		$Tabs/Graphics/ScrollContainer/VBoxContainer/frame_rate_limit/frame_rate_limit_selector.selected = JSON.parse_string(file_access.get_as_text())["frame_rate_limit"]
		$Tabs/Graphics/ScrollContainer/VBoxContainer/particle_amount_slider.value = JSON.parse_string(file_access.get_as_text())["particle_amount"]
		$Tabs/Graphics/ScrollContainer/VBoxContainer/brightness_slider.value = JSON.parse_string(file_access.get_as_text())["brightness"]
	else:
		$Tabs/Graphics/ScrollContainer/VBoxContainer/window_type/window_type_selector.selected = 2
		$Tabs/Graphics/ScrollContainer/VBoxContainer/window_resulotion/window_resulotion_selector.selected = 10
		$Tabs/Graphics/ScrollContainer/VBoxContainer/frame_rate_limit/frame_rate_limit_selector.selected = 1
		$Tabs/Graphics/ScrollContainer/VBoxContainer/particle_amount_slider.value = 0
		$Tabs/Graphics/ScrollContainer/VBoxContainer/brightness_slider.value = 0

func _on_save_button_pressed() -> void:
	if dir_access.file_exists(Global.game_location+"/options.cfg"):
		file_access = FileAccess.open(Global.game_location+"/options.cfg",FileAccess.READ_WRITE)
	else:
		file_access = FileAccess.open(Global.game_location+"/options.cfg",FileAccess.WRITE)
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	json_settings = JSON.stringify(settings)
	print(json_settings)
	file_access.store_string(json_settings)
	file_access.close()

func _on_cancel_button_pressed() -> void:
	file_access = FileAccess.open(Global.game_location+"/options.cfg",FileAccess.READ)
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	print(file_access.get_as_text())


func _on_window_type_selector_item_selected(index: int) -> void:
	settings["window_type"] = index

func _on_window_resulotion_selector_item_selected(index: int) -> void:
	settings["window_resolution"] = index

func _on_frame_rate_limit_selector_item_selected(index: int) -> void:
	settings["frame_rate_limit"] = index

func _on_particle_amount_slider_value_changed(value: float) -> void:
	settings["particle_amount"] = value

func _on_brightness_slider_value_changed(value: float) -> void:
	settings["brightness"] = value
