class_name Icon
extends AnimatedSprite

enum {
	BLANK,
	SICK,
	TALK,
	PATIENT,
}

#-------------------------------------------------------------------------------
func set_icon(animation_enum:int):
	match animation_enum:
		SICK:
			animation = "Sick"
		TALK:
			animation = "Talk"
		BLANK:
			animation = "Blank"
		PATIENT:
			animation = "Patient"
