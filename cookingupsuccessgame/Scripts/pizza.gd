extends Area2D

# Pizza properties
var pizza_value: float = 0.0
var is_baking: bool = false
var bake_time: float = 0.0
var max_bake_time: float = 10.0  # 10 seconds to fully bake
var is_dragging: bool = false
var drag_offset: Vector2
var baked: bool = false
var timer = 0.0
var current_click = 0.0
var last_click_time = 0.0
var click_threshold = 0.2
var mouse_on_me: bool = false

# Ingredient values (you can adjust these)
var ingredient_values: Dictionary = {
	"dough": 2.0,
	"tomato_sauce": 1.5,
	"cheese": 3.0,
	"pepperoni": 4.0,
	"mushrooms": 2.5,
	"olives": 3.5,
	"peppers": 2.0,
	"bacon": 5.0,
	"ham": 4.5,
	"anchovies": 3.0,
	"garlic": 2.5,
	"pineapple": 2.0,
	"tomato": 2.0,
	"onion": 2.5,
	"sausage": 4.0
}

var used_ingredients = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]

# Current ingredients on the pizza
var current_ingredients: Array[String] = []

# Nodes
@onready var sprite: Sprite2D = $Pizza/Icon
@onready var bake_timer: Timer = $Baker_timer
@onready var clock_timer: Node2D = $ClockTimer

func _ready() -> void:
	# Connect signals using modern syntax
	input_event.connect(_on_input_event)
	bake_timer.timeout.connect(_on_bake_complete)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and not is_dragging:
				current_click = timer
				if current_click - last_click_time < click_threshold && mouse_on_me && !is_baking && !baked :
					var x = 0
					for i in Global.ingredients:
						Global.ingredients[x] += used_ingredients[x]
						used_ingredients[x] = 0
						print(Global.food[x], ": ", Global.ingredients[x])
						x += 1
					var y = 0
					for child in get_children():
						if y > 4:
							child.queue_free()
						y += 1
					current_ingredients = []
					queue_free()
				else:
					last_click_time = current_click
				# Start dragging - only if clicking directly on the pizza
				var mouse_pos: Vector2 = get_global_mouse_position()
				var local_mouse_pos: Vector2 = to_local(mouse_pos)
				# Check if mouse is directly over the pizza sprite, not its children
				if _is_mouse_over_pizza(local_mouse_pos) and _is_clicking_on_pizza_sprite(mouse_pos):
					is_dragging = true
					drag_offset = global_position - mouse_pos
			elif not event.pressed and is_dragging:
				# Stop dragging
				is_dragging = false
				_check_for_oven()

func _is_mouse_over_pizza(local_mouse_pos: Vector2) -> bool:
	"""Check if mouse is over the pizza area"""
	# Simple bounds check - you can adjust these values based on your sprite size
	var bounds: Vector2 = Vector2(128, 128)  # Adjust to match your pizza sprite size
	mouse_on_me = abs(local_mouse_pos.x) <= bounds.x/2 and abs(local_mouse_pos.y) <= bounds.y/2
	return abs(local_mouse_pos.x) <= bounds.x/2 and abs(local_mouse_pos.y) <= bounds.y/2

func _is_clicking_on_pizza_sprite(mouse_pos: Vector2) -> bool:
	"""Check if the mouse click is directly on the pizza sprite, not on attached ingredients"""
	# Get the pizza sprite node
	var pizza_sprite: Sprite2D = $Pizza/Icon
	if not pizza_sprite:
		# Fallback to collision shape check if sprite doesn't exist
		var local_mouse_pos: Vector2 = to_local(mouse_pos)
		return _is_mouse_over_pizza(local_mouse_pos)
	
	# Convert mouse position to local coordinates of the pizza sprite
	var sprite_local_pos: Vector2 = pizza_sprite.to_local(mouse_pos)
	
	# Check if the click is within the sprite's bounds
	var sprite_size: Vector2 = pizza_sprite.texture.get_size() if pizza_sprite.texture else Vector2(128, 128)
	var bounds: Vector2 = sprite_size * pizza_sprite.scale
	
	return abs(sprite_local_pos.x) <= bounds.x/2 and abs(sprite_local_pos.y) <= bounds.y/2

func _process(delta: float) -> void:
	timer = Time.get_ticks_msec() / 1000.0
	if is_dragging:
		var new_position = get_global_mouse_position() + drag_offset
		
		# Get camera and world boundaries
		var camera = get_viewport().get_camera_2d()
		if camera:
			var viewport_size = get_viewport().get_visible_rect().size
			var camera_pos = camera.global_position
			var pizza_size = Vector2(128, 128)  # Approximate pizza size
			
			# Calculate world boundaries based on camera position
			var world_left = camera_pos.x - viewport_size.x/2
			var world_right = camera_pos.x + viewport_size.x/2
			var world_top = camera_pos.y - viewport_size.y/2
			var world_bottom = camera_pos.y + viewport_size.y/2
			
			# Constrain pizza position to world boundaries
			new_position.x = clamp(new_position.x, world_left + pizza_size.x/2, world_right - pizza_size.x/2)
			new_position.y = clamp(new_position.y, world_top + pizza_size.y/2, world_bottom - pizza_size.y/2)
		else:
			# Fallback if no camera found
			var viewport_size = get_viewport().get_visible_rect().size
			var pizza_size = Vector2(128, 128)
			
			# Use viewport boundaries as fallback
			new_position.x = clamp(new_position.x, pizza_size.x/2, viewport_size.x - pizza_size.x/2)
			new_position.y = clamp(new_position.y, pizza_size.y/2, viewport_size.y - pizza_size.y/2)
		
		global_position = new_position
	
	# Update baking progress
	if is_baking:
		bake_time += delta
		if clock_timer:
			clock_timer.visible = true
			clock_timer.set("progress", bake_time / max_bake_time)
	else:
		if clock_timer:
			clock_timer.visible = false

func add_ingredient(ingredient_name: String) -> void:
	"""Add an ingredient to the pizza and update its value"""
	if ingredient_name in ingredient_values:
		current_ingredients.append(ingredient_name)
		used_ingredients[Global.food.find(ingredient_name)] += 1
		print(used_ingredients)
		_update_pizza_value()
		print("Added ", ingredient_name, " to pizza. New value: $", pizza_value)
		
		# Visual feedback - you can add effects here
		_show_ingredient_added_effect(ingredient_name)

func _show_ingredient_added_effect(ingredient_name: String) -> void:
	"""Show visual feedback when ingredient is added"""
	# You can add particle effects, sound, or other visual feedback here
	print("Visual effect: ", ingredient_name, " added to pizza!")

func _update_pizza_value() -> void:
	"""Calculate pizza value based on current ingredients"""
	pizza_value = 0.0
	for ingredient in current_ingredients:
		if ingredient in ingredient_values:
			pizza_value += ingredient_values[ingredient]
	
	# Base value for just having a pizza
	if current_ingredients.size() > 0:
		pizza_value += 1.0

func start_baking() -> void:
	"""Start the baking process"""
	if is_baking or baked:
		print("Pizza is already baking or baked, ignoring start request")
		return
		
	is_baking = true
	bake_time = 0.0
	bake_timer.start(max_bake_time)
	# self.hide()  # Do not hide the pizza so the timer label is visible
	if clock_timer:
		clock_timer.visible = true
	print("Pizza started baking! Timer started for ", max_bake_time, " seconds")

func stop_baking() -> void:
	"""Stop the baking process"""
	if not is_baking:
		print("Pizza is not baking, ignoring stop request")
		return
		
	is_baking = false
	bake_timer.stop()
	if clock_timer:
		clock_timer.visible = false
	print("Pizza stopped baking!")
	self.show()

func _on_bake_complete() -> void:
	"""Called when baking is complete"""
	if baked:
		print("Pizza already baked, ignoring completion")
		return
		
	baked = true
	is_baking = false
	# Increase value for fully baked pizza
	pizza_value *= 1.5
	print("Pizza is fully baked! Final value: $", pizza_value)
	self.show()

func reset_pizza() -> void:
	"""Reset the pizza to its initial state"""
	is_baking = false
	baked = false
	bake_time = 0.0
	current_ingredients.clear()
	pizza_value = 0.0
	
	if bake_timer:
		bake_timer.stop()
	if clock_timer:
		clock_timer.visible = false
	self.show()
	print("Pizza reset to initial state")

func _check_for_oven() -> void:
	"""Check if pizza is placed in an oven"""
	var overlapping_areas: Array[Area2D] = get_overlapping_areas()
	var oven_found: bool = false
	
	print("Checking for oven - overlapping areas: ", overlapping_areas.size())
	
	for area in overlapping_areas:
		print("Checking area: ", area.name, " groups: ", area.get_groups())
		if area.is_in_group("oven"):
			oven_found = true
			print("Oven found: ", area.name)
			break
	
	if oven_found and not is_baking and not baked:
		print("Starting baking process...")
		start_baking()
	elif not oven_found and is_baking:
		print("Stopping baking process - no oven detected")
		stop_baking()

func get_pizza_info() -> Dictionary:
	"""Get information about the current pizza"""
	return {
		"value": pizza_value,
		"ingredients": current_ingredients,
		"is_baking": is_baking,
		"bake_progress": bake_time / max_bake_time if max_bake_time > 0 else 0.0
	}

func _on_input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	"""Handle input events for dragging"""
	pass  # Handled in _input for better control
	
func sell_pizza():
	if !is_dragging && baked:
		Global.money += pizza_value
		queue_free()
