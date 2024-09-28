extends HBoxContainer

var slots: Array


func _ready() -> void:
	slots = get_children()
	for i in slots.size():
		pass
		slots[i].change_key = str(i + 1)
		
		## Testing slots
		slots[0].skill = FireShot.new(slots[0])
		slots[1].skill = WaterBall.new(slots[1])
		slots[2].skill = Tornado.new(slots[2])
		slots[3].skill = DarkBall.new(slots[3])
		slots[4].skill = Ultimate.new(slots[4])
