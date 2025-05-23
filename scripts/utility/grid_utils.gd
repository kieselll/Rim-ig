extends Node

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

func find_nearest_tile(call_coords: Vector2i, tiles: Array[Global.BuildableBase]) -> Vector2i:
	var lengths: Array = []
	var tile_array: Array
	var tile_arrays: Array = []
	for i in range(tiles.size()):
		var layer: TileMapLayer = tiles[i].get_layer_node(layers)
		tile_array = layer.get_used_cells_by_id(tiles[i].source_id, tiles[i].atlas_coords)
		tile_arrays.append_array(tile_array)
	for j in range(tile_array.size()):
		lengths.append((tile_array[j] - call_coords).length())
	if lengths.size() > 0:
		var min_index = lengths.find(lengths.min())
		return tile_arrays[min_index]
	else:
		return Vector2i(-1,-1)

func find_nearest_tile_coord(call_coords: Vector2i, tiles: Array[Vector2i]) -> Vector2i:
	var lengths: Array = []
	for i in tiles:
		lengths.append((Vector2i(i) - call_coords).length())
	if lengths.size() > 0:
		var min_index = lengths.find(lengths.min())
		return tiles[min_index]
	else:
		return Vector2i(-1,-1)

func get_neighbor_tiles(pos: Vector2, is_map := false) -> Array:
	var output = []
	var offsets
	if is_map:
		offsets = [Vector2(1, 1), Vector2(1, 0), Vector2(1, -1), Vector2(0, 1), Vector2(0, -1), Vector2(-1, 1), Vector2(-1, 0), Vector2(-1, -1)]
	else:
		offsets = [Vector2(32, 32), Vector2(32, 0), Vector2(32, -32), Vector2(0, 32), Vector2(0, -32), Vector2(-32, 32), Vector2(-32, 0), Vector2(-32, -32)]
	for i in offsets:
		output.append(pos + i)
	return output
