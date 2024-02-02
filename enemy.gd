extends CharacterBody2D

@export var SPEED = 300.0

@onready var target = get_node("/root/Main/Player")
@onready var ray = get_node("/root/Main/Player/EnemyPathfindingRaycast")
@onready var navAgent = get_node("NavigationAgent2D")
@onready var cooldownTimer = get_node("CooldownTimer")
@onready var modeGenerator = get_node("/root/Main/ModeGenerator")

var cooldownActive = false
var targetOffset = Vector2(0,0)
@export var shootingDistance = 300
@export var threshold = 75

@onready var rangedEnemyTarget = target.global_position

var projectile = preload("res://enemy_projectile.tscn")

var firingMode

var rng = RandomNumberGenerator.new()

func _ready():
	firingMode=modeGenerator._create_mode(-0.25, 0, 5)
	_update_ranged_target()

func _physics_process(_delta):
	if(!cooldownActive):
		var direction = to_local(navAgent.get_next_path_position()).normalized()
		var intendedVelocity = direction * SPEED
		navAgent.set_velocity(intendedVelocity)
	else: 
		navAgent.set_velocity(Vector2(0,0))

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
	cooldownTimer.start(rng.randf_range(0.95, 1.05)) #variation to prevent all enemies from checking on same frame
	
	#shooting here
	var aimDirection = target.global_position-global_position
	aimDirection=aimDirection.normalized()
	var type = firingMode[0]
	var damage = firingMode[1]
	var firerate = firingMode[2]
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
			var circleAmount=8.0
			for i in circleAmount:
				_spawn_projectile(aimDirection.rotated(deg_to_rad(360/circleAmount*i)),damage,speed,size)
		"burst":
			_burst(aimDirection,damage,speed,size)
		"spray":
			_spray(aimDirection,damage,speed,size)

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

func _update_ranged_target():
	var direction = Vector2(rng.randf_range(-1,1),rng.randf_range(-1,1)).normalized()
	direction *= shootingDistance
	ray.set_target_position(direction)
	ray.force_raycast_update()
	if(ray.get_collider()):
		rangedEnemyTarget=ray.get_collision_point()
	else:
		rangedEnemyTarget=target.global_position+direction
	cooldownActive = false
