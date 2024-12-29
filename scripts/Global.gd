extends Node
var world_size = 50
var button_hover = false
var game_location = "C:/Users/Кирилл/Desktop/Сейвы игры (хз)" 
var astar = AStarGrid2D.new()

var building_queue : Dictionary = {}

var demolition_queue : Dictionary = {}

var class_reference : Dictionary = {
	"doors_regular" : buildables.doors.regular,
	"doors_large" : buildables.doors.large,
	"terrain_pavement" : buildables.terrain.pavement,
	"terrain_brussels" : buildables.terrain.brussells,
	"terrain_remove" : buildables.terrain.remove,
	"furniture_chair" : buildables.objects.furniture.chair,
	"furniture_armchair" : buildables.objects.furniture.armchair,
	"furniture_sofa" : buildables.objects.furniture.sofa,
	"furniture_table" : buildables.objects.furniture.table,
	"furniture_dresser" : buildables.objects.furniture.dresser,
	"furniture_shower" : buildables.objects.furniture.shower,
	"electronics_tv" : buildables.objects.electronics.tv,
	"electronics_pc" : buildables.objects.electronics.pc,
	"electronics_oven" : buildables.objects.electronics.oven,
	"electronics_washing_machine" : buildables.objects.electronics.washing_machine,
	"electronics_antenna" : buildables.objects.electronics.antenna,
	"electronics_street_light_double" : buildables.objects.electronics.street_light_double,
	"decorations_flower" : buildables.objects.decorations.flower,
	"decorations_cactus" : buildables.objects.decorations.cactus,
	"objects_remove" : buildables.objects.remove,
	"walls_standard" : buildables.walls.standard,
	"walls_remove" : buildables.walls.remove
}

class BuildableItem:
	var id : int
	var collision : bool
	var wall : bool
	var layer : String
	var queued_layer : String
	var source_id : int
	var atlas_coords : Vector2
	var build_time : float

	func _init(_id, _collision, _wall, _layer, _queued_layer, _source_id, _atlas_coords, _build_time = 2.0):
		self.id = _id
		self.collision = _collision
		self.wall = _wall
		self.layer = _layer
		self.queued_layer = _queued_layer
		self.source_id = _source_id
		self.atlas_coords = _atlas_coords
		self.build_time = _build_time

	func get_layer_node(layers: Dictionary) -> Node:
		return layers.get(layer, null)

	func get_queued_layer_node(layers: Dictionary) -> Node:
		return layers.get(queued_layer, null)


class BuildableLightSource:
	var id : int
	var collision : bool
	var wall : bool
	var layer : String
	var queued_layer : String
	var source_id : int
	var atlas_coords : Vector2
	var build_time : float
	var light_scene
	var radians_per_alternative

	func _init(_id, _collision, _wall, _layer, _queued_layer, _source_id, _atlas_coords, _light_scene, _radians_per_alternative, _build_time = 3.0):
		self.id = _id
		self.collision = _collision
		self.wall = _wall
		self.layer = _layer
		self.queued_layer = _queued_layer
		self.source_id = _source_id
		self.atlas_coords = _atlas_coords
		self.build_time = _build_time
		self.light_scene = _light_scene
		self.radians_per_alternative = _radians_per_alternative


class BuildableTerrain:
	var id : int
	var collision : bool
	var wall : bool
	var layer : String
	var queued_layer : String
	var filled : bool
	var terrain_set : int
	var terrain_id : int
	var build_time : float

	func _init(_id, _collision, _wall, _layer, _queued_layer, _filled, _terrain_set, _terrain_id, _build_time = 4.0):
		self.id = _id
		self.collision = _collision
		self.wall = _wall
		self.layer = _layer
		self.queued_layer = _queued_layer
		self.filled = _filled
		self.terrain_set = _terrain_set
		self.terrain_id = _terrain_id
		self.build_time = _build_time

	func get_layer_node(layers: Dictionary) -> Node:
		return layers.get(layer, null)

	func get_queued_layer_node(layers: Dictionary) -> Node:
		return layers.get(queued_layer, null)


class buildables:
	class doors:
		static var regular = BuildableItem.new(3, true, false, "walls", "walls_queued", 3, Vector2(0, 0), 2.5)
		static var large = BuildableItem.new(4, true, false, "walls", "walls_queued", 3, Vector2(0, 1), 3.5)
	class terrain:
		static var pavement = BuildableTerrain.new(5, false, false, "terrain", "terrain_queued", true, 0, 1, 4.0)
		static var brussells = BuildableTerrain.new(6, false, false, "terrain", "terrain_queued", true, 0, 3, 5.0)
		static var remove = BuildableItem.new(-1, false, false, "terrain", "terrain_queued_d", -1, Vector2.ZERO, 0)
	class objects:
		class furniture:
			static var chair = BuildableItem.new(7, true, false, "walls", "walls_queued", 5, Vector2(0, 0), 2.0)
			static var armchair = BuildableItem.new(8, true, false, "walls", "walls_queued", 5, Vector2(1, 0), 2.5)
			static var sofa = BuildableItem.new(9, true, false, "walls", "walls_queued", 5, Vector2(0, 2), 3.0)
			static var table = BuildableItem.new(10, true, true, "walls", "walls_queued", 5, Vector2(2, 2), 4.0)
			static var dresser = BuildableItem.new(11, true, true, "walls", "walls_queued", 5, Vector2(4, 2), 4.5)
			static var shower = BuildableItem.new(12, true, false, "walls", "walls_queued", 5, Vector2(1, 1), 3.5)
		class electronics:
			static var tv = BuildableItem.new(13, true, true, "walls", "walls_queued", 5, Vector2(0, 3), 3.5)
			static var pc = BuildableLightSource.new(14, true, true, "walls", "walls_queued", 5, Vector2(2, 0), "res://scenes/light_scenes/ComputerLight.tscn", 1.5707975, 4.0)
			static var oven = BuildableItem.new(15, true, true, "walls", "walls_queued", 5, Vector2(3, 0), 3.5)
			static var washing_machine = BuildableItem.new(16, false, true, "walls", "walls_queued", 5, Vector2(0, 1), 4.0)
			static var antenna = BuildableItem.new(17, false, true, "walls", "walls_queued", 5, Vector2(4, 0), 3.0)
			static var street_light_double = BuildableLightSource.new(18, false, true, "light_masked", "light_masked_queued", 5, Vector2(6, 0), "res://scenes/light_scenes/StreetLightDouble.tscn", 4.71239, 5.0)
		class decorations:
			static var flower = BuildableItem.new(19, false, true, "walls", "walls_queued", 5, Vector2(3, 1), 2.0)
			static var cactus = BuildableItem.new(20, false, true, "walls", "walls_queued", 5, Vector2(2, 1), 2.5)
		static var remove = BuildableItem.new(-1, false, false, "walls", "walls_queued_d", -1, Vector2.ZERO, 0)
	class walls:
		static var standard = BuildableTerrain.new(21, true, true, "walls", "walls_queued", false, 1, 0, 6.0)
		static var remove = BuildableTerrain.new(-1, false, false, "walls", "walls_queued_d", false, 1, -1, 6.5)

func find_tile_by_id(id : int):
	for i in class_reference:
		if class_reference[i].id == id:
			return class_reference[i]
