extends CharacterBody2D


var speed      := 640.0
var direction  := Vector2.RIGHT
var abes       := []
	

func _ready() -> void:
	## init direction
	if(global_position.x < 640):
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT
	## little random
	velocity.x  += direction.x * speed * randf()
	speed *= randf_range(0.8,1.2)
	
	## @USE attachable
	abes.append(attachable("Diffuse"))


func _physics_process(delta: float) -> void:
	## bob movement
	if global_position.x <= (512):
		direction = Vector2.RIGHT
	if global_position.x >= (1280-512):
		direction = Vector2.LEFT
	velocity  += direction * speed * delta
	velocity.x = clamp(velocity.x, -speed, speed)
	move_and_slide()
	## Call attachable.execute()
	if(randf() < 0.01):
		var args: Dictionary
		args.from = get_parent().find_child("from")
		args.to = get_parent().find_child("to")
		args.amount = 10
		abes[0].execute(args)
	
	
func attachable(abe_name: StringName, args: Array = []) -> Node:
	## Instantiate ability
	var fname := "res://Addings/Abes/Abilities/" + abe_name + "/" + abe_name
	var scene = load(fname + ".tscn")
	var script = load(fname + ".gd")
	var instance: Node2D = scene.instantiate()
	add_child(instance)
	## Set up instance and script
	instance.set_script(script)
	## Force call _ready() due to not really ready
	instance._ready()
	## Force calling _process()
	instance.set_process(true)
	print("Node \"", name, "\" attached ", abe_name, args)
	print (instance)
	return instance
