extends MarginContainer



# Called when the node enters the scene tree for the first time.
func _ready():
	add_theme_constant_override("margin_left", 15)
	add_theme_constant_override("margin_bottom", 60)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
