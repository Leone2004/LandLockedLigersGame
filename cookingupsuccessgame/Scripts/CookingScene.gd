extends Node2D

var ovenswitch: bool = true
var recipe_book_visible: bool = false
var recipes: Array[Array] = [] # recipes[i][0] is name. recipes[i][1] is ingredients subarray
var current_recipe: int = 0

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
var bacon_scene: PackedScene = preload("res://Scenes/bacon.tscn")
var olive_scene: PackedScene = preload("res://Scenes/olive.tscn")
var garlic_scene: PackedScene = preload("res://Scenes/garlic.tscn")
var ham_scene: PackedScene = preload("res://Scenes/ham.tscn")
var pepper_scene: PackedScene = preload("res://Scenes/pepper.tscn")
var pineapple_scene: PackedScene = preload("res://Scenes/pineapple.tscn")
var sausage_scene: PackedScene = preload("res://Scenes/sausage.tscn")
var anchovies_scene: PackedScene = preload("res://Scenes/anchovies.tscn")

# Spawn positions for each ingredient
var pepperoni_spawn_area: Vector2 = Vector2(-475.5, -557.5)
var cheese_spawn_area: Vector2 = Vector2(-475.5, -485.5)
var mushrooms_spawn_area: Vector2 = Vector2(-475.5, -413.5)
var sauce_spawn_area: Vector2 = Vector2(-475.5, -335.5)
var bacon_spawn_area: Vector2 = Vector2(-475.5, -265.5)
var olive_spawn_area: Vector2 = Vector2(-475.5, -195.5)
var garlic_spawn_area: Vector2 = Vector2(-475.5, -125.5)
var ham_spawn_area: Vector2 = Vector2(-475.5, -55.5)
var pepper_spawn_area: Vector2 = Vector2(-475.5, 14.5)
var pineapple_spawn_area: Vector2 = Vector2(-475.5, 84.5)
var sausage_spawn_area: Vector2 = Vector2(-475.5, 154.5)
var anchovies_spawn_area: Vector2 = Vector2(-475.5, 224.5)
var tomato_spawn_area: Vector2 = Vector2(-475.5, 294.5)
var onion_spawn_area: Vector2 = Vector2(-475.5, 364.5)
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
	spawn_bacon()
	spawn_olive()
	spawn_garlic()
	spawn_ham()
	spawn_pepper()
	spawn_pineapple()
	spawn_sausage()
	spawn_anchovies()
	spawn_tomato()
	spawn_onion()

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

func spawn_bacon() -> void:
	var bacon_count: int = Global.ingredients[6]
	for child in get_children():
		if child.name.begins_with("bacon") and child.name != "bacon":
			child.queue_free()
	if bacon_count <= 0:
		return
	for i in range(bacon_count):
		var new_bacon: Area2D = bacon_scene.instantiate()
		new_bacon.name = "bacon_" + str(i)
		var row: int = i / 5
		var col: int = i % 5
		var spawn_pos: Vector2 = bacon_spawn_area + Vector2(col * ingredient_spacing.x, row * ingredient_spacing.y)
		new_bacon.position = spawn_pos
		new_bacon.scale = Vector2(2.03125, 2.03125)
		add_child(new_bacon)

func spawn_olive() -> void:
	var olive_count: int = Global.ingredients[4]
	for child in get_children():
		if child.name.begins_with("olive") and child.name != "olive":
			child.queue_free()
	if olive_count <= 0:
		return
	for i in range(olive_count):
		var new_olive: Area2D = olive_scene.instantiate()
		new_olive.name = "olive_" + str(i)
		var row: int = i / 5
		var col: int = i % 5
		var spawn_pos: Vector2 = olive_spawn_area + Vector2(col * ingredient_spacing.x, row * ingredient_spacing.y)
		new_olive.position = spawn_pos
		new_olive.scale = Vector2(2.03125, 2.03125)
		add_child(new_olive)

func spawn_pepper() -> void:
	var pepper_count: int = Global.ingredients[5]
	for child in get_children():
		if child.name.begins_with("pepper") and child.name != "pepper":
			child.queue_free()
	if pepper_count <= 0:
		return
	for i in range(pepper_count):
		var new_pepper: Area2D = pepper_scene.instantiate()
		new_pepper.name = "pepper_" + str(i)
		var row: int = i / 5
		var col: int = i % 5
		var spawn_pos: Vector2 = pepper_spawn_area + Vector2(col * ingredient_spacing.x, row * ingredient_spacing.y)
		new_pepper.position = spawn_pos
		new_pepper.scale = Vector2(2.03125, 2.03125)
		add_child(new_pepper)

func spawn_pineapple() -> void:
	var pineapple_count: int = Global.ingredients[10]
	for child in get_children():
		if child.name.begins_with("pineapple") and child.name != "pineapple":
			child.queue_free()
	if pineapple_count <= 0:
		return
	for i in range(pineapple_count):
		var new_pineapple: Area2D = pineapple_scene.instantiate()
		new_pineapple.name = "pineapple_" + str(i)
		var row: int = i / 5
		var col: int = i % 5
		var spawn_pos: Vector2 = pineapple_spawn_area + Vector2(col * ingredient_spacing.x, row * ingredient_spacing.y)
		new_pineapple.position = spawn_pos
		new_pineapple.scale = Vector2(2.03125, 2.03125)
		add_child(new_pineapple)

func spawn_ham() -> void:
	var ham_count: int = Global.ingredients[7]
	for child in get_children():
		if child.name.begins_with("ham") and child.name != "ham":
			child.queue_free()
	if ham_count <= 0:
		return
	for i in range(ham_count):
		var new_ham: Area2D = ham_scene.instantiate()
		new_ham.name = "ham_" + str(i)
		var row: int = i / 5
		var col: int = i % 5
		var spawn_pos: Vector2 = ham_spawn_area + Vector2(col * ingredient_spacing.x, row * ingredient_spacing.y)
		new_ham.position = spawn_pos
		new_ham.scale = Vector2(2.03125, 2.03125)
		add_child(new_ham)

func spawn_anchovies() -> void:
	var anchovies_count: int = Global.ingredients[8]
	for child in get_children():
		if child.name.begins_with("anchovies") and child.name != "anchovies":
			child.queue_free()
	if anchovies_count <= 0:
		return
	for i in range(anchovies_count):
		var new_anchovies: Area2D = anchovies_scene.instantiate()
		new_anchovies.name = "anchovies_" + str(i)
		var row: int = i / 5
		var col: int = i % 5
		var spawn_pos: Vector2 = anchovies_spawn_area + Vector2(col * ingredient_spacing.x, row * ingredient_spacing.y)
		new_anchovies.position = spawn_pos
		new_anchovies.scale = Vector2(2.03125, 2.03125)
		add_child(new_anchovies)

func spawn_garlic() -> void:
	var garlic_count: int = Global.ingredients[9]
	for child in get_children():
		if child.name.begins_with("garlic") and child.name != "garlic":
			child.queue_free()
	if garlic_count <= 0:
		return
	for i in range(garlic_count):
		var new_garlic: Area2D = garlic_scene.instantiate()
		new_garlic.name = "garlic_" + str(i)
		var row: int = i / 5
		var col: int = i % 5
		var spawn_pos: Vector2 = garlic_spawn_area + Vector2(col * ingredient_spacing.x, row * ingredient_spacing.y)
		new_garlic.position = spawn_pos
		new_garlic.scale = Vector2(2.03125, 2.03125)
		add_child(new_garlic)

func spawn_tomato() -> void:
	var tomato_count: int = Global.ingredients[10]
	for child in get_children():
		if child.name.begins_with("tomato") and child.name != "tomato":
			child.queue_free()
	if tomato_count <= 0:
		return
	for i in range(tomato_count):
		var new_tomato: Area2D = preload("res://Scenes/tomato.tscn").instantiate()
		new_tomato.name = "tomato_" + str(i)
		var row: int = i / 5
		var col: int = i % 5
		var spawn_pos: Vector2 = tomato_spawn_area + Vector2(col * ingredient_spacing.x, row * ingredient_spacing.y)
		new_tomato.position = spawn_pos
		new_tomato.scale = Vector2(2.03125, 2.03125)
		add_child(new_tomato)

func spawn_onion() -> void:
	var onion_count: int = Global.ingredients[11]
	for child in get_children():
		if child.name.begins_with("onion") and child.name != "onion":
			child.queue_free()
	if onion_count <= 0:
		return
	for i in range(onion_count):
		var new_onion: Area2D = preload("res://Scenes/onion.tscn").instantiate()
		new_onion.name = "onion_" + str(i)
		var row: int = i / 5
		var col: int = i % 5
		var spawn_pos: Vector2 = onion_spawn_area + Vector2(col * ingredient_spacing.x, row * ingredient_spacing.y)
		new_onion.position = spawn_pos
		new_onion.scale = Vector2(2.03125, 2.03125)
		add_child(new_onion)

func spawn_sausage() -> void:
	var sausage_count: int = Global.ingredients[12]
	for child in get_children():
		if child.name.begins_with("sausage") and child.name != "sausage":
			child.queue_free()
	if sausage_count <= 0:
		return
	for i in range(sausage_count):
		var new_sausage: Area2D = sausage_scene.instantiate()
		new_sausage.name = "sausage_" + str(i)
		var row: int = i / 5
		var col: int = i % 5
		var spawn_pos: Vector2 = sausage_spawn_area + Vector2(col * ingredient_spacing.x, row * ingredient_spacing.y)
		new_sausage.position = spawn_pos
		new_sausage.scale = Vector2(2.03125, 2.03125)
		add_child(new_sausage)


func refresh_all_ingredients() -> void:
	spawn_pepperoni()
	spawn_cheese()
	spawn_mushrooms()
	spawn_sauce()
	spawn_olive()
	spawn_pepper()
	spawn_bacon()
	spawn_ham()
	spawn_anchovies()
	spawn_garlic()
	spawn_pineapple()
	spawn_tomato()
	spawn_onion()
	spawn_sausage()

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
