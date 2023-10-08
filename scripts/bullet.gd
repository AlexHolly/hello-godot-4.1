extends RigidBody2D

var dir = Vector2(0,0)
var speed = 200
var damage = 1
var object_owner = -1

func _ready():
	add_to_group("bullet")
	set_physics_process(true)

func _physics_process(delta):
	if damage != 0:
		#set_constant_force(  )
		var collision = move_and_collide(dir * speed * delta)
		if collision:
			var colliding_body = collision.get_collider()
			on_body_entered(colliding_body)
	else:
		queue_free()

func hit_me(body):
	body.hit(damage)
	damage = 0

func on_body_entered(body):
	if body.is_in_group("brick"):
		body.hit(damage)
		damage = 0
	elif body.is_in_group("player"):
		if object_owner != body.id:
			body.hit(damage)
			damage = 0
	queue_free()
