extends Area2D

var area_ref
var pizza_ref
var anim_ref
var cur_customer: int = 0
var playing: bool = false
@onready var happy_face = preload("res://Art/Final Cooking up Success Image folder 2/Equipment/Pizza cutter.png")
@onready var face = $Pizza/Icon
@onready var normal_face = face.texture

func _ready() -> void:
	area_ref = $"."
	pizza_ref = $Pizza
	pizza_ref.modulate.a = 0
	anim_ref = $AnimationPlayer
	area_ref.hide()

func _process(delta: float) -> void:
	if cur_customer != 1 && cur_customer < 2 && !playing && Global.customers > -1:
		Global.customers -= 1
		area_ref.show()
		playing = true
		anim_ref.play("transparent_off")
		await anim_ref.animation_finished
		cur_customer = 1
		playing = false
	elif cur_customer == 2 && !playing:
		face.texture = happy_face
		playing = true
		anim_ref.play("transparent_on")
		await anim_ref.animation_finished
		face.texture = normal_face
		cur_customer = 0
		playing= false
	if cur_customer == 1 && Global.customers > -1:
		check_for_selling()
	elif Global.customers < 0:
		next_day()
	pass

func check_for_selling() -> void:
	var overlapping_areas: Array[Area2D] = get_overlapping_areas()
	for area in overlapping_areas:
		var food_ref = area.is_dragging
		# Only sell pizzas that are not in the spawned_pizzas group (to avoid newly spawned pizzas)
		if area.has_method("sell_pizza") && !food_ref && !area.is_in_group("spawned_pizzas"):
			area.sell_pizza()
			cur_customer = 2
			# Looks for pizza
			return

func next_day():
	if Global.customers > 0:
		return  # Don't switch scene if there are still customers
	Global.day += 1 # increments day by one, when the "done" button is pressed
	get_tree().change_scene_to_file("res://Scenes/GroceryStore.tscn") # changes scene back to shopping scene
	Global.customers = 3
