extends Node2D
var ovenswitch : bool = true
var recipe_book_visible : bool
var recipes = Array() # recipes[i][0] is name. recipes[i][1] is ingredients subarray
var current_recipe : int
@onready var recipe = get_node("CanvasLayer/RecipeBook/Current Recipe")
@onready var recipe_book_layer = get_node("CanvasLayer/RecipeBook")
@onready var camera : Camera2D = $Camera2D

func _ready() -> void:
	current_recipe = 0
	recipe_book_visible = false
	recipe_book_layer.visible = recipe_book_visible
	recipe.text = "[center][b]THE RECIPE BOOK[/b][/center]"
	recipes.append(["pepperoni", ["pepperoni", "cheese", "sauce", "dough"]])

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
	#var recipe_number_text = "[center]Recipe Number %s[/center]"
	#recipe_number_text = recipe_number_text % current_recipe
	var recipe_text = get_recipe_string(recipes[0])
	recipe.text = recipe_text


func _on_previous_pressed() -> void: #go to previous page
	var recipe_number_text = "[center]Recipe Number %s[/center]"
	if current_recipe > 1: # don't let go to non-existent recipes
		current_recipe -= 1
		recipe_number_text = recipe_number_text % current_recipe
		recipe.text = recipe_number_text

func get_recipe_string(recipe) -> String:
	var recipe_string = "[center][b]%s[/b][/center]\n"
	recipe_string = recipe_string % recipe[0]
	recipe_string += "[ul]\n"
	for ingredient in recipe[1]:
		recipe_string += "%s\n" % ingredient
	recipe_string += "[/ul]"
	return recipe_string
