extends Node
@onready var parent = $".."
enum states {
	IDLE,
	ALERT,
	ATTACK,
	REST,
	BUILD,
	UNCONCIOUS,
	KNOCKED,
	DEAD
}

func _ready() -> void:
	add_user_signal("state_changed")

func _process(delta: float) -> void:
	if parent.healthy == true:
		if parent.characteristics.get_stat("tiredness") > 90\
		and parent.current_state != states.REST:
			parent.current_state = states.REST
		elif parent.characteristics.get_stat("tiredness") <= 90\
		and parent.current_state != states.REST:
			if not Global.building_queue.keys().is_empty():
				parent.current_state = states.BUILD
			else:
				parent.current_state = states.IDLE
		elif parent.current_state == states.REST:
			if parent.characteristics.get_stat("tiredness") < 20:
				if not Global.building_queue.keys().is_empty():
					parent.current_state = states.BUILD
				else:
					parent.current_state = states.IDLE

	if parent.characteristics.get_stat("health") <= 20:
		parent.healthy = false
		parent.current_state = states.KNOCKED
	elif parent.characteristics.get_stat("health") == 0:
		parent.healthy = false
		parent.current_state = states.DEAD
	else:
		parent.healthy = true
