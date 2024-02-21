extends Control

func _process(_delta):
	if(Input.is_action_just_pressed("keyboardInputs")):
		Global.controller=false
	elif(Input.is_action_just_pressed("controllerInputs", false)):
		Global.controller=true
	
	if(Input.is_action_just_pressed("discard")):
		Global.mainMenuMusicTime=get_node("Music").get_playback_position()
		get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
