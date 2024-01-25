extends HBoxContainer

@onready var player = get_node("/root/Main/Player/PlayerProjectileSpawner") 

@onready var switchTimer = get_node("/root/Main/SwitchTimer")

var textureRects=[]

# Called when the node enters the scene tree for the first time.
func _ready():
	await Engine.get_main_loop().process_frame #wait 1 frame
	switchTimer.timeout.connect(_on_switch_timer_timeout)
	for i in range(player._get_firing_modes().size()):
		textureRects.append(get_children()[i].get_children()[0])
	_update_firing_mode_ui()

func _on_switch_timer_timeout():
	_update_firing_mode_ui()

func _update_firing_mode_ui():
	var firingModeIndex=player._get_current_firing_mode()
	var firingModes = player._get_firing_modes().duplicate()
	var temp = firingModes.slice(0, firingModeIndex)
	firingModes.append_array(temp)
	for i in range(temp.size()):
		firingModes.pop_front()


	var textureIndex = 0
	for mode in firingModes:
		var type = mode[0]
		match type:
			"single":
				textureRects[textureIndex].texture=load("res://sprites/single.png")
			"triple":
				textureRects[textureIndex].texture=load("res://sprites/triple.png")
		textureIndex+=1

