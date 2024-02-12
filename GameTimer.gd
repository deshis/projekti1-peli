extends RichTextLabel

var seconds = 0
var minutes = 0
var hours = 0

func _on_timer_timeout():
	var timealive = "[center]"
	seconds +=1
	if(seconds>=60):
		seconds=0
		minutes+=1
		if(minutes>=60):
			minutes=0
			hours+=1
	if(hours>=1):
		timealive+=str(hours)
		timealive+=":"
	if(minutes<10):
		timealive+="0"
	timealive+=str(minutes)
	timealive+=":"
	if(seconds<10):
		timealive+="0"
	timealive+=str(seconds)
	set_text(timealive)
