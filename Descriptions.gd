extends VBoxContainer

@onready var player = get_node("/root/Main/Player/PlayerProjectileSpawner") 

var textBoxes=[]

# Called when the node enters the scene tree for the first time.
func _ready():
	var firingModes = player._get_firing_modes()
	for i in range(firingModes.size()):
		textBoxes.append(get_children()[i].get_children()[0])
	var textIndex=0
	for mode in firingModes:
		textBoxes[textIndex].append_text("TYPE: "+str(mode[0])+"\n")
		textBoxes[textIndex].append_text("DAMAGE: "+str(snapped(mode[1], 0.01))+"\n")
		if(mode[2]==-1):
			textBoxes[textIndex].append_text("FIRERATE: N/A \n")
		else:
			textBoxes[textIndex].append_text("FIRERATE: "+str(snapped(mode[2], 0.01))+"\n")
		textBoxes[textIndex].append_text("SIZE: "+str(snapped(mode[3], 0.01))+"\n")
		if(mode[4]==-1):
			textBoxes[textIndex].append_text("SPEED: N/A \n")
		else:
			textBoxes[textIndex].append_text("SPEED: "+str(snapped(mode[4], 1))+"\n")
		if(mode[5]): #dot
			textBoxes[textIndex].append_text("DAMAGE OVER TIME: Continues to deal damage for 5 seconds after hitting an enemy\n")
		if(mode[6]): #aoe
			textBoxes[textIndex].append_text("AREA OF EFFECT: Deals damage to nearby enemies after hitting an enemy\n")
		if(mode[7]): #selfheal
			textBoxes[textIndex].append_text("HEALING: Heal for 20% of damage dealt after hitting an enemy\n")
		textIndex+=1 
