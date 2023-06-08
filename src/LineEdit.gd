extends LineEdit

func _ready():
	connect("text_changed", self, "_on_LineEdit_text_changed")
	connect("focus_entered", self, "_on_focus_entered")

func _on_LineEdit_text_changed(new_text : String):
	var new_text_size = new_text.length()
	var replacedText = new_text
	
	var remainingSpaceInText = 30 - new_text_size
	
	for space in range(remainingSpaceInText):
		replacedText += "_"
	
	$Label.text = replacedText


func _on_focus_entered():
	pass
