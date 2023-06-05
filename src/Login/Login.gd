extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	Brain.change_ui_color()
	Firebase.Auth.connect("login_succeeded", self, "on_login_successful")
	Firebase.Auth.connect("login_failed", self, "on_login_failed")
	Firebase.Auth.connect("signup_succeeded", self, "on_register_successful")
	
#	for c in get_tree().get_nodes_in_group("OpensKeyboard"):
#		c.connect("focus_entered", self, "resize_screen_to_keyboard")
#		c.connect("focus_exited", self, "resize_screen_from_keyboard")
#
#
#func resize_screen_to_keyboard():
#	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED,  SceneTree.STRETCH_ASPECT_IGNORE, Vector2(1280,720),1)
#func resize_screen_from_keyboard():
#	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D,  SceneTree.STRETCH_ASPECT_KEEP_WIDTH, Vector2(1280,720),1)



func _on_Login_pressed():
	var email = $TabContainer/Login/Username.text
	var password = Brain.global_password
	Firebase.Auth.login_with_email_and_password(email, password)
	$"TabContainer/Login/Notification".text = "Loading.."



func on_login_successful(result):
	Brain.loggedIn = true
	$"TabContainer/Login/Notification".text = "Login Successful!"
	Brain.email = result["email"]
	Save.save_game()
	print(result["email"])
	print("login_successful")
	
	yield(get_tree().create_timer(1), "timeout")
#	$"TabContainer/Login/Notification".text = "Getting Your Presets.."
#
#	var collection : FirestoreCollection = Firebase.Firestore.collection(Brain.get_collection_name())
#	collection.get("presets")
#	collection.connect("error", self, "on_get_doc_failed")
#	var document : FirestoreDocument = yield(collection, "get_document")
#
#	Brain.presetsFromDataBase = document
	Brain.get_saved_presets()
	get_tree().change_scene("res://src/Main.tscn")
	
func on_login_failed(auth, result):
	$"TabContainer/Login/Notification".text = "Login Failed!\nIncorrect Email Or Password"
	$"TabContainer/Register/Notification".text = "Register Failed!\n"+result.replace("_"," ")
	print(auth)
	print(result)
	print("login_failed")

func on_register_successful(result):
	Brain.loggedIn = true
	$"TabContainer/Register/Notification".text = "Register Successful!"
	Brain.email = result["email"]
	
	var _name = $"TabContainer/Register/Name".text
	var age = int($"TabContainer/Register/RegisterAge".text)
	var country = $"TabContainer/Register/Country".text
	var wantsUpdates = $"TabContainer/Register/CheckBox".pressed
	
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection(Brain.get_collection_name())
	var add_task : FirestoreTask = firestore_collection.add("details", {'name': _name, 'age': age, 'country': country, "wants_updates": wantsUpdates})
#	var document : FirestoreDocument = yield(add_task, "task_finished")

	
	print(result)
	print("register_successful")
	
	yield(get_tree().create_timer(2), "timeout")
	get_tree().change_scene("res://src/Main.tscn")

#func on_register_failed(auth, result):
#	print(auth)
#	print(result)
#	print("register_failed")

func _on_Register_pressed():
	$"TabContainer/Login/Notification".text = ""
	$"TabContainer/Register/Notification".text = ""
	$TabContainer.current_tab = 1

func _on_Cancel_pressed():
	$"TabContainer/Login/Notification".text = ""
	$"TabContainer/Register/Notification".text = ""
	$TabContainer.current_tab = 0

func _on_SignUp_pressed():
	var email: String = $TabContainer/Register/RegisterEmail.text
	var password = Brain.global_password
	
	if email.find("@") >= 0:
		$"TabContainer/Register/Notification".text = "Loading.."
		Firebase.Auth.signup_with_email_and_password(email, password)
	else:
		$"TabContainer/Register/Notification".text = "Email Must Have '@'"

func on_get_doc_failed(errorCode,errorStatus,errorMessage):
	print(errorCode)
	print(errorStatus)
	print(errorMessage)
	print("get_doc_failed")
	$"TabContainer/Login/Notification".text = "No Presets Found\nSaving Presets From Device"
	yield(get_tree().create_timer(2), "timeout")
	get_tree().change_scene("res://src/Main.tscn")


func _on_Skip_pressed():
	get_tree().change_scene("res://src/Main.tscn")


func _on_Password_text_entered(new_text):
	_on_Login_pressed()


func _on_Username_text_entered(new_text):
	_on_Login_pressed()


func _on_RegisterEmail_text_entered(new_text):
	_on_SignUp_pressed()

func _on_RegisterPassword_text_entered(new_text):
	_on_SignUp_pressed()

func _on_RegisterAge_text_entered(new_text):
	_on_SignUp_pressed()

func _on_Country_text_entered(new_text):
	_on_SignUp_pressed()

func _on_Name_text_entered(new_text):
	_on_SignUp_pressed()
