extends MarginContainer

@onready var item = get_parent().get_parent().get_parent()._get_item()
@onready var inventory = get_parent().get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_theme_constant_override("margin_top", 100)
	

func _process(_delta):
	if(Input.is_action_just_pressed("accept")):
		_swap()
	elif(Input.is_action_just_pressed("discard")):
		_remove()
	
func _swap():
	inventory._set_swapping(true)
	pass
	
	#remove item and close inventory
func _remove():
	item.queue_free()
	get_parent().get_parent().get_parent()._close_inventory()
