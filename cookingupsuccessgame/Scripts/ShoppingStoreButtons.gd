extends Control

@onready var BackButton : Button = $Back
@onready var NextButton : Button = $Next
@onready var FinishedButton : Button = $Finished
@onready var ShoppingButton : Button = $ShoppingList
@onready var camera : Camera2D = $"../Camera2D"
@onready var money : Label = $CanvasLayer/Money

var aisle_index := 0  # keeps track of which aisle we're on

func _ready():
	update_label()

func _physics_process(delta: float) -> void:
	update_label()

func update_label():
	money.text = "Money: $" + str(Global.money)


func _on_back_pressed() -> void:
	var screen_width := get_viewport().get_visible_rect().size.x
	print("back button was pressed")

	if aisle_index > 0:
		aisle_index -= 1
		camera.position.x = aisle_index * screen_width

func _on_next_pressed() -> void:
	var screen_width := get_viewport().get_visible_rect().size.x
	print("next button was pressed")

	aisle_index += 1  # increase aisle
	camera.position.x = aisle_index * screen_width

func _on_finished_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/cooking.tscn")


func _on_shopping_list_pressed() -> void:
	print("shopping list button was pressed")



func _on_pepperoni_pressed() -> void:
	Global.pepperoni += 1 
	Global.money -= 25
	print(Global.pepperoni)
	print(Global.money)
