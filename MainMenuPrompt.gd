extends RichTextLabel

var dpad = preload("res://sprites/prompts/controller/XboxSeriesX_Dpad.png")
var controllerA = preload("res://sprites/prompts/controller/XboxSeriesX_A.png")
var up = preload("res://sprites/prompts/keyboard/Arrow_Up_Key_Light.png")
var down = preload("res://sprites/prompts/keyboard/Arrow_Down_Key_Light.png")
var enter = preload("res://sprites/prompts/keyboard/Enter_Tall_Key_Light.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	_updatePrompt()

func _process(_delta):
	if(Input.is_anything_pressed()):
		_updatePrompt()

func _updatePrompt():
	clear()
	if(Global.controller):
		add_image(dpad)
		add_text(" select \n")
		add_image(controllerA)
		add_text(" accept")
	else:
		add_image(up)
		add_image(down)
		add_text(" select \n")
		add_image(enter)
		add_text(" accept")
	add_text("\n controller is recommended")
