extends Node2D

@onready var moneyTimer = get_node("MoneyTimer")
@onready var spawnTimer = get_node("SpawnTimer")
@onready var screen_size = get_viewport_rect().size
@onready var tileMap = get_node("/root/Main/TileMap")

@export var minSpawnTime = 10
@export var maxSpawnTime = 20

var meleeEnemy = preload("res://MeleeEnemy.tscn")
var rangedEnemy = preload("res://RangedEnemy.tscn")


var phase = 1
var credits = 0.0

var spawnPositions

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	spawnTimer.start(rng.randf_range(minSpawnTime, maxSpawnTime))


func _process(_delta):
	print (Engine.get_frames_per_second())

func _get_bias():
	if(phase==1):
		return 0
	return 0


func _on_money_timer_timeout():
	if(phase==1):
		credits+=1


func _on_spawn_timer_timeout():
	var spawnWaitTime = rng.randf_range(minSpawnTime, maxSpawnTime)
	var enemyAmount
	var spawnLocation
	var validSpawnLocationFound = false
	
	
	#try to find a valid spawn location off screen up to 3 times. if a valid location is not found, spawn on top of player
	for i in 3:
		spawnLocation = global_position+Vector2(rng.randf_range(-1,1), rng.randf_range(-1,1)).normalized()*screen_size.x/2
		var spawnTile = tileMap.get_cell_tile_data(0, tileMap.local_to_map(spawnLocation))
		print("trying to spawn at "+str(spawnTile))
		if(spawnTile):
			if(spawnTile.get_collision_polygons_count(0)==0):
				validSpawnLocationFound=true
				break
		await Engine.get_main_loop().process_frame #yield 1 frame to avoid lagspikes
	if(!validSpawnLocationFound):
		spawnLocation=global_position
	
	
	#the director uses its credits every time a spawn opportunity happens
	#the amount of enemies is randomized and the credits are split evenly among the spawned enemies
	#for example, the director could spawn a few strong enemies or many weaker enemies
	if(phase==1):
		enemyAmount = rng.randi_range(1, 5)
	var budget = credits/enemyAmount
	while(credits>=1):
		if(rng.randi_range(0,1)==1): #spawn melee enemy
			var instance = meleeEnemy.instantiate()
			instance.budget=budget
			instance.position=spawnLocation
			get_tree().current_scene.add_child(instance)
		else: #spawn ranged enemy
			var instance = rangedEnemy.instantiate()
			instance.budget=budget
			instance.position=spawnLocation
			get_tree().current_scene.add_child(instance)
		credits-=budget
		await Engine.get_main_loop().process_frame #yield 1 frame to avoid lagspikes
		
	spawnTimer.start(spawnWaitTime)
