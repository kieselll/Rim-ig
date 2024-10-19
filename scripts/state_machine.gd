extends Node
@onready var parent = $".."
enum states {
	IDLE,
	ALERT,
	ATTACK,
	REST
}

func _process(delta: float) -> void:
	if parent.characteristics.get_stat("tiredness") > 50:
		parent.current_state = states.REST
