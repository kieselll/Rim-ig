extends TileMap
var button = false
var button2 = false
var type = "null"
var noise = FastNoiseLite.new()
var RectX = Vector2i.ZERO
var RectY = Vector2i.ZERO
func _ready():
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = randi()
	noise.frequency = 0.2

	for i in 40:
		for n in 40:
			print("loading...")
			if noise.get_noise_2d(i,n) < -0.3:
				set_cells_terrain_connect(0,[Vector2i(i,n)],0,3,false)
			elif noise.get_noise_2d(i,n) < 0.1:
				set_cells_terrain_connect(0,[Vector2i(i,n)],0,2,false)
			elif noise.get_noise_2d(i,n) < 0.5:
				set_cells_terrain_connect(0,[Vector2i(i,n)],0,1,false)
			elif noise.get_noise_2d(i,n) < 1:
				set_cells_terrain_connect(0,[Vector2i(i,n)],0,0,false)
	
func _input(event):
	if button == true:
		if type != "null":
			if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT:
					if event.pressed:
						print("click")
						RectX = local_to_map(event.position)
					elif not event.pressed:
						print("clack")
						RectY = local_to_map(event.position)
						if sign(RectX.x - RectY.x) != 0:
							print(RectX,RectY,sign(RectY.x - RectX.x))
							for x in range(RectX.x,RectY.x,sign(RectX.x - RectY.x)):
								print(x)
								if type == "Wood wall":
									print("getting the walls done")
									set_cells_terrain_connect(1,[Vector2i(RectX.y,x),Vector2i(RectY.y,x)],1,0)
func _on_button_2_toggled(toggled_on):
	button2 = toggled_on
	
func _on_button_toggled(toggled_on):
	button = toggled_on

func _on_woodwall_toggled(toggled_on):
	if toggled_on == true:
		type = "Wood wall"
	else:
		type = "null"
