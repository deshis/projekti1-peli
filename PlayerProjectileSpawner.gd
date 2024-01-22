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
@onready var switchTimer = get_node("/root/Main/SwitchTimer")

@onready var modeGenerator = get_node("/root/Main/ModeGenerator")

var projectile = preload("res://player_projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	switchTimer.timeout.connect(_on_switch_timer_timeout)
	
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
		aimDirection=aimDirection.normalized()
		crosshair.set_position(aimDirection * delta * crosshairDistance)  #change crosshair position
		_shoot()


func _shoot():
	var type = firingModes[currentFiringMode][0]
	var damage = firingModes[currentFiringMode][1]
	var firerate = firingModes[currentFiringMode][2]
	var size = firingModes[currentFiringMode][3]
	var speed = firingModes[currentFiringMode][4]
	
	
	if(canShoot):
		match type: 
			"single":
				_spawn_projectile(aimDirection,damage,speed,size)
				shootTimer.start(firerate)
			"triple":
				pass
			"blast":
				pass
			"beam":
				pass
			"circle":
				pass
			"burst":
				pass
			"spray":
				pass
		canShoot=false

func _spawn_projectile(direction,damage,speed,size):
	var instance = projectile.instantiate()
	instance.position=global_position
	instance.set_damage(damage)
	instance.set_linear_velocity(direction*speed)
	instance.get_node("AnimatedSprite2D").set_scale(Vector2(size, size))
	instance.get_node("CollisionShape2D").set_scale(Vector2(size, size))
	get_tree().current_scene.add_child(instance)

#switch firing mode
func _on_switch_timer_timeout():
	if(currentFiringMode<firingModes.size()-1):
		currentFiringMode+=1
	else:
		currentFiringMode=0

#when shooting cooldown ends
func _on_shoot_timer_timeout():
	canShoot=true
