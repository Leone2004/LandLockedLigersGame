extends Control

@onready var BackButton : Button = $CanvasLayer/Back
@onready var NextButton : Button = $CanvasLayer/Next
@onready var FinishedButton : Button = $CanvasLayer/Finished
@onready var ShoppingButton : Button = $CanvasLayer/ShoppingList
@onready var camera : Camera2D = $"../Camera2D"
@onready var money : Label = $CanvasLayer/Money
@onready var shopping_list = $"../ShoppingListScene".get_node("ShoppingList")
@onready var BaconButton : Button = $"bacon"
@onready var OliveButton : Button = $"olives2"
@onready var GarlicButton : Button = $"garlic"
@onready var HamButton : Button = $"ham"
@onready var PepperButton : Button = $"peppers"
@onready var PineappleButton : Button = $"pineapple"
@onready var SausageButton : Button = $"sausage"

var aisle_index: int = 0  # keeps track of which aisle we're on

func _ready() -> void:
	print("Day:", Global.day) # indicates the day you're on
	print("--------------------------") # a line break
	update_label()
	shopping_list.hide()
	BaconButton.pressed.connect(func(): _on_food_pressed(6, 1.0))
	OliveButton.pressed.connect(func(): _on_food_pressed(4, 1.0))
	GarlicButton.pressed.connect(func(): _on_food_pressed(9, 1.0))
	HamButton.pressed.connect(func(): _on_food_pressed(7, 1.0))
	PepperButton.pressed.connect(func(): _on_food_pressed(5, 1.0))
	PineappleButton.pressed.connect(func(): _on_food_pressed(10, 1.0))
	SausageButton.pressed.connect(func(): _on_food_pressed(12, 1.0))

func _physics_process(delta: float) -> void:
	update_label()

func update_label() -> void:
	money.text = "Money: $" + str(Global.money)

func _on_back_pressed() -> void:
	var screen_width: float = get_viewport().get_visible_rect().size.x
	print("back button was pressed")
	aisle_index -= 1
	if aisle_index < 0:
		aisle_index = 2
	camera.position.x = aisle_index * screen_width

func _on_next_pressed() -> void:
	var screen_width: float = get_viewport().get_visible_rect().size.x
	print("next button was pressed")
	aisle_index += 1  # increase aisle
	aisle_index = aisle_index % 3
	camera.position.x = aisle_index * screen_width

func _on_finished_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/cooking.tscn")

func _on_shopping_list_pressed() -> void:
	print("shopping list button was pressed")
	shopping_list.visible = !shopping_list.visible
	$"../ShoppingListScene".update_shopping_list() # keep up to date

func _on_food_pressed(item: int, price: float) -> void:
	if Global.money >= price: # checks to see if the player has enough money
		Global.ingredients[item] += 1  # increments the proper item by 1
		Global.money -= price
		print(Global.food[item], ": ", Global.ingredients[item]) # indicates the food you bought
		print("Money: ", Global.money)
		print("------------------------")
		$"../ShoppingListScene".remove_one(Global.food[item])
	else: # what happens if the player doesn't have enough money
		print("Not enough money!")
