extends Node

var rng = RandomNumberGenerator.new()

func _create_mode(bias: float):
	
	var firingMode=[]
	match rng.randi_range(0,4):
		0: 		#type, damage multiplier, firerate divider(?), speed multiplier, size multiplier
			firingMode=["single", snapped(randf_range(0.75, 1.25), 0.01)+bias, snapped(randf_range(0.75, 1.25), 0.01)+bias, snapped(randf_range(0.75, 1.25), 0.01)+bias, snapped(randf_range(0.75, 1.25), 0.01)+bias]
		1:
			firingMode=["triple", snapped(randf_range(0.75, 1.25), 0.01)+bias, snapped(randf_range(0.75, 1.25), 0.01)+bias, snapped(randf_range(0.75, 1.25), 0.01)+bias, snapped(randf_range(0.75, 1.25), 0.01)+bias]
		2:
			firingMode=["blast", snapped(randf_range(0.75, 1.25), 0.01)+bias, snapped(randf_range(0.75, 1.25), 0.01)+bias, snapped(randf_range(0.75, 1.25), 0.01)+bias, snapped(randf_range(0.75, 1.25), 0.01)+bias]
		3:
			firingMode=["beam", snapped(randf_range(0.75, 1.25), 0.01)+bias, snapped(randf_range(0.75, 1.25), 0.01)+bias, snapped(randf_range(0.75, 1.25), 0.01)+bias, snapped(randf_range(0.75, 1.25), 0.01)+bias]
		4:
			firingMode=["circle", snapped(randf_range(0.75, 1.25), 0.01)+bias, snapped(randf_range(0.75, 1.25), 0.01)+bias, snapped(randf_range(0.75, 1.25), 0.01)+bias, snapped(randf_range(0.75, 1.25), 0.01)+bias]
		#5:
			#firingMode=["beam_continuous", snapped(rng.randf(), 0.01), snapped(rng.randf(), 0.01), snapped(rng.randf(), 0.01), snapped(rng.randf(), 0.01)]

	return (firingMode)

