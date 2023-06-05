extends HBoxContainer


func _on_ColorPicker_pressed():
	$Colors.visible = !$Colors.visible


func _on_Red_pressed():
	any_pressed(Brain.RED)


func _on_Green_pressed():
	any_pressed(Brain.GREEN)


func _on_Yellow_pressed():
	any_pressed(Brain.YELLOW)


func _on_White_pressed():
	any_pressed(Brain.WHITE)


func any_pressed(color):
	Brain.change_ui_color(color)
	Save.save_game()

func _on_ColorPicker_focus_exited():
	$Colors.visible = false
