extends Node2D


## Parts
@onready var rope: Node2D = find_child("RopeRoot")
@onready var from: Node2D = find_child("from")
@onready var rope_start: Node = find_child("RopeStart")
@onready var to: Node2D = find_child("to")
@onready var rope_end: Node = find_child("RopeEnd")
## Variables
var real_dist: int
## Cooldown timer
var timer: Timer
## Arguments
var _from: CharacterBody2D
var _to: CharacterBody2D
var _dist: int
## Hack infrastructuure
var child_to = get_parent()
var i_am_ready := false


func _ready() -> void:
	if !i_am_ready:
		## link Rope parts
		rope.hide()
		i_am_ready = true


## @INTERFACE execute(args: Dictionary) -> Dictionary:
func execute(args: Dictionary) -> Dictionary:
	var res: Dictionary
	## Check cooldown timer
	if timer != null:
		print("Cool down ", _from.name, " on ", name)
		return res
	## Get arguments
	_from = args.from
	_to = args.to
	_dist = args.dist
	## Instatiate Rope
	res.success = false
	if _to != null and _from != null:
		real_dist = int((_from.global_position - _to.global_position).length())
		if real_dist <= _dist:
			## Add the Rope
			from = _from
			to = _to
			res.success = true
		## Return result
		res.to_name = _to.name
		res.from_name = _from.name
		res.dist = real_dist
	return res


func _process(_delta: float) -> void:
	## Hack _ready() cant be called from pawn's add_child(instance)
	if !i_am_ready:
		_ready()
	## To avoid empty startup errors
	if _to != null and _from != null:
			## Update Rope
			from = _from
			to = _to
			rope_set()


func rope_set() -> void:
		rope_start.rope = rope
		rope_start.target_node = from
		rope_end.rope = rope
		rope_end.target_node = to
		rope.show()
