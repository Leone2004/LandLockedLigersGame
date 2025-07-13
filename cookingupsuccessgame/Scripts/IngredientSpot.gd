extends Area2D

signal ingredient_dragged(ingredient_type: String)

# Export variable to set in inspector
# Ingredient Index Reference:
# 0 = pepperoni, 1 = cheese, 2 = mushrooms, 3 = sauce, 4 = olives, 5 = peppers
# 6 = bacon, 7 = ham, 8 = anchovies, 9 = garlic, 10 = pineapple, 11 = tomato
# 12 = onion, 13 = sausage
@export var ingredient_index: int = 0  # Index in Global.food array

var ingredient_type: String = ""
var has_ingredients: bool = false
var is_dragging: bool = false
var drag_offset: Vector2
var original_position: Vector2
var original_scale: Vector2

# Get sprite node safely
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# Colors for different states
var available_color: Color = Color.WHITE
var unavailable_color: Color = Color(0.5, 0.5, 0.5, 0.5)  # Gray with transparency

func _ready() -> void:
	# Wait one frame to ensure all nodes are properly initialized
	await get_tree().process_frame
	
	# Double-check nodes are available
	if not sprite:
		print("Error: Sprite2D node not found in IngredientSpot")
		return
	if not collision_shape:
		print("Error: CollisionShape2D node not found in IngredientSpot")
		return
	
	# Set ingredient type based on the exported index
	_set_ingredient_type_from_index()
	
	original_position = global_position
	original_scale = scale
	print("IngredientSpot ready - ", ingredient_type, " at position: ", global_position)
	update_visual_state()

func _set_ingredient_type_from_index() -> void:
	"""Set ingredient type based on the exported ingredient_index"""
	if ingredient_index >= 0 and ingredient_index < Global.food.size():
		ingredient_type = Global.food[ingredient_index]
		print("Set ingredient type to: ", ingredient_type, " (index: ", ingredient_index, ")")
	else:
		print("Error: Invalid ingredient_index: ", ingredient_index, " (max: ", Global.food.size() - 1, ")")
		ingredient_type = ""
		return
	
	# Set the appropriate texture based on ingredient type
	_set_texture_for_ingredient()

func _set_texture_for_ingredient() -> void:
	"""Set the texture based on the ingredient type"""
	if not sprite:
		print("Error: Cannot set texture - sprite is null")
		return
	
	match ingredient_type:
		"pepperoni":
			sprite.texture = preload("res://Art/pepperoni.png")
			sprite.scale = Vector2(1.5, 1.5)  # Scale up pepperoni
		"cheese":
			sprite.texture = preload("res://Art/cheese.png")
			sprite.scale = Vector2(1.5, 1.5)  # Scale up cheese
		"mushrooms":
			sprite.texture = preload("res://Art/mushroom.png")
			sprite.scale = Vector2(1.5, 1.5)  # Scale up mushrooms
		"sauce":
			sprite.texture = preload("res://Art/sauce.png")
			sprite.scale = Vector2(1.5, 1.5)  # Scale up sauce
		"olives":
			sprite.texture = preload("res://Art/olive.png")
		"peppers":
			sprite.texture = preload("res://Art/pepper.jpeg")
		"bacon":
			sprite.texture = preload("res://Art/Bacon.png")
		"ham":
			sprite.texture = preload("res://Art/ham.jpeg")
		"anchovies":
			sprite.texture = preload("res://Art/anchovies.jpeg")
		"garlic":
			sprite.texture = preload("res://Art/garlic.jpeg")
		"pineapple":
			sprite.texture = preload("res://Art/pinapple.jpeg")
		"tomato":
			sprite.texture = preload("res://Art/tomato.jpeg")
		"onion":
			sprite.texture = preload("res://Art/onion.jpeg")
		"sausage":
			sprite.texture = preload("res://Art/sausage.jpeg")
		_:
			print("Warning: Unknown ingredient type: ", ingredient_type)

func update_visual_state() -> void:
	"""Update the visual state based on available ingredients"""
	if not sprite or not collision_shape:
		return
	
	# Check if we have ingredients
	var current_count = 0
	if ingredient_index >= 0 and ingredient_index < Global.ingredients.size():
		current_count = Global.ingredients[ingredient_index]
	
	has_ingredients = current_count > 0
	
	print("Updating ", ingredient_type, " spot - index: ", ingredient_index, ", count: ", current_count, ", has_ingredients: ", has_ingredients)
	
	if has_ingredients:
		sprite.modulate = available_color
		collision_shape.disabled = false
		print(ingredient_type, " spot is colored and enabled (", current_count, " available)")
	else:
		sprite.modulate = unavailable_color
		collision_shape.disabled = true
		print(ingredient_type, " spot is gray and disabled (0 available)")

func _input(event: InputEvent) -> void:
	if not has_ingredients or not collision_shape:
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and not is_dragging:
				# Check if mouse is over this spot
				var mouse_pos = get_global_mouse_position()
				var local_mouse_pos = to_local(mouse_pos)
				if _is_mouse_over_spot(local_mouse_pos):
					is_dragging = true
					drag_offset = global_position - mouse_pos
					scale = original_scale * 1.1  # Slight scale effect
					print("Started dragging ", ingredient_type, "!")
			elif not event.pressed and is_dragging:
				# Stop dragging
				is_dragging = false
				scale = original_scale
				_check_for_pizza()

func _process(delta: float) -> void:
	update_visual_state()
	if is_dragging:
		global_position = get_global_mouse_position() + drag_offset

func _is_mouse_over_spot(local_mouse_pos: Vector2) -> bool:
	# Simple bounds check - adjust based on your spot sprite size
	var bounds = Vector2(30, 30)  # Adjusted for smaller sprite scale (0.3)
	return abs(local_mouse_pos.x) <= bounds.x/2 and abs(local_mouse_pos.y) <= bounds.y/2

func _check_for_pizza() -> void:
	# Check if we're over a pizza
	var overlapping_areas = get_overlapping_areas()
	for area in overlapping_areas:
		if area.name.begins_with("Area2D") and area.has_method("add_ingredient"):
			# Map ingredient names to match pizza's ingredient_values
			var pizza_ingredient_name = ingredient_type
			if ingredient_type == "sauce":
				pizza_ingredient_name = "tomato_sauce"
			# Add more mappings if needed for other ingredients
			
			# Add ingredient to pizza
			area.add_ingredient(pizza_ingredient_name)
			
			# Create visual ingredient on the pizza
			_create_visual_ingredient_on_pizza(area)
			
			# Consume one ingredient
			Global.ingredients[ingredient_index] -= 1
			print("Added ", ingredient_type, " to pizza! Remaining: ", Global.ingredients[ingredient_index])
			
			# Update visual state
			update_visual_state()
			
			# Return to original position
			global_position = original_position
			return
	
	# If not over pizza, return to original position
	global_position = original_position

func _create_visual_ingredient_on_pizza(pizza_area: Area2D) -> void:
	"""Create a visual ingredient that attaches to the pizza"""
	# Create a Sprite2D node for the visual ingredient
	var visual_ingredient = Sprite2D.new()
	visual_ingredient.name = ingredient_type + "_visual"
	visual_ingredient.scale = Vector2(0.2, 0.2)  # Small scale for pizza topping
	
	# Set the texture based on ingredient type
	match ingredient_type:
		"pepperoni":
			visual_ingredient.texture = preload("res://Art/pepperoni.png")
			visual_ingredient.scale = Vector2(1.0, 1.0)  # Scale up pepperoni on pizza
		"cheese":
			visual_ingredient.texture = preload("res://Art/cheese.png")
			visual_ingredient.scale = Vector2(1.0, 1.0)  # Scale up cheese on pizza
		"mushrooms":
			visual_ingredient.texture = preload("res://Art/mushroom.png")
			visual_ingredient.scale = Vector2(1.0, 1.0)  # Scale up mushrooms on pizza
		"sauce":
			visual_ingredient.texture = preload("res://Art/sauce.png")
			visual_ingredient.scale = Vector2(1.0, 1.0)  # Scale up sauce on pizza
		"olives":
			visual_ingredient.texture = preload("res://Art/olive.png")
		"peppers":
			visual_ingredient.texture = preload("res://Art/pepper.jpeg")
		"bacon":
			visual_ingredient.texture = preload("res://Art/Bacon.png")
		"ham":
			visual_ingredient.texture = preload("res://Art/ham.jpeg")
		"anchovies":
			visual_ingredient.texture = preload("res://Art/anchovies.jpeg")
		"garlic":
			visual_ingredient.texture = preload("res://Art/garlic.jpeg")
		"pineapple":
			visual_ingredient.texture = preload("res://Art/pinapple.jpeg")
		"tomato":
			visual_ingredient.texture = preload("res://Art/tomato.jpeg")
		"onion":
			visual_ingredient.texture = preload("res://Art/onion.jpeg")
		"sausage":
			visual_ingredient.texture = preload("res://Art/sausage.jpeg")
	
	# Position the ingredient where it was dropped on the pizza
	var drop_position = global_position - pizza_area.global_position
	visual_ingredient.position = drop_position
	
	# Add the visual ingredient to the pizza
	pizza_area.add_child(visual_ingredient)
	print("Created visual ", ingredient_type, " on pizza at position ", drop_position)

func refresh_state() -> void:
	"""Refresh the visual state - call this when ingredients change"""
	update_visual_state() 
