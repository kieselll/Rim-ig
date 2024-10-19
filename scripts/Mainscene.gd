extends Node2D
var saved_scene = PackedScene.new()
var dir_access = DirAccess.open("res://")
func _on_button_pressed():
	$Control/popup_layer/pause_menu.show()
	$Control/popup_layer/Panel3.show()
	get_tree().paused = true
