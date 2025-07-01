extends Node2D

var ingredients = ["pepperoni", "sausage", "cheese", "olives", "pineapple chunks"] # demo ingredients
@onready var item_picker = $"ShoppingList/List Editor/ItemPicker"
@onready var item_counter = $"ShoppingList/List Editor/ItemCount"
@onready var shopping_list = $ShoppingList/ShoppingListText

func _ready() -> void:
	for item in ingredients: # set up item picker with ingredients
		item_picker.add_item(item)

func _on_update_button_pressed() -> void:
	var item = item_picker.get_item_text(item_picker.get_item_index(item_picker.get_selected_id()))
	var item_amount = item_counter.get_line_edit().text.to_int()
	shopping_list.text = item + "......" + str(item_amount)
