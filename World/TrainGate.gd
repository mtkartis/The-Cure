extends Node

const TRAIN = "res://World/Cutscenes/TrainCar.tscn"

signal on

func _ready():
	if GlobalPlayerStats.people_done == 9:
		emit_signal("on", TRAIN)
