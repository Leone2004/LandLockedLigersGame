extends Node2D
var ovenswitch : bool = true
var recipe_book_visible : bool = false
var current_recipe : int = 0
@onready var recipe = get_node("CanvasLayer/RecipeBook/Current Recipe")
@onready var recipe_book_layer = get_node("CanvasLayer/RecipeBook")
@onready var camera : Camera2D = $Camera2D

func _on_button_pressed() -> void:
	var screen_width := get_viewport().get_visible_rect().size.x
	print("back button was pressed")

	if ovenswitch == true:
		camera.position.x = 1 * screen_width
		ovenswitch = false

func _on_recipe_pressed() -> void:
	recipe_book_visible = !recipe_book_visible
	recipe_book_layer.visible = recipe_book_visible


func _on_next_pressed() -> void: # go to next page
	current_recipe += 1
	var recipe_number_text = "[center]Recipe Number %s[/center]"
	recipe_number_text = recipe_number_text % current_recipe
	recipe.text = recipe_number_text


func _on_previous_pressed() -> void: #go to previous page
	current_recipe -= 1
	var recipe_number_text = "[center]Recipe Number %s[/center]"
	recipe_number_text = recipe_number_text % current_recipe
	recipe.text = recipe_number_text
