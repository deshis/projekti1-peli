extends Node

@export var singleSpeed = 1000
@export var singleFirerate = 0.5
@export var singleSize = 1
@export var singleDamage = 5

var rng = RandomNumberGenerator.new()

func _create_mode(bias: float):
	var lower = 0.66
	var upper = 1.5
	var firingMode=[]
	match rng.randi_range(0,0): #only single for testing purposes
		0:  #type, damage, firerate, size, speed
			firingMode.append("single")
			firingMode.append(singleDamage*(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(singleFirerate/(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(singleSize*(snapped(randf_range(lower, upper), 0.01)+bias))
			firingMode.append(singleSpeed*(snapped(randf_range(lower, upper), 0.01)+bias))
		1:
			firingMode.append("triple")
			for i in 4:
				firingMode.append(snapped(randf_range(lower, upper), 0.01)+bias)
		2:
			firingMode.append("blast")
			for i in 4:
				firingMode.append(snapped(randf_range(lower, upper), 0.01)+bias)
		3:
			firingMode.append("beam")
			for i in 4:
				firingMode.append(snapped(randf_range(lower, upper), 0.01)+bias)
		4:
			firingMode.append("circle")
			for i in 4:
				firingMode.append(snapped(randf_range(lower, upper), 0.01)+bias)
		5:
			firingMode.append("burst")
			for i in 4:
				firingMode.append(snapped(randf_range(lower, upper), 0.01)+bias)
		6:
			firingMode.append("spray")
			for i in 4:
				firingMode.append(snapped(randf_range(lower, upper), 0.01)+bias)
		#7:
			#firingMode=["beam_continuous", snapped(rng.randf(), 0.01), snapped(rng.randf(), 0.01), snapped(rng.randf(), 0.01), snapped(rng.randf(), 0.01)]
		#8:
			#firingMode=["????", snapped(rng.randf(), 0.01), snapped(rng.randf(), 0.01), snapped(rng.randf(), 0.01), snapped(rng.randf(), 0.01)]

	return (firingMode)

