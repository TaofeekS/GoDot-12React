extends Node


func save():
	var save_dict = {
		"filename" : get_filename(),
		"presets" : Brain.presets,
		"color" : Brain.currentColor.to_html(),
		"email" : Brain.email,
	}
	return save_dict


func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var node_data = call("save");
	save_game.store_line(to_json(node_data))
	save_game.close()
	
	if Brain.loggedIn and Brain.presets:
		
		var firestore_collection : FirestoreCollection = Firebase.Firestore.collection(Brain.get_collection_name())
		var _up_task : FirestoreTask = firestore_collection.update("presets", {'my_presets': Brain.presets})
		var _document : FirestoreDocument = yield(_up_task, "task_finished")
		if !firestore_collection.is_connected("error", self, "update_doc_failed"):
			firestore_collection.connect("error", self, "update_doc_failed")
	
	print("game saved")

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		save_game()
		return false# Error! We don't have a save to load.
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		Brain.presets = node_data["presets"]
		Brain.email = node_data["email"]
#		Brain.currentColor = node_data["color"]
		
	save_game.close()
	return true


func update_doc_failed(err, status, msg):
	print(err)
	print(status)
	print(msg)
