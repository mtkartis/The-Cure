extends Node

const save_file = preload("res://Data/SaveData.gd")

const folder_path = "user://saves"
const file_path = folder_path + "/save1.tres"


func _ready():
	make_file()

func make_file():
	var dir = Directory.new()
	if not dir.dir_exists(folder_path):
		dir.make_dir_recursive(folder_path)

func save():
	var file = File.new()
	var save_game:SaveData
	if file.file_exists(file_path):
		save_game = load(file_path)
	else:
		save_game = save_file.new()
	
	for node in get_tree().get_nodes_in_group("Saves"):
		node.save(save_game)
	
	ResourceSaver.save(file_path, save_game)

func load():
	var file = File.new()
	if not file.file_exists(file_path): return

	var load_game = load(file_path)
	print(load_game.data)
	for node in get_tree().get_nodes_in_group("Saves"):
		node.load(load_game)

func erase():
	var file = Directory.new()
	if file.file_exists(file_path):
		file.remove()
		make_file()
