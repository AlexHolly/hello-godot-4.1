extends StaticBody2D

var item_hp = preload ("res://scenes/hp_item.scn")
var item_ammo = preload ("res://scenes/ammo_item.scn")

var items = [item_hp, item_ammo]

var item = null

var show_0 = preload("res://textures/stein0.png")
var show_1 = preload("res://textures/stein1.png")
var show_2 = preload("res://textures/stein2.png")

var img = [show_2, show_1, show_0]

func _ready():
	add_to_group("brick")

func spawn_random_item():
	item = items[randi() % items.size()]
	randomize()
	if typeof(item) != TYPE_INT:
		item = item.instantiate()
		
		item.set_global_position(self.get_position())
		get_parent().add_child(item)
		return item

func hit(amount):
	var hp = get_node("ProgressBar")
	var next_amount = hp.get_value()-amount
	
	if next_amount > 0:
		hp.set_value(next_amount)
		$BrickColli.set_texture(img[hp.get_value()-1])
	else:
		var item = spawn_random_item()
		if typeof(item) != TYPE_INT:
			item.pickable = true
		self.queue_free()
