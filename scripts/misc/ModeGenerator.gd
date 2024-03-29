extends Node

@export var singleSpeed = 600
@export var singleFirerate = 0.4
@export var singleSize = 0.8
@export var singleDamage = 5

@export var tripleSpeed = 600
@export var tripleFirerate = 0.75
@export var tripleSize = 0.65
@export var tripleDamage = 5

@export var blastSpeed = 600
@export var blastFirerate = 1.5
@export var blastSize = 0.6
@export var blastDamage = 3

@export var circleSpeed = 800
@export var circleFirerate = 0.75
@export var circleSize = 0.8
@export var circleDamage = 5

@export var burstSpeed = 600
@export var burstFirerate = 1
@export var burstSize = 0.8
@export var burstDamage = 5

@export var spraySpeed = 600
@export var sprayFirerate = 1
@export var spraySize = 0.8
@export var sprayDamage = 5

@export var beamSize = 0.7
@export var beamDamage = 0.1 #low because it triggers every frame

@export var laserFirerate = 1
@export var laserSize = 0.8
@export var laserDamage = 10

var rng = RandomNumberGenerator.new()

func _create_mode(bias: float=0.0, startIndex:int=0, endIndex:int=7):
	var lower = 0.66
	var upper = 1.5
	var firingMode=[]
	match rng.randi_range(startIndex, endIndex):
		0:
			firingMode.append("single")
			firingMode.append(singleDamage*(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(singleFirerate/(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(singleSize*(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(singleSpeed*(snapped(randf_range(lower, upper), 0.01)+bias))
		1:
			firingMode.append("triple")
			firingMode.append(tripleDamage*(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(tripleFirerate/(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(tripleSize*(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(tripleSpeed*(snapped(randf_range(lower, upper), 0.01)+bias))
		2:
			firingMode.append("blast")
			firingMode.append(blastDamage*(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(blastFirerate/(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(blastSize*(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(blastSpeed*(snapped(randf_range(lower, upper), 0.01)+bias))
		3:
			firingMode.append("circle")
			firingMode.append(circleDamage*(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(circleFirerate/(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(circleSize*(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(circleSpeed*(snapped(randf_range(lower, upper), 0.01)+bias))
		4:
			firingMode.append("burst")
			firingMode.append(burstDamage*(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(burstFirerate/(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(burstSize*(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(burstSpeed*(snapped(randf_range(lower, upper), 0.01)+bias))
		5:
			firingMode.append("spray")
			firingMode.append(sprayDamage*(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(sprayFirerate/(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(spraySize*(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(spraySpeed*(snapped(randf_range(lower, upper), 0.01)+bias))
		6:
			firingMode.append("laser")
			firingMode.append(laserDamage*(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(laserFirerate/(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(laserSize*(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(-1)
		7:
			firingMode.append("beam")
			firingMode.append(beamDamage*(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(-1)
			firingMode.append(beamSize*(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(-1)
	
	#dot, aoe, selfheal
	for i in range(3):
		if(rng.randf_range(0,1)<=0.1*(1.0+bias)):
			firingMode.append(true)
		else:
			firingMode.append(false)
	return (firingMode)

func _create_default_mode():
	var firingMode=[]
	firingMode.append("single")
	firingMode.append(singleDamage)
	firingMode.append(singleFirerate)
	firingMode.append(singleSize)
	firingMode.append(singleSpeed)
	firingMode.append(false)
	firingMode.append(false)
	firingMode.append(false)
	return (firingMode)

