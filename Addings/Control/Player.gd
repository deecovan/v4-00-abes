extends CharacterBody2D


var projectile_node: PackedScene = preload("res://Addings/Control/Projectile.tscn")


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func single_shot(animation_name = "Fire") -> void:
	var projectile = projectile_node.instantiate()
	projectile.play(animation_name)
	projectile.add_to_group("projectile")
	projectile.set_physics_process(true)
	projectile.global_position = global_position
	projectile.direction = (
		get_global_mouse_position() - global_position
	).normalized()
	get_tree().current_scene.call_deferred("add_child", projectile)


func multi_shot(count: int = 3, delay: float = 0.3, 
	animation_name = "Fire") -> void:
		for i in range(count):
			single_shot(animation_name)
			await get_tree().create_timer(delay).timeout


func angled_shot(angle: float, i: int) -> void:
	var projectile = projectile_node.instance()
	if i % 2 == 0:
		projectile.play("Dark")
	else:
		projectile.play("Fire")
	projectile.add_to_group("projectile")
	projectile.set_physics_process(true)
	projectile.position = global_position
	projectile.direction = (Vector2(cos(angle), sin(angle)))
	get_tree().current_scene.call_deferred("add_child", projectile)


func radial(count: int) -> void:
	for i in range(count):
		angled_shot( 2.0 * PI * float(i) / count, i)


func _physics_process(_delta: float) -> void:
	pass
