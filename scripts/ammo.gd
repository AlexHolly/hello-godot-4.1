extends Area2D

var amount = 8
var pickable = false

func _ready():
	pass

func hit(amount):
	var hp = get_node("ProgressBar")
	if hp.get_value()-amount > 0:
		hp.set_value(hp.get_value()-amount)
	else:
		self.queue_free() 

func _on_body_entered(body):
	if pickable && body.is_in_group("player"):
		body.add_ammo(amount)
		queue_free()
	elif pickable && body.is_in_group("bullet"):
		body.hit_me(self)
