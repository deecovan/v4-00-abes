extends Node2D

@export var diffuse_speed = 0.1
@export var diffuse_cooldown = 1.0

var from: CharacterBody2D
var to: CharacterBody2D
var amount: int = 0
var timer: float = 0.0
var square_array: Array
var square: Polygon2D
var color: Color


## @INTERFACE execute(args: Dictionary) -> Dictionary:
func execute(args: Dictionary) -> Dictionary:
	timer = 0.0
	from = args.from
	to = args.to
	amount = args.amount
	color = args.color
	for i in amount:
		var square_node = square.duplicate()
		square_array.append(square_node)
		self.add_child(square_node)
		square_node.add_to_group("diffuse")
		square_node.show()
	return {}


## works
func _init() -> void:
	amount = 10
	square = find_child("Square")
	
	
## not works but forced with Scene._ready()
func _ready() -> void:
	pass


## not works but forced with instance.set_process(true)
func _process(delta: float) -> void:
	## Colldown: reset and delete all
	print(timer)
	if timer > diffuse_cooldown:
		timer = 0.0
		get_tree().call_group("diffuse", "queue_free")
		return
	## Else move
	if (from != null and to != null and 
			get_tree().get_nodes_in_group("diffuse").size() > 0):
		timer += delta
		for child in get_children():
			if child.is_in_group("diffuse"):
				if (child.global_position - to.global_position).length() < 50:
					child.queue_free()
				else:
					child.global_position = lerp(
						child.global_position, to.global_position, diffuse_speed)
							
