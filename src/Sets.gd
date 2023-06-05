extends Panel

const arrows: Array = ["↖","↑","↗","←","→","↙","↓","↘","↔","↕",]

var tempQueue: Array

var currentSet
var currentNumberOfSets: int = 1
#var currentDrill: int = 0

var currentDrill

func start_set():
	
	if Brain.inQueue.empty():
		currentSet = Brain.presets[0]
	else:
		tempQueue = Brain.inQueue.duplicate(true)
		currentSet = tempQueue[0]
	currentNumberOfSets = currentSet.number_of_sets
	
	visible = true
	if Brain.currentColor == Brain.RED:
		self_modulate = Brain.RED
	else:
		self_modulate = Color.black
	
	OS.window_fullscreen = true
	$Countdown/AnimationPlayer.play("countdown")


func _on_Stop_pressed():
#	Brain.inQueue.clear()
	$CurrentDrill.visible = false
	$CurrentDrillArrow.visible = false
	$SetsLeft.visible = false
	$Countdown/Done.visible = false
	$Countdown/Break.visible = false
	$DrillTimer.stop()
	$WorkTimer.stop()
	$BreakTimer.stop()
	$Countdown/AnimationPlayer.stop()
	get_parent()._on_Sets_Stop_pressed()
	
	OS.window_fullscreen = false
	visible = false


func _on_Presets_pressed():
	_on_Stop_pressed()
	get_parent()._on_Presets_pressed()


func _on_AnimationPlayer_animation_finished(_anim_name):
	refresh_drill()
	
	$WorkTimer.wait_time = currentSet.work_time
	$WorkTimer.start()
	
	$BreakTimer.wait_time = currentSet.break_time
	
	$CurrentDrillArrow.visible = true
	$CurrentDrill.visible = true


func _on_DrillTimer_timeout():
	refresh_drill()


func refresh_drill():
	$DrillTimer.wait_time = rand_range(currentSet.min_time, currentSet.max_time)
	$DrillTimer.start()
	
	var d = get_random_drill()
	while str(currentDrill) == str(d):
		d = get_random_drill()
	currentDrill = d
	if arrows.has(d):
		$CurrentDrillArrow.text = str(d)
		$CurrentDrill.text = ""
	else:
		$CurrentDrillArrow.text = ""
		$CurrentDrill.text = str(d)
	if 'play_audio' in currentSet and currentSet.play_audio:
		$Audio.play(currentDrill)


func _on_WorkTimer_timeout():
	$DrillTimer.stop()
	$CurrentDrill.visible = false
	$CurrentDrillArrow.visible = false
	
	currentNumberOfSets -= 1
	
	if get_number_of_sets() > 0:
		$Countdown/Break.visible = true
		$SetsLeft.visible = true
	else:
		$BreakTimer.wait_time = 3
		$Countdown/Done.visible = true
	
	if get_number_of_sets() > 1:
		$SetsLeft.text = str(get_number_of_sets()) + ' SETS LEFT!'
	else:
		$SetsLeft.text = 'LAST ONE!'
	
	$BreakTimer.start()
	


func _on_BreakTimer_timeout():
	if currentNumberOfSets <= 0:
		if !tempQueue.empty():
			tempQueue.remove(0)
		
		if !tempQueue.empty():
			currentSet = tempQueue[0]
			currentNumberOfSets = currentSet.number_of_sets
		
		elif get_number_of_sets() <= 0:
			_on_Stop_pressed()
			return
	
	$Countdown/Break.visible = false
	$Countdown/Done.visible = false
	$SetsLeft.visible = false
	
	$Countdown/AnimationPlayer.play("countdown")


func get_number_of_sets():
	var s = currentNumberOfSets
	for q in tempQueue:
		if q != currentSet:
			s += q.number_of_sets
	return s

func get_random_drill():
	randomize()
	return currentSet.drills[randi() % currentSet.drills.size()]


func play_count_down(track):
	if 'play_audio' in currentSet and currentSet.play_audio:
		$Audio.play(track)
