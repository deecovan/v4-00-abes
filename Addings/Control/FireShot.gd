extends Skill
class_name FireShot

func _init(target) -> void:
	cooldown = 1.0
	animation_name = "Fire"
	texture = preload("res://Addings/Control/Assets/FX/Skill Icons/48x48/skill_icons4.png")

	super._init(target)
	
	
func cast_spell(target) -> void:
	super.cast_spell(target)
	target.multi_shot()
