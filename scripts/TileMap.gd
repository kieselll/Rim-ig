extends TileMap
@onready var button_1 = $"../Control/CanvasLayer/ui_buttons/build_toggle_button".button_pressed
@onready var button_2 = $"../Control/CanvasLayer/ui_buttons/colonists_button_toggle".button_pressed
var subtype = null
var selection_array = []
var filled_area
var os_name = OS.get_name()
var selection_texture = preload("res://textures/tilesets/selection_tile.png")

func check_mouse_collision(node : Node):
	var node_rect = Rect2(Vector2(0,0),node.size)
	if node_rect.has_point(node.get_local_mouse_position()):
		return true
	else:
		return false

func _process(_delta):
	if check_mouse_collision($"../Control/CanvasLayer/selection_buttons_rect")\
	or check_mouse_collision($"../Control/CanvasLayer/selection_buttons_rect/HBoxContainer/list_rect")\
	or check_mouse_collision($"../Control/CanvasLayer/ui_buttons"):
		Global.button_hover = true
	elif os_name == "Android":
		if check_mouse_collision($"../Control/CanvasLayer/movement_buttons")\
		or check_mouse_collision($"../Control/CanvasLayer/zoom_buttons"):
			Global.button_hover = true
	else:
		Global.button_hover = false
