class_name Door
extends StaticBody2D

export(String) var POSITION_KEY

export(String) var go_to

onready var p_position = $Position2D

#-------------------------------------------------------------------------------
func get_go_to():
	return go_to

func open():
	Global.door_key = POSITION_KEY
	DataManagement.save()
	var file = File.new()
	if file.file_exists(go_to):
		get_tree().change_scene(go_to)


func _on_trigger(value):
	go_to = value 
