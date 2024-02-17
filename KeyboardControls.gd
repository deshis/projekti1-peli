extends RichTextLabel

var keyboardW = preload("res://sprites/prompts/keyboard/W_Key_Light.png")
var keyboardA = preload("res://sprites/prompts/keyboard/A_Key_Light.png")
var keyboardS = preload("res://sprites/prompts/keyboard/S_Key_Light.png")
var keyboardD = preload("res://sprites/prompts/keyboard/D_Key_Light.png")
var keyboardUp = preload("res://sprites/prompts/keyboard/Arrow_Up_Key_Light.png")
var keyboardDown = preload("res://sprites/prompts/keyboard/Arrow_Down_Key_Light.png")
var keyboardLeft = preload("res://sprites/prompts/keyboard/Arrow_Left_Key_Light.png")
var keyboardRight = preload("res://sprites/prompts/keyboard/Arrow_Right_Key_Light.png")
var keyboardSpace = preload("res://sprites/prompts/keyboard/Space_Key_Light.png")
var keyboardEscape = preload("res://sprites/prompts/keyboard/Esc_Key_Light.png")
var keyboardEnter = preload("res://sprites/prompts/keyboard/Enter_Tall_Key_Light.png")
var keyboardX = preload("res://sprites/prompts/keyboard/X_Key_Light.png")

func _ready():
	add_image(keyboardW)
	add_image(keyboardA)
	add_image(keyboardS)
	add_image(keyboardD)
	add_text("Move \n")
	
	add_image(keyboardUp)
	add_image(keyboardDown)
	add_image(keyboardLeft)
	add_image(keyboardRight)
	add_text("Shoot \n")
	
	add_image(keyboardSpace)
	add_text(" Sprint \n")
	
	add_image(keyboardEscape)
	add_text("Menu \n")
	
	add_image(keyboardEnter)
	add_text("Accept / Select \n")
	
	add_image(keyboardX)
	add_text("Discard / Back \n")
