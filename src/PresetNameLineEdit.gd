extends LineEdit


func _on_LineEdit_text_changed(new_text):
	$HebrewLabel.hebrew_input += new_text
	text = ''
