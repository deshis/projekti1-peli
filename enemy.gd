extends CharacterBody2D


@export var SPEED = 300.0

@onready var target = get_node("/root/Main/Player")
@onready var navAgent = get_node("NavigationAgent2D")

func _physics_process(delta):
	var direction = to_local(navAgent.get_next_path_position()).normalized()
	var intendedVelocity = direction * SPEED
	navAgent.set_velocity(intendedVelocity)


func _on_timer_timeout(): #refresh target every 0.2s
	navAgent.target_position=target.global_position


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
