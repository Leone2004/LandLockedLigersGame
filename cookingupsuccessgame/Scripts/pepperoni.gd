extends Area2D

var is_dragging: bool = false
var drag_offset: Vector2
var is_attached_to_pizza: bool = false
var attached_pizza: Node = null
var original_position: Vector2
var original_scale: Vector2
var type = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = global_position
	original_scale = scale
	# Connect the area entered signal
	area_entered.connect(_on_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_dragging and not is_attached_to_pizza:
		global_position = get_global_mouse_position() + drag_offset
		# Add a slight scale effect while dragging
		scale = original_scale * 1.1
	else:
		scale = original_scale

func _input(event: InputEvent) -> void:
	# Don't handle input if attached to pizza
	if is_attached_to_pizza:
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and not is_dragging and not is_attached_to_pizza:
				# Check if mouse is over this pepperoni
				var mouse_pos: Vector2 = get_global_mouse_position()
				var local_mouse_pos: Vector2 = to_local(mouse_pos)
				if _is_mouse_over_pepperoni(local_mouse_pos):
					is_dragging = true
					drag_offset = global_position - mouse_pos
			elif not event.pressed and is_dragging:
				# Stop dragging
				is_dragging = false
				_check_for_pizza()

func _is_mouse_over_pepperoni(local_mouse_pos: Vector2) -> bool:
	"""Check if mouse is over the pepperoni area"""
	# Simple bounds check - adjust based on your pepperoni sprite size
	var bounds: Vector2 = Vector2(22, 21)  # Based on the collision shape size
	return abs(local_mouse_pos.x) <= bounds.x/2 and abs(local_mouse_pos.y) <= bounds.y/2

func _check_for_pizza() -> void:
	"""Check if pepperoni is dropped on a pizza"""
	var overlapping_areas: Array[Area2D] = get_overlapping_areas()
	for area in overlapping_areas:
		if area.has_method("add_ingredient"):
			# This is a pizza! Attach the pepperoni
			attach_to_pizza(area)
			return
	
	# If not dropped on pizza, return to original position
	if not is_attached_to_pizza:
		global_position = original_position

func _on_area_entered(area: Area2D) -> void:
	"""Called when another area enters this pepperoni's area"""
	if is_dragging and area.has_method("add_ingredient"):
		# We're hovering over a pizza while dragging
		pass

func attach_to_pizza(pizza: Node) -> void:
	"""Attach the pepperoni to the pizza"""
	is_attached_to_pizza = true
	attached_pizza = pizza
	
	# Add the pepperoni ingredient to the pizza
	pizza.add_ingredient("pepperoni")
	
	# Decrease global pepperoni count (index 0 for pepperoni)
	if Global.ingredients.size() > 0:
		Global.ingredients[0] -= 1
	
	# Make the pepperoni a child of the pizza
	reparent(pizza)
	
	# Disable collision detection to prevent interference
	var collision_shape: CollisionShape2D = $CollisionShape2D
	if collision_shape:
		collision_shape.disabled = true
	
	# Visual feedback - slightly darker color to show it's attached
	modulate = Color(0.8, 0.8, 0.8, 1.0)
