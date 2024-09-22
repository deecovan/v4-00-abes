extends Node2D


## Variables
var lines: Node2D = find_child("Lines")
## Cooldown timer
var timer: Timer
var real_dist: int
## Arguments
var from: CharacterBody2D
var to: CharacterBody2D
var dist: int
## Hack infrastructuure
var child_to = get_parent().get_parent()
var i_am_ready := false


func _ready() -> void:
	if !i_am_ready:
		print_debug()
		lines.hide()
		i_am_ready = true


## @INTERFACE execute(args: Dictionary) -> Dictionary:
func execute(args: Dictionary) -> Dictionary:
	var res: Dictionary
	## Check cooldown timer
	if timer != null:
		print("Cool down ", to)
		return res
	## Get arguments
	to = args.to
	from = args.from
	dist = args.dist
	## Instatiate Mark
	res.success = false
	if to != null and from != null:
		start_timer()
		real_dist = int((from.global_position - to.global_position).length())
		if real_dist <= dist:
			## Show mark
			lines.global_position = to.global_position
			lines.show()
			res.success = true
		## Return result
		res.to_name = to.name
		res.from_name = from.name
		res.dist = real_dist
	return res


func _process(_delta: float) -> void:
	## Hack _ready() cant be called from pawn's add_child(instance)
	if !i_am_ready:
		_ready()
	if to != null and from != null:
	## To avoid empty startup errors
		real_dist = int((from.global_position - to.global_position).length())
		if real_dist <= dist:
			## Update mark
			lines.global_position = to.global_position
		else:
			## Delete mark
			delete_mark()


## Create and start a timer manually
func start_timer() -> void:
	timer = Timer.new()
	timer.one_shot = true
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", _on_timer_timeout)


## Manually too
func _on_timer_timeout() -> void:
	delete_mark()


func delete_mark() -> void:
	if timer != null:
		timer.queue_free()
	lines.hide()
