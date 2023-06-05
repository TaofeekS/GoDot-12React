extends HBoxContainer


func _on_Website_pressed():
	OS.shell_open("http://12react.com/")


func _on_12ReactPro_pressed():
	get_tree().change_scene("res://src/Login/Login.tscn")
#	OS.shell_open('http://12react.com/pro')


func _on_Facebook_pressed(share = false):
	if share:
		OS.shell_open("https://www.facebook.com/sharer.php?u=https://12react.github.io/")
	else:
		OS.shell_open("https://www.facebook.com/12ReAct")


func _on_YouTube_pressed():
	OS.shell_open("https://www.youtube.com/channel/UC7lLNKNtfoSWc3pnycZFOcw")


func _on_GooglePlay_pressed():
	OS.shell_open("https://play.google.com/store/apps/details?id=com.Agmon.OneTwoReAct")


func _on_Share_pressed():
	$Share/ShareButtons.popup_centered()


func _on_Fullscreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_Instagram_pressed():
	OS.shell_open("https://www.instagram.com/coach_agmon")


func _on_TikTok_pressed():
	OS.shell_open("https://www.tiktok.com/@coachagmon")


func _on_Learn_pressed():
	$Learn/LearnButtons.popup_centered()


func _on_Kit_pressed():
	OS.shell_open("http://12react.com/12react-kit.html")


func _on_Reset_pressed():
	$Reset/Confirm.popup_centered_ratio(0.25)


func _on_Whatsapp_pressed():
	OS.shell_open("whatsapp://send?text=https://12react.github.io/")


func _on_ResetNo_pressed():
	$Reset/Confirm.hide()


func _on_ResetYes_pressed():
	Brain.reset_presets()
	get_tree().get_nodes_in_group("PresetsContainer")[0].refresh_sets()
	$Reset/Confirm.hide()
