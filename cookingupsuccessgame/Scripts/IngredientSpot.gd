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
		return
	if not collision_shape:
		return
	
	# Set ingredient type based on the exported index
	_set_ingredient_type_from_index()
	
	original_position = global_position
	original_scale = scale
	update_visual_state()

func _set_ingredient_type_from_index() -> void:
	"""Set ingredient type based on the exported ingredient_index"""
	if ingredient_index >= 0 and ingredient_index < Global.food.size():
		ingredient_type = Global.food[ingredient_index]
	else:
		ingredient_type = ""
		return
	
	# Set the appropriate texture based on ingredient type
	_set_texture_for_ingredient()

func _set_texture_for_ingredient() -> void:
	"""Set the texture based on the ingredient type"""
	if not sprite:
		return

	match ingredient_type:
		"pepperoni":
			sprite.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/cooking_up_success_pepperoni.png")
		"mushrooms":
			sprite.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/cooking_up_success_mushrooms.png")
		"olives":
			sprite.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/cooking_up_success_olives.png")
		"peppers":
			sprite.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/cooking_up_success_jalapeno.png")
		"bacon":
			sprite.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/cooking_up_success_bacon.png")
		"ham":
			sprite.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/cooking_up_success_ham.png")
		"garlic":
			sprite.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/cooking_up_success_garlic.png")
		"pineapple":
			sprite.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/cooking_up_success_pineapple.png")
		"tomato":
			sprite.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/Single tomato.png")
			sprite.scale = Vector2(0.5, 0.5) # Scale down tomato spot
		"onion":
			sprite.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/cooking_up_success_onion.png")
		"sausage":
			sprite.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/cooking_up_success_sausage.png")
		# EXCEPTIONS: cheese, sauce, anchovies use old logic
		"cheese":
			sprite.texture = preload("res://Art/cheese.png")
		"sauce":
			sprite.texture = preload("res://Art/sauce.png")
		"anchovies":
			sprite.texture = preload("res://Art/anchovies.jpeg")
		_:
			print("Warning: Unknown ingredient type: ", ingredient_type)

	# Set all ingredient spot icons to a consistent size
	var spot_scale = Vector2(0.25, 0.25) # Default scale
	if ingredient_type == "tomato":
		spot_scale = Vector2(0.10, 0.10) # Smaller for tomato
	sprite.scale = spot_scale

func update_visual_state() -> void:
	"""Update the visual state based on available ingredients"""
	if not sprite or not collision_shape:
		return
	
	# Check if we have ingredients
	var current_count = 0
	if ingredient_index >= 0 and ingredient_index < Global.ingredients.size():
		current_count = Global.ingredients[ingredient_index]
	
	has_ingredients = current_count > 0
	
	if has_ingredients:
		sprite.modulate = available_color
		collision_shape.disabled = false
	else:
		sprite.modulate = unavailable_color
		collision_shape.disabled = true

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
		if area.has_method("add_ingredient"):
			# Map ingredient names to match pizza's ingredient_values
			var pizza_ingredient_name = ingredient_type
			if ingredient_type == "sauce":
				pizza_ingredient_name = "tomato_sauce"
			# Add more mappings if needed for other ingredients
			
			# Add ingredient to pizza
			area.add_ingredient(pizza_ingredient_name)
			
			# Create visual ingredient on the pizza
			_create_visual_ingredient_on_pizza(area)
			
			# Consume one ingredient with bounds checking
			if ingredient_index >= 0 and ingredient_index < Global.ingredients.size():
				Global.ingredients[ingredient_index] -= 1
			
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

	# Set the texture based on ingredient type (use on_pizza PNGs for all except cheese, sauce, anchovies)
	match ingredient_type:
		"pepperoni":
			visual_ingredient.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/on_pizza_pepperoni.png")
		"mushrooms":
			visual_ingredient.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/on_pizza_mushroom.png")
		"olives":
			visual_ingredient.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/on_pizza_olives.png")
		"peppers":
			visual_ingredient.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/on_pizza_jalapeno.png")
		"bacon":
			visual_ingredient.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/on_pizza_bacon.png")
		"ham":
			visual_ingredient.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/on_pizza_ham.png")
		"garlic":
			visual_ingredient.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/on_pizza_garlic.png")
		"pineapple":
			visual_ingredient.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/on_pizza_pineapple.png")
		"tomato":
			visual_ingredient.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/Single tomato.png")
		"onion":
			visual_ingredient.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/on_pizza_onion.png")
		"sausage":
			visual_ingredient.texture = preload("res://Art/Final_Cooking_up_Success_Images_and_Audio_2/new_ingredients/on_pizza_sausage.png")
		# EXCEPTIONS: cheese, sauce, anchovies use old logic
		"cheese":
			visual_ingredient.texture = preload("res://Art/cheese.png")
		"sauce":
			visual_ingredient.texture = preload("res://Art/sauce.png")
		"anchovies":
			visual_ingredient.texture = preload("res://Art/anchovies.jpeg")
		_:
			print("Warning: Unknown ingredient type: ", ingredient_type)

	# Set all toppings to the same pixel size (e.g., 48x48), except tomato (e.g., 20x20)
	var target_size = Vector2(48, 48)
	if ingredient_type == "tomato":
		target_size = Vector2(20, 20)
	if visual_ingredient.texture:
		var tex_size = visual_ingredient.texture.get_size()
		visual_ingredient.scale = target_size / tex_size

	# Position the ingredient where it was dropped on the pizza
	var drop_position = global_position - pizza_area.global_position
	visual_ingredient.position = drop_position

	# Add the visual ingredient to the pizza
	pizza_area.add_child(visual_ingredient)

func refresh_state() -> void:
	"""Refresh the visual state - call this when ingredients change"""
	update_visual_state() 
