extends Node2D

var crosshair

@export var crosshairDistance = 20000

@export var maxModeAmount=5
var firingModes = []
var currentFiringMode = 0

var aiming = true
var canShoot = true
var aimDirection = Vector2.ZERO

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	#initialize random array of firing modes, for testing purposes
	for i in maxModeAmount:
		var firingMode=["single", snapped(rng.randf(), 0.01), snapped(rng.randf(), 0.01), snapped(rng.randf(), 0.01)]
		firingModes.append(firingMode)
		
	crosshair=get_node("Crosshair")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	aimDirection = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")

	#move crosshair
	if(aimDirection.length()==0):
		aiming = false
		crosshair.set_position(Vector2(0, 0)) #if not aiming, the crosshair is hidden under the player
	else:
		aiming = true
		crosshair.set_position(aimDirection.normalized() * delta * crosshairDistance)  #change crosshair position


func _shoot():
	await get_tree().create_timer(1).timeout
	if(aiming):
		match firingModes[currentFiringMode][0]: 
			#firing modes here
			"single":
				print("single shooting")
			"triple":
				print("triple shooting")
			"blast":
				print("blast shooting")
			"beam":
				print("beam shooting")
			"beam_continuous":
				print("beam_continuous shooting")
			"circle":
				print("circle shooting")



#switch firing mode
func _on_switch_timer_timeout():
	if(currentFiringMode<4):
		currentFiringMode+=1
	else:
		currentFiringMode=0
