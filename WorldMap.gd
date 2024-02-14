extends TileMap

@export var mapSize = 256 #must be divisible by 4

@export var obstacleChance = 0.025

@onready var dirtNoise = FastNoiseLite.new()
@onready var mudNoise = FastNoiseLite.new()
@onready var sandNoise = FastNoiseLite.new()
@onready var grassNoise = FastNoiseLite.new()

var rng = RandomNumberGenerator.new()
@onready var loadingUI=get_node("../LoadingUi")	
@onready var hud=get_node("../HUD")	
@onready var player=get_node("../Player")	


func _ready():
	await Engine.get_main_loop().process_frame
	dirtNoise.seed=randi()
	mudNoise.seed=randi()
	sandNoise.seed=randi()
	grassNoise.seed=randi()
	hud.visible=false
	player.visible=false
	get_tree().paused = true
	loadingUI.visible=true
	loadingUI.set_loading_bar_max_value(100)
	player.get_node("PlayerCamera").set_zoom(Vector2(1,1))
	await generate_world(position, mapSize)
	hud.visible=true
	player.visible=true
	player.get_node("PlayerCamera").set_zoom(Vector2(1.5,1.5))
	get_tree().paused = false
	loadingUI.queue_free()


func generate_world(pos, size):
	generate_terrain_chunk(pos+Vector2(-size*16,-size*16),size/2)
	loadingUI.set_loading_bar_value(10)	
	await Engine.get_main_loop().process_frame
	
	generate_terrain_chunk(pos+Vector2(-size*16,size*16),size/2)
	loadingUI.set_loading_bar_value(20)	
	await Engine.get_main_loop().process_frame
	
	generate_terrain_chunk(pos+Vector2(size*16,-size*16),size/2)
	loadingUI.set_loading_bar_value(30)	
	await Engine.get_main_loop().process_frame
	
	generate_terrain_chunk(pos+Vector2(size*16,size*16),size/2)
	loadingUI.set_loading_bar_value(40)	
	await Engine.get_main_loop().process_frame
	
	generate_obstacles(pos+Vector2(-size*16,-size*16),size/2)
	loadingUI.set_loading_bar_value(50)	
	await Engine.get_main_loop().process_frame
	
	generate_obstacles(pos+Vector2(-size*16,size*16),size/2)
	loadingUI.set_loading_bar_value(60)	
	await Engine.get_main_loop().process_frame
	
	generate_obstacles(pos+Vector2(size*16,-size*16),size/2)
	loadingUI.set_loading_bar_value(70)	
	await Engine.get_main_loop().process_frame
	
	generate_obstacles(pos+Vector2(size*16,size*16),size/2)
	loadingUI.set_loading_bar_value(80)	
	await Engine.get_main_loop().process_frame
	
	generate_outer_wall(pos, size)
	loadingUI.set_loading_bar_value(90)	
	await Engine.get_main_loop().process_frame


func generate_terrain_chunk(pos, size):
	var cellPosXOffset = size/2
	var cellPosYOffset = size/2
	var tilePos = local_to_map(pos)
	for x in range(size):
		var cellPosX = tilePos.x-cellPosXOffset+x
		for y in range(size):
			var cellPosY = tilePos.y-cellPosYOffset+y
			#terrain
			if(grassNoise.get_noise_2d(cellPosX, cellPosY)>=0.2):
				set_cell(1, Vector2i(cellPosX, cellPosY), 1, Vector2i(rng.randi_range(0,3),3))
			elif(sandNoise.get_noise_2d(cellPosX, cellPosY)>=0.2):
				set_cell(1, Vector2i(cellPosX, cellPosY), 1, Vector2i(rng.randi_range(0,3),2))
			elif(dirtNoise.get_noise_2d(cellPosX, cellPosY)>=0.2):
				set_cell(1, Vector2i(cellPosX, cellPosY), 1, Vector2i(rng.randi_range(0,3),1))
			else:
				set_cell(1, Vector2i(cellPosX, cellPosY), 1, Vector2i(rng.randi_range(0,3),0))


func generate_obstacles(pos, size):
	var cellPosXOffset = size/2
	var cellPosYOffset = size/2
	var tilePos = local_to_map(pos)
	for x in range(size):
		loadingUI.set_loading_bar_value(x)
		var cellPosX = tilePos.x-cellPosXOffset+x
		for y in range(size):
			var cellPosY = tilePos.y-cellPosYOffset+y
			
			#prevent diagonals
			if(rng.randf_range(0,1)<=obstacleChance and get_cell_atlas_coords(2, Vector2i(cellPosX-1, cellPosY-1))!=Vector2i(0,0) and get_cell_atlas_coords(2, Vector2i(cellPosX-1, cellPosY+1))!=Vector2i(0,0)):
				if(rng.randf_range(0,1)<=0.5): #50% chance for obstacle to be flipped for more variety
					set_cell(2, Vector2i(cellPosX, cellPosY), 4, Vector2i(rng.randi_range(0,2),rng.randi_range(0,2)), TileSetAtlasSource.TRANSFORM_FLIP_H) #set random obstacle
				else:
					set_cell(2, Vector2i(cellPosX, cellPosY), 4, Vector2i(rng.randi_range(0,2),rng.randi_range(0,2))) #set random obstacle
				set_cell(0, Vector2i(cellPosX, cellPosY), 3, Vector2i(0,1)) #set navmesh as non-navigable
			else:
				#if no obstacle, navigable
				set_cell(0, Vector2i(cellPosX, cellPosY), 3, Vector2i(0,0))


func generate_outer_wall(pos, size):
	var cellPosXOffset = size/2
	var cellPosYOffset = size/2
	var tilePos = local_to_map(pos)
	for x in range(size):
		var cellPosX = tilePos.x-cellPosXOffset+x
		for y in range(size):
			var cellPosY = tilePos.y-cellPosYOffset+y
			#outer walls
			if(cellPosX==-size/2 or cellPosY==-size/2 or cellPosX==size/2-1 or cellPosY == size/2-1):
				set_cell(2, Vector2i(cellPosX, cellPosY), 2, Vector2i(0,0))
				set_cell(0, Vector2i(cellPosX, cellPosY), 3, Vector2i(0,1))
