extends RichTextLabel

var seconds = 0
var minutes = 0
var hours = 0

func _on_timer_timeout():
	var text = "[center]"
	seconds +=1
	if(seconds>=60):
		seconds=0
		minutes+=1
		if(minutes>=60):
			minutes=0
			hours+=1
	if(hours>=1):
		text+=str(hours)
		text+=":"
	if(minutes<10):
		text+="0"
	text+=str(minutes)
	text+=":"
	if(seconds<10):
		text+="0"
	text+=str(seconds)
	set_text(text)
