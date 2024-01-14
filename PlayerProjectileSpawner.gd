extends Node2D

var crosshair

@export var crosshair_distance = 20000


# Called when the node enters the scene tree for the first time.
func _ready():
	crosshair=get_node("Crosshair")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	var aim_direction = Vector2.ZERO
	aim_direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	
	
	#move crosshair
	if(aim_direction.length()==0):
		crosshair.set_position(Vector2(0, 0)) #if not aiming, the crosshair is hidden under the player
	else:
		crosshair.set_position(aim_direction.normalized() * delta * crosshair_distance)  #change crosshair position
	
	
	#shooting

