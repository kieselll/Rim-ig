class_name PawnStats
extends Resource

enum personalities {
	INTROVERT,
	EXTROVERT,
	AMBIVERT
}
class pawn_trait:
	var name : String
	var socially_positive : bool
	var self_positive : bool
	
	func _init(name,socially_positive,self_positive) -> void:
		self.name = name
		self.socially_positive = socially_positive
		self.self_positive = self_positive

@export var personality = personalities.AMBIVERT
@export var stats = {
	"health": 100,
	"tiredness": 0,
	"happiness": 100
}
@export var traits = []

func get_stat(stat : String):
	if stats.has(stat):
		return stats.get(stat)
	else:
		return

func has_trait(pawn_trait_name : String):
	for i in traits.size():
		if traits[i].name == pawn_trait_name:
			return true
	return false
