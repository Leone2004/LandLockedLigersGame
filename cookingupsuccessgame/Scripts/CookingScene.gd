extends Node2D
var ovenswitch : bool = true
@onready var camera : Camera2D = $Camera2D

func _on_button_pressed() -> void:
	var screen_width := get_viewport().get_visible_rect().size.x
	print("back button was pressed")

	if ovenswitch == true:
		camera.position.x = 1 * screen_width
		ovenswitch = false
