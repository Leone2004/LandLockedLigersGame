extends Area2D

var area_ref
var pizza_ref
var anim_ref
var cur_customer: int = 0
var playing: bool = false
var customer_id: int = -1  # Unique ID for this customer
var is_satisfied: bool = false  # Whether this customer has been satisfied
@onready var happy_face = preload("res://Art/Final Cooking up Success Image folder 2/Equipment/Pizza cutter.png")
@onready var face = $Pizza/PlainPizza
@onready var normal_face = face.texture if face != null else null

func _ready() -> void:
	if face == null:
		print("ERROR: $Pizza/PlainPizza not found in sell.gd!")
	
	# Assign customer ID based on position (you can adjust this logic)
	assign_customer_id()
	
	area_ref = $"."
	pizza_ref = $Pizza
	pizza_ref.modulate.a = 0
	anim_ref = $AnimationPlayer
	area_ref.hide()

func assign_customer_id() -> void:
	# Assign ID based on position - you can adjust these values
	if global_position.x > 200:
		customer_id = 0  # Right customer
	elif global_position.x > 50:
		customer_id = 1  # Middle customer
	else:
		customer_id = 2  # Left customer

func _process(delta: float) -> void:
	# Check if this customer should appear (not satisfied yet and not currently active)
	if cur_customer == 0 && !playing && !is_satisfied:
		area_ref.show()
		playing = true
		# Start with fade in
		anim_ref.play("transparent_off")
		await anim_ref.animation_finished
		# Then play neutral animation
		anim_ref.play("neutral")
		await anim_ref.animation_finished
		cur_customer = 1
		playing = false
	elif cur_customer == 2 && !playing:
		# Play happy animation when pizza is sold
		playing = true
		anim_ref.play("happy")
		await anim_ref.animation_finished
		# Then fade out and stay hidden
		anim_ref.play("transparent_on")
		await anim_ref.animation_finished
		cur_customer = 0
		playing = false
		# Mark this customer as satisfied and hide them permanently
		if customer_id >= 0 and customer_id < Global.satisfied_customers.size():
			Global.satisfied_customers[customer_id] = true
			is_satisfied = true
		area_ref.hide()  # Keep them hidden after satisfaction
	if cur_customer == 1 && !is_satisfied:
		check_for_selling()
	
	# Check if all customers are satisfied for scene transition
	if all_customers_satisfied():
		next_day()
	pass

func check_for_selling() -> void:
	var overlapping_areas: Array[Area2D] = get_overlapping_areas()
	for area in overlapping_areas:
		var food_ref = area.is_dragging
		# Only sell pizzas that are baked and not being dragged
		if area.has_method("sell_pizza") && !food_ref:
			# Try to sell the pizza and only change customer state if successful
			if area.sell_pizza():
				cur_customer = 2
				# Looks for pizza
				return

func next_day():
	# Check if all customers are satisfied
	var all_satisfied = true
	for satisfied in Global.satisfied_customers:
		if not satisfied:
			all_satisfied = false
			break
	
	if not all_satisfied:
		return  # Don't switch scene if not all customers are satisfied
	
	Global.day += 1 # increments day by one, when the "done" button is pressed
	get_tree().change_scene_to_file("res://Scenes/GroceryStore.tscn") # changes scene back to shopping scene
	Global.customers = 3
	# Reset customer satisfaction for next day
	Global.satisfied_customers = [false, false, false]

func all_customers_satisfied() -> bool:
	for satisfied in Global.satisfied_customers:
		if not satisfied:
			return false
	return true
