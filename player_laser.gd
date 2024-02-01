extends RigidBody2D

var damage
@export var timeoutSeconds = 0.2

func get_damage():
	return damage
	
func set_damage(d):
	damage=d

# Called when the node enters the scene tree for the first time.
func _ready(): 
	_despawn()


func _despawn():
	await get_tree().create_timer(timeoutSeconds).timeout
	if(get_tree().paused): #dont remove while game is paused
		_despawn()
	else:
		queue_free()
