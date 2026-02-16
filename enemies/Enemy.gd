extends CharacterBody2D

@export var health = 3
@export var speed = 150

func _physics_process(delta):
	var player = get_tree().current_scene.get_node("Player")
	
	if player == null:
		return
	
	var direction = player.global_position - global_position
	
	if direction.length() > 0:
		direction = direction.normalized()
	
	velocity = direction * speed
	
	move_and_slide()
func take_damage(amount):
	health -= amount
	
	print("Враг получил урон. HP:", health)
	
	if health <= 0:
		die()

func die():
	queue_free()
