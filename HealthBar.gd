extends ProgressBar

@onready var player = get_node("/root/Main/Player")

func _ready():
	update_health()

func update_health():
	value=player.get_health()

func update_max_health():
	value=player.get_max_health()
