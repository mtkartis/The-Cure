extends Node

const MUSIC1 = preload("res://Sounds/SimpleSong.wav")
const MUSIC2 = preload("res://Sounds/TitleSong.wav")
const MUSIC3 = preload("res://Sounds/Town1.wav")
const MUSIC4 = preload("res://Sounds/Town3edit1.wav")
const MUSIC5 = preload("res://Sounds/Town4.wav")
const MUSIC6 = preload("res://Sounds/Town5.wav")

enum STORY {BEGINNING, END}

var door_key:String = ""

var story_state = STORY.BEGINNING


#---------------LOGISTIC SETUP---------------
var music_option = true
var music = AudioStreamPlayer.new()
var timer = Timer.new()
var music_index = [MUSIC1,MUSIC2,MUSIC3,MUSIC4,MUSIC5,MUSIC6]
onready var screen_size = OS.get_screen_size()
onready var window_size = OS.get_window_size()

#-----------------------READY-----------------------
func _ready():
	randomize()
	#set OS screen centred on startup
	OS.set_window_position(screen_size*0.5 - window_size*0.5)

	add_child(music)
	music.set_autoplay(true)
	music.set_stream(music_index[randi() % music_index.size()])
	music.volume_db = 1
	#music.play()
	music.connect("finished",self,"_finish_audio_track")
	print(music.is_playing())
	print(music.stream)

#----------------------AUDIO LOOPER--------------------------
func _finish_audio_track():
	randomize()
	print("finished")
	if music_option == true:
		add_child(timer)
		timer.wait_time = (10 + (randi() % 10))
		timer.connect("timeout",self,"_audio_timer_timeout")
		timer.start()
	else:
		return
func _audio_timer_timeout():
	randomize()
	print("timeout")
	timer.stop()
	music.set_stream(music_index[randi() % music_index.size()])
	music.play(0)

#------------GLOBAL INPUT---------------------------
func _input(event):
	if event is InputEventKey:
		#quit key
		if event.is_action_pressed("ui_cancel"):
			get_tree().quit()
