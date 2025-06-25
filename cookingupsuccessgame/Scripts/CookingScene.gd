extends Node2D
var ovenswitch : bool = true
@onready var camera : Camera2D = $Camera2D

func _on_button_pressed() -> void:
	var screen_width := get_viewport().get_visible_rect().size.x
	print("back button was pressed")

	if ovenswitch == true: # acts like a toggle button for the oven
		camera.position.x = 1 * screen_width
		ovenswitch = false
	else :
		camera.position.x = 0 # sets camera's x position back to 0
		ovenswitch = true


func _on_nextday_pressed() -> void:
	Global.day += 1 # increments day by one, when the "done" button is pressed
	get_tree().change_scene_to_file("res://Scenes/GroceryStore.tscn") # changes scene back to shopping scene
