extends MarginContainer

@onready var item = get_parent().get_parent().get_parent()._get_item()
@onready var inventory = get_parent().get_parent()

var swapPressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_theme_constant_override("margin_top", 100)
	

func _process(_delta):
	if(!swapPressed):
		if(Input.is_action_just_pressed("accept")):
			swapPressed = true
			_swap()
		elif(Input.is_action_just_pressed("discard")):
			_remove()

func _swap():
	self.get_child(1).set_visible(true)
	self.get_parent().get_child(0).get_child(0).get_child(1).set_visible(true)
	inventory._set_swapping(true)

	#remove item and close inventory
func _remove():
	item.queue_free()
	get_parent().get_parent().get_parent()._close_inventory()
