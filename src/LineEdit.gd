extends LineEdit

func _ready():
	connect("text_changed", self, "_on_LineEdit_text_changed")
	connect("focus_entered", self, "_on_focus_entered")

func _on_LineEdit_text_changed(new_text):
	if !text.empty():
		if get_index() < get_parent().get_child_count() - 1:
			get_parent().get_child(get_index() + 1).grab_focus()
		else:
			placeholder_text = new_text[-1]
			text = new_text[-1]
			caret_position = text.length()


func _on_focus_entered():
	placeholder_text = "-"
	text = ""
