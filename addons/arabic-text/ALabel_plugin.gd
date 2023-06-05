tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("HebrewLabel", "Label", preload("res://addons/arabic-text/ALabel.gd"), preload("res://addons/arabic-text/Label.svg"))

func _exit_tree():
	remove_custom_type("ALabel")
