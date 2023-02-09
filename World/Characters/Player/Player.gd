class_name Player
extends KinematicBody2D

onready var DATA_KEY = "PLAYER"

const MAX_SPEED = 200 #200 is good
const FRICTION = 1000 #instantaneous is ok
const ACCEL = 1000

var velocity = Vector2.ZERO

onready var interact = $Interact
onready var dialog = $CanvasLayer/DialogBox
onready var animationtree = $AnimationTree
onready var camera = $CameraMain
onready var TL = $CameraMain/TL
onready var BR = $CameraMain/BR

#-------------------------------------------------------------------------------

func _ready():
	print("S: ", GlobalPlayerStats.samples)
	if camera.current:
		camera.limit_bottom = BR.global_position.y
		camera.limit_left = TL.global_position.x
		camera.limit_right = BR.global_position.x
		camera.limit_top = TL.global_position.y

func _physics_process(delta):
	
	var run = Input.get_action_strength("SELECT")
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("RIGHT") - Input.get_action_strength("LEFT")
	input_vector.y = Input.get_action_strength("DOWN") - Input.get_action_strength("UP")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		animationtree["parameters/playback"].travel("Move")
		animationtree["parameters/Move/blend_position"] = input_vector
		animationtree["parameters/Idle/blend_position"] = input_vector
		move_and_slide(input_vector * MAX_SPEED * (run * 2 + 1))
	else:
		animationtree["parameters/playback"].travel("Idle")
#		animationtree.set("parameters/Idle/blend_position",input_vector)

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("SPACE"):
			var collisions = interact.get_overlapping_bodies()
			
			if not dialog.typing and dialog.visible:
				dialog.hide()
				return
			
			
			if collisions.empty():
				if not dialog.typing:
					if dialog.visible:
						dialog.hide()
						return
				else:
					dialog.skip()
					return
					
			for i in collisions:
				if i is Door:
					i.open()
					return
					
				elif i is Villager:
					if not dialog.typing:
						if i.status == i.SICK and GlobalPlayerStats.samples > 0:
							dialog.start_typing(["002"])
							return
						if dialog.visible:
							dialog.hide()
							return
						else:
							dialog.start_typing(i.get_dialog())
							return
					else:
						dialog.skip()
						return


func save(file_path:Resource):
	file_path.data[DATA_KEY] = [GlobalPlayerStats.samples, GlobalPlayerStats.cures, GlobalPlayerStats.people_done]

func load(file_path:Resource):
	if file_path.data.keys().find(DATA_KEY) != -1:
		print(DATA_KEY)
		GlobalPlayerStats.samples = file_path.data [DATA_KEY][0]
		GlobalPlayerStats.cures = file_path.data[DATA_KEY][1]
		GlobalPlayerStats.people_done = file_path.data[DATA_KEY][2]
		print("Samples: ", GlobalPlayerStats.samples)
