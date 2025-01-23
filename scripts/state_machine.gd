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
var prev_state
var state = states.IDLE
signal state_changed

func _process(_delta: float) -> void:
	prev_state = state
	if parent.healthy:
		var tiredness = parent.characteristics.get_stat("tiredness")
		if state == states.REST:
			if tiredness < 20:
				if !Global.building_queue.keys().is_empty():
					state = states.BUILD
					parent.first_time_building = true
				elif !Global.demolition_queue.keys().is_empty():
					state = states.DEMOLISH
					parent.first_time_building = true
				else:
					state = states.IDLE
		elif tiredness > 90:
			state = states.REST
		else:
			if !Global.building_queue.keys().is_empty():
				state = states.BUILD
				parent.first_time_building = true
			elif !Global.demolition_queue.keys().is_empty():
				state = states.DEMOLISH
				parent.first_time_building = true
			else:
				state = states.IDLE

	if parent.characteristics.get_stat("health") <= 20:
		parent.healthy = false
		state = states.KNOCKED
	elif parent.characteristics.get_stat("health") == 0:
		parent.healthy = false
		state = states.DEAD
	else:
		parent.healthy = true
	parent.current_state = state
	if state != prev_state:
		state_changed.emit()
