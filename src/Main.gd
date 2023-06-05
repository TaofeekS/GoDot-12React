


extends Control

onready var tabs = $TabContainer
var presetToDelete


func _ready():
#	Save.load_game()
	if !Brain.loggedIn and Brain.email:
		Firebase.Auth.connect("login_failed", self, "on_login_failed")
		Firebase.Auth.connect("login_succeeded", self, "on_login_successful")
		Firebase.Auth.login_with_email_and_password(Brain.email, Brain.global_password)

	for p in get_tree().get_nodes_in_group("NumberEdit"):
		p.connect("focus_entered", self, "open_numpad")
		p.connect("focus_exited", self, "close_numpad")
#	for le in get_tree().get_nodes_in_group('SingleLetterLineEdit'):
#		le.connect('text_changed', self, 'line_edit_keep_one_letter', [le])
#		le.connect('focus_exited', self, 'close_arrowpad')

	Brain.change_ui_color()


#	for c in get_tree().get_nodes_in_group("OpensKeyboard"):
#		c.connect("focus_entered", self, "resize_screen_to_keyboard")
#		c.connect("focus_exited", self, "resize_screen_from_keyboard")
#
#
#func resize_screen_to_keyboard():
#	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED,  SceneTree.STRETCH_ASPECT_IGNORE, Vector2(1280,720),1)
#func resize_screen_from_keyboard():
#	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D,  SceneTree.STRETCH_ASPECT_KEEP_WIDTH, Vector2(1280,720),1)


func on_login_successful(_result):
	print("login successful")
	Brain.loggedIn = true

	for p in get_tree().get_nodes_in_group("Preset"):
		p.enable_editing()

	var collection: FirestoreCollection = Firebase.Firestore.collection(Brain.get_collection_name())
	collection.get("presets")
#	collection.connect("error", self, "on_get_doc_failed")
	var document: FirestoreDocument = yield(collection, "get_document")
	print("get document successful")

	Brain.presetsFromDataBase = document
	Brain.get_saved_presets()

	get_tree().get_nodes_in_group("PresetsContainer")[0].refresh_sets()


func on_login_failed(_auth, _result):
	print("login failed")


func _on_Presets_pressed():
	tabs.current_tab = 1


func _on_Sets_Stop_pressed():
	tabs.current_tab = 1


func _on_AddPreset_pressed():
	if Brain.presets.size() >= 10:
		$"TabContainer/Presets/Buttons/AddPreset/MaxPresets".popup_centered_ratio(0.3)
		return
	if !Brain.loggedIn:
		get_tree().get_nodes_in_group("SaveOnCloudPopup")[0].popup_centered()
	else:
		tabs.current_tab = 2


func _on_OnDevice_pressed():
	Brain.noCloudPlease = true
	tabs.current_tab = 2
	get_tree().get_nodes_in_group("SaveOnCloudPopup")[0].hide()


func _on_AddPresetBack_pressed():
	tabs.current_tab = 1


func open_numpad():
	$NumPad.visible = true


func close_numpad():
	$NumPad.visible = false


func close_arrowpad():
	$ArrowPad.visible = false


#func line_edit_keep_one_letter(new_text, lineEdit: LineEdit):
#	if new_text.length() > 1:
#		print(new_text.length())
#		lineEdit.text = lineEdit.text[-1]
#		lineEdit.caret_position = new_text.length()


func _on_StartSet_pressed():
	$Sets.start_set()


func delete_preset(preset_item, preset_name):
	presetToDelete = preset_item
	$ConfirmDeletePreset/VBoxContainer/PresetName.text = preset_name
	$ConfirmDeletePreset.popup_centered_ratio(0.25)


func _on_DeletePresetNo_pressed():
	$ConfirmDeletePreset.hide()


func _on_DeletePresetYes_pressed():
	presetToDelete.delete_preset()
	$ConfirmDeletePreset.hide()


