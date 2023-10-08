extends Sprite2D

@onready var sprite = get_node("Sprite2D")

var color_start = Color.ORANGE

var color_current = color_start

var bar_width_max = 40.0
var bar_width_current = bar_width_max
var bar_height = 5.0

var border_pixels = 1

func _ready():
	$Timer.connect("timeout", _on_Timer_timeout)
	set_physics_process(true)

func _physics_process(delta):
	bar_width_current = $Timer.time_left/$Timer.wait_time*bar_width_max
	queue_redraw()

func _on_Timer_timeout():
	$Timer.stop()

func is_stopped():
	return $Timer.is_stopped()

func _draw():
	draw_rect(Rect2(-bar_width_max/2.0-border_pixels, -border_pixels, bar_width_max + border_pixels*2, bar_height + border_pixels*2), Color.BLACK)
	draw_rect(Rect2(-bar_width_max/2.0, 0, bar_width_current, bar_height), color_current)
