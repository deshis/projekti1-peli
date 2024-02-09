extends TileMap

@export var mapSize = 64 #must be divisible by 4

@export var terrainChance = 0.02

var rng = RandomNumberGenerator.new()
@onready var loadingUI=get_node("../LoadingUi")	
@onready var hud=get_node("../HUD")	
@onready var player=get_node("../Player")	


func _ready():
	await Engine.get_main_loop().process_frame
	hud.visible=false
	player.visible=false
	get_tree().paused = true
	loadingUI.set_loading_bar_max_value(100)
	await generate_world(position, mapSize)
	loadingUI.queue_free()
	hud.visible=true
	player.visible=true
	get_tree().paused = false


func generate_world(pos, size):
	generate_chunk(pos+Vector2(-size*4,-size*4),size/2)
	loadingUI.set_loading_bar_value(20)	
	await Engine.get_main_loop().process_frame
	
	generate_chunk(pos+Vector2(-size*4,size*4),size/2)
	loadingUI.set_loading_bar_value(40)
	await Engine.get_main_loop().process_frame
	
	generate_chunk(pos+Vector2(size*4,-size*4),size/2)
	loadingUI.set_loading_bar_value(60)
	await Engine.get_main_loop().process_frame
	
	generate_chunk(pos+Vector2(size*4,size*4),size/2)
	loadingUI.set_loading_bar_value(80)
	await Engine.get_main_loop().process_frame
	
	generate_outer_walls(pos, size)
	loadingUI.set_loading_bar_value(95)
	await Engine.get_main_loop().process_frame


func generate_chunk(pos, size):
	var cellPosXOffset = size/2
	var cellPosYOffset = size/2
	var tilePos = local_to_map(pos)
	for x in range(size):
		var cellPosX = tilePos.x-cellPosXOffset+x
		for y in range(size):
			var cellPosY = tilePos.y-cellPosYOffset+y
			if(rng.randf_range(0,1)<=terrainChance):
				set_cell(0, Vector2i(cellPosX, cellPosY), 1, Vector2i(1,0))
			else:
				set_cell(0, Vector2i(cellPosX, cellPosY), 1, Vector2i(0,0))


func generate_outer_walls(pos, size):
	var cellPosXOffset = size/2
	var cellPosYOffset = size/2
	var tilePos = local_to_map(pos)
	for x in range(size):
		var cellPosX = tilePos.x-cellPosXOffset+x
		for y in range(size):
			var cellPosY = tilePos.y-cellPosYOffset+y
			if(cellPosX==-size/2 or cellPosY==-size/2 or cellPosX==size/2-1 or cellPosY == size/2-1):
				set_cell(0, Vector2i(cellPosX, cellPosY), 1, Vector2i(1,0))
