extends CharacterBody2D

@export var scr_width  := 1100
@export var scr_height := 600


var hlf_speed      := speed/2.0
var hlf_scr_width  := scr_width/2.0
var qtr_scr_width  := scr_width/4.0
var hlf_scr_height := scr_height/2.0
var qtr_scr_height := scr_height/4.0


var speed          := qtr_scr_width * randf() + qtr_scr_width
var direction      := Vector2.ZERO
var abes           := []
var mark_attached  := false
var rope_attached  := false


func _ready() -> void:
	## Initial direction
	direction = Vector2.ZERO
	
	if(global_position.x < hlf_scr_width):
		direction = Vector2.RIGHT
		speed = qtr_scr_width * randf() + qtr_scr_width
	else:
		direction = Vector2.LEFT
		speed = qtr_scr_width * randf() + qtr_scr_width
	if(global_position.y < hlf_scr_height):
		direction += Vector2.DOWN
		speed = qtr_scr_width * randf() + qtr_scr_width
	else:
		direction += Vector2.UP
		speed = qtr_scr_width * randf() + qtr_scr_width
	## A little bit random
	
	speed *= randf_range(0.8,1.2)
	velocity  += direction * speed
	
	## Append attachable
	abes.append(null) ## Empty node was attachable("Diffuse")
	## Simple attachable mark
	if name == "p1":
		abes.append(attachable("Mark"))
		## Attachable Rope
		abes.append(attachable("Rope"))



func _physics_process(delta: float) -> void:
	## Bob movement 2d
	direction = Vector2.ZERO
	if global_position.x <= (qtr_scr_width):
		direction += Vector2.RIGHT
	if global_position.x >= (scr_width - qtr_scr_width):
		direction += Vector2.LEFT
	if global_position.y <= (qtr_scr_height):
		direction += Vector2.DOWN
	if global_position.y >= (scr_height - qtr_scr_height):
		direction += Vector2.UP
	velocity  += direction * speed * delta
	
	move_and_slide()
	
	### Call attachable.execute() for abes[0]
	#if(abes[0] != null and randf() < delta):
		#var args: Dictionary
		#if name == "p1":
			#args.from = get_parent().find_child("p1")
			#args.to = get_parent().find_child("p2")
			#args.color = Color.CYAN
		#else:
			#args.from = get_parent().find_child("p2")
			#args.to = get_parent().find_child("p1")
			#args.color = Color.MAGENTA
		#args.amount = randi_range(5, 25)
		#
		#var res = abes[0].execute(args)
		### Print the answer result
		#if res != {}:
			#print(res)
	
	## Call attachable.execute() for p1.abes[1]
	if(name == "p1" 
	and !mark_attached and !rope_attached and randf() < delta
	and abes.size() > 1 and abes[1] != null):
		var args: Dictionary
		args.from = get_parent().find_child("p1")
		args.to = get_parent().find_child("p2")
		args.dist = 400
		
		var res = abes[1].execute(args)
		## Print the answer result
		if res != {}:
			print(res)
			mark_attached = res.success
	
	## Call attachable.execute() for p1.abes[2]
	if(name == "p1"
	and mark_attached and !rope_attached and randf() < delta
	and abes.size() > 2 and abes[2] != null):
		var args: Dictionary
		args.from = get_parent().find_child("p1")
		args.to = get_parent().find_child("p2")
		args.dist = 500
		
		var res = abes[2].execute(args)
		## Print the answer result
		if res != {}:
			print(res)
			rope_attached = res.success


func attachable(abe_name: StringName, args: Array = []) -> Node:
	## Instantiate ability
	var fname := "res://Addings/Abes/Abilities/" + abe_name + "/" + abe_name
	var scene = load(fname + ".tscn")
	var script = load(fname + ".gd")
	var instance: Node2D = scene.instantiate()
	get_parent().add_child.call_deferred(instance)
	## Setting up an instance and script
	instance.set_script(script)
	## Force calling _process() and _ready()
	instance.set_process(true)
	print("Node \"", name, "\" attached ", abe_name, args)
	return instance
