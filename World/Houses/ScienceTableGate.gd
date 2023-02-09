extends Node2D

const SCIENCE = "res://World/ScienceTable/Science.tscn"

signal on

func _ready():
	if GlobalPlayerStats.samples > 0:
		emit_signal("on", SCIENCE)

