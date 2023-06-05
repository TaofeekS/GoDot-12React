extends VBoxContainer

var presetItemRsc = preload("res://src/PresetItem.tscn")

func _on_Presets_visibility_changed():
	refresh_sets()


func refresh_sets():
	for p in get_tree().get_nodes_in_group('Preset'):
		p.queue_free()
	
#	Brain.inQueue.clear()
	
	for ps in Brain.presets:
		var presetItem = presetItemRsc.instance()
		presetItem.start(ps)
		call_deferred("add_child", presetItem)
