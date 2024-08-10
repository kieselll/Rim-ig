extends TileMap
var button_1 = false
var button_2 = false
var type = "null"
var subtype = "null"
var noise = FastNoiseLite.new()
var click_1 = Vector2.ZERO
var click_2 = Vector2.ZERO
var selection_array = []
var button_hover = false

func _ready():
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.seed = randi()
	noise.frequency = 0.2

	for i in WorldCreation.world_size:
		for n in WorldCreation.world_size:
			if noise.get_noise_2d(i,n) < -0.3:
				set_cells_terrain_connect(0,[Vector2i(i,n)],0,3,false)
			elif noise.get_noise_2d(i,n) < -0.1:
				set_cells_terrain_connect(0,[Vector2i(i,n)],0,2,false)
			elif noise.get_noise_2d(i,n) < 0.7:
				set_cells_terrain_connect(0,[Vector2i(i,n)],0,1,false)
			elif noise.get_noise_2d(i,n) < 1:
				set_cells_terrain_connect(0,[Vector2i(i,n)],0,0,false)
	
func _input(event):
	if button_1 == true and type == "wall" and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and button_hover == false:
		if event.pressed:
			click_1 = local_to_map(get_global_mouse_position())
		if not event.pressed:
			click_2 = local_to_map(get_global_mouse_position())

			if subtype == "wood_wall":

				if sign(click_2.x - click_1.x) != 0 and sign(click_2.y - click_1.y) != 0:
					for i in range(click_1.x,click_2.x + sign(click_2.x - click_1.x),sign(click_2.x - click_1.x)):
						selection_array.append(Vector2(i,click_1.y))
						selection_array.append(Vector2(i,click_2.y))
					for i in range(click_1.y,click_2.y,sign(click_2.y - click_1.y)):
						selection_array.append(Vector2(click_1.x,i))
						selection_array.append(Vector2(click_2.x,i))
						set_cells_terrain_connect(1,selection_array,1,0)

				elif sign(click_2.x - click_1.x) == 0 and sign(click_2.y - click_1.y) != 0:
					for i in range(click_1.y,click_2.y + sign(click_2.y - click_1.y),sign(click_2.y - click_1.y)):
						selection_array.append(Vector2(click_1.x,i))
						selection_array.append(Vector2(click_2.x,i))
						set_cells_terrain_connect(1,selection_array,1,0)

				elif sign(click_2.y - click_1.y) == 0 and sign(click_2.x - click_1.x) != 0:
					for i in range(click_1.x,click_2.x + sign(click_2.x - click_1.x),sign(click_2.x - click_1.x)):
						selection_array.append(Vector2(i,click_1.y))
						selection_array.append(Vector2(i,click_2.y))
						set_cells_terrain_connect(1,selection_array,1,0)

				else:
					set_cells_terrain_connect(1,[click_1],1,0)
				for i in selection_array.size():
					WorldCreation.astar.set_point_solid(selection_array.pop_back())

			elif subtype == "remove":
				if sign(click_2.x - click_1.x) != 0 and sign(click_2.y - click_1.y) != 0:
					for i in range(click_1.x,click_2.x + sign(click_2.x - click_1.x),sign(click_2.x - click_1.x)):
						for j in range(click_1.y,click_2.y + sign(click_2.y - click_1.y),sign(click_2.y - click_1.y)):
							selection_array.append(Vector2(i,j))
					set_cells_terrain_connect(1,selection_array,1,-1)

				elif sign(click_2.x - click_1.x) == 0 and sign(click_2.y - click_1.y) != 0:
					for i in range(click_1.y,click_2.y + sign(click_2.y - click_1.y),sign(click_2.y - click_1.y)):
						selection_array.append(Vector2(click_1.x,i))
					set_cells_terrain_connect(1,selection_array,1,-1)

				elif sign(click_2.x - click_1.x) != 0 and sign(click_2.y - click_1.y) == 0:
					for i in range(click_1.x,click_2.x + sign(click_2.x - click_1.x),sign(click_2.x - click_1.x)):
						selection_array.append(Vector2(i,click_1.y))
					set_cells_terrain_connect(1,selection_array,1,-1)

				else:
					set_cells_terrain_connect(1,[click_1],1,-1)
			click_1 = Vector2.ZERO
			click_2 = Vector2.ZERO
			selection_array = []

func _on_button_2_toggled(toggled_on):
	button_2 = toggled_on
	
func _on_button_toggled(toggled_on):
	button_1 = toggled_on

func _on_woodwall_toggled(toggled_on):
	if toggled_on == true:
		type = "wall"
		subtype = "wood_wall"
	else:
		type = "null"
		subtype = "null"

func _on_wallremove_toggled(toggled_on):
	if toggled_on == true:
		type = "wall"
		subtype = "remove"
	else:
		type = "null"
		subtype = "null"


func _on_color_rect_mouse_entered():
	button_hover = true

func _on_color_rect_mouse_exited():
	button_hover = false

func _on_color_rect_2_mouse_entered():
	button_hover = true

func _on_color_rect_2_mouse_exited():
	button_hover = false
