extends Node
var dir_access = DirAccess.open(Global.game_location+"/saves")

func _on_resume_button_pressed() -> void:
	$"../Control/popup_layer/pause_menu".hide()
	$"../Control/popup_layer/Panel3".hide()
	get_tree().paused = false

func _on_main_menu_button_pressed() -> void:
	$"../Control/popup_layer/pause_menu".hide()
	$"../Control/popup_layer/save_confirmation_menu".show()

func _on_cancel_button_pressed() -> void:
	$"../Control/popup_layer/pause_menu".show()
	$"../Control/popup_layer/save_confirmation_menu".hide()
