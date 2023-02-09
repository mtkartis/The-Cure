class_name Dialog
extends MarginContainer

const dl = preload("res://World/Dialog/GeneralDialog.gd")
const SCORE = preload("res://World/Scoreboard.tscn")

var typing_speed:float = 0.5
var typing_index:float = 0.0

var typing:bool = false

onready var text = $TextureRect/Label

signal next
signal command
signal done

#-------------------------------------------------------------------------------
func _process(delta):
	if typing:
		typing_index += typing_speed
		text.visible_characters = round(typing_index)
		if text.visible_characters == text.text.length():
			typing = false

func start_typing(new_text:Array):
	for i in new_text:
		#check if general dialog cue (a three-digit integer)
		if i is String:
			if i.is_valid_integer():
				if dl.line.keys().find(int(i)) != -1:
					text.set_text(dl.line[int(i)])
					emit_signal("command",int(i))
				else:
					text.set_text("<<NOT COMPATIBLE>>")
			else:
				text.set_text(i)
			visible = true
			text.visible_characters = 0
			typing_index = 0
			typing = true
			yield(self,"next")
	emit_signal("done")

func hide():
	visible = false
	typing = false
	emit_signal("next")

func skip():
	typing = false
	typing_index = -1
	text.visible_characters = -1
	

func _on_DialogBox_command(command):
	match command:
		000:
			GlobalPlayerStats.samples += 1
		001:
#			GlobalPlayerStats.cures -= 1
			GlobalPlayerStats.people_done += 1
			if GlobalPlayerStats.people_done == 9:
				Global.story_state = Global.STORY.END
		003:
			
			get_tree().change_scene("res://World/Town.tscn")
		004:
			var score = SCORE.instance()
			add_child(score)
			score.rect_global_position = Vector2.ZERO
