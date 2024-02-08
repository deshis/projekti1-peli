extends CharacterBody2D
signal PlayerHit

@export var moveSpeed = 200
@export var sprintSpeed = 300
var currentSpeed

@export var maxHealth = 100
@export var currentHealth = 80
@onready var healthbar = get_node("/root/Main/HUD/HealthBarMargin/HealthBar")

@onready var iFrameTimer = get_node("iFrameTimer")
var canTakeDamage = true
@export var immunityTime = 0.3

@onready var regenTimer = get_node("HealthRegenTimer")
@onready var regenCooldownTimer = get_node("HealthRegenCooldownTimer")

var healCooldown=10.0
var canRegen = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if(Input.is_action_pressed("sprint")):
		currentSpeed=sprintSpeed
	else:
		currentSpeed=moveSpeed
	var input_direction = Vector2.ZERO
	input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * currentSpeed
	move_and_slide()


func _take_damage(dmg):
	currentHealth-=dmg
	update_health_ui()
	if(currentHealth<=0):
		_game_over()

func _game_over():
	currentHealth=0
	update_health_ui()
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

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


func _on_health_regen_cooldown_timer_timeout():
	canRegen=true
