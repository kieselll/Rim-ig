extends TileMap
var button_1 = false
var button_2 = false
var subtype = null
var noise = FastNoiseLite.new()
var click_1 = Vector2.ZERO
var click_2 = Vector2.ZERO
var selection_array = []
var filled_area

var plants : Dictionary = {
	
}

class wall_types:
	const remove = Vector2(0,0)
	const wood = Vector2(0,1)

class plant_types:
	const remove = Vector2(1,0)
	const brussels = Vector2(1,1)

class types:
	const wall = wall_types
	const plant = plant_types

func fill_area(pos_1 : Vector2i,pos_2 : Vector2i, fill : bool, layer : int, terrain_set : int, terrain : int, solid : bool):
	var fill_rect = Rect2(pos_1,pos_2 - pos_1).abs()
	var fill_array : Array
	if fill == true:
		for i in range(fill_rect.position.x,fill_rect.position.x + fill_rect.size.x + 1,1):
			for j in range(fill_rect.position.y,fill_rect.position.y + fill_rect.size.y + 1,1):
				fill_array.append(Vector2(i,j))
		set_cells_terrain_connect(layer,fill_array,terrain_set,terrain)
		$"../test_pawn".astar.fill_solid_region(fill_rect,solid)
	else:
		for i in range(fill_rect.position.x,fill_rect.position.x + fill_rect.size.x + 1,1):
			fill_array.append(Vector2(i,fill_rect.position.y))
			fill_array.append(Vector2(i,fill_rect.position.y + fill_rect.size.y))
		for i in range(fill_rect.position.y,fill_rect.position.y + fill_rect.size.y + 1,1):
			fill_array.append(Vector2(fill_rect.position.x,i))
			fill_array.append(Vector2(fill_rect.position.x + fill_rect.size.x,i))
		set_cells_terrain_connect(layer,fill_array,terrain_set,terrain)
		for i in fill_array.size():
			$"../test_pawn".astar.set_point_solid(fill_array.pop_back(),solid)
	return fill_array

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
	
func _process(delta):
	if Input.is_action_just_pressed("check"):
		print(plants[Vector2(local_to_map(get_global_mouse_position()).x,local_to_map(get_global_mouse_position()).y)])
func _input(event):
	if button_1 == true and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and WorldCreation.button_hover == false and not subtype == null:
		if event.pressed:
			click_1 = local_to_map(get_global_mouse_position())
			print(click_1)
		if not event.pressed:
			click_2 = local_to_map(get_global_mouse_position())
			print(click_2)
			if subtype.x == 0:
				if subtype.y == 1:
					fill_area(click_1,click_2,false,1,1,0,true)
				elif subtype.y == 0:
					filled_area = fill_area(click_1,click_2,true,1,1,-1,true)
					for i in filled_area.size():
						plants.erase(filled_area[i])
			elif subtype.x == 1:
				filled_area = fill_area(click_1,click_2,true,1,1,1,false)
				for i in filled_area.size():
					if not plants.has(filled_area[i]):
						plants[filled_area[i]] = 0
			click_1 = Vector2.ZERO
			click_2 = Vector2.ZERO
			selection_array = []
			filled_area = []

#region button_detection
func _on_button_2_toggled(toggled_on):
	button_2 = toggled_on
	
func _on_button_toggled(toggled_on):
	button_1 = toggled_on

func _on_woodwall_toggled(toggled_on):
	if toggled_on == true:
		subtype = types.wall.wood

func _on_wallremove_toggled(toggled_on):
	if toggled_on == true:
		subtype = types.wall.remove

func _on_brussels_planting_toggled(toggled_on):
	if toggled_on == true:
		subtype = types.plant.brussels
#endregion

#region button_hover

#endregion

func _on_crop_timer_timeout():
	print("growing")
	for i in plants.size():
		if plants[plants.keys()[i]] < 100:
			plants[plants.keys()[i]] = plants[plants.keys()[i]] + 1
		if plants[plants.keys()[i]] == 33:
			set_cell(1,plants.keys()[i],4,Vector2(1,0))
		elif plants[plants.keys()[i]] == 66 :
			set_cell(1,plants.keys()[i],4,Vector2(0,1))
		elif plants[plants.keys()[i]] == 100 :
			set_cell(1,plants.keys()[i],4,Vector2(1,1))

