extends RigidBody2D
signal ProjectileHit

@export var damage = 5
@export var timeoutSeconds = 5.0

func get_damage():
	return damage
	
func set_damage(d):
	damage=d


# Called when the node enters the scene tree for the first time.
func _ready(): 
	#make collision detection work
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	
	#delete projectile after 5 seconds
	_despawn()

func _despawn():
	await get_tree().create_timer(timeoutSeconds).timeout
	if(get_tree().paused): #dont remove while game is paused
		_despawn()
	else:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(_body): #remove on collision
	queue_free()
