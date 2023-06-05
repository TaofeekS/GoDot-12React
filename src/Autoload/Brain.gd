extends Node

const global_password: String = "12react"

const RED: Color = Color('ff0000')
const GREEN: Color = Color('00b0f0')
const YELLOW: Color = Color('ffff33')
const WHITE: Color = Color('ffffff')

var setTemplate: Dictionary = {
	'set_name': 'preset',
	'drills': [],
	'min_time': 1,
	'max_time': 3,
	'work_time': 50,
	'break_time': 10,
	'number_of_sets': 1,
	'play_audio': false
}

var presetsFromDataBase
var presets: Array
var inQueue: Array

var currentColor: Color = YELLOW

#var email = "test@test.com"
var email = ""
var loggedIn: bool = false
var noCloudPlease: bool = false

func _ready():
	if !Save.load_game():
		reset_presets()
	change_ui_color(currentColor)


func reset_presets():

	
	var p = setTemplate.duplicate(true)
	p.set_name = "0-9"
	p.drills = [0,1,2,3,4,5,6,7,8,9]
	p.play_audio = true
	
	var p2 = setTemplate.duplicate(true)
	p2.set_name = "12345"
	p2.drills = [1,2,3,4,5]
	
	var p3 = setTemplate.duplicate(true)
	p3.set_name = "REACT"
	p3.drills = ["R","E","A","C","T",]
	
	var p4 = setTemplate.duplicate(true)
	p4.set_name = "YGOPB"
	p4.drills = ["Y","G","O","P","B",]
			
	var p5 = setTemplate.duplicate(true)
	p5.set_name = "←→↑↓"
	p5.drills = ["←","→","↑","↓"]
	p5.max_time = 1
	p5.work_time = 5
	p5.break_time = 10
	
	presets.clear()
	presets.append(p2.duplicate(true))
	presets.append(p3.duplicate(true))
	presets.append(p4.duplicate(true))
	presets.append(p5.duplicate(true))
	presets.append(p.duplicate(true))
	
	inQueue.clear()
	
	Save.save_game()


func get_saved_presets():
	if presetsFromDataBase:
		presets = presetsFromDataBase["doc_fields"]["my_presets"]
	elif loggedIn and !presetsFromDataBase:
		var collection : FirestoreCollection = Firebase.Firestore.collection(get_collection_name())
		collection.get(Brain.get_collection_name())
#		collection.connect("error", self, "on_get_doc_failed")
		var document : FirestoreDocument = yield(collection, "get_document")
		presets = document["doc_fields"]["my_presets"]
		

func get_collection_name():
	return email


func get_main_scene():
	return $'/root/Main'

func get_main_tabs():
	return $'/root/Main/TabContainer'

func get_create_preset_tabs():
	return $'/root/Main/TabContainer/AddPreset/CreatePreset'

func set_main_tab(tab):
	$'/root/Main/TabContainer'.current_tab = tab

func open_numpad():
	$'/root/Main/NumPad'.visible = true

func close_numpad():
	$'/root/Main/NumPad'.visible = false

func open_arrowpad():
	$'/root/Main/ArrowPad'.visible = !$'/root/Main/ArrowPad'.visible

func close_arrowpad():
	$'/root/Main/ArrowPad'.visible = false

func change_ui_color(color = currentColor):
	currentColor = color
	VisualServer.set_default_clear_color(Color(0,0,0))
	
	if currentColor == RED:
		color = WHITE
		VisualServer.set_default_clear_color(RED)
	elif currentColor == GREEN:
		VisualServer.set_default_clear_color(WHITE)

	
	for c in get_tree().get_nodes_in_group("ToModulate"):
		c.modulate = color
	for c in get_tree().get_nodes_in_group("ToSelfModulate"):
		c.self_modulate = color
	


