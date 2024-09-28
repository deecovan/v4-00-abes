extends HBoxContainer

var slots: Array


func _ready() -> void:
	slots = get_children()
	for i in slots.size():
		pass
		slots[i].change_key = str(i + 1)
		
		## Testing slots
		slots[0].skill = FireShot.new(slots[0])
