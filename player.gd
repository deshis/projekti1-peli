extends Area2D
signal PlayerHit

@export var speed = 400
@export var health = 10
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#movement
	var velocity = Vector2.ZERO
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if velocity.length() > 0:
		if velocity.length()>1:
			velocity=velocity.normalized() #stop character from moving faster diagonally
		velocity = velocity * speed
	position += velocity * delta #change character position
	position = position.clamp(Vector2.ZERO, screen_size) #prevent character from moving off screen

func _on_body_entered(body):

	#if collide with projectile, take damage and delete projectile. 
	if body.get_collision_layer()==2:
		_take_damage(body.get_damage())
		body.queue_free()

""" dingler code idk
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
"""

func _take_damage(dmg):
	health-=dmg
	update_health_ui()
	if(health<=0):
		_game_over()

func _game_over():
	health=0
	update_health_ui()
	queue_free()
	
func get_health():
	return health

func update_health_ui():
	var hud = get_parent().get_node("HUD")
	if hud:
		hud.update_health()
