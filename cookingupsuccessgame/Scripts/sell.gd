extends Area2D

var area_ref
var pizza_ref
var anim_ref
var cur_customer: int = 0
var playing: bool = false
var customer_id: int = -1  # Unique ID for this customer
var is_satisfied: bool = false  # Whether this customer has been satisfied
var animation_state: String = "idle"  # idle, appearing, happy, fading
var animation_timer: float = 0.0
var animation_duration: float = 1.0  # Duration for each animation phase

@onready var happy_face = preload("res://Art/Final Cooking up Success Image folder 2/Equipment/Pizza cutter.png")
@onready var face = $Pizza/Icon  # Changed from PlainPizza to Icon
@onready var normal_face = face.texture if face != null else null

func _ready() -> void:
	# Assign customer ID based on position (you can adjust this logic)
	assign_customer_id()
	
	area_ref = $"."
	pizza_ref = $Pizza
	if pizza_ref:
		pizza_ref.modulate.a = 0
	anim_ref = $AnimationPlayer
	area_ref.hide()
	
	# Debug print to verify customer ID assignment
	print("Customer initialized with ID: ", customer_id, " at position: ", global_position)
	print("Global satisfied customers at start: ", Global.satisfied_customers)

func assign_customer_id() -> void:
	# Assign ID based on node name - more reliable than position
	if name == "Area2D":
		customer_id = 0  # Right customer
	elif name == "Area2D2":
		customer_id = 1  # Middle customer
	elif name == "Area2D3":
		customer_id = 2  # Left customer
	else:
		# Fallback to position-based assignment
		if global_position.x > 200:
			customer_id = 0  # Right customer
		elif global_position.x > 50:
			customer_id = 1  # Middle customer
		else:
			customer_id = 2  # Left customer
	
	print("Assigned customer ID: ", customer_id, " for node: ", name, " at position: ", global_position)

func _process(delta: float) -> void:
	# Handle animation states
	handle_animation_state(delta)
	
	# Check if this customer should appear (not satisfied yet and not currently active)
	if cur_customer == 0 && !playing && !is_satisfied && animation_state == "idle":
		start_customer_appearance()
	elif cur_customer == 2 && !playing && animation_state == "idle":
		# Start happy animation when pizza is sold
		start_happy_animation()
	elif cur_customer == 1 && !is_satisfied:
		check_for_selling()
	
	# Check if all customers are satisfied for scene transition
	if all_customers_satisfied():
		# Find the CookingScene and call its transition function
		var cooking_scene = get_tree().get_first_node_in_group("cooking_scene")
		if cooking_scene and cooking_scene.has_method("transition_to_next_day"):
			cooking_scene.transition_to_next_day()
		else:
			# Fallback: call the local next_day function
			next_day()

func handle_animation_state(delta: float) -> void:
	"""Handle the current animation state"""
	if animation_state == "idle":
		return
		
	animation_timer += delta
	
	match animation_state:
		"appearing":
			if animation_timer >= animation_duration:
				# Switch to neutral animation
				animation_state = "neutral"
				animation_timer = 0.0
				if anim_ref:
					anim_ref.play("neutral")
				print("Customer ", customer_id, " switched to neutral animation")
		"neutral":
			if animation_timer >= animation_duration:
				# Animation complete, customer is ready
				animation_state = "idle"
				animation_timer = 0.0
				cur_customer = 1
				playing = false
				print("Customer ", customer_id, " is now ready for pizza")
		"happy":
			if animation_timer >= animation_duration:
				# Switch to fading out
				animation_state = "fading"
				animation_timer = 0.0
				if anim_ref:
					anim_ref.play("transparent_on")
				print("Customer ", customer_id, " switching to fade out")
		"fading":
			if animation_timer >= animation_duration:
				# Animation complete, customer is satisfied
				animation_state = "idle"
				animation_timer = 0.0
				cur_customer = 0
				playing = false
				# Mark this customer as satisfied and hide them permanently
				if customer_id >= 0 and customer_id < Global.satisfied_customers.size():
					Global.satisfied_customers[customer_id] = true
					is_satisfied = true
					print("Customer ", customer_id, " is now satisfied! Global state: ", Global.satisfied_customers)
					print("Customer satisfaction check - All satisfied: ", all_customers_satisfied())
				else:
					print("ERROR: Invalid customer_id ", customer_id, " for Global.satisfied_customers array of size ", Global.satisfied_customers.size())
				if area_ref:
					area_ref.hide()  # Keep them hidden after satisfaction

func start_customer_appearance() -> void:
	"""Start the customer appearance animation sequence"""
	if playing or is_satisfied or animation_state != "idle":
		return
		
	playing = true
	animation_state = "appearing"
	animation_timer = 0.0
	
	if area_ref:
		area_ref.show()
	
	if anim_ref:
		anim_ref.play("transparent_off")

func start_happy_animation() -> void:
	"""Start the happy animation sequence"""
	if playing or animation_state != "idle":
		return
		
	playing = true
	animation_state = "happy"
	animation_timer = 0.0
	
	if anim_ref:
		anim_ref.play("happy")

func check_for_selling() -> void:
	var overlapping_areas: Array[Area2D] = get_overlapping_areas()
	for area in overlapping_areas:
		var food_ref = area.is_dragging
		# Only sell pizzas that are baked and not being dragged
		if area.has_method("sell_pizza") && !food_ref:
			# Try to sell the pizza and only change customer state if successful
			if area.sell_pizza():
				cur_customer = 2
				print("Pizza sold to customer ", customer_id, "! Customer state: ", cur_customer)
				return

func next_day():
	print("All customers satisfied! Transitioning to next day...")
	Global.day += 1 # increments day by one
	get_tree().change_scene_to_file("res://Scenes/GroceryStore.tscn") # changes scene back to shopping scene
	Global.customers = 3
	# Reset customer satisfaction for next day
	Global.satisfied_customers = [false, false, false]

func all_customers_satisfied() -> bool:
	for i in range(Global.satisfied_customers.size()):
		if not Global.satisfied_customers[i]:
			return false
	return true
