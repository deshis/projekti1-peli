extends Node2D

@onready var crosshair = get_node("Crosshair")
@export var crosshairDistance = 20000

@export var maxModeAmount=5
var firingModes = []
var currentFiringMode = 0

var aiming = true
var canShoot = true
var aimDirection = Vector2.ZERO
@onready var shootTimer = get_node("ShootTimer")


@onready var modeGenerator = get_node("/root/Main/ModeGenerator")


# Called when the node enters the scene tree for the first time.
func _ready():
	
	#initialize random array of firing modes, for testing purposes
	for i in maxModeAmount:
		var firingMode=modeGenerator._create_mode(0)
		firingModes.append(firingMode)
	print(str(firingModes))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	aimDirection = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	
	#move crosshair
	if(aimDirection.length()==0):
		crosshair.set_position(Vector2(0, 0)) #if not aiming, the crosshair is hidden under the player
	else:
		crosshair.set_position(aimDirection.normalized() * delta * crosshairDistance)  #change crosshair position
		_shoot()


func _shoot():
	var type = firingModes[currentFiringMode][0]
	var damage = firingModes[currentFiringMode][1]
	var firerate = firingModes[currentFiringMode][2]
	var size = firingModes[currentFiringMode][3]
	var speed = firingModes[currentFiringMode][4]
	
	if(canShoot):
		match type: 
			#firing modes here
			"single":
				print("single shooting")
			"triple":
				print("triple shooting")
			"blast":
				print("blast shooting")
			"beam":
				print("beam shooting")
			"circle":
				print("circle shooting")
		shootTimer.start(firerate)
		canShoot=false
		print("timer set for "+str(firerate))


#switch firing mode
func _on_switch_timer_timeout():
	if(currentFiringMode<firingModes.size()-1):
		currentFiringMode+=1
	else:
		currentFiringMode=0

#when shooting cooldown ends
func _on_shoot_timer_timeout():
	canShoot=true
