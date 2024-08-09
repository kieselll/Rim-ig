extends TileMap
var button = false
var button2 = false
var type
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
	if event is InputEventMouseButton:
		for i in 1:
			if i == 0:
				RectX = map_to_local(event.position)
			else:
				RectY = map_to_local(event.position)
				for x in range(RectX.x,RectY.x,sign(RectX.x - RectY.x)):
					if type == "Wood wall":
						set_cells_terrain_connect(1,[Vector2i(RectX.y,x),Vector2i(RectY.y,x)],1,0)

func _on_button_2_toggled(toggled_on):
	button2 = toggled_on

func _on_woodwall_toggled(toggled_on):
	if toggled_on == true:
		type = "Wood wall"
	else:
		type = null
