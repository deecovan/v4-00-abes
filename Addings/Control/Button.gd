extends TextureButton


@onready var cooldown := $CoolDown
@onready var key := $Key
@onready var time := $Time
@onready var timer := $Timer

var change_key = "":
	set(value):
		change_key = value
		key.text = value

		shortcut = Shortcut.new()
		var input_key := InputEventKey.new()
		input_key.keycode = value.unicode_at(0)
		
		shortcut.events = [input_key]
