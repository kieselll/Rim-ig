extends ColorRect

func _on_button_toggled(toggled_on):
	if toggled_on == true:
		show()
		$"../Container3".hide()
	else:
		hide()
		$"../Container3".show()


func _on_button_2_toggled(toggled_on):
	pass # Replace with function body.


func _on_button_3_pressed():
	$"../HFlowContainer/Button".button_pressed = false
