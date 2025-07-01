extends Node2D

var ingredients = ["pepperoni", "sausage", "cheese", "olives", "pineapple chunks"] # demo ingredients
@onready var item_picker = $"ShoppingList/List Editor/ItemPicker"

func _ready() -> void:
	for item in ingredients: # set up item picker with ingredients
		item_picker.add_item(item)
