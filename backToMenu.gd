extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(Input.is_action_just_pressed("discard")):
		Global.mainMenuMusicTime=get_node("Music").get_playback_position()
		get_tree().change_scene_to_file("res://menu.tscn")
