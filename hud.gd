extends Node

@onready var inventory = preload("res://inventory.tscn")
var isInventoryOpen = false
var item = null

func _process(_delta):
	if(Input.is_action_just_pressed("menu")):
		_toggle_inventory()
	if(Input.is_action_just_pressed("keyboardInputs")):
		Global.controller=false
	elif(Input.is_action_just_pressed("controllerInputs", false)):
		Global.controller=true
	
func _toggle_inventory():
	if(!isInventoryOpen):
		_open_inventory(null)
	else:
		if(!get_child(5).mode):
			_close_inventory()
			
func _open_inventory(itempickup):
	for i in get_child_count():
		get_child(i).set_visible(false)
	var instance = inventory.instantiate()
	if(itempickup):
		item = itempickup
		instance.mode = item._get_mode()
		instance.item = item
	add_child(instance)
	isInventoryOpen=true
	get_tree().paused = true


func _close_inventory():
	for i in get_children():
		if(i.get_class()=="Panel"):
			i.queue_free()
	item=null
	for i in get_child_count():
		get_child(i).set_visible(true)
	isInventoryOpen=false
	get_tree().paused = false

func _get_item():
	return item
