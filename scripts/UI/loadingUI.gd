extends Control

@onready var loadingBar = get_node("ColorRect/MarginContainer/ProgressBar")

func set_loading_bar_value(val):
	loadingBar.value = val

func set_loading_bar_max_value(val):
	loadingBar.max_value = val
