extends Control

@onready var BackButton : Button = $Back
@onready var NextButton : Button = $Next
@onready var FinishedButton : Button = $Finished
@onready var ShoppingButton : Button = $ShoppingList
@onready var camera : Camera2D = $"../Camera2D"
@onready var money : Label = $CanvasLayer/Money
@onready var shopping_list = $"../ShoppingListScene".get_node("ShoppingList")


var aisle_index: int = 0  # keeps track of which aisle we're on

func _ready() -> void:
	print("Day:", Global.day) # indicates the day you're on
	print("--------------------------") # a line break
	update_label()
	shopping_list.hide()

func _physics_process(delta: float) -> void:
	update_label()

func update_label() -> void:
	money.text = "Money: $" + str(Global.money)

func _on_back_pressed() -> void:
	var screen_width: float = get_viewport().get_visible_rect().size.x
	print("back button was pressed")

	if aisle_index > 0:
		aisle_index -= 1
		camera.position.x = aisle_index * screen_width

func _on_next_pressed() -> void:
	var screen_width: float = get_viewport().get_visible_rect().size.x
	print("next button was pressed")

	aisle_index += 1  # increase aisle
	camera.position.x = aisle_index * screen_width

func _on_finished_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/cooking.tscn")

func _on_shopping_list_pressed() -> void:
	print("shopping list button was pressed")
	shopping_list.visible = !shopping_list.visible
	$"../ShoppingListScene".update_shopping_list()


func _on_food_pressed(item: int, price: float) -> void:
	if Global.money >= price: # checks to see if the player has enough money
		Global.ingredients[item] += 1  # increments the proper item by 1
		Global.money -= price
		print(Global.food[item], ": ", Global.ingredients[item]) # indicates the food you bought
		print("Money: ", Global.money)
		print("------------------------")
	else: # what happens if the player doesn't have enough money
		print("Not enough money!")
