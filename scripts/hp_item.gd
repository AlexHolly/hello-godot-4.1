extends Area2D

var heal_amount = 1
var pickable = false

func hit(amount):
	self.queue_free() 

func _on_body_entered(body):
	if pickable && body.is_in_group("player"):
		body.heal(heal_amount)
		queue_free()
	elif pickable && body.is_in_group("bullet"):
		hit(body.damage)
		body.damage = 0
