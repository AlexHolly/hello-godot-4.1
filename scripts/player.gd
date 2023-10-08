extends CharacterBody2D

@export var player_sprite : Texture2D
@export var id = 1

var speed = 100
var ammo = 20
var dir = Vector2(0,0)
var last_dir = Vector2(1,0)

func _ready():
	$Sprite2D.set_texture(player_sprite)
	add_to_group("player")
	set_physics_process(true)

func _physics_process(delta):
	_handle_move(delta)
	_handle_shoot()

func _handle_move(delta):
	dir = Vector2(0, 0)
	if Input.is_action_pressed("ui_left") && id == 1 || Input.is_action_pressed("left") && id == 2:
		dir += Vector2(-1,0)
		last_dir = dir
	if Input.is_action_pressed("ui_right") && id == 1 || Input.is_action_pressed("right") && id == 2:
		dir += Vector2(1,0)
		last_dir = dir
	if Input.is_action_pressed("ui_up") && id == 1 || Input.is_action_pressed("up") && id == 2:
		dir += Vector2(0,-1)
		last_dir = dir
	if Input.is_action_pressed("ui_down") && id == 1 || Input.is_action_pressed("down") && id == 2:
		dir += Vector2(0,1)
		last_dir = dir
	
	$Sprite2D.set_rotation(atan2(last_dir.y, last_dir.x))
	
	var motion = dir * speed * delta
	move_and_collide( motion )

#--shoot--
var bullet_class = preload("res://scenes/bullet.scn")

func _handle_shoot():
	
	if ammo > 0 && (Input.is_action_pressed("ui_accept") && id == 1 || Input.is_action_pressed("shoot") && id == 2) && $ShootCooldown.is_stopped():
		add_ammo(-1)
		var bullet = bullet_class.instantiate()
		bullet.set_name(str(bullet.get_name(), bullet.get_instance_id()))
		
		if last_dir.x == 0 && last_dir.y == 0:
			last_dir.x = 1
		
		var offset = get_position() + (Vector2(25,25) * last_dir)
		bullet.set_position(offset)
		bullet.dir = last_dir
		bullet.object_owner = id
		get_parent().add_child(bullet)

		$ShootCooldown/Timer.start()

func hit(amount):
	var bar = $HpBar
	bar.set_value(bar.get_value()-amount)
	if bar.get_value() <= 0:
		queue_free()

func heal(amount):
	var bar = $HpBar
	bar.set_value(bar.get_value()+amount)

func add_ammo(amount):
	ammo += amount
