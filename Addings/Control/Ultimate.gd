extends Skill
class_name Ultimate

func _init(target) -> void:
	cooldown = 10.0
	animation_name = "Water"
	texture = preload("res://Addings/Control/Assets/FX/Skill Icons/48x48/skill_icons13.png")

	super._init(target)
	
	
func cast_spell(target) -> void:
	super.cast_spell(target)
	target.radial(21)
