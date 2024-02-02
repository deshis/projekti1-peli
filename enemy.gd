extends CharacterBody2D

@export var SPEED = 300.0
@onready var target = get_node("/root/Main/Player")
@onready var ray = get_node("/root/Main/Player/EnemyPathfindingRaycast")
@onready var navAgent = get_node("NavigationAgent2D")
@onready var cooldownTimer = get_node("CooldownTimer")

var cooldownActive = false
var targetOffset = Vector2(0,0)
@export var shootingDistance = 300

@onready var rangedEnemyTarget = target.global_position

var rng = RandomNumberGenerator.new()

func _ready():
	_update_ranged_target()

func _physics_process(_delta):
	if(!cooldownActive):
		var direction = to_local(navAgent.get_next_path_position()).normalized()
		var intendedVelocity = direction * SPEED
		navAgent.set_velocity(intendedVelocity)
	else: 
		navAgent.set_velocity(Vector2(0,0))

func _on_timer_timeout(): #refresh target
	if(global_position.distance_to(rangedEnemyTarget)<=100&&!cooldownActive):
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
