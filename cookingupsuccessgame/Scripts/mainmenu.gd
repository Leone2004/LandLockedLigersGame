extends Control

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/GroceryStore.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_resume_button_pressed() -> void:
	pass # Replace with function body.
