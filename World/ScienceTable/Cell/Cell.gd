class_name Cell
extends RigidBody2D

var mod_default = Vector3(modulate.r,modulate.g,modulate.b)

onready var area = $Area2D
onready var layer_1 = $Layer1
onready var layer_2 = $Layer2
onready var layer_3 = $Layer3

func _process(delta):
	var collisions = area.get_overlapping_areas()
	if collisions != []:
		modulate.r = 0
		modulate.b = 0
		modulate.g = 255
	else:
		modulate.r = mod_default.x
		modulate.g = mod_default.y
		modulate.b = mod_default.z

func set_image(layer1, layer2, layer3):
	layer_1.frame = layer1
	layer_2.frame = layer2
	layer_3.frame = layer3
