extends CharacterBody2D

@export var scr_width  := 1100
@export var scr_height := 660
@export var speed      := 300
## Distance for Mark and Rope
@export var max_endpoint_distance = 300


var hlf_speed      := speed/2.0
var hlf_scr_width  := scr_width/2.0
var qtr_scr_width  := scr_width/4.0
var hlf_scr_height := scr_height/2.0
var qtr_scr_height := scr_height/4.0


var direction      := Vector2.ZERO
var abes           := []
var mark_attached  := false
var rope_attached  := false


func _ready() -> void:
	## Initial direction
	direction = Vector2.ZERO
	if(global_position.x < hlf_scr_width):
		direction += Vector2.RIGHT * randf()
	else:
		direction = Vector2.LEFT * randf()
	if(global_position.y < hlf_scr_height):
		direction += Vector2.DOWN * randf()
	else:
		direction += Vector2.UP * randf()
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
		direction += Vector2.RIGHT * randf()
	if global_position.x >= (scr_width - qtr_scr_width):
		direction += Vector2.LEFT * randf()
	if global_position.y <= (qtr_scr_height):
		direction += Vector2.DOWN * randf()
	if global_position.y >= (scr_height - qtr_scr_height):
		direction += Vector2.UP * randf()
	
	## SpeedUp p1 when the Rope is linked
	var vel_m := 1
	if(rope_attached):
		vel_m *= 5
	if(name == "p1"):
		vel_m *= 4
	## Little bit random
	velocity += vel_m * speed * delta * direction
		
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
		args.dist = max_endpoint_distance
		print ("Marked: ", mark_attached)
		var res = abes[1].execute(args)
		## Print the answer result
		if res != {}:
			print("Mark: ", res)
			if(res.success):
				mark_attached = res.success
	
	## Call attachable.execute() for p1.abes[2]
	if(name == "p1"
	and mark_attached and !rope_attached and randf() < delta/4
	and abes.size() > 2 and abes[2] != null):
		var args: Dictionary
		args.from = get_parent().find_child("p1")
		args.to = get_parent().find_child("p2")
		args.dist = max_endpoint_distance
		var res = abes[2].execute(args)
		## Print the answer result
		if res != {}:
			print("Rope: ", res)
			if(!rope_attached and res.success):
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
