extends Panel

var mode
var item

@onready var textBox=get_node("InventorySplitter/NewMode/VBoxContainer/NewModeTextMargin/RichTextLabel")
@onready var textureBox=get_node("InventorySplitter/NewMode/VBoxContainer/NewModeTexture")
@onready var player = get_node("/root/Main/Player/PlayerProjectileSpawner") 
@onready var currentModes=get_node("InventorySplitter/CurrentModes")
@onready var Descriptions=get_node("InventorySplitter/Descriptions")
@onready var newMode = get_node("InventorySplitter/NewMode")
@onready var pauseMenu = get_node("InventorySplitter/PauseMenuButtons")
@onready var HUD = get_parent()

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
		newMode.set_process(false)
		newMode.visible=false
		
		pauseMenu.set_process(true)
		pauseMenu.visible=true
		
		_highlightPauseMenu(0)
	else: #pick up new mode
		newMode.set_process(true)
		pauseMenu.set_process(false)
		pauseMenu.visible=false
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
			HUD._close_inventory()
			HUD.get_node("FiringQueueMargin/FiringQueueContainer")._update_firing_mode_ui()
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
			if(selectedIndex==0): #continue game
				HUD._close_inventory() 
			elif(selectedIndex==1): #main menu
					get_tree().change_scene_to_file("res://menu.tscn")


func _highlight(index):
	for i in currentModes.get_children().size():
		var panel = currentModes.get_child(i).get_node("Panel")
		if(i==index):
			panel.set_visible(true)
		else:
			panel.set_visible(false)

func _highlightPauseMenu(index):
	var buttons = get_node("InventorySplitter/PauseMenuButtons")
	for i in range(0,buttons.get_children().size()):
		if(i==index):
			buttons.get_child(i).get_node("SelectedPanel").set_visible(true)
		else:
			buttons.get_child(i).get_node("SelectedPanel").set_visible(false)
