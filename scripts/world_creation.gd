extends Node
var world_size = 50
var button_hover = false
var game_location = "C:/Users/Кирилл/Desktop/Сейвы игры (хз)"

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
	var source_id : int
	var atlas_coords : Vector2
	func _init(id, collision, wall, layer, source_id, atlas_coords):
		self.id = id
		self.collision = collision
		self.wall = wall
		self.layer = layer
		self.source_id = source_id
		self.atlas_coords = atlas_coords
	func get_layer_node(layers: Dictionary) -> Node:
		if layers.has(layer):
			return layers[layer]
		return null

class BuildableLightSource:
	var id : int
	var collision : bool
	var wall : bool
	var layer : String
	var source_id : int
	var atlas_coords : Vector2
	var light_scene
	var radians_per_alternative
	func _init(id, collision, wall, layer, source_id, atlas_coords, light_scene, radians_per_alternative):
		self.id = id
		self.collision = collision
		self.wall = wall
		self.layer = layer
		self.source_id = source_id
		self.atlas_coords = atlas_coords
		self.light_scene = light_scene
		self.radians_per_alternative = radians_per_alternative
	func get_layer_node(layers: Dictionary) -> Node:
		if layers.has(layer):
			return layers[layer]
		return null

class BuildableTerrain:
	var id : int
	var collision : bool
	var wall : bool
	var layer : String
	var filled : bool
	var terrain_set : int
	var terrain_id : int
	func _init(id, collision, wall, layer, filled, terrain_set, terrain_id):
		self.id = id
		self.collision = collision
		self.wall = wall
		self.layer = layer
		self.filled = filled
		self.terrain_set = terrain_set
		self.terrain_id = terrain_id
	func get_layer_node(layers: Dictionary) -> Node:
		if layers.has(layer):
			return layers[layer]
		return null

class buildables:
	class doors:
		static var regular = BuildableItem.new(3, true, false, "walls", 3, Vector2(1,0))
		static var large = BuildableItem.new(4, true, false, "walls", 3, Vector2(0, 0))
	class terrain:
		static var pavement = BuildableTerrain.new(5, false, false, "terrain", true, 0, 1)
		static var brussells = BuildableItem.new(6, false, false, "terrain", 0, Vector2(1, 2))
		static var remove = BuildableItem.new(-1, false, false, "terrain", -1, Vector2.ZERO)
	class objects:
		class furniture:
			static var chair = BuildableItem.new(7, true, false, "walls", 5, Vector2(0, 0))
			static var armchair = BuildableItem.new(8, true, false, "walls", 5, Vector2(1, 0))
			static var sofa = BuildableItem.new(9, true, false, "walls", 5, Vector2(0, 2))
			static var table = BuildableItem.new(10, true, true, "walls", 5, Vector2(2, 2))
			static var dresser = BuildableItem.new(11, true, true, "walls", 5, Vector2(4, 2))
			static var shower = BuildableItem.new(12, true, false, "walls", 5, Vector2(1, 1))
		class electronics:
			static var tv = BuildableItem.new(13, true, true, "walls", 5, Vector2(0, 3))
			static var pc = BuildableLightSource.new(14, true, true, "walls", 5, Vector2(2, 0), "res://scenes/light_scenes/ComputerLight.tscn", 1.5707975)
			static var oven = BuildableItem.new(15, true, true, "walls", 5, Vector2(3, 0))
			static var washing_machine = BuildableItem.new(16, false, true, "walls", 5, Vector2(0, 1))
			static var antenna = BuildableItem.new(17, false, true, "walls", 5, Vector2(4, 0))
			static var street_light_double = BuildableLightSource.new(18, false, true, "light_masked", 5, Vector2(6, 0), "res://scenes/light_scenes/StreetLightDouble.tscn", 4.71239)
		class decorations:
			static var flower = BuildableItem.new(19, false, true, "walls", 5, Vector2(3, 1))
			static var cactus = BuildableItem.new(20, false, true, "walls", 5, Vector2(2, 1))
		static var remove = BuildableItem.new(-1, false, false, "walls", -1, Vector2.ZERO)
	class walls:
		static var standard = BuildableTerrain.new(21, true, true, "walls", false, 1, 0)
		static var remove = BuildableItem.new(-1, false, false, "walls", -1, Vector2.ZERO)
