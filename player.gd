extends Area2D
signal PlayerHit

@export var moveSpeed = 500
@export var maxHealth = 100
@export var currentHealth = 80

@onready var healthbar = get_node("/root/Main/HUD/HealthBar")


#TODO iframes and sprint/dash


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#movement
	var velocity = Vector2.ZERO
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if velocity.length() > 0:
		if velocity.length()>1:
			velocity=velocity.normalized() #stop character from moving faster diagonally
		velocity = velocity * moveSpeed
	position += velocity * delta #change character position
	
func _on_body_entered(body):
	print("Entered body...")
	#if collide with enemyprojectile on layer 2, take damage and delete projectile. 
	if body.get_collision_layer()==2:
		_take_damage(body.get_damage())
		body.queue_free()

func _take_damage(dmg):
	currentHealth-=dmg
	update_health_ui()
	if(currentHealth<=0):
		_game_over()

func _game_over():
	currentHealth=0
	update_health_ui()
	queue_free()
	
func get_health():
	return currentHealth
	
func get_max_health():
	return maxHealth

func update_health_ui():
	healthbar.update_health()
	
	
