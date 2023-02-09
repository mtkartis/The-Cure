class_name Villager
extends KinematicBody2D

enum {NORMAL, SICK, PATIENT, CURED}

export(String, MULTILINE) var normal_dialog
export(String, MULTILINE) var sick_dialog
export(String, MULTILINE) var patient_dialog
export(String, MULTILINE) var inject_dialog
export(String, MULTILINE) var cured_dialog

export(int) var status


onready var image = $Sprite
onready var icon:Icon = $Icon
onready var DATA_KEY = str(get_path())

#-------------------------------------------------------------------------------
func _ready():
	call_deferred("assign_icon")

func assign_icon():
	match status:
		NORMAL:
			icon.set_icon(icon.BLANK)
		SICK:
			icon.set_icon(icon.SICK)
		PATIENT:
			icon.set_icon(icon.PATIENT)
		CURED:
			icon.set_icon(icon.BLANK)

func get_dialog()->Array:
	var a:Array = []
	match status:
		SICK:
			a = delineate_text(sick_dialog)
			status = PATIENT
		NORMAL:
			a = delineate_text(normal_dialog)
		PATIENT:
			if GlobalPlayerStats.cures > 0:
				a = delineate_text(inject_dialog)
				status = CURED
				GlobalPlayerStats.cures -= 1
			else:
				a = delineate_text(patient_dialog)
		CURED:
			a = delineate_text(cured_dialog)
			status = NORMAL
	return a

func delineate_text(text:String)->Array:
	var b = text.strip_escapes()
	var a = Array(b.split("|",false))
	return a

func _on_Interact_body_entered(body):
	if body is KinematicBody2D:
		icon.set_icon(icon.TALK)

func _on_Interact_body_exited(body):
	if body is KinematicBody2D:
		match status:
			NORMAL:
				icon.set_icon(icon.BLANK)
			CURED:
				icon.set_icon(icon.BLANK)
			SICK:
				icon.set_icon(icon.SICK)
			PATIENT:
				icon.set_icon(icon.PATIENT)

func save(file_path:Resource):
	file_path.data[DATA_KEY] = status

func load(file_path:Resource):
	print("load")
	if file_path.data.keys().find(DATA_KEY) != -1:
		print(DATA_KEY)
		status = file_path.data[DATA_KEY]
