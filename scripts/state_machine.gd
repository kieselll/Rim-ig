extends Node
@onready var parent = $".."
enum states {
	IDLE,
	ALERT,
	ATTACK,
	REST,
	BUILD,
	DEMOLISH,
	UNCONCIOUS,
	KNOCKED,
	DEAD
}

func _ready() -> void:
	add_user_signal("state_changed")

func _process(_delta: float) -> void:
	if parent.healthy:
		var tiredness = parent.characteristics.get_stat("tiredness")
		if parent.current_state == states.REST:
			if tiredness < 20:
				if !Global.building_queue.keys().is_empty():
					parent.current_state = states.BUILD
					parent.first_time_building = true
				elif !Global.demolition_queue.keys().is_empty():
					parent.current_state = states.DEMOLISH
					parent.first_time_building = true
				else:
					parent.current_state = states.IDLE
		elif tiredness > 90:
			parent.current_state = states.REST
		else:
			if !Global.building_queue.keys().is_empty():
				parent.current_state = states.BUILD
				parent.first_time_building = true
			elif !Global.demolition_queue.keys().is_empty():
				parent.current_state = states.DEMOLISH
				parent.first_time_building = true
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
