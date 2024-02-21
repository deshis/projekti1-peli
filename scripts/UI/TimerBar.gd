extends ProgressBar

@onready var timer = get_node("/root/Main/SwitchTimer")

func _ready():
	max_value=timer.get_wait_time()


func _process(_delta):
	value=timer.get_time_left()
