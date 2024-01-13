extends CanvasLayer


@onready var healthUI = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	update_health()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func update_health():
	var player = get_parent().get_node("Player")
	healthUI.text = "HP: " + str(player.get_health())
