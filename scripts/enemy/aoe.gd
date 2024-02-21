extends RigidBody2D

var damage
var type = "aoe"
var dot = false
var aoe = false
var heal = false

func _get_type():
	return type

func get_damage():
	return damage
	
func set_damage(d):
	damage=d

# Called when the node enters the scene tree for the first time.
func _ready(): 
	#make collision detection work
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	await Engine.get_main_loop().physics_frame
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
