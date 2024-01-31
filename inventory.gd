extends Panel

var mode
var item
@onready var textBox=get_child(0).get_child(2).get_child(0).get_child(1).get_child(0)
@onready var textureBox=get_child(0).get_child(2).get_child(0).get_child(0)
@onready var player = get_node("/root/Main/Player/PlayerProjectileSpawner") 

@onready var currentModes=get_child(0).get_child(0)
@onready var Descriptions=get_child(0).get_child(1)

var selectedModeContainer

var swapping
var paused
var selectedIndex

# Called when the node enters the scene tree for the first time.
func _ready():
	swapping = false
	paused = false
	selectedIndex = 0
	if(!mode): #pause menu
		paused = true
		get_child(0).get_child(2).set_process(false)
		get_child(0).get_child(2).visible=false
		
		get_child(0).get_child(3).set_process(true)
		get_child(0).get_child(3).visible=true
		
		_highlightPauseMenu(0)
	else: #pick up new mode
		get_child(0).get_child(2).set_process(true)
		get_child(0).get_child(3).set_process(false)
		get_child(0).get_child(3).visible=false
		textureBox.texture=load("res://sprites/"+mode[0]+".png")
		textBox.push_font_size(24)
		textBox.append_text("[center]")
		textBox.append_text("TYPE: "+str(mode[0])+"\n")
		textBox.append_text("DAMAGE: "+str(snapped(mode[1], 0.01))+"\n")
		if(mode[2]==-1):
			textBox.append_text("FIRERATE: N/A \n")
		else:
			textBox.append_text("FIRERATE: "+str(snapped(mode[2], 0.01))+"\n")
		textBox.append_text("SIZE: "+str(snapped(mode[3],0.01))+"\n")
		if(mode[4]==-1):
			textBox.append_text("SPEED: N/A \n")
		else:
			textBox.append_text("SPEED: "+str(snapped(mode[4],1))+"\n")
			
func _set_swapping(s):
	swapping = s


func _process(_delta):
	if(swapping): #selecting a new mode 
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
			player._swap_mode(mode, selectedIndex)
			get_parent()._close_inventory()
			get_parent().get_child(3).get_child(0)._update_firing_mode_ui()
			item.queue_free()
	elif(paused): #pause menu
		if(Input.is_action_just_pressed("UI_up")):
			if(selectedIndex<=0):
				selectedIndex=1
			else:
				selectedIndex-=1
			_highlightPauseMenu(selectedIndex)
		if(Input.is_action_just_pressed("UI_down")):
			if(selectedIndex>=1):
				selectedIndex=0
			else:
				selectedIndex+=1
			_highlightPauseMenu(selectedIndex)
		if(Input.is_action_just_pressed("accept")):
			if(selectedIndex==0): #close the menu and continue game
				get_parent()._close_inventory() 
			elif(selectedIndex==1): #quit the game
				get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
				get_tree().quit()


func _highlight(index):
	for i in currentModes.get_children().size():
		if(i==index):
			currentModes.get_child(i).get_child(1).set_visible(true)
		else:
			currentModes.get_child(i).get_child(1).set_visible(false)


func _highlightPauseMenu(index):
	for i in range(0,get_child(0).get_child(3).get_children().size()):
		if(i==index):
			get_child(0).get_child(3).get_child(i).get_child(2).set_visible(true)
		else:
			get_child(0).get_child(3).get_child(i).get_child(2).set_visible(false)
