extends Control

#@onready var masterVolumeSlider = get_node("VBoxContainer/MasterVolume/MarginContainer2/VolumeSlider")
#@onready var musicVolumeSlider
#@onready var SFXVolumeSlider

var selectedIndex = 1
@onready var soundEffect = get_node("UI_select") 

func _ready():
	get_node("VBoxContainer").get_child(1).get_node("SelectedPanel").set_visible(true)

func _process(_delta):
	if(Input.is_action_just_pressed("discard")):
		Global.mainMenuMusicTime=get_node("Music").get_playback_position()
		get_tree().change_scene_to_file("res://menu.tscn")
	
	if(Input.is_action_just_pressed("UI_up")):
		if(selectedIndex<=1):
			selectedIndex=4
		else:
			selectedIndex-=1
		_highlight(selectedIndex)
	if(Input.is_action_just_pressed("UI_down")):
		if(selectedIndex>=4):
			selectedIndex=1
		else:
			selectedIndex+=1
		_highlight(selectedIndex)
	
	if(Input.is_action_just_pressed("ui_accept") and selectedIndex==1):
		get_node("VBoxContainer/FullScreen/CheckButton").button_pressed=!get_node("VBoxContainer/FullScreen/CheckButton").button_pressed
		if(get_node("VBoxContainer/FullScreen/CheckButton").button_pressed):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if(Input.is_action_just_pressed("UI_right")):
		if(selectedIndex>=2 and selectedIndex<=4):
			get_node("VBoxContainer").get_child(selectedIndex).get_node("MarginContainer2/VolumeSlider").value+=0.05
	if(Input.is_action_just_pressed("UI_left")):
		if(selectedIndex>=2 and selectedIndex<=4):
			get_node("VBoxContainer").get_child(selectedIndex).get_node("MarginContainer2/VolumeSlider").value-=0.05

func _highlight(index):
	soundEffect.play()
	for i in range(1, get_node("VBoxContainer").get_children().size()-1):
		var panel = get_node("VBoxContainer").get_child(i).get_node("SelectedPanel")
		if(i==index):
			panel.set_visible(true)
		else:
			panel.set_visible(false)
