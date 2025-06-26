extends Node2D
var ovenswitch : bool = true
var recipe_book_visible : bool
var recipes = Array() # recipes[i][0] is name. recipes[i][1] is ingredients subarray
var current_recipe : int
@onready var recipe = $CanvasLayer/RecipeBook/Recipe
@onready var recipe_book_layer = $CanvasLayer/RecipeBook
@onready var camera : Camera2D = $Camera2D
@onready var OvenCookingButton : Button = $CanvasLayer/Oven_Cooking_Button

func _ready() -> void:
	current_recipe = 0
	recipe_book_visible = false
	recipe_book_layer.visible = recipe_book_visible
	recipe.text = "[center][b]THE RECIPE BOOK[/b][/center]"
	recipes.append(["pepperoni", ["pepperoni", "cheese", "sauce", "dough"]])
	recipes.append(["cheese", ["cheese", "sauce", "dough"]])


func _on_button_pressed() -> void:
	var screen_width := get_viewport().get_visible_rect().size.x
	print("back button was pressed")

	if ovenswitch == true: # acts like a toggle button for the oven
		camera.position.x = 1 * screen_width
		ovenswitch = false
		position.x -= 500
		OvenCookingButton.text = "Cooking"
		
	else :
		camera.position.x = 0 # sets camera's x position back to 0
		ovenswitch = true
		position.x+= 500
		OvenCookingButton.text = "Ovens"

func _on_nextday_pressed() -> void:
	Global.day += 1 # increments day by one, when the "done" button is pressed
	get_tree().change_scene_to_file("res://Scenes/GroceryStore.tscn") # changes scene back to shopping scene

func _on_recipe_pressed() -> void:
	recipe_book_visible = !recipe_book_visible
	recipe_book_layer.visible = recipe_book_visible

func _on_next_pressed() -> void: # go to next page
	if current_recipe < len(recipes): #stay in bounds
		current_recipe += 1
		var recipe_index = current_recipe - 1
		var recipe_text = get_recipe_string(recipes[recipe_index])
		recipe.text = recipe_text

func _on_previous_pressed() -> void: #go to previous page
	if current_recipe > 1: # don't let go to non-existent recipes
		current_recipe -= 1
		var recipe_index = current_recipe - 1
		var recipe_text = get_recipe_string(recipes[recipe_index])
		recipe.text = recipe_text

func get_recipe_string(recipe) -> String:
	var recipe_string = "[center][b]%s[/b][/center]\n"
	recipe_string = recipe_string % recipe[0]
	recipe_string += "[ul]\n"
	for ingredient in recipe[1]:
		recipe_string += "%s\n" % ingredient
	recipe_string += "[/ul]"
	return recipe_string
