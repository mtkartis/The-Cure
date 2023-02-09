extends Node

#vars
var inx = 0
var button_inx =[]
var orientation
var button_gap = Vector2.ZERO
var star_index = 0
var player_path_index = 0
var title_path_index = 0
var player_path_active = false
var title_path_active = false

#dictionaries
var button_dict = {}
var star_dict = {
	0:"Stars/AnimatedSprite",
	1:"Stars/AnimatedSprite2",
	2:"Stars/AnimatedSprite3",
	3:"Stars/AnimatedSprite4",
	4:"Stars/AnimatedSprite5",
}

#child nodes
onready var star_timer = $StarTimer
onready var title_path_position = $Title/Path2D/PathFollow2D
onready var start = $Title/Path2D/PathFollow2D/Text/Start

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
################################################################################
#								ON READY
################################################################################

#----------------------------------READY----------------------------------------
func _ready():
	set_star_timer()

#---------------------------------MAIN LOOPS------------------------------------
func _process(delta):
	if star_timer.is_stopped():
		title_path_active = true
	if title_path_active == true:
		#move
		if title_path_index < 1:
			#move position marker
			title_path_position.unit_offset = title_path_index
			#update
			title_path_index += 0.2*delta
		else:
			#shut off
			title_path_active = false
			start.visible = true

#-------------------------INPUT MANAGER-----------------------------------------
func _input(event):
	if event is InputEventKey or event is InputEventJoypadButton:
		if Input.is_action_just_pressed("SPACE"):
			if title_path_index < 1:
				title_path_index = 1
				title_path_position.unit_offset = 1
				title_path_active = false
				start.visible = true
				return
			else:
				get_tree().change_scene("res://World/Cutscenes/TrainCar.tscn")

#--------------------------MENU ANIMATION MANAGER-------------------------------
func set_star_timer():
	randomize()
	star_timer.wait_time = (randi() % 2) + 1
	star_timer.start()

func light_star(index):
	print(index)
	get_node(star_dict[index]).visible = true
	
#-------------------------------INCOMING SIGNALS--------------------------------
func _on_StarTimer_timeout():
	if star_index < 4:
		star_index += 1
		set_star_timer()
		light_star(star_index)
