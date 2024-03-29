extends CharacterBody2D
signal PlayerHit

@onready var animatedSprite = get_node("AnimatedSprite2D")

@export var moveSpeed = 200
@export var sprintSpeed = 300
var currentSpeed

@export var maxHealth = 100
@export var currentHealth = 100
@onready var healthbar = get_node("/root/Main/HUD/HealthBarMargin/HealthBar")

@onready var iFrameTimer = get_node("iFrameTimer")
var canTakeDamage = true
@export var immunityTime = 0.3

@onready var regenTimer = get_node("HealthRegenTimer")
@onready var regenCooldownTimer = get_node("HealthRegenCooldownTimer")

var healCooldown=6.0
var canRegen = true
var moving
var sprinting = false
var moveAnimationDirection

var animationThreshold=0.35

@onready var takeDMGSound = get_node("TakeDMGSound")
@onready var healSound = get_node("HealSound")
@onready var regenStartSound = get_node("RegenStartSound")
@onready var moveSound = get_node("MoveSlowSound")
@onready var sprintSound = get_node("MoveFastSound")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if(Input.is_action_pressed("sprint")):
		sprinting=true
		currentSpeed=sprintSpeed
	else:
		sprinting=false
		currentSpeed=moveSpeed
	
	var input_direction = Vector2.ZERO
	input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	moving = true
	
	#movement animation stuff
	if(input_direction.x>animationThreshold):
		if(input_direction.y<-animationThreshold):
			animatedSprite.play("move_up_right")
			animatedSprite.set_flip_h(false)
		elif(input_direction.y>animationThreshold):
			animatedSprite.play("move_down_left")
			animatedSprite.set_flip_h(true)
		else:
			animatedSprite.play("move_right")
			animatedSprite.set_flip_h(false)
	elif(input_direction.x<-animationThreshold):
		if(input_direction.y<-animationThreshold):
			animatedSprite.play("move_up_right")
			animatedSprite.set_flip_h(true)
		elif(input_direction.y>animationThreshold):
			animatedSprite.play("move_down_left")
			animatedSprite.set_flip_h(false)
		else:
			animatedSprite.play("move_left")
			animatedSprite.set_flip_h(false)
	elif(input_direction.y<-animationThreshold):
		animatedSprite.play("move_up")
		animatedSprite.set_flip_h(false)
	elif(input_direction.y>animationThreshold):
		animatedSprite.play("move_down")
		animatedSprite.set_flip_h(false)
	else:
		moving=false
	
	
	if(sprinting):
		animatedSprite.set_speed_scale(1.5)
	else:
		animatedSprite.set_speed_scale(1.0)
	if(!moving):
		animatedSprite.set_speed_scale(0)
	
	#prevent moving while animation not playing
	if(moving):
		if(sprinting):
			if(!sprintSound.is_playing()):
				sprintSound.play()
				moveSound.stop()
		else:
			if(!moveSound.is_playing()):
				moveSound.play()
				sprintSound.stop()
		velocity = input_direction * currentSpeed
	else:
		moveSound.stop()
		sprintSound.stop()
		velocity=Vector2.ZERO
		
	move_and_slide()

func _take_damage(dmg):
	takeDMGSound.play()
	currentHealth-=dmg
	update_health_ui()
	if(currentHealth<=0):
		_game_over()

func _game_over():
	currentHealth=0
	update_health_ui()
	Global.timeAlive = get_node("/root/Main/HUD/GameTimerMargin/GameTimer").get_text().get_slice("]", 1)
	get_tree().change_scene_to_file.bind("res://scenes/menu/GameOver.tscn").call_deferred()

func get_health():
	return currentHealth
	
func get_max_health():
	return maxHealth

func update_health_ui():
	healthbar.update_health()

func _on_player_hurt_box_body_entered(body):
	#if collide with enemyprojectile on layer 2, take damage and delete projectile. 
	if body.get_collision_layer()==2:
		if(canTakeDamage): #iframes
			canTakeDamage=false
			iFrameTimer.start(immunityTime)
			canRegen=false
			regenCooldownTimer.start(healCooldown)
			_take_damage(body.get_damage())
			body.queue_free()

func _on_i_frame_timer_timeout():
	canTakeDamage=true

func _on_health_regen_timer_timeout():
	if(currentHealth<maxHealth&&canRegen):
		currentHealth+=1
		update_health_ui()

func heal(amount):
	if(currentHealth<maxHealth):
		healSound.play()
		currentHealth+=amount
		update_health_ui()

func _on_health_regen_cooldown_timer_timeout():
	if(currentHealth<maxHealth):
		regenStartSound.play()
	canRegen=true
