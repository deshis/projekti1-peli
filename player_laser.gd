extends RigidBody2D

var damage
@export var timeoutSeconds = 0.2

func get_damage():
	return damage
	
func set_damage(d):
	damage=d

# Called when the node enters the scene tree for the first time.
func _ready(): 
	await get_tree().create_timer(timeoutSeconds).timeout #delete projectile after 5 seconds
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
