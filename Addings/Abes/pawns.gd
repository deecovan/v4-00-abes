extends CharacterBody2D


var speed      := 640.0
var direction  := Vector2.RIGHT

func _ready() -> void:
	## init direction
	if(global_position.x < 640):
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT
	## little random
	velocity.x  += direction.x * speed * randf()
	speed *= randf_range(0.8,1.2)


func _physics_process(delta: float) -> void:
	## bob movement
	if global_position.x <= (512):
		direction = Vector2.RIGHT
	if global_position.x >= (1280-512):
		direction = Vector2.LEFT
	velocity  += direction * speed * delta
	velocity.x = clamp(velocity.x, -speed, speed)
	move_and_slide()
