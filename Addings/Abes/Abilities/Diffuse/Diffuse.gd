extends Node2D


@export var from: CharacterBody2D
@export var to: CharacterBody2D
@export var amount: int = 0:
	set(value):
		if value < 0:
			amount = 0
		else:
			amount = value
@export var timer: float = 0.0
@export var square: Node2D
var square_array: Array


## @INTERFACE execute(args: Array) -> Array:
func execute(_args: Array) -> Array:
	var res := []
	return res


## works
func _init() -> void:
	amount = 10
	square = find_child("Square")
	
	
## not works but forced with instance._ready()
func _ready() -> void:
	for i in amount:
		var square_node = square.duplicate()
		square_array.append(square_node)
		self.add_child(square_node)
		square_node.add_to_group("diffuse")
		square_node.global_position += Vector2(randf_range(-20,20),randf_range(-20,20))
		square_node.show()


## not works but forced with instance.set_process(true)
func _process(delta: float) -> void:
	timer += delta
	if(amount > 0 and from != null and to != null):
		var i := 0
		for child in get_children():
			i += 1
			if child.is_in_group("diffuse"):
				var coords: Vector2
				coords = lerp(
					from.global_position, to.global_position, 
					amount * i)
				square.global_position = coords
				timer += delta
			## Delete if more squares than amount
			if i > amount:
				child.queue_free()
		amount -= 1
		
