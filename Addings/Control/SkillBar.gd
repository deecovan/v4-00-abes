extends HBoxContainer

var slots: Array 
var skills: Array = [FireShot, WaterBall, Tornado, DarkBall, Ultimate]


func _ready() -> void:
	slots = get_children()
	for i in slots.size():
		pass
		slots[i].change_key = str(i + 1)
		slots[i].skill = skills[i].new(slots[i])
