extends Control

var inQueue: bool = false
var preset


func _ready():
	$Preset/Sets.connect("focus_entered", Brain.get_main_scene(), 'open_numpad')
	$Preset/Sets.connect("focus_exited", Brain.get_main_scene(), 'close_numpad')


func start(set):
	preset = set
	if preset.set_name.length() > 0:
		$Preset/PresetName.hebrew_input = preset.set_name
	
	if Brain.inQueue.has(preset):
		inQueue = true
	$InQueue.visible = inQueue
	refresh_queue_number()
#	else:
#		var presets = 0
#		for p in Brain.presets:
#			if p.set_name.begins_with('preset'):
#				presets += 1
#		$Preset/PresetName.hebrew_input = 'preset'
	if preset.number_of_sets > 0:
		$Preset/Sets.placeholder_text = str(preset.number_of_sets)
	
	if Brain.loggedIn:
		enable_editing()
	
	if preset.play_audio:
		$Preset/PresetName/Audio.visible = true


func enable_editing():
	$Preset/Edit.visible = true

func _on_Queue_pressed():
	inQueue = !inQueue
	$InQueue.visible = inQueue
	
	if inQueue:
		Brain.inQueue.append(preset)
	else:
		Brain.inQueue.remove(Brain.inQueue.find(preset))
	
	refresh_all_queue_numbers()


func refresh_all_queue_numbers():
	for p in get_tree().get_nodes_in_group('Preset'):
		p.refresh_queue_number()


func _on_PresetName_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and !event.is_pressed():
		_on_Queue_pressed()


func refresh_queue_number():
	if inQueue:
		$Preset/Queue/Label.text = str(Brain.inQueue.find(preset) + 1)
	else:
		$Preset/Queue/Label.text = ''


func _on_Delete_pressed():
	Brain.get_main_scene().delete_preset(self, preset.set_name)


func delete_preset():
	if inQueue:
		Brain.inQueue.remove(Brain.inQueue.find(self))
	refresh_all_queue_numbers()
	
	$Tween.interpolate_property(self, 'rect_min_size:y', rect_min_size.y, 0, 0.2, Tween.TRANS_QUAD,Tween.EASE_IN)
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	
	Brain.presets.remove(Brain.presets.find(preset))
	Save.save_game()
	
	Brain.get_main_scene().find_node('CreatePreset').refresh_max_presets()
	
	queue_free()


func _on_Edit_pressed():
	Brain.set_main_tab(2)
	Brain.get_create_preset_tabs().edit_preset(preset)


func _on_Sets_text_changed(_new_text):
	preset.number_of_sets = int($Preset/Sets.text)
