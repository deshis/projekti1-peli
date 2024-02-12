extends Node2D

@onready var crosshair = get_node("Crosshair")
@export var crosshairDistance = 200

@export var maxModeAmount=5
var firingModes = []
var currentFiringMode = 0

var aiming = true
var canShoot = true
var aimDirection = Vector2.ZERO

@onready var shootTimer = get_node("ShootTimer")
@onready var switchTimer = get_node("/root/Main/SwitchTimer")
@onready var modeGenerator = get_node("/root/Main/ModeGenerator")
@onready var laserRay = get_node("LaserRayCaster")

var projectile = preload("res://player_projectile.tscn")
var laser = preload("res://player_laser.tscn")

var rng = RandomNumberGenerator.new()

var animationThreshold=0.35
@onready var animatedSprite = get_node("AnimatedSprite2D")
var animationPlaying = false

# Called when the node enters the scene tree for the first time.
func _ready():
	switchTimer.timeout.connect(_on_switch_timer_timeout)
	
	#initialize default firing modes at start of game
	for i in maxModeAmount:
		var firingMode=modeGenerator._create_default_mode()
		firingModes.append(firingMode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	crosshair.set_position(Vector2.ZERO) #if not aiming, the crosshair is hidden under the player
	aimDirection = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	
	
	if(!Input.is_action_pressed("sprint")):	#disable aiming while sprinting
		if(aimDirection.length()>0):
			aimDirection=aimDirection.normalized() 
			crosshair.set_position(aimDirection * crosshairDistance)  #change crosshair position
			_shoot()
	
	#aiming animations
	if(!animationPlaying):
		if(aimDirection.x>animationThreshold):
			if(aimDirection.y<-animationThreshold):
				animatedSprite.play("aim_up_right")
				animatedSprite.set_flip_h(false)
			elif(aimDirection.y>animationThreshold):
				animatedSprite.play("aim_down_right")
				animatedSprite.set_flip_h(false)
			else:
				animatedSprite.play("aim_right")
				animatedSprite.set_flip_h(false)
		elif(aimDirection.x<-animationThreshold):
			if(aimDirection.y<-animationThreshold):
				animatedSprite.play("aim_up_right")
				animatedSprite.set_flip_h(true)
			elif(aimDirection.y>animationThreshold):
				animatedSprite.play("aim_down_right")
				animatedSprite.set_flip_h(true)
			else:
				animatedSprite.play("aim_right")
				animatedSprite.set_flip_h(true)
		elif(aimDirection.y<-animationThreshold):
			animatedSprite.play("aim_up")
			animatedSprite.set_flip_h(false)
		elif(aimDirection.y>animationThreshold):
			animatedSprite.play("aim_down")
			animatedSprite.set_flip_h(false)

func play_shoot_animation():
	if(aimDirection.x>animationThreshold):
		if(aimDirection.y<-animationThreshold):
			animatedSprite.play("shoot_up_right")
			animatedSprite.set_flip_h(false)
		elif(aimDirection.y>animationThreshold):
			animatedSprite.play("shoot_down_right")
			animatedSprite.set_flip_h(false)
		else:
			animatedSprite.play("shoot_right")
			animatedSprite.set_flip_h(false)
	elif(aimDirection.x<-animationThreshold):
		if(aimDirection.y<-animationThreshold):
			animatedSprite.play("shoot_up_right")
			animatedSprite.set_flip_h(true)
		elif(aimDirection.y>animationThreshold):
			animatedSprite.play("shoot_down_right")
			animatedSprite.set_flip_h(true)
		else:
			animatedSprite.play("shoot_right")
			animatedSprite.set_flip_h(true)
	elif(aimDirection.y<-animationThreshold):
		animatedSprite.play("shoot_up")
		animatedSprite.set_flip_h(false)
	elif(aimDirection.y>animationThreshold):
		animatedSprite.play("shoot_down")
		animatedSprite.set_flip_h(false)
	animationPlaying=true


func _shoot():
	var type = firingModes[currentFiringMode][0]
	var damage = firingModes[currentFiringMode][1]
	var firerate = firingModes[currentFiringMode][2]
	var size = firingModes[currentFiringMode][3]
	var speed = firingModes[currentFiringMode][4]
	var dot = firingModes[currentFiringMode][5]
	var aoe = firingModes[currentFiringMode][6]
	var heal = firingModes[currentFiringMode][7]
	
	if(canShoot):
		match type: 
			"single":
				_spawn_projectile(aimDirection,damage,speed,size, dot, aoe, heal)
			"triple":
				_spawn_projectile(aimDirection,damage,speed,size, dot, aoe, heal)
				_spawn_projectile(aimDirection.rotated(deg_to_rad(7.5)),damage,speed,size, dot, aoe, heal)
				_spawn_projectile(aimDirection.rotated(deg_to_rad(-7.5)),damage,speed,size, dot, aoe, heal)
			"blast":
				for i in rng.randi_range(6,8):
					_spawn_projectile(aimDirection.rotated(deg_to_rad(rng.randfn(0,5))),damage,speed*rng.randf_range(0.9,1.1),size*rng.randf_range(0.9,1.1), dot, aoe, heal)
			"circle":
				var circleAmount=16.0
				for i in circleAmount:
					_spawn_projectile(aimDirection.rotated(deg_to_rad(360/circleAmount*i)),damage,speed,size, dot, aoe, heal)
			"burst":
				_burst(aimDirection,damage,speed,size, dot, aoe, heal)
			"spray":
				_spray(aimDirection,damage,speed,size, dot, aoe, heal)
			"laser":
				_spawn_laser(damage, size, dot, aoe, heal)
			"beam":
				_spawn_beam(damage, size, dot, aoe, heal)
		if(type!="beam"):
			shootTimer.start(firerate)
			canShoot=false
			play_shoot_animation()

func _spawn_beam(damage,width, dot, aoe, heal):
	var ray = _cast_ray_in_aim_direction()
	var instance = laser.instantiate()
	instance.position=global_position+ray/2
	instance.set_damage(damage)
	instance.get_node("AnimatedSprite2D").set_scale(Vector2(ray.length()/32, width))
	instance.get_node("CollisionShape2D").set_scale(Vector2(ray.length()/32, width))
	instance.look_at(global_position+ray)
	instance.continuous=true
	instance.dot=dot
	instance.aoe=aoe
	instance.heal=heal
	get_tree().current_scene.add_child(instance)
	

func _spawn_laser(damage,width, dot, aoe, heal):
	var ray = _cast_ray_in_aim_direction()
	var instance = laser.instantiate()
	instance.position=global_position+ray/2
	instance.set_damage(damage)
	instance.get_node("AnimatedSprite2D").set_scale(Vector2(ray.length()/32, width))
	instance.get_node("CollisionShape2D").set_scale(Vector2(ray.length()/32, width))
	instance.look_at(global_position+ray)
	instance.dot=dot
	instance.aoe=aoe
	instance.heal=heal
	get_tree().current_scene.add_child(instance)

func _spawn_projectile(direction,damage,speed,size, dot, aoe, heal):
	var instance = projectile.instantiate()
	instance.position=global_position
	instance.set_damage(damage)
	instance.set_linear_velocity(direction*speed)
	instance.get_node("AnimatedSprite2D").set_scale(Vector2(size, size))
	instance.get_node("CollisionShape2D").set_scale(Vector2(size, size))
	instance.dot=dot
	instance.aoe=aoe
	instance.heal=heal
	get_tree().current_scene.add_child(instance)
	
func _burst(direction,damage,speed,size, dot, aoe, heal):
	for i in rng.randi_range(3,5):
		_spawn_projectile(direction,damage,speed,size, dot, aoe, heal)
		await get_tree().create_timer(0.05).timeout

func _spray(direction,damage,speed,size, dot, aoe, heal):
	for i in 5:
		_spawn_projectile(direction.rotated(deg_to_rad(-20+10*i)),damage,speed,size, dot, aoe, heal)
		await get_tree().create_timer(0.05).timeout

func _cast_ray_in_aim_direction():
	laserRay.set_target_position(aimDirection*2000)
	laserRay.force_raycast_update()
	if(laserRay.is_colliding()):
		return (laserRay.get_collision_point()-global_position)
	else:
		return (aimDirection*2000)

#switch firing mode
func _on_switch_timer_timeout():
	if(currentFiringMode<firingModes.size()-1):
		currentFiringMode+=1
	else:
		currentFiringMode=0

#when shooting cooldown ends
func _on_shoot_timer_timeout():
	canShoot=true

#delayed shot timer for burst and spray firing modes
func _on_delayed_shot_timer_timeout():
	pass

func _get_firing_modes():
	return firingModes

func _get_current_firing_mode():
	return currentFiringMode

func _swap_mode(mode, index):
	firingModes[index]=mode


func _on_animated_sprite_2d_animation_finished():
	animationPlaying = false
