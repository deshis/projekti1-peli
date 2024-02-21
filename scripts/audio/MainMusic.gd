extends AudioStreamPlayer

var songs = []
var index = 0

func _ready():
	songs.append(preload("res://sound/music/10 Past Midnight.mp3"))
	songs.append(preload("res://sound/music/Jewel Thieves.mp3"))
	songs.append(preload("res://sound/music/Mad Scientist.mp3"))
	songs.append(preload("res://sound/music/Midnight Wanderer.mp3"))
	songs.append(preload("res://sound/music/Nighttime Escape.mp3"))
	songs.append(preload("res://sound/music/Red Convertible.mp3"))
	songs.append(preload("res://sound/music/Slick Streets.mp3"))
	songs.shuffle()
	set_stream(songs[index])
	play()

func _on_finished():
	index+=1
	if(index>=songs.size()):
		index=0
	set_stream(songs[index])
	play()
