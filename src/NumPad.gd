extends GridContainer



func _on_numpad_pressed(number):
	var target = get_focus_owner()
	if !target:
		return
	if number is int or number == '.':
		target.append_at_cursor(str(number))
		if target.is_in_group('EmitChangesOnPads'):
			target.emit_signal('text_changed', target.text)
	elif number is String:
		target.text = number


func _on_NumPadBack_pressed():
	var target = get_focus_owner()
	if target is LineEdit:
		target.delete_char_at_cursor()


func _on_NumPadOk_pressed():
	var target = get_focus_owner()
	if target is LineEdit:
		target.release_focus()
	visible = false
