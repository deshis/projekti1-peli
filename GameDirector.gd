extends Node

@onready var moneyTimer = get_node("MoneyTimer")
@onready var spawnTimer = get_node("SpawnTimer")

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
	spawnTimer.start(0)

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
	
	#the director uses its credits every time a spawn opportunity happens
	#the amount of enemies is randomized and the credits are split evenly among the spawned enemies
	#for example, the director could spawn a few strong enemies or many weaker enemies
	if(phase==1):
		enemyAmount = rng.randi_range(1, 5)
	var budget = credits/enemyAmount
	while(credits>1):
		if(rng.randi_range(0,1)==1): #spawn melee enemy
			var instance = meleeEnemy.instantiate()
			instance.budget=budget
			instance.position=Vector2(0,0)
			get_tree().current_scene.add_child(instance)
		else: #spawn ranged enemy
			var instance = rangedEnemy.instantiate()
			instance.position=Vector2(0,0)
			instance.budget=budget
			get_tree().current_scene.add_child(instance)
		credits-=budget
	spawnTimer.start(spawnWaitTime)
