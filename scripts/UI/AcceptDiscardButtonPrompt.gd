extends RichTextLabel


func _ready():
	_updatePrompt()

func _process(_delta):
	if(Input.is_anything_pressed()):
		_updatePrompt()

func _updatePrompt():
	clear()
	if(Global.controller):
		add_image(load("res://sprites/prompts/controller/XboxSeriesX_A.png"))
		add_text("  SWAP \n \n")
		add_image(load("res://sprites/prompts/controller/XboxSeriesX_X.png"))
		add_text("  DISCARD")
	else:
		add_image(load("res://sprites/prompts/keyboard/Enter_Tall_Key_Light.png"))
		add_text("  SWAP \n \n")
		add_image(load("res://sprites/prompts/keyboard/X_Key_Light.png"))
		add_text("  DISCARD")
