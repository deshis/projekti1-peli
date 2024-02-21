extends Control

var selectedIndex=0
@onready var soundEffect = get_node("UI_select") 

func _ready():
	get_tree().paused = false
	for i in range(5):
		var panel = get_node("Panel/MenuButtons").get_child(i).get_node("SelectedPanel")
		if(i==0):
			panel.set_visible(true)
		else:
			panel.set_visible(false)

func _process(_delta):
	
	if(Input.is_action_just_pressed("keyboardInputs")):
		Global.controller=false
	elif(Input.is_action_just_pressed("controllerInputs", false)):
		Global.controller=true
		
	if(Input.is_action_just_pressed("UI_up")):
		if(selectedIndex<=0):
			selectedIndex=4
		else:
			selectedIndex-=1
		_highlight(selectedIndex)
	if(Input.is_action_just_pressed("UI_down")):
		if(selectedIndex>=4):
			selectedIndex=0
		else:
			selectedIndex+=1
		_highlight(selectedIndex)
	if(Input.is_action_just_pressed("accept")):
		Global.mainMenuMusicTime=get_node("Music").get_playback_position()
		if(selectedIndex==0): #start game
			get_tree().change_scene_to_file("res://scenes/misc/main.tscn")
		elif(selectedIndex==1): #controls
			get_tree().change_scene_to_file("res://scenes/menu/controls.tscn")
		elif(selectedIndex==2): #credits
			get_tree().change_scene_to_file("res://scenes/menu/credits.tscn")
		elif(selectedIndex==3): #settings
			get_tree().change_scene_to_file("res://scenes/menu/settings.tscn")
		elif(selectedIndex==4): #quit
			get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
			get_tree().quit()

func _highlight(index):
	soundEffect.play()
	for i in range(5):
		var panel = get_node("Panel/MenuButtons").get_child(i).get_node("SelectedPanel")
		if(i==index):
			panel.set_visible(true)
		else:
			panel.set_visible(false)
