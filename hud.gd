extends Node

@onready var inventory = preload("res://inventory.tscn")
var isInventoryOpen = false
var item = null


func _process(_delta):
	if(Input.is_action_just_pressed("menu")):
		_toggle_inventory()
	
func _toggle_inventory():
	if(!isInventoryOpen):
		_open_inventory(null)
	else:
		_close_inventory()
	
func _open_inventory(itempickup):
	for i in get_child_count():
		get_child(i).set_visible(false)
	var instance = inventory.instantiate()
	if(itempickup):
		item = itempickup
		instance.mode = item._get_mode()
	add_child(instance)
	isInventoryOpen=true
	get_tree().paused = true


func _close_inventory():
	item=null
	get_child(4).queue_free()
	for i in get_child_count():
		get_child(i).set_visible(true)
	isInventoryOpen=false	
	get_tree().paused = false

func _get_item():
	return item
