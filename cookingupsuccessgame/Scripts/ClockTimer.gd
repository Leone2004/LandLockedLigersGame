extends Node2D

# Progress from 0.0 (start) to 1.0 (done)
var progress: float = 0.0:
	set(value):
		progress = clamp(value, 0.0, 1.0)
		queue_redraw()

func _draw():
	var radius: float = 40
	var thickness: float = 6
	var start_angle: float = -PI/2
	var end_angle: float = start_angle + 2 * PI * progress

	# Draw background circle (light gray)
	draw_arc(Vector2.ZERO, radius, 0, 2*PI, 64, Color(0.8, 0.8, 0.8, 0.5), thickness)

	# Draw progress arc (red)
	if progress > 0:
		draw_arc(Vector2.ZERO, radius, start_angle, end_angle, 64, Color(1, 0, 0, 1), thickness)

	# Draw outer circle outline
	draw_circle(Vector2.ZERO, radius + thickness/2, Color(0, 0, 0, 0.3), 2)

func _ready() -> void:
	progress = 0.0
	visible = false 
