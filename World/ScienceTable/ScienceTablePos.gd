extends KinematicBody2D

const CELL_MOVE = 100

onready var detect_area = $Area2D
onready var timer = $Timer

signal check

func _process(delta):
	var input_vector = Vector2(
		Input.get_action_strength("RIGHT") - Input.get_action_strength("LEFT"),
		Input.get_action_strength("DOWN") - Input.get_action_strength("UP")
	)
	input_vector = input_vector.normalized()
	move_and_slide(input_vector * (CELL_MOVE + (900 * Input.get_action_strength("SELECT"))))
	
	var collisions = detect_area.get_overlapping_areas()
	var closest_distance = INF
	var closest_index = null
	for i in collisions:
		var distance = (global_position - i.global_position).length()
		if distance < closest_distance:
			closest_index = i
			i.modulate.g = 100
	if Input.is_action_just_pressed("SPACE") and timer.time_left == 0.0:
#		print(closest_index)
		if closest_index != null:
			var a = [closest_index.owner.layer_1.frame, closest_index.owner.layer_2.frame, closest_index.owner.layer_3.frame]
			emit_signal("check", a)

func get_collisions():
	return detect_area.get_overlapping_areas()
