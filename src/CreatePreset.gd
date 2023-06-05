extends TabContainer

var setInEditing


#func _ready():
#	refresh_max_presets()


func refresh_max_presets():
	var maxSets = Brain.presets.size() >= 10
	$"../../Presets/Buttons/AddPreset".disabled = maxSets
	$"../../Presets/Buttons/AddPreset/MaxPresets".visible = maxSets
	

func _on_AddPreset_visibility_changed():
	clear_all_fields()
	current_tab = 0
	_on_CreatePreset_tab_changed(current_tab)
#	refresh_max_presets()


func clear_all_fields():
	for le in $DRILLS/Drills.get_children():
		le.placeholder_text = '-'
		le.text = ''
	$"../PresetName/LineEdit".text = ''
	$TIME/SecondsRange/MinSeconds.text = ''
	$TIME/SecondsRange/MaxSeconds.text = ''
	$SETS/SecondsRange/WorkSeconds.text = ''
	$SETS/SecondsRange/BreakSeconds.text = ''


func create_new_set():
	var set
	if !setInEditing:
		set = Brain.setTemplate.duplicate(true)
	else:
		set = setInEditing
		set.drills.clear()
	
	
	for le in $DRILLS/Drills.get_children():
		if !le.text.empty():
			set.drills.append(le.text)
		elif le.placeholder_text != '-':
			set.drills.append(le.placeholder_text)
	if set.drills.empty():
		set.drills.append_array(['1','2','3','4','5'])
	
	
	var setName = $"../PresetName/LineEdit".text
	if setName.length() > 0:
		set.set_name = $"../PresetName/LineEdit".text
	else:
		var presets = 0
		for p in Brain.presets:
			if p.set_name.begins_with('preset'):
				presets += 1
		if presets >= 1:
			set.set_name = 'preset' + str(presets)
		else:
			set.set_name = 'preset'
	
	var minTime = float($TIME/SecondsRange/MinSeconds.text)
	var maxTime = float($TIME/SecondsRange/MaxSeconds.text)
	
	if minTime <= 0:
		minTime = Brain.setTemplate.min_time
	if maxTime <= 0:
		maxTime = Brain.setTemplate.max_time
	
	if minTime <= maxTime:
		set.min_time = minTime
		set.max_time = maxTime
	else:
		set.min_time = maxTime
		set.max_time = minTime
	
	
	var workTime = float($SETS/SecondsRange/WorkSeconds.text)
	var breakTime = float($SETS/SecondsRange/BreakSeconds.text)
	
	if workTime <= 0:
		workTime = Brain.setTemplate.work_time
	if breakTime <= 0:
		breakTime = Brain.setTemplate.break_time
	
	set.work_time = workTime
	set.break_time = breakTime
	
	if !setInEditing:
		Brain.presets.append(set)
	else:
		setInEditing = null
	
	Save.save_game()


func edit_preset(set):
	setInEditing = set
	
	for le in $DRILLS/Drills.get_children():
		if set.drills.size() > le.get_index():
			le.placeholder_text = str(set.drills[le.get_index()])
		
	$"../PresetName/LineEdit".text = set.set_name
	$TIME/SecondsRange/MinSeconds.text = str(set.min_time)
	$TIME/SecondsRange/MaxSeconds.text = str(set.max_time)
	$SETS/SecondsRange/WorkSeconds.text = str(set.work_time)
	$SETS/SecondsRange/BreakSeconds.text = str(set.break_time)
	

func _on_Back_pressed():
	if current_tab > 0:
		current_tab -= 1


func _on_Next_pressed():
	if current_tab < 2:
		current_tab += 1


func _on_CreatePreset_tab_changed(_tab):
	$"../BackNext/Next".disabled = false
	$"../BackNext/Back".disabled = false
	if current_tab == 2:
		$"../BackNext/Next".disabled = true
	if current_tab == 0:
		$"../BackNext/Back".disabled = true

func _on_Save_pressed():
	Brain.close_numpad()
	Brain.close_arrowpad()
	if !$"../PresetName".visible:
		var setName: String = ''
		for le in $DRILLS/Drills.get_children():
			if !le.text.empty():
				setName += le.text
			elif le.placeholder_text != '-':
				setName += le.placeholder_text
		if setName.length() > 9:
			for i in 10:
				$"../PresetName/LineEdit".text += setName[i]
		else:
			$"../PresetName/LineEdit".text = setName
		$"../PresetName".visible = true
	else:
		_on_PresetNameSave_pressed()


func _on_PresetNameBack_pressed():
	$"../PresetName".visible = false
	


func _on_PresetNameSave_pressed():
	create_new_set()

	$"../PresetName".visible = false
	Brain.set_main_tab(1)


func _on_ArrowKeys_pressed():
	Brain.open_arrowpad()
	OS.hide_virtual_keyboard()


func _on_AddPresetBack_pressed():
	setInEditing = null

