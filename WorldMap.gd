extends TileMap

@export var mapSize = 128
@export var terrainChance = 0.025

func _ready():
	generate_chunk(mapSize)

func generate_chunk(size):
	var tilePos = local_to_map(position)
	for x in range(size):
		for y in range(size):
			var cellPosX = tilePos.x-size/2+x
			var cellPosY = tilePos.y-size/2+y
			
			#outer walls
			if(cellPosX==-size/2 or cellPosY==-size/2 or cellPosX==size/2-1 or cellPosY == size/2-1):
				set_cell(0, Vector2i(cellPosX, cellPosY), 1, Vector2i(1,0))
			
			elif(!get_cell_tile_data(0,Vector2i(cellPosX, cellPosY))):
				if(randf_range(0, 1)<=terrainChance):
					set_cell(0, Vector2i(cellPosX, cellPosY), 1, Vector2i(1,0))
				else:
					set_cell(0, Vector2i(cellPosX, cellPosY), 1, Vector2i(0,0))
