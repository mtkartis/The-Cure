extends MarginContainer


var reveal_index = 0

onready var timer = $Timer
onready var labels = $VBoxContainer/GridContainer

onready var science_time = $VBoxContainer/GridContainer/ScienceTime
onready var mistakes = $VBoxContainer/GridContainer/Mistakes
onready var play_time = $VBoxContainer/GridContainer/PlayTime
onready var overall_score = $VBoxContainer/GridContainer/OverallScore

func _ready():
	get_tree().paused = true
	timer.start()
	science_time.set_text(str(GlobalScore.science_time))
	mistakes.set_text(str(GlobalScore.science_mistakes))
	play_time.set_text(str(GlobalScore.play_time))
	overall_score.set_text(str(GlobalScore.science_time + GlobalScore.science_mistakes * 60 + GlobalScore.play_time))

func _on_Timer_timeout():
	var c = labels.get_children()
	if reveal_index < c.size():
		c[reveal_index].visible = true
		reveal_index += 1
	else:
		timer.stop()
		get_tree().paused = false
		DataManagement.erase()
	
	
