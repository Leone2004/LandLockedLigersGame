extends Area2D

var is_dragging: bool = false
var drag_offset: Vector2
var is_attached_to_pizza: bool = false
var attached_pizza: Node = null
var original_position: Vector2
var original_scale: Vector2

func _ready() -> void:
	original_position = global_position
	original_scale = scale
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	if is_dragging and not is_attached_to_pizza:
		global_position = get_global_mouse_position() + drag_offset
		scale = original_scale * 1.1
	else:
		scale = original_scale

func _input(event: InputEvent) -> void:
	if is_attached_to_pizza:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and not is_dragging and not is_attached_to_pizza:
				var mouse_pos: Vector2 = get_global_mouse_position()
				var local_mouse_pos: Vector2 = to_local(mouse_pos)
				if _is_mouse_over_olive(local_mouse_pos):
					is_dragging = true
					drag_offset = global_position - mouse_pos
			elif not event.pressed and is_dragging:
				is_dragging = false
				_check_for_pizza()

func _is_mouse_over_olive(local_mouse_pos: Vector2) -> bool:
	var bounds: Vector2 = Vector2(22, 21)
	return abs(local_mouse_pos.x) <= bounds.x/2 and abs(local_mouse_pos.y) <= bounds.y/2

func _check_for_pizza() -> void:
	var overlapping_areas: Array[Area2D] = get_overlapping_areas()
	for area in overlapping_areas:
		if area.has_method("add_ingredient"):
			attach_to_pizza(area)
			return
	if not is_attached_to_pizza:
		global_position = original_position

func _on_area_entered(area: Area2D) -> void:
	if is_dragging and area.has_method("add_ingredient"):
		pass

func attach_to_pizza(pizza: Node) -> void:
	is_attached_to_pizza = true
	attached_pizza = pizza
	pizza.add_ingredient("olive")
	Global.ingredients[5] -= 1
	reparent(pizza)
	var collision_shape: CollisionShape2D = $CollisionShape2D
	if collision_shape:
		collision_shape.disabled = true
	modulate = Color(0.8, 0.8, 0.8, 1.0) 