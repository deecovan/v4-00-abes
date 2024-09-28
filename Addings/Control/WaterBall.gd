extends Skill
class_name WaterBall

func _init(target) -> void:
	cooldown = 4.0
	animation_name = "Water"
	texture = preload("res://Addings/Control/Assets/FX/Skill Icons/48x48/skill_icons28.png")

	super._init(target)
	
	
func cast_spell(target) -> void:
	super.cast_spell(target)
	target.multi_shot(2, 0.8, animation_name)
