extends RichTextLabel

var exitButtonController = preload("res://sprites/prompts/controller/XboxSeriesX_X.png")
var exitButtonKeyboard = preload("res://sprites/prompts/keyboard/X_Key_Light.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	_updatePrompt()

func _process(_delta):
	if(Input.is_anything_pressed()):
		_updatePrompt()

func _updatePrompt():
	clear()
	if(Global.controller):
		add_image(exitButtonController)
	else:
		add_image(exitButtonKeyboard)
	add_text("  exit")
