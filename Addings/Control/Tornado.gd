extends Skill
class_name Tornado

func _init(target) -> void:
	cooldown = 5.0
	animation_name = "Tornado"
	texture = preload("res://Addings/Control/Assets/FX/Skill Icons/48x48/skill_icons49.png")

	super._init(target)
	
	
func cast_spell(target) -> void:
	super.cast_spell(target)
	target.single_shot(animation_name)
