extends Area2D

# Pizza properties
var pizza_value: float = 0.0
var is_baking: bool = false
var bake_time: float = 0.0
var max_bake_time: float = 10.0  # 10 seconds to fully bake
var is_dragging: bool = false
var drag_offset: Vector2

var items = [0,0,0,0,0]

# Ingredient values (you can adjust these)
var ingredient_values = {
	"dough": 2.0,
	"tomato_sauce": 1.5,
	"cheese": 3.0,
	"pepperoni": 4.0,
	"mushrooms": 2.5,
	"peppers": 2.0,
	"olives": 3.5,
	"bacon": 5.0,
	"ham": 4.5,
	"pineapple": 2.0
}

# Current ingredients on the pizza
var current_ingredients: Array = []

# Nodes
@onready var sprite: Sprite2D = $Sprite2D
@onready var bake_timer: Timer = $Baker_timer
@onready var progress_bar: ProgressBar = $ProgressBar

func _ready():
	# Connect signals
	input_event.connect(_on_input_event)
	bake_timer.timeout.connect(_on_bake_complete)
	
	# Initialize progress bar
	if progress_bar:
		progress_bar.max_value = max_bake_time
		progress_bar.visible = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and not is_dragging:
				# Start dragging
				var mouse_pos = get_global_mouse_position()
				var local_mouse_pos = to_local(mouse_pos)
				# Check if mouse is within the collision shape bounds
				if has_overlapping_areas() or _is_mouse_over_pizza(local_mouse_pos):
					is_dragging = true
					drag_offset = global_position - mouse_pos
			elif not event.pressed and is_dragging:
				# Stop dragging
				is_dragging = false
				_check_for_oven()

func _is_mouse_over_pizza(local_mouse_pos: Vector2) -> bool:
	"""Check if mouse is over the pizza area"""
	# Simple bounds check - you can adjust these values based on your sprite size
	var bounds = Vector2(128, 128)  # Adjust to match your pizza sprite size
	return abs(local_mouse_pos.x) <= bounds.x/2 and abs(local_mouse_pos.y) <= bounds.y/2

func _process(delta):
	if is_dragging:
		global_position = get_global_mouse_position() + drag_offset
	
	# Update baking progress
	if is_baking:
		bake_time += delta
		if progress_bar:
			progress_bar.value = bake_time
			progress_bar.visible = true

func add_ingredient(ingredient_name: String):
	"""Add an ingredient to the pizza and update its value"""
	if ingredient_name in ingredient_values:
		current_ingredients.append(ingredient_name)
		_update_pizza_value()
		print("Added ", ingredient_name, " to pizza. New value: $", pizza_value)

func _update_pizza_value():
	"""Calculate pizza value based on current ingredients"""
	pizza_value = 0.0
	for ingredient in current_ingredients:
		if ingredient in ingredient_values:
			pizza_value += ingredient_values[ingredient]
	
	# Base value for just having a pizza
	if current_ingredients.size() > 0:
		pizza_value += 1.0

func start_baking():
	"""Start the baking process"""
	if not is_baking:
		is_baking = true
		bake_time = 0.0
		bake_timer.start(max_bake_time)
		print("Pizza started baking!")

func stop_baking():
	"""Stop the baking process"""
	is_baking = false
	bake_timer.stop()
	if progress_bar:
		progress_bar.visible = false
	print("Pizza stopped baking!")

func _on_bake_complete():
	"""Called when baking is complete"""
	is_baking = false
	if progress_bar:
		progress_bar.visible = false
	
	# Increase value for fully baked pizza
	pizza_value *= 1.5
	print("Pizza is fully baked! Final value: $", pizza_value)

func _check_for_oven():
	"""Check if pizza is placed in an oven"""
	var overlapping_areas = get_overlapping_areas()
	for area in overlapping_areas:
		if area.is_in_group("oven"):
			start_baking()
			return
	
	# If not in oven, stop baking
	if is_baking:
		stop_baking()

func get_pizza_info() -> Dictionary:
	"""Get information about the current pizza"""
	return {
		"value": pizza_value,
		"ingredients": current_ingredients,
		"is_baking": is_baking,
		"bake_progress": bake_time / max_bake_time if max_bake_time > 0 else 0.0
	}

func _on_input_event(viewport, event, shape_idx):
	"""Handle input events for dragging"""
	pass  # Handled in _input for better control
