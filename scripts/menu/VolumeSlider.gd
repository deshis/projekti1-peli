extends HSlider

@export var busName:String
var busIndex

func _ready():
	busIndex = AudioServer.get_bus_index(busName)
	value_changed.connect(_on_value_changed)
	value = db_to_linear(AudioServer.get_bus_volume_db(busIndex))

func _on_value_changed(audioValue):
	AudioServer.set_bus_volume_db(busIndex, linear_to_db(audioValue))
