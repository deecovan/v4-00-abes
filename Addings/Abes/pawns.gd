extends CharacterBody2D

@export var scr_width  := 1100
@export var scr_height := 600


var speed      := scr_width/3.0
var direction  := Vector2.ZERO
var abes       := []


var hlf_speed := speed/2.0
var hlf_scr_width := scr_width/2.0
var qtr_scr_width := scr_width/4.0
var hlf_scr_height := scr_height/2.0
var qtr_scr_height := scr_height/4.0


func _ready() -> void:
	## Initial direction
	direction = Vector2.ZERO
	
	if(global_position.x < hlf_scr_width):
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT
	
	if(global_position.y < hlf_scr_height):
		direction += Vector2.DOWN
	else:
		direction += Vector2.UP
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
		direction = Vector2.RIGHT
	if global_position.x >= (scr_width-qtr_scr_width):
		direction = Vector2.LEFT
	if global_position.y <= (qtr_scr_height):
		direction = Vector2.DOWN
	if global_position.y >= (scr_height-qtr_scr_height):
		direction = Vector2.UP
	velocity  += direction * speed * delta
	velocity.x = clamp(velocity.x, -hlf_speed, hlf_speed)
	velocity.y = clamp(velocity.y, -hlf_speed, hlf_speed)
	move_and_slide()
	
	## Call attachable.execute() for abes[0]
	if(abes[0] != null and randf() < delta):
		var args: Dictionary
		if name == "p1":
			args.from = get_parent().find_child("p1")
			args.to = get_parent().find_child("p2")
			args.color = Color.CYAN
		else:
			args.from = get_parent().find_child("p2")
			args.to = get_parent().find_child("p1")
			args.color = Color.MAGENTA
		args.amount = randi_range(5, 25)
		
		var res = abes[0].execute(args)
		## Print the answer result
		if res != {}:
			print(res)
	
	## Call attachable.execute() for p1.abes[1]
	if(abes[1] != null and name == "p1" and randf() < delta ):
		var args: Dictionary
		args.from = get_parent().find_child("p1")
		args.to = get_parent().find_child("p2")
		args.dist = 400
		
		var res = abes[1].execute(args)
		## Print the answer result
		if res != {}:
			print(res)


func attachable(abe_name: StringName, args: Array = []) -> Node:
	## Instantiate ability
	var fname := "res://Addings/Abes/Abilities/" + abe_name + "/" + abe_name
	var scene = load(fname + ".tscn")
	var script = load(fname + ".gd")
	var instance: Node2D = scene.instantiate()
	add_child(instance)
	## Setting up an instance and script
	instance.set_script(script)
	## Force calling _process() and _ready()
	instance.set_process(true)
	print("Node \"", name, "\" attached ", abe_name, args)
	return instance
