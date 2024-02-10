extends Control

var selectedIndex=0

func _ready():
	get_tree().paused = false
	_highlight(0)

func _process(_delta):
	if(Input.is_action_just_pressed("UI_up")):
		if(selectedIndex<=0):
			selectedIndex=3
		else:
			selectedIndex-=1
		_highlight(selectedIndex)
	if(Input.is_action_just_pressed("UI_down")):
		if(selectedIndex>=3):
			selectedIndex=0
		else:
			selectedIndex+=1
		_highlight(selectedIndex)
	if(Input.is_action_just_pressed("accept")):
		if(selectedIndex==0): #start game
			get_tree().change_scene_to_file("res://main.tscn")
		elif(selectedIndex==1): #controls
			pass
		elif(selectedIndex==2): #credits
			pass
		elif(selectedIndex==3): #quit game
			get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
			get_tree().quit()


func _highlight(index):
	for i in range(4):
		var panel = get_node("Panel/MenuButtons").get_child(i).get_node("SelectedPanel")
		if(i==index):
			panel.set_visible(true)
		else:
			panel.set_visible(false)
