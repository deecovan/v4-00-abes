extends Node2D


## Parts
var pause: bool
var rope: Node2D = find_child("Rope")
var from: Node2D = find_child("from")
var rope_start: Node2D = find_child("ropeStart")
var to: Node2D = find_child("to")
var rope_end: Node2D = find_child("ropeEnd")
## Variables
var zzz := ""
var real_dist: int
## Cooldown timer
var timer: Timer
## Arguments
var _from: CharacterBody2D
var _to: CharacterBody2D
var _dist: int
## Hack infrastructuure
var child_to = get_parent().get_parent()
var i_am_ready := false


func _ready() -> void:
	if !i_am_ready:
		print("Imnt Ready")
		## link Rope parts
		rope.target_rope = rope
		rope_start.rope = rope
		rope_start.target_node = from
		rope_end.rope = rope
		rope_end.target_node = to
		i_am_ready = true


## @INTERFACE execute(args: Dictionary) -> Dictionary:
func execute(args: Dictionary) -> Dictionary:
	var res: Dictionary
	## Check cooldown timer
	if timer != null:
		print("Cool down ", _from.name, " on ", name)
		return res
	## Get arguments
	_to = args.to
	_from = args.from
	_dist = args.dist
	## Instatiate Rope
	res.success = false
	if _to != null and _from != null:
		start_timer()
		real_dist = int((_from.global_position - _to.global_position).length())
		if real_dist <= _dist:
			## Show Rope
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
		real_dist = int((_from.global_position - _to.global_position).length())
		if real_dist <= _dist:
			## Update Rope
			pass
		else:
			## Delete Rope
			delete_rope()


## Create and start a timer manually
func start_timer() -> void:
	timer = Timer.new()
	timer.one_shot = true
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", _on_timer_timeout)


## Manually too
func _on_timer_timeout() -> void:
	delete_rope()


func delete_rope() -> void:
	if timer != null:
		timer.queue_free()
		_to = null
		_from = null
