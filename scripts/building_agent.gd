extends Node

var current_item
var click_1 = null
var click_2 = null
var build_button = true
var rotate = false
var rotate_pressed = load("res://textures/ui/Untitled 08-08-2024 07-18-10 (1) (2).png")
var rotate_not_pressed = load("res://textures/ui/Untitled 08-08-2024 07-18-10 (1) (1).png")
@onready var tilemap = $"../TileMap"
var filled_array
var touch_event
var motion_event

@onready var layers: Dictionary = {
	ground = $"../TileMap/ground", 
	terrain = $"../TileMap/terrain", 
	walls = $"../TileMap/walls", 
	light_masked = $"../TileMap/light_masked", 
	terrain_queued = $"../TileMap/terrain_queued", 
	walls_queued = $"../TileMap/walls_queued", 
	light_masked_queued = $"../TileMap/light_masked_queued", 
	terrain_queued_d = $"../TileMap/terrain_queued_d", 
	walls_queued_d = $"../TileMap/walls_queued_d", 
	light_masked_queued_d = $"../TileMap/light_masked_queued_d"
}

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("rotate"):
		rotate = !rotate
	if rotate == true:
		$"../Control/CanvasLayer/zoom_buttons/rotate_button".texture_normal = rotate_pressed
	else:
		$"../Control/CanvasLayer/zoom_buttons/rotate_button".texture_normal = rotate_not_pressed


func fill_area(pos_1: Vector2i, pos_2: Vector2i, built_object, queued: bool, auto: bool = false):
	var fill_rect = Rect2(pos_1, pos_2 - pos_1).abs()
	var fill_array: Array = []
	if built_object is Global.BuildableTerrain and built_object.filled == true:
		for i in range(fill_rect.position.x, fill_rect.position.x + fill_rect.size.x + 1):
			for j in range(fill_rect.position.y, fill_rect.position.y + fill_rect.size.y + 1):
				fill_array.append(Vector2(i, j))
		if built_object.id == -1 and not auto:
			fill_array = fill_array.filter(func(tile): return not ($"../TileMap/ground".get_cell_tile_data(tile).get_custom_data("can_build_on") and built_object.get_layer_node(layers).get_cell_source_id(tile) == -1))
			print(fill_array)
		elif not auto:
			fill_array = fill_array.filter(func(tile): return $"../TileMap/ground".get_cell_tile_data(tile).get_custom_data("can_build_on") and built_object.get_layer_node(layers).get_cell_source_id(tile) == -1)
		if queued:
			if built_object.id == -1 and not auto:
				get_node("../TileMap/" + built_object.layer + "_queued_d").set_cells_terrain_connect(fill_array, built_object.terrain_set, 0)
			elif built_object.id == -1:
				get_node("../TileMap/" + built_object.layer + "_queued_d").set_cells_terrain_connect(fill_array, 1, -1)
			else:
				built_object.get_queued_layer_node(layers).set_cells_terrain_connect(fill_array, built_object.terrain_set, built_object.terrain_id)
		else:
			built_object.get_layer_node(layers).set_cells_terrain_connect(fill_array, built_object.terrain_set, built_object.terrain_id)
		Global.astar.fill_solid_region(fill_rect, not built_object.wall)
		return fill_array

	elif built_object is Global.BuildableTerrain and not built_object.filled:
		for i in range(fill_rect.position.x, fill_rect.position.x + fill_rect.size.x + 1):
			fill_array.append(Vector2(i, fill_rect.position.y))
			fill_array.append(Vector2(i, fill_rect.position.y + fill_rect.size.y))
		for j in range(fill_rect.position.y, fill_rect.position.y + fill_rect.size.y + 1):
			fill_array.append(Vector2(fill_rect.position.x, j))
			fill_array.append(Vector2(fill_rect.position.x + fill_rect.size.x, j))
		fill_array = fill_array.filter(func(tile): return $"../TileMap/ground".get_cell_tile_data(tile).get_custom_data("can_build_on") and built_object.get_layer_node(layers).get_cell_source_id(tile) == -1)
		if queued:
			if built_object == Global.buildables.walls.remove:
				get_node("../TileMap/" + built_object.layer + "_queued_d").set_cells_terrain_connect(fill_array, built_object.terrain_set, 0)
			elif built_object == Global.buildables.terrain.remove:
				get_node("../TileMap/" + built_object.layer + "_queued_d").set_cells_terrain_connect(fill_array, built_object.terrain_set, 1)
			else:
				built_object.get_queued_layer_node(layers).set_cells_terrain_connect(fill_array, built_object.terrain_set, built_object.terrain_id)
		else:
			built_object.get_layer_node(layers).set_cells_terrain_connect(fill_array, built_object.terrain_set, built_object.terrain_id)
		return fill_array

	elif built_object is Global.BuildableItem or built_object is Global.BuildableLightSource:
		if $"../TileMap/ground".get_cell_tile_data(pos_2).get_custom_data("can_build_on") and built_object.get_layer_node().get_cell_source_id(pos_2) == -1:
			if queued:
				built_object.get_queued_layer_node(layers).set_cell(pos_2, built_object.source_id, built_object.atlas_coords)
			else:
				built_object.get_layer_node(layers).set_cell(pos_2, built_object.source_id, built_object.atlas_coords)
		return [pos_2]

func get_rect_border_points(pos_1: Vector2, pos_2: Vector2) -> Array:
	var points = []
	var selection_rect: Rect2i = Rect2i(pos_1, pos_2 - pos_1).abs()
	for i in range(selection_rect.position.x, selection_rect.position.x + selection_rect.size.x + 1, 1):
		points.append(Vector2(i, selection_rect.position.y))
		points.append(Vector2(i, selection_rect.position.y + selection_rect.size.y))
	for i in range(selection_rect.position.y + 1, selection_rect.position.y + selection_rect.size.y - 1 + 1, 1):
		points.append(Vector2(selection_rect.position.x, i))
		points.append(Vector2(selection_rect.position.x + selection_rect.size.x, i))

	return points

func _input(event: InputEvent) -> void :
	if event is InputEventMouseMotion:
		handle_mouse_motion()
	elif event is InputEventMouseButton:
		handle_mouse_button(event)

func handle_mouse_motion() -> void :
	if click_1:
		get_tree().call_group("selection", "queue_free")
		if current_item is Global.BuildableTerrain or current_item.id == -1:
			for i in get_rect_border_points(click_1, tilemap.local_to_map(tilemap.get_global_mouse_position())):
				create_selection_sprite(i)
		elif current_item is Global.BuildableItem or current_item is Global.BuildableLightSource:
			create_selection_sprite(tilemap.local_to_map(tilemap.get_global_mouse_position()))

func create_selection_sprite(position: Vector2) -> void :
	var sprite = Sprite2D.new()
	sprite.position = tilemap.map_to_local(position)
	sprite.texture = tilemap.selection_texture
	sprite.scale = Vector2(16, 16)
	sprite.z_index = 2
	sprite.add_to_group("selection")
	add_child(sprite)

func handle_mouse_button(event: InputEventMouseButton) -> void :
	if event.button_index == MOUSE_BUTTON_LEFT:
		if build_button and current_item and not rotate:
			if event.pressed and not Global.button_hover:
				click_1 = tilemap.local_to_map(tilemap.get_global_mouse_position()).clamp(
					$"../TileMap/ground".get_used_rect().position, 
					$"../TileMap/ground".get_used_rect().size
				)
			elif not event.pressed and click_1:
				click_2 = tilemap.local_to_map(tilemap.get_global_mouse_position()).clamp(
					$"../TileMap/ground".get_used_rect().position, 
					$"../TileMap/ground".get_used_rect().size
				)
				process_click_area()
				reset_clicks()
		elif event.pressed and not Global.button_hover and rotate:
			handle_rotation()

func process_click_area() -> void :
	get_tree().call_group("selection", "queue_free")
	filled_array = fill_area(click_1, click_2, current_item, true, false)
	if current_item == Global.buildables.walls.remove:
		handle_wall_removal(filled_array)
		print("         WALL REMOVAL         ")
	elif current_item == Global.buildables.terrain.remove:
		handle_terrain_removal(filled_array)
		print("         TERRAIN REMOVAL         ")
	else:
		handle_building(filled_array)

func handle_wall_removal(_filled_array: Array) -> void :
	for i in _filled_array:
		var node_path = "../TileMap/%s" % var_to_str(i)
		if get_node_or_null(node_path):
			get_node(node_path).free()
		Global.demolition_queue[i] = Global.buildables.walls.remove

func handle_terrain_removal(_filled_array: Array) -> void :
	for i in _filled_array:
		Global.demolition_queue[i] = Global.buildables.terrain.remove

func handle_building(_filled_array: Array) -> void :
	for i in _filled_array:
		Global.building_queue[i] = current_item
	if current_item is Global.BuildableLightSource:
		var click_pos_str = var_to_str(click_2)
		if get_node_or_null("../TileMap/%s" % click_pos_str) == null:
			var light_scene = load(current_item.light_scene).instantiate()
			$"../TileMap".add_child(light_scene)
			light_scene.position = current_item.get_layer_node(layers).map_to_local(click_2)
			light_scene.name = var_to_str($"../TileMap".local_to_map(light_scene.position))


func handle_rotation() -> void :
	var click = $"../TileMap".local_to_map($"../TileMap".get_global_mouse_position())
	var tile_data = $"../TileMap/walls".get_cell_tile_data(click)
	if tile_data:
		var current_rot = $"../TileMap/walls".get_cell_atlas_coords(click)
		var next_rot = Global.class_reference[tile_data.get_custom_data("class_reference")].rotations[wrapi(Global.class_reference[tile_data.get_custom_data("class_reference")].rotations.find(current_rot) + 1, 0, Global.class_reference[tile_data.get_custom_data("class_reference")].rotations.size())]
		$"../TileMap/walls".set_cell(click, $"../TileMap/walls".get_cell_source_id(click), next_rot)
		if Global.class_reference[tile_data.get_custom_data("class_reference")] is Global.BuildableLightSource:
			get_node("../TileMap/%s" % var_to_str(click)).rotate(Global.class_reference[tile_data.get_custom_data("class_reference")].radians_per_alternative)

func reset_clicks() -> void :
	click_1 = null
	click_2 = null

func _on_build_toggle_button_toggled(toggled_on: bool) -> void :
	build_button = toggled_on
func _on_wall_selection_list_item_selected(index: int) -> void :
	if index == 0:
		current_item = Global.buildables.walls.standard
	elif index == 1:
		current_item = Global.buildables.doors.regular
	elif index == 2:
		current_item = Global.buildables.doors.large
	elif index == 3:
		current_item = Global.buildables.walls.remove
func _on_floor_selection_list_item_selected(index: int) -> void :
	if index == 0:
		current_item = Global.buildables.terrain.pavement
	elif index == 1:
		current_item = Global.buildables.terrain.remove
func _on_furniture_selection_list_item_selected(index: int) -> void :
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
func _on_workbench_selection_list_item_selected(index: int) -> void :
	if index == 0:
		current_item = Global.buildables.objects.electronics.oven
	elif index == 1:
		current_item = Global.buildables.objects.electronics.pc
