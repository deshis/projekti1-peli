extends CharacterBody2D

@export var SPEED = 140.0
@export var damage = 8.0
@export var maxHealth = 40

@onready var target = get_node("/root/Main/Player")
@onready var navAgent = get_node("NavigationAgent2D")
@onready var cooldownTimer = get_node("CooldownTimer")
@onready var healthBar = get_node("ProgressBar")

var cooldownActive = false
@export var threshold = 30
@export var cooldown = 1.5

var currentHealth

@export var itemDropChance = 0.05

var rng = RandomNumberGenerator.new()
var meleeHitbox = preload("res://MeleeHitbox.tscn")
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
@onready var attackSound = get_node("MeleeEnemyAttack")

func _ready():
	if(budget):
		SPEED=SPEED+SPEED*budget/50
		maxHealth=maxHealth+maxHealth*budget/50
		damage=damage+damage*budget/50
	currentHealth=maxHealth
	healthBar.max_value = maxHealth
	healthBar.value = currentHealth
	_update_target()


func _physics_process(_delta):
	if(global_position.distance_to(target.global_position)>=threshold&&!cooldownActive):
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
	if(global_position.distance_to(target.global_position)<=threshold&&!cooldownActive):
		_attack()
	else:
		_update_target()


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()


func _attack():
	cooldownActive = true 
	cooldownTimer.start(rng.randf_range(0.95, 1.05)*cooldown) #variation to prevent all enemies from checking on same frame
	var aimDirection = target.global_position-global_position
	var instance = meleeHitbox.instantiate()
	instance.position=global_position+aimDirection/1.2
	instance.set_damage(damage)
	instance.get_node("CollisionShape2D").set_scale(Vector2(3, 3))
	instance.look_at(target.global_position)
	await get_tree().create_timer(0.1).timeout #pause to give player time to dodge
	get_tree().current_scene.add_child(instance)
	play_attack_animation(aimDirection.normalized())
	attackSound.play()

func _on_cooldown_timer_timeout():
	cooldownActive = false
	animationPlaying=false

func _update_target(): 
	await Engine.get_main_loop().process_frame
	navAgent.target_position=target.global_position

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
