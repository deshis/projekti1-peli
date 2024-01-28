extends Panel

var mode
@onready var textBox=get_child(0).get_child(2).get_child(0).get_child(1).get_child(0)
@onready var textureBox=get_child(0).get_child(2).get_child(0).get_child(0)
@onready var player = get_node("/root/Main/Player/PlayerProjectileSpawner") 

@onready var currentModes=get_child(0).get_child(0)
@onready var Descriptions=get_child(0).get_child(1)

var swapping
var selectedIndex

# Called when the node enters the scene tree for the first time.
func _ready():
	swapping = false
	selectedIndex = 0
	if(!mode):
		get_child(0).get_child(2).set_process(false)
	else:
		get_child(0).get_child(2).set_process(true)
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
	if(swapping):
		if(Input.is_action_just_pressed("UI_up")):
			if(selectedIndex<=0):
				selectedIndex=4
			else:
				selectedIndex-=1
		if(Input.is_action_just_pressed("UI_down")):
			if(selectedIndex>=4):
				selectedIndex=0
			else:
				selectedIndex+=1
		#for i in currentModes:
			#var modeContainer = get_child(0)
			#modeContainer.
			
			#highlight selected.......
