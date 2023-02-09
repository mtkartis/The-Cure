extends Node

const CELL = preload("res://World/ScienceTable/Cell/Cell.tscn")
const LAB = "res://World/Houses/ScienceLab.tscn"
const DOOR_KEY = "Science"


export(int) var cell_count = 300

var virus_assigned:bool = false
var virus_layer_index:Array = [0,0,0]
var shake:bool = false
var t:float = 0.0

onready var cell_layer = $Cell
onready var cell_display = $Tabletop/TextureRect/VBoxContainer/Cell
onready var camera = $Position2D/Camera2D
onready var shake_timer = $Position2D/ShakeTimer
onready var camera_pos = $Position2D

func _ready():
	randomize()
	virus_layer_index = [randi() % 7, randi() % 17, randi() % 10]
	print(virus_layer_index)
	cell_display.layer_1.frame = virus_layer_index[0]
	cell_display.layer_2.frame = virus_layer_index[1]
	cell_display.layer_3.frame = virus_layer_index[2]
	spawn_cells()

func _process(delta):
	GlobalScore.science_time += delta
	if shake:
		camera.offset.x += sin(t * 50) * 10
		t += delta

func spawn_cells():
	var cells:Array = []
	for n in cell_count:
		var cell = CELL.instance()
		cell_layer.add_child(cell)
		cell.global_position = Vector2(rand_range(-100, 100), rand_range(-100, 100))
		cells.append(cell)
		
		
	while not cells.empty():
		randomize()
		var n = randi() % cells.size()
		var index = cells.pop_at(n)
		
		if not virus_assigned:
			var viral_chance = randf()
			if viral_chance == 1.0 or cells.empty():
				index.layer_1.frame = virus_layer_index[0]
				index.layer_2.frame = virus_layer_index[1]
				index.layer_3.frame = virus_layer_index[2]
				virus_assigned = true
				continue
				
		index.layer_1.frame = randi() % 7
		index.layer_2.frame = randi() % 17
		index.layer_3.frame = randi() % 10

func update_global_stats():
	GlobalPlayerStats.cures = 1
	GlobalPlayerStats.samples = 0


func _on_Position2D_check(layers:Array):
	var is_match = false
	var counter = 0
	for i in layers.size():
		if layers[i] == virus_layer_index[i]:
			counter += 1
	if counter == 3:
		print("MATCH!!")
		print(GlobalPlayerStats.cures)
		update_global_stats()
		print("CURES: ", GlobalPlayerStats.cures)
		Global.door_key = DOOR_KEY
		get_tree().change_scene(LAB)
	else:
		shake_timer.start()
		shake = true 
		GlobalScore.science_mistakes += 1
		print("NOT MATCH")


func _on_ShakeTimer_timeout():
	shake = false
	t = 0.0
	camera.offset = Vector2.ZERO
