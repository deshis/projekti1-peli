extends RigidBody2D
signal ProjectileHit

@export var damage = 6
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
	await get_tree().create_timer(timeoutSeconds).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(body): #remove if collide with environment
	if(body.get_collision_layer()==16):
		queue_free()
