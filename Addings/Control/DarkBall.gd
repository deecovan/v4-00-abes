extends Skill
class_name DarkBall

func _init(target) -> void:
	cooldown = 6.0
	animation_name = "DarkBall"
	texture = preload("res://Addings/Control/Assets/FX/Skill Icons/48x48/skill_icons29.png")

	super._init(target)
	
	
func cast_spell(target) -> void:
	super.cast_spell(target)
	target.multi_shot(4, 0.2, animation_name)
