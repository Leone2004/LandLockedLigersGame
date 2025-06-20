extends Control

@onready var BackButton : Button = $Back
@onready var NextButton : Button = $Next
@onready var FinishedButton : Button = $Finished
@onready var ShoppingButton : Button = $ShoppingList
@onready var camera : Camera2D = $"../Camera2D"

var aisle_index := 0  # keeps track of which aisle we're on

func _on_back_pressed() -> void:
	var screen_width := get_viewport().get_visible_rect().size.x
	print("back button was pressed")

	if aisle_index > 0:
		aisle_index -= 1
		camera.position.x = aisle_index * screen_width

func _on_next_pressed() -> void:
	var screen_width := get_viewport().get_visible_rect().size.x
	print("next button was pressed")

	aisle_index += 1  # increase aisle
	camera.position.x = aisle_index * screen_width

func _on_finished_pressed() -> void:
	print("finished button was pressed")

func _on_shopping_list_pressed() -> void:
	print("shopping list button was pressed")
