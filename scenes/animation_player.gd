extends Node

@onready var right_hand = $"../right_hand"
@onready var left_hand = $"../left_hand"

enum animations {NONE,COOK}

func _process(delta: float) -> void:
	play_animation(animations.NONE)

func play_animation(animation : animations):
	match animation:
		animations.NONE:
			right_hand.hide()
			left_hand.hide()
			right_hand.reparent($"..")
			left_hand.reparent($"..")
		animations.COOK:
			right_hand.reparent($"../Path2D/PathFollow2D")
			left_hand.reparent($"../Path2D2/PathFollow2D2")
			right_hand.show()
			left_hand.show()
			var tween = create_tween().set_loops(10).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
			tween.parallel().tween_property($"../Path2D2/PathFollow2D2","progress",771,6).as_relative()
			tween.parallel().tween_property($"../Path2D/PathFollow2D","progress",771,6).as_relative()
