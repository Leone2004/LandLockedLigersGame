extends Node2D

const conveyer_speed = 100 # pixels per second

var ovenswitch: bool = true
var recipe_book_visible: bool = false
var recipes: Array[Array] = [] # recipes[i][0] is name. recipes[i][1] is ingredients subarray
var current_recipe: int = 0
var nodes_on_conveyer: Array[Node2D] = []

@onready var recipe: RichTextLabel = $"CanvasLayer/RecipeBook/Current Recipe"
@onready var recipe_book_layer: CanvasLayer = $CanvasLayer/RecipeBook
@onready var camera: Camera2D = $Camera2D
@onready var OvenCookingButton: Button = $CanvasLayer/Oven_Cooking_Button
@onready var shopping_list = $ShoppingListScene.get_node("ShoppingList")


# Ingredient spawning
var pepperoni_scene: PackedScene = preload("res://Scenes/pepperoni.tscn")
var cheese_scene: PackedScene = preload("res://Scenes/cheese.tscn")
var mushrooms_scene: PackedScene = preload("res://Scenes/mushrooms.tscn")
var sauce_scene: PackedScene = preload("res://Scenes/sauce.tscn")

# Spawn positions for each ingredient
var pepperoni_spawn_area: Vector2 = Vector2(-475.5, -557.5)
var cheese_spawn_area: Vector2 = Vector2(-475.5, -485.5)
var mushrooms_spawn_area: Vector2 = Vector2(-475.5, -413.5)
var sauce_spawn_area: Vector2 = Vector2(-475.5, -335.5)
var ingredient_spacing: Vector2 = Vector2(50, 0)  # Space between ingredients

func _ready() -> void:
	current_recipe = 0
	recipe_book_visible = false
	shopping_list.hide()
	recipe_book_layer.visible = recipe_book_visible
	recipe.text = "[center][b]THE RECIPE BOOK[/b][/center]"
	recipes.append(["pepperoni", ["pepperoni", "cheese", "sauce", "dough"]])
	recipes.append(["cheese", ["cheese", "sauce", "dough"]])
	
	# Spawn all ingredients based on global counts
	spawn_pepperoni()
	spawn_cheese()
	spawn_mushrooms()
	spawn_sauce()

func _process(delta: float) -> void:
	update_conveyer(delta)

func spawn_pepperoni() -> void:
	"""Spawn pepperoni instances based on global pepperoni count"""
	var pepperoni_count: int = Global.ingredients[0]  # Index 0 is pepperoni
	
	print("Spawning ", pepperoni_count, " pepperoni based on global count")
	
	# Remove existing pepperoni instances
	for child in get_children():
		if child.name.begins_with("pepperoni") and child.name != "pepperoni":
			child.queue_free()
	
	# Don't spawn if count is 0 or negative
	if pepperoni_count <= 0:
		print("No pepperoni to spawn")
		return
	
	# Spawn new pepperoni instances
	for i in range(pepperoni_count):
		var new_pepperoni: Area2D = pepperoni_scene.instantiate()
		new_pepperoni.name = "pepperoni_" + str(i)
		
		# Calculate position - arrange in a grid
		var row: int = i / 5  # 5 pepperoni per row
		var col: int = i % 5
		var spawn_pos: Vector2 = pepperoni_spawn_area + Vector2(col * ingredient_spacing.x, row * ingredient_spacing.y)
		
		new_pepperoni.position = spawn_pos
		new_pepperoni.scale = Vector2(2.03125, 2.03125)
		
		add_child(new_pepperoni)
		print("Spawned pepperoni ", i + 1, " of ", pepperoni_count, " at position ", spawn_pos)

func spawn_cheese() -> void:
	"""Spawn cheese instances based on global cheese count"""
	var cheese_count: int = Global.ingredients[1]  # Index 1 is cheese
	
	print("Spawning ", cheese_count, " cheese based on global count")
	
	# Remove existing cheese instances
	for child in get_children():
		if child.name.begins_with("cheese") and child.name != "cheese":
			child.queue_free()
	
	# Don't spawn if count is 0 or negative
	if cheese_count <= 0:
		print("No cheese to spawn")
		return
	
	# Spawn new cheese instances
	for i in range(cheese_count):
		var new_cheese: Area2D = cheese_scene.instantiate()
		new_cheese.name = "cheese_" + str(i)
		
		# Calculate position - arrange in a grid
		var row: int = i / 5  # 5 cheese per row
		var col: int = i % 5
		var spawn_pos: Vector2 = cheese_spawn_area + Vector2(col * ingredient_spacing.x, row * ingredient_spacing.y)
		
		new_cheese.position = spawn_pos
		new_cheese.scale = Vector2(2.03125, 2.03125)
		
		add_child(new_cheese)
		print("Spawned cheese ", i + 1, " of ", cheese_count, " at position ", spawn_pos)

func spawn_mushrooms() -> void:
	"""Spawn mushrooms instances based on global mushrooms count"""
	var mushrooms_count: int = Global.ingredients[2]  # Index 2 is mushrooms
	
	print("Spawning ", mushrooms_count, " mushrooms based on global count")
	
	# Remove existing mushrooms instances
	for child in get_children():
		if child.name.begins_with("mushrooms") and child.name != "mushrooms":
			child.queue_free()
	
	# Don't spawn if count is 0 or negative
	if mushrooms_count <= 0:
		print("No mushrooms to spawn")
		return
	
	# Spawn new mushrooms instances
	for i in range(mushrooms_count):
		var new_mushrooms: Area2D = mushrooms_scene.instantiate()
		new_mushrooms.name = "mushrooms_" + str(i)
		
		# Calculate position - arrange in a grid
		var row: int = i / 5  # 5 mushrooms per row
		var col: int = i % 5
		var spawn_pos: Vector2 = mushrooms_spawn_area + Vector2(col * ingredient_spacing.x, row * ingredient_spacing.y)
		
		new_mushrooms.position = spawn_pos
		new_mushrooms.scale = Vector2(2.03125, 2.03125)
		
		add_child(new_mushrooms)
		print("Spawned mushrooms ", i + 1, " of ", mushrooms_count, " at position ", spawn_pos)

func spawn_sauce() -> void:
	"""Spawn sauce instances based on global sauce count"""
	var sauce_count: int = Global.ingredients[3]  # Index 3 is sauce
	
	print("Spawning ", sauce_count, " sauce based on global count")
	
	# Remove existing sauce instances
	for child in get_children():
		if child.name.begins_with("sauce") and child.name != "sauce":
			child.queue_free()
	
	# Don't spawn if count is 0 or negative
	if sauce_count <= 0:
		print("No sauce to spawn")
		return
	
	# Spawn new sauce instances
	for i in range(sauce_count):
		var new_sauce: Area2D = sauce_scene.instantiate()
		new_sauce.name = "sauce_" + str(i)
		
		# Calculate position - arrange in a grid
		var row: int = i / 5  # 5 sauce per row
		var col: int = i % 5
		var spawn_pos: Vector2 = sauce_spawn_area + Vector2(col * ingredient_spacing.x, row * ingredient_spacing.y)
		
		new_sauce.position = spawn_pos
		new_sauce.scale = Vector2(2.03125, 2.03125)
		
		add_child(new_sauce)
		print("Spawned sauce ", i + 1, " of ", sauce_count, " at position ", spawn_pos)

func refresh_all_ingredients() -> void:
	"""Refresh all ingredient counts - useful if player buys more at store"""
	spawn_pepperoni()
	spawn_cheese()
	spawn_mushrooms()
	spawn_sauce()

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
		node.position += Vector2(1,0) * conveyer_speed * time_delta
