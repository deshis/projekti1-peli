extends VBoxContainer

@onready var player = get_node("/root/Main/Player/PlayerProjectileSpawner") 

var textureRects=[]
var firingModes

# Called when the node enters the scene tree for the first time.
func _ready():
	firingModes = player._get_firing_modes()
	for i in range(firingModes.size()):
		textureRects.append(get_children()[i].get_children()[0])
	var textureIndex=0
	for mode in firingModes:
		textureRects[textureIndex].texture=load("res://sprites/"+mode[0]+".png")
		textureIndex+=1
