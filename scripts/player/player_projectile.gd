extends RigidBody2D
signal ProjectileHit

var damage
@export var timeoutSeconds = 5.0

var type = "projectile"

var dot
var aoe
var heal

@onready var HitObstacle = preload("res://scenes/misc/HitObstacleSound.tscn")
@onready var HitEnemy = preload("res://scenes/misc/HitEnemySound.tscn")

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

func _on_body_entered(body): #remove if collide with environment
	if is_instance_of(body, TileMap):
		var instance = HitObstacle.instantiate()
		get_tree().current_scene.call_deferred("add_child", instance)
	elif body.get_collision_layer()==8:
		var instance = HitEnemy.instantiate()
		get_tree().current_scene.call_deferred("add_child", instance)
	queue_free()
