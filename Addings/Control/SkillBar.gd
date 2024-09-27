extends HBoxContainer

var slots: Array


func _ready() -> void:
	slots = get_children()
	for i in slots:
		slots[i].change_key = str(i + 1)
