extends MarginContainer

@onready var item = get_parent().get_parent().get_parent()._get_item()
@onready var HUD = get_parent().get_parent().get_parent()
@onready var inventory = get_parent().get_parent()


func _process(_delta):
	if(Input.is_action_just_pressed("accept")):
		_swap()
	if(Input.is_action_just_pressed("discard")):
		_remove()

func _swap():
	get_node("MarginContainer").set_visible(true)
	get_node("../CurrentModes/FiringModeContainer/Panel").set_visible(true)
	inventory._set_swapping(true)

	#remove item and close inventory
func _remove():
	item.queue_free()
	HUD._close_inventory()
