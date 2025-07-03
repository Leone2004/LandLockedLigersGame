extends Control

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/GroceryStore.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	$PauseMenu.visible = false

func _on_save_button_pressed() -> void:
	Global.save_game()

func _on_pause_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/mainmenu.tscn")

func show_pause_menu():
	get_tree().paused = true
	$PauseMenu.visible = true

func _ready() -> void:
	$PauseMenu/ResumeButton.pressed.connect(_on_resume_button_pressed)
	$PauseMenu/SaveButton.pressed.connect(_on_save_button_pressed)
	$PauseMenu/QuitButton.pressed.connect(_on_pause_quit_button_pressed)
