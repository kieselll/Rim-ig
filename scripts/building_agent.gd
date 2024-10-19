extends Node

var current_item
var click_1 = null
var click_2 = null
var build_button = true
var rotate = false
var rotate_pressed = ImageTexture.create_from_image(Image.load_from_file("res://textures/ui/Untitled 08-08-2024 07-18-10 (1) (2).png"))
var rotate_not_pressed = ImageTexture.create_from_image(Image.load_from_file("res://textures/ui/Untitled 08-08-2024 07-18-10 (1) (1).png"))
@onready var tilemap = $"../TileMap"

@onready var layers : Dictionary = {
	ground = $"../TileMap/ground",
	terrain = $"../TileMap/terrain",
	walls = $"../TileMap/walls",
	light_masked = $"../TileMap/light_masked"
}

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("rotate"):
		rotate = !rotate
		print("rotated")
	if rotate == true:
		$"../Control/CanvasLayer/zoom_buttons/rotate_button".texture_normal = rotate_pressed
	else:
		$"../Control/CanvasLayer/zoom_buttons/rotate_button".texture_normal = rotate_not_pressed

func fill_area(pos_1 : Vector2i, pos_2 : Vector2i, built_object):
	var fill_rect = Rect2(pos_1,pos_2 - pos_1).abs()
	var fill_array : Array
	if built_object is Global.BuildableTerrain and built_object.filled == true:
		for i in range(fill_rect.position.x,fill_rect.position.x + fill_rect.size.x + 1):
			for j in range(fill_rect.position.y,fill_rect.position.y + fill_rect.size.y + 1): #rect area
				fill_array.append(Vector2i(i,j))
		built_object.get_layer_node(layers).set_cells_terrain_connect(fill_array, built_object.terrain_set,built_object.terrain_id)
		$"../test_pawn".astar.fill_solid_region(fill_rect, not built_object.wall)
		return fill_array
	elif built_object is Global.BuildableTerrain and built_object.filled == false:
		for i in range(fill_rect.position.x,fill_rect.position.x + fill_rect.size.x + 1,1): #vertical rect borders
			fill_array.append(Vector2(i,fill_rect.position.y))
			fill_array.append(Vector2(i,fill_rect.position.y + fill_rect.size.y))
			for j in range(fill_rect.position.y,fill_rect.position.y + fill_rect.size.y + 1,1): #horizontal rect borders
				fill_array.append(Vector2(fill_rect.position.x,j))
				fill_array.append(Vector2(fill_rect.position.x + fill_rect.size.x,j))
		built_object.get_layer_node(layers).set_cells_terrain_connect(fill_array,built_object.terrain_set,built_object.terrain_id)
		return fill_array
	elif built_object is Global.BuildableItem or built_object is Global.BuildableLightSource:
		built_object.get_layer_node(layers).set_cell(pos_2,built_object.source_id,built_object.atlas_coords)
		return pos_2

func get_rect_border_points(pos_1: Vector2, pos_2: Vector2) -> Array:
	var points = []
	var selection_rect : Rect2i = Rect2i(pos_1,pos_2 - pos_1).abs()

	for i in range(selection_rect.position.x,selection_rect.position.x + selection_rect.size.x + 1,1):
		points.append(Vector2(i,selection_rect.position.y))
		points.append(Vector2(i,selection_rect.position.y + selection_rect.size.y))
	for i in range(selection_rect.position.y + 1,selection_rect.position.y + selection_rect.size.y - 1 + 1,1):
		points.append(Vector2(selection_rect.position.x,i))
		points.append(Vector2(selection_rect.position.x + selection_rect.size.x,i))

	return points

func _input(event: InputEvent) -> void:
	var filled_array
	if click_1 and event is InputEventMouseMotion and (current_item is Global.BuildableTerrain or current_item.id == -1):
		get_tree().call_group("selection", "queue_free")
		for i in get_rect_border_points(click_1,tilemap.local_to_map(tilemap.get_global_mouse_position())):
			var sprite = Sprite2D.new()
			sprite.position = tilemap.map_to_local(i)
			sprite.texture = tilemap.selection_texture
			sprite.scale = Vector2(16,16)
			sprite.z_index = 2
			sprite.add_to_group("selection")
			add_child(sprite)
	elif (current_item is Global.BuildableItem or current_item is Global.BuildableLightSource) and click_1 and event is InputEventMouseMotion:
		get_tree().call_group("selection", "queue_free")
		var sprite = Sprite2D.new()
		sprite.position = tilemap.map_to_local(tilemap.local_to_map($"..".get_global_mouse_position()))
		sprite.texture = tilemap.selection_texture
		sprite.scale = Vector2(16,16)
		sprite.z_index = 2
		sprite.add_to_group("selection")
		add_child(sprite)
	if build_button == true and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and current_item and rotate == false:
		if event.pressed and Global.button_hover == false:
			click_1 = tilemap.local_to_map(tilemap.get_global_mouse_position())
		if not event.pressed and click_1 != null:
			get_tree().call_group("selection", "queue_free")
			click_2 = tilemap.local_to_map(tilemap.get_global_mouse_position())
			if current_item == Global.buildables.walls.remove:
				filled_array = fill_area(click_1,click_2,Global.BuildableTerrain.new(-20,false,true,"walls",true,1,-1))
				for i in filled_array:
					if get_node_or_null("../TileMap/%s" % var_to_str(i)) != null:
						get_node("../TileMap/%s" % var_to_str(i)).free()
			elif current_item == Global.buildables.terrain.remove:
				fill_area(click_1,click_2,Global.BuildableTerrain.new(-20,false,true,"terrain",true,0,-1))
			elif current_item != null:
				fill_area(click_1,click_2,current_item)
				if current_item is Global.BuildableLightSource:
					if get_node_or_null("../TileMap/%s" % var_to_str(click_2)) == null:
						var light_scene = load(current_item.light_scene).instantiate()
						$"../TileMap".add_child(light_scene)
						light_scene.position = current_item.get_layer_node(layers).map_to_local(click_2)
						light_scene.name = var_to_str($"../TileMap".local_to_map(light_scene.position))
			click_1 = null
			click_2 = null

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not Global.button_hover and rotate:
		var click = $"../TileMap".local_to_map($"../TileMap".get_global_mouse_position())
		var tile_data = $"../TileMap/walls".get_cell_tile_data(click)
		if tile_data and tile_data.get_custom_data("alternatives") > 0:
			var current_alt = $"../TileMap/walls".get_cell_alternative_tile(click)
			var next_alt = (current_alt + 1) % (tile_data.get_custom_data("alternatives") + 1)
			$"../TileMap/walls".set_cell(click, $"../TileMap/walls".get_cell_source_id(click), $"../TileMap/walls".get_cell_atlas_coords(click), next_alt)
			if Global.class_reference[tile_data.get_custom_data("class_reference")] is Global.BuildableLightSource:
				get_node("../TileMap/%s" % var_to_str(click)).rotate(Global.class_reference[tile_data.get_custom_data("class_reference")].radians_per_alternative)

func _on_build_toggle_button_toggled(toggled_on: bool) -> void:
	build_button = toggled_on

'''
func _on_crop_timer_timeout():
	for i in plants.size():
		if plants[plants.keys()[i]] < 100:
			plants[plants.keys()[i]] = plants[plants.keys()[i]] + 1
		if plants[plants.keys()[i]] == 33:
			set_cell(1,plants.keys()[i],4,Vector2(1,0))
		elif plants[plants.keys()[i]] == 66 :
			set_cell(1,plants.keys()[i],4,Vector2(0,1))
		elif plants[plants.keys()[i]] == 100 :
			set_cell(1,plants.keys()[i],4,Vector2(1,1))
			'''


func _on_wall_selection_list_item_selected(index: int) -> void:
	if index == 0:
		current_item = Global.buildables.walls.standard
	elif index == 1:
		current_item = Global.buildables.doors.regular
	elif index == 2:
		current_item = Global.buildables.doors.large
	elif index == 3:
		current_item = Global.buildables.walls.remove
	print(current_item.id)

func _on_floor_selection_list_item_selected(index: int) -> void:
	if index == 0:
		current_item = Global.buildables.terrain.pavement
	elif index == 1:
		current_item = Global.buildables.terrain.remove
	print(current_item.id)

func _on_furniture_selection_list_item_selected(index: int) -> void:
	if index == 0:
		current_item = Global.buildables.objects.furniture.chair
	elif index == 1:
		current_item = Global.buildables.objects.furniture.armchair
	elif index == 2:
		current_item = Global.buildables.objects.furniture.table
	elif index == 3:
		current_item = Global.buildables.objects.furniture.dresser
	elif index == 4:
		current_item = Global.buildables.objects.furniture.sofa
	elif index == 5:
		current_item = Global.buildables.objects.electronics.washing_machine
	elif index == 6:
		current_item = Global.buildables.objects.electronics.tv
	elif index == 7:
		current_item = Global.buildables.objects.furniture.shower
	print(current_item.id)

func _on_workbench_selection_list_item_selected(index: int) -> void:
	if index == 0:
		current_item = Global.buildables.objects.electronics.oven
	elif index == 1:
		current_item = Global.buildables.objects.electronics.pc
	print(current_item.id)


func _on_plants_selection_list_item_selected(index: int) -> void:
	if index == 0:
		current_item = Global.buildables.objects.decorations.cactus
	elif index == 1:
		current_item = Global.buildables.objects.decorations.flower
	elif index == 2:
		current_item = Global.buildables.terrain.brussells
	print(current_item.id)
