extends CharacterBody2D

@export var speed = 800
@export var damage = 1

var direction = Vector2.RIGHT

func _physics_process(delta):
	rotation = direction.angle()
	
	velocity = direction * speed
	move_and_slide()
	
	check_collision()


func check_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()
		
		if body.has_method("take_damage"):
			body.take_damage(damage)
			queue_free()
			return
