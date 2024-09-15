extends Node2D

@export var diffuse_cooldown = 1.0
@export var diffuse_speed = 5.0


var from: CharacterBody2D
var to: CharacterBody2D
var square: Polygon2D
var color: Color
var amount: int = 0
var timer: float = 0.0


## @INTERFACE execute(args: Dictionary) -> Dictionary:
func execute(args: Dictionary) -> Dictionary:
	var res: Dictionary
	if timer > 0 and timer < diffuse_cooldown:
		return {}
	from = args.from
	to = args.to
	amount = args.amount
	color = args.color
	for i in amount:
		var square_node = square.duplicate()
		add_child(square_node)
		square_node.add_to_group("diffuse")
		square_node.color = color
		square_node.global_position += Vector2(randf_range(-10,10),randi_range(-10,10))
		square_node.show()
		
	res.count = get_tree().get_nodes_in_group("diffuse").size()
	return res


## @INTERFACE reset() -> void:
func reset() -> void:
	get_tree().call_group("diffuse", "queue_free")
	timer = 0.0

## works
func _init() -> void:
	square = find_child("Square")


## not works but forced with Scene._ready()
func _ready() -> void:
	pass


## not works but forced with instance.set_process(true)
func _process(delta: float) -> void:
	if timer > diffuse_cooldown:
		timer = 0.0
	if (from != null and to != null and 
			get_tree().get_nodes_in_group("diffuse").size() > 0):
		timer += delta
		for child in get_children():
			var num := 0
			if child.is_in_group("diffuse"):
				num += 1
				if (child.global_position - to.global_position).length() < 50:
					child.queue_free()
				else:
					child.global_position = lerp(
						child.global_position, to.global_position, 
						((randf() * num) * diffuse_speed * delta))
	else:
		reset()
