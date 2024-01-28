extends Area2D

@onready var modeGenerator = get_node("/root/Main/ModeGenerator")
@onready var gameDirector = get_node("/root/Main/GameDirector")
@onready var hud = get_node("/root/Main/HUD")
var mode

# Called when the node enters the scene tree for the first time.
func _ready():
	mode = modeGenerator._create_mode(gameDirector._get_bias())
	get_child(1).set_texture(load("res://sprites/"+mode[0]+".png"))

func _on_body_entered(_body):
	hud._open_inventory(self)

func _get_mode():
	return mode
