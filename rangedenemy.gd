extends CharacterBody2D

@export var SPEED = 115.0
@export var maxHealth = 40

@onready var target = get_node("/root/Main/Player")
@onready var ray = get_node("/root/Main/Player/EnemyPathfindingRaycast")
@onready var navAgent = get_node("NavigationAgent2D")
@onready var cooldownTimer = get_node("CooldownTimer")
@onready var modeGenerator = get_node("/root/Main/ModeGenerator")
@onready var healthBar = get_node("ProgressBar")

var cooldownActive = false
var targetOffset = Vector2(0,0)
@export var shootingDistance = 100
@export var threshold = 25
@export var cooldown = 1.5

var currentHealth

@export var itemDropChance = 0.05

@onready var rangedEnemyTarget = target.global_position

var projectile = preload("res://enemy_projectile.tscn")
var firingMode
var rng = RandomNumberGenerator.new()

var bias

var item = preload("res://item_pick_up.tscn")

var budget

var animationThreshold = 0
@onready var animatedSprite = get_node("AnimatedSprite2D")
var animDirection
var animationPlaying = false

@onready var dotTimer = get_node("DOTTimer")
var damageOverTime = false

@onready var aoe = preload("res://aoe.tscn")

@onready var deathExplosion = preload("res://explosion.tscn")
@onready var attackSound = get_node("RangedEnemyAttack")


func _ready():
	if(budget):
		SPEED=SPEED+SPEED*budget/50
		maxHealth=maxHealth+maxHealth*budget/20
		bias=budget/100
	currentHealth=maxHealth
	healthBar.max_value = maxHealth
	healthBar.value = currentHealth
	if(budget):
		firingMode=modeGenerator._create_mode(bias, 0, 5)
	else:
		firingMode=modeGenerator._create_mode(0, 0, 5)
	_update_ranged_target()

func _physics_process(_delta):
	if(!cooldownActive):
		var direction = to_local(navAgent.get_next_path_position()).normalized()
		navAgent.set_velocity(direction*SPEED)
	else: 
		navAgent.set_velocity(Vector2(0,0))
	
	
	animDirection = velocity.normalized()
	if(!animationPlaying):
		if(animDirection.x>animationThreshold):
			if(animDirection.y<-animationThreshold):
				animatedSprite.play("move_up_right")
				animatedSprite.set_flip_h(false)
			elif(animDirection.y>animationThreshold):
				animatedSprite.play("move_down_left")
				animatedSprite.set_flip_h(true)
		elif(animDirection.x<-animationThreshold):
			if(animDirection.y<-animationThreshold):
				animatedSprite.play("move_up_right")
				animatedSprite.set_flip_h(true)
			elif(animDirection.y>animationThreshold):
				animatedSprite.play("move_down_left")
				animatedSprite.set_flip_h(false)

func play_attack_animation(dir):
	if(dir.x>animationThreshold):
		if(dir.y<-animationThreshold):
			animatedSprite.play("attack_up_right")
			animatedSprite.set_flip_h(false)
		elif(dir.y>animationThreshold):
			animatedSprite.play("attack_down_left")
			animatedSprite.set_flip_h(true)
	elif(dir.x<-animationThreshold):
		if(dir.y<-animationThreshold):
			animatedSprite.play("attack_up_right")
			animatedSprite.set_flip_h(true)
		elif(dir.y>animationThreshold):
			animatedSprite.play("attack_down_left")
			animatedSprite.set_flip_h(false)
	animationPlaying=true

func _on_timer_timeout(): #refresh target
	if(global_position.distance_to(rangedEnemyTarget)<=threshold&&!cooldownActive):
		_shoot()
	else:
		navAgent.target_position=rangedEnemyTarget

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()

func _shoot():
	cooldownActive = true 
	cooldownTimer.start(rng.randf_range(0.95, 1.05)*cooldown) #variation to prevent all enemies from checking on same frame
	
	var aimDirection = target.global_position-global_position
	aimDirection=aimDirection.normalized()
	var type = firingMode[0]
	var damage = firingMode[1]
	var size = firingMode[3]
	var speed = firingMode[4]
	match type: 
		"single":
			_spawn_projectile(aimDirection,damage,speed,size)
		"triple":
			_spawn_projectile(aimDirection,damage,speed,size)
			_spawn_projectile(aimDirection.rotated(deg_to_rad(7.5)),damage,speed,size)
			_spawn_projectile(aimDirection.rotated(deg_to_rad(-7.5)),damage,speed,size)
		"blast":
			for i in rng.randi_range(4,6):
				_spawn_projectile(aimDirection.rotated(deg_to_rad(rng.randfn(0,5))),damage,speed*rng.randf_range(0.9,1.1),size*rng.randf_range(0.9,1.1))
		"circle":
			var circleAmount=16.0
			for i in circleAmount:
				_spawn_projectile(aimDirection.rotated(deg_to_rad(360/circleAmount*i)),damage,speed,size)
		"burst":
			_burst(aimDirection,damage,speed,size)
		"spray":
			_spray(aimDirection,damage,speed,size)
	play_attack_animation(aimDirection.normalized())
	attackSound.play()

func _spawn_projectile(direction,damage,speed,size):
	var instance = projectile.instantiate()
	instance.position=global_position
	instance.set_damage(damage)
	instance.set_linear_velocity(direction*speed)
	instance.get_node("AnimatedSprite2D").set_scale(Vector2(size, size))
	instance.get_node("CollisionShape2D").set_scale(Vector2(size, size))
	get_tree().current_scene.add_child(instance)
	
func _burst(direction,damage,speed,size):
	for i in rng.randi_range(3,5):
		_spawn_projectile(direction,damage,speed,size)
		await get_tree().create_timer(0.05).timeout
		
func _spray(direction,damage,speed,size):
	for i in 5:
		_spawn_projectile(direction.rotated(deg_to_rad(-20+10*i)),damage,speed,size)
		await get_tree().create_timer(0.05).timeout

func _on_cooldown_timer_timeout():
	_update_ranged_target()
	cooldownActive = false
	animationPlaying=false

func _update_ranged_target():
	await Engine.get_main_loop().process_frame
	var direction = Vector2(rng.randf_range(-1,1),rng.randf_range(-1,1)).normalized()
	direction *= shootingDistance
	ray.set_target_position(direction)
	ray.force_raycast_update()
	if(ray.get_collider()):
		rangedEnemyTarget=ray.get_collision_point()
	else:
		rangedEnemyTarget=target.global_position+direction

func _on_enemy_hurt_box_body_entered(body):
	#if collide with playerprojectile on layer, take damage and delete projectile.
	if body.get_collision_layer()==4:
		var dmg = body.get_damage()
		if(body.heal):
			get_node("/root/Main/Player").heal(dmg/5.0)
		if(body.aoe):
			dmg=dmg/2.0
			var instance = aoe.instantiate()
			instance.position=global_position
			instance.set_damage(dmg)
			get_tree().current_scene.call_deferred("add_child", instance)
		if(body.dot):
			_damage_over_time()
		if(body._get_type()=="projectile"): #dont delete lasers or aoe
			body.queue_free()
			
		_take_damage(dmg)

func _damage_over_time():
	damageOverTime=true
	dotTimer.start(5.0)

func _on_dot_timer_timeout():
	damageOverTime = false

func _on_dot_timer_2_timeout():
	if(damageOverTime):
		_take_damage(2)

func _take_damage(dmg):
	currentHealth-=dmg
	healthBar.value = currentHealth
	if(currentHealth<=0):
		if(rng.randf_range(0, 1)<=itemDropChance):
			var itemInstance = item.instantiate()
			itemInstance.position=global_position
			get_tree().current_scene.call_deferred("add_child", itemInstance)
		var explosionInstance = deathExplosion.instantiate()
		explosionInstance.position=global_position
		get_tree().current_scene.call_deferred("add_child", explosionInstance)
		queue_free()
