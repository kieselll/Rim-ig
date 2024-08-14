extends ColorRect

func _on_button_toggled(toggled_on):
	if toggled_on == true:
		show()
		$"../Container3".hide()
	else:
		hide()
		$"../Container3".show()
