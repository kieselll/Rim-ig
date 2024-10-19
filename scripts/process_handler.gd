extends Node
var time = 1200
enum times_of_day {
	MORNING,
	NOON,
	EVENING,
	NIGHT
}
var time_of_day : times_of_day

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	time = fposmod(time + 30 * delta, 2400)
	if time <= 300:
		time_of_day = times_of_day.NIGHT
		$"../fancy_thing/CanvasModulate".color = lerp(Color(0.1, 0.1, 0.15), Color(0.4, 0.35, 0.35), time / 300)
	elif time <= 900:
		time_of_day = times_of_day.MORNING
		$"../fancy_thing/CanvasModulate".color = lerp(Color(0.4, 0.4, 0.35), Color(1, 0.9, 0.7), (time - 300) / 600)
	elif time <= 1500:
		time_of_day = times_of_day.NOON
		$"../fancy_thing/CanvasModulate".color = lerp(Color(1, 0.9, 0.7), Color(1, 1, 1), (time - 900) / 600)
	elif time <= 2100:
		time_of_day = times_of_day.EVENING
		$"../fancy_thing/CanvasModulate".color = lerp(Color(1, 1, 1), Color(0.1, 0.1, 0.15), (time - 1500) / 600)
