extends Control

var selectedIndex=0

func _ready():
	get_node("Panel/timeMargin/RichTextLabel").set_text("[center]You were alive for "+str(Global.timeAlive))
	_highlight(0)

func _process(_delta):
	if(Input.is_action_just_pressed("UI_up")):
		if(selectedIndex<=0):
			selectedIndex=1
		else:
			selectedIndex-=1
		_highlight(selectedIndex)
	if(Input.is_action_just_pressed("UI_down")):
		if(selectedIndex>=1):
			selectedIndex=0
		else:
			selectedIndex+=1
		_highlight(selectedIndex)
	if(Input.is_action_just_pressed("accept")):
		if(selectedIndex==0): #restart
			get_tree().change_scene_to_file("res://main.tscn")
		elif(selectedIndex==1): #main menu
			get_tree().change_scene_to_file("res://menu.tscn")


func _highlight(index):
	for i in range(2):
		var panel = get_node("Panel/MenuButtons").get_child(i).get_node("SelectedPanel")
		if(i==index):
			panel.set_visible(true)
		else:
			panel.set_visible(false)
