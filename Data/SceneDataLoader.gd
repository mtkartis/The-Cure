extends Node

func _ready():
	if GlobalPlayerStats.people_done == 9:
		Global.story_state = Global.STORY.END
	if !name == "Lab":
		DataManagement.load()
	var c = get_children()
	for i in c:
		if i is YSort:
			c = i.get_children()
			break
	var p = null
	var d = null
	for i in c:
		if i is Player:
			p = i
		if i is Door:
			if i.POSITION_KEY == Global.door_key:
				d = i
	if d != null and p != null:
		p.global_position = d.p_position.global_position

func _process(delta):
	GlobalScore.play_time += delta
