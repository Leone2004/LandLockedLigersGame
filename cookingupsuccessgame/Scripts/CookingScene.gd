extends Node2D

const conveyer_speed = 100 # pixels per second

var ovenswitch: bool = true
var recipe_book_visible: bool = false
var recipes: Array = [] # recipes[i][0] is name. recipes[i][1] is ingredients subarray
var current_recipe: int = 1
var nodes_on_conveyer: Array[Node2D] = []
var conveyer_direction: int = 1

@onready var recipe: RichTextLabel = $"CanvasLayer/RecipeBook/Current Recipe"
@onready var recipe_book_layer: CanvasLayer = $CanvasLayer/RecipeBook
@onready var camera: Camera2D = $Camera2D
@onready var OvenCookingButton: Button = $CanvasLayer/Oven_Cooking_Button
@onready var shopping_list = $ShoppingListScene.get_node("ShoppingList")

# Ingredient spots
var ingredient_spot_scene: PackedScene
var ingredient_spots: Dictionary = {}

# Grid layout for ingredient spots
var spot_grid_start: Vector2 = Vector2(-300, -200)  # Positioned in top-left area, clearly visible
var spot_spacing: Vector2 = Vector2(60, 60)  # Slightly smaller spacing for better fit
var spots_per_row: int = 4  # Number of spots per row

func _ready() -> void:
	recipes = Global.recipes
	current_recipe = 1
	recipe_book_visible = false
	shopping_list.hide()
	recipe_book_layer.visible = recipe_book_visible
	recipe.text = get_recipe_string(recipes[current_recipe - 1])
	
	for i in range(Global.ingredients.size()):
		print("  ", Global.food[i], ": ", Global.ingredients[i])
	
	# Refresh all ingredient spots based on actual inventory
	refresh_all_ingredient_spots()


func _enter_tree() -> void:
	# Refresh ingredient spots when entering the scene (e.g., returning from store)
	refresh_all_ingredient_spots()

func _process(delta: float) -> void:
	update_conveyer(delta)

func refresh_all_ingredient_spots() -> void:
	"""Refresh all ingredient spots in the scene"""
	print("Refreshing all ingredient spots...")
	
	# Find all IngredientSpot nodes in the scene
	var ingredient_spots = get_tree().get_nodes_in_group("ingredient_spots")
	if ingredient_spots.size() == 0:
		# Fallback: search for nodes with IngredientSpot script
		for child in get_children():
			if child.has_method("refresh_state"):
				child.refresh_state()
				print("Refreshed ingredient spot: ", child.name)
	else:
		for spot in ingredient_spots:
			if spot.has_method("refresh_state"):
				spot.refresh_state()
				print("Refreshed ingredient spot: ", spot.name)
	
	print("Ingredient spot refresh completed")

func get_ingredient_index(type: String) -> int:
	# Use Global.food array to get the correct index
	var index = Global.food.find(type)
	if index >= 0:
		return index
	else:
		print("Warning: Ingredient type '", type, "' not found in Global.food array")
		return -1

func _on_button_pressed() -> void:
	var screen_width: float = get_viewport().get_visible_rect().size.x
	print("back button was pressed")

	if ovenswitch: # acts like a toggle button for the oven
		camera.position.x = 1 * screen_width
		ovenswitch = false
		position.x -= 500
		OvenCookingButton.text = "Cooking"
		
	else:
		camera.position.x = 0 # sets camera's x position back to 0
		ovenswitch = true
		position.x += 500
		OvenCookingButton.text = "Ovens"

func _on_nextday_pressed() -> void:
	Global.day += 1 # increments day by one, when the "done" button is pressed
	get_tree().change_scene_to_file("res://Scenes/GroceryStore.tscn") # changes scene back to shopping scene
	Global.customers = 3

func _on_recipe_pressed() -> void:
	set_physics_process(false)
	recipe_book_visible = !recipe_book_visible
	recipe_book_layer.visible = recipe_book_visible
	

func _on_next_pressed() -> void: # go to next page
	if current_recipe < len(recipes): #stay in bounds
		current_recipe += 1
		var recipe_index: int = current_recipe - 1
		var recipe_text: String = get_recipe_string(recipes[recipe_index])
		recipe.text = recipe_text

func _on_previous_pressed() -> void: #go to previous page
	if current_recipe > 1: # don't let go to non-existent recipes
		current_recipe -= 1
		var recipe_index: int = current_recipe - 1
		var recipe_text: String = get_recipe_string(recipes[recipe_index])
		recipe.text = recipe_text

func get_recipe_string(recipe: Array) -> String:
	var recipe_string: String = "[center][b]%s[/b][/center]\n"
	recipe_string = recipe_string % recipe[0]
	recipe_string += "[ul]\n"
	for ingredient in recipe[1]:
		recipe_string += "%s\n" % ingredient
	recipe_string += "[/ul]"
	return recipe_string


func _on_shopping_list_pressed() -> void:
	print("shopping list button was pressed")
	shopping_list.visible = !shopping_list.visible
	$ShoppingListScene.update_shopping_list() # keep up to date

func _on_conveyer_belt_area_entered(area: Area2D) -> void:
	nodes_on_conveyer.append(area)
	
func _on_conveyer_belt_area_exited(area: Area2D) -> void:
	nodes_on_conveyer.remove_at(nodes_on_conveyer.find(area))

func update_conveyer(time_delta: float) -> void: # called from _process(delta)
	for node in nodes_on_conveyer:
		node.position += Vector2(1,0) * conveyer_speed * time_delta * conveyer_direction

func _on_conveyer_direction_switch_pressed() -> void:
	conveyer_direction *= -1
