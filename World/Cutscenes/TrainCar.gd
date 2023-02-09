extends Node

enum STATE {ARRIVE, LEAVE}

export(STATE) var state = STATE.LEAVE

onready var forest = $Forest
onready var city = $City
onready var trees = $Forest/TextureRect
onready var car = $Car/TextureRect

onready var dialog = $CanvasLayer/DialogBox
onready var timer = $CanvasLayer/Timer
onready var fader = $CanvasLayer/ColorRect
onready var tween = $CanvasLayer/Tween

func _ready():
	dialog.connect("done", self, "cutscene_end")
	fade(true)
	if Global.story_state == Global.STORY.END:
		state = STATE.ARRIVE
	else:
		state = STATE.LEAVE
	timer.start()

func _process(delta):
#	match state:
#		STATE.LEAVE:
#			if fade.color.a > 0:
#				fade.color.a -= 1 * delta
#		STATE.ARRIVE:
#			if fade.color.a < 1:
#				fade.color.a += 1 * delta
	var dir = -1
#	if state == STATE.ARRIVE:
#		dir = 1
#	else:
#		dir = -1
	
	city.offset.x += 1 * dir
	var length = trees.rect_size.x
	var car_width = car.rect_size.x
	if length - abs(forest.offset.x) <= car_width:
		forest.offset.x = 0
	else:
		forest.offset.x += 10 * dir

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("SPACE"):
			if dialog.typing:
				dialog.skip()
			else:
				dialog.hide()

func cutscene_end():
	match state:
		STATE.ARRIVE:
			fade(false)
			yield(tween, "tween_completed")
			get_tree().change_scene("res://Title/Title.tscn")
		STATE.LEAVE:
			fade(false)
			yield(tween, "tween_completed")
			get_tree().change_scene("res://World/Town.tscn")

func fade(fade_in:bool)->void:
	match fade_in:
		true:
			tween.interpolate_property(fader, "color", fader.color, Color(0,0,0,0), 
			2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.0)
			tween.start()
			
		false:
			tween.interpolate_property(fader, "color", fader.color, Color(0,0,0,1),
			2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.0)
			tween.start()
			


func _on_Timer_timeout():
	match state:
		STATE.ARRIVE:
			dialog.start_typing([
				"I was relieved to escape that small town.",
				"Something was definitely off with the folks there",
				"But my cures should hold, and no further calls from there should need reach my office.",
				"My office job awaits",
				"*cough* *cough*",
				"004",
			])
		STATE.LEAVE:
			dialog.start_typing([
				"A random phone call pulled me from my office.",
				"It began with a wimper.",
				"And then a plea...",
				"'Please, our town needs a doctor! Everyone is getting sick!'",
				"'The sheriff is dead. We need help!'",
				"And so here I am. On a train to the middle of logging country.",
				"Who knew that this town even existed.",
				"I will get specimens from the patients, isolate the viruses, develop medicine, then return to my comfy office job.",
				"It shouldn't take that long..."
			])
