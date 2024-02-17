extends RichTextLabel

var controllerLeftStick = preload("res://sprites/prompts/controller/XboxSeriesX_Left_Stick.png")
var controllerRightStick = preload("res://sprites/prompts/controller/XboxSeriesX_Right_Stick.png")
var controllerRightTrigger = preload("res://sprites/prompts/controller/XboxSeriesX_RT.png")
var controllerMenu = preload("res://sprites/prompts/controller/XboxSeriesX_Menu.png")
var controllerA = preload("res://sprites/prompts/controller/XboxSeriesX_A.png")
var controllerX = preload("res://sprites/prompts/controller/XboxSeriesX_X.png")


func _ready():
	add_image(controllerLeftStick)
	add_text("Move \n")
	add_image(controllerRightStick)
	add_text("Shoot \n")
	add_image(controllerRightTrigger)
	add_text("Sprint \n")
	add_image(controllerMenu)
	add_text("Menu \n")
	add_image(controllerA)
	add_text("Accept / Select \n")
	add_image(controllerX)
	add_text("Discard / Back \n")
