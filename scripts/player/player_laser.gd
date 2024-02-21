extends RigidBody2D

var damage
@export var timeoutSeconds = 0.2
var type = "laser"

@export var continuous = false

var dot
var aoe
var heal

func _get_type():
	return type

func get_damage():
	return damage
	
func set_damage(d):
	damage=d

# Called when the node enters the scene tree for the first time.
func _ready(): 
	_despawn()

func _despawn():
	if(continuous):
		await Engine.get_main_loop().physics_frame
		$AnimatedSprite2D.set_visible(false)
		await Engine.get_main_loop().physics_frame
		queue_free()
	else:
		await get_tree().create_timer(timeoutSeconds).timeout
		if(get_tree().paused): #dont remove while game is paused
			_despawn()
		else:
			queue_free()
