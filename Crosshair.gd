extends AnimatedSprite2D

@export var crosshair_speed = 99999999
@export var crosshair_distance = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	#aiming
	var aim_direction = Vector2.ZERO
	aim_direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")

	if(aim_direction.length()==0):
		position=Vector2(0, 0)
	else:
		position += aim_direction * delta * crosshair_speed#change crosshair position
		position = position.limit_length(crosshair_distance) #prevent crosshair from moving too far from character
