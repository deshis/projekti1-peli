extends CharacterBody2D

@export var SPEED = 450.0

@onready var target = get_node("/root/Main/Player")
@onready var navAgent = get_node("NavigationAgent2D")
@onready var cooldownTimer = get_node("CooldownTimer")
@onready var healthBar = get_node("ProgressBar")

var cooldownActive = false
@export var threshold = 100
@export var cooldown = 1.5

@export var damage = 10

@export var maxHealth = 50
var currentHealth

@export var itemDropChance = 0.05

var rng = RandomNumberGenerator.new()
var meleeHitbox = preload("res://MeleeHitbox.tscn")
var item = preload("res://item_pick_up.tscn")

func _ready():
	currentHealth=maxHealth
	healthBar.max_value = maxHealth
	healthBar.value = currentHealth
	_update_target()

func _physics_process(_delta):
	if(global_position.distance_to(target.global_position)>=threshold&&!cooldownActive):
		var direction = to_local(navAgent.get_next_path_position()).normalized()
		navAgent.set_velocity(direction)
	else: 
		navAgent.set_velocity(Vector2(0,0))

func _on_timer_timeout(): #refresh target
	if(global_position.distance_to(target.global_position)<=threshold&&!cooldownActive):
		_attack()
	else:
		_update_target()

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity*SPEED
	move_and_slide()


func _attack():
	cooldownActive = true 
	cooldownTimer.start(rng.randf_range(0.95, 1.05)*cooldown) #variation to prevent all enemies from checking on same frame
	var aimDirection = target.global_position-global_position
	#aimDirection=aimDirection.normalized()
	var instance = meleeHitbox.instantiate()
	instance.position=global_position+aimDirection/1.5
	instance.set_damage(damage)
	instance.get_node("AnimatedSprite2D").set_scale(Vector2(3, 3))
	instance.get_node("CollisionShape2D").set_scale(Vector2(3, 3))
	instance.look_at(target.global_position)
	await get_tree().create_timer(0.2).timeout #pause to give player time to dodge
	get_tree().current_scene.add_child(instance)
	


func _on_cooldown_timer_timeout():
	cooldownActive = false

func _update_target(): 
	await Engine.get_main_loop().process_frame
	navAgent.target_position=target.global_position


func _on_enemy_hurt_box_body_entered(body):
	#if collide with playerprojectile on layer, take damage and delete projectile.
	if body.get_collision_layer()==4:
		_take_damage(body.get_damage())
		if(body._get_type()=="projectile"): #dont delete lasers
			body.queue_free()


func _take_damage(dmg):
	currentHealth-=dmg
	healthBar.value = currentHealth
	if(currentHealth<=0):
		if(rng.randf_range(0, 1)<=itemDropChance):
			var instance = item.instantiate()
			instance.position=global_position
			get_tree().current_scene.call_deferred("add_child", instance)
		queue_free()


