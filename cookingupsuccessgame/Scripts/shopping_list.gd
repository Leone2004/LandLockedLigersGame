extends Node2D

var ingredients = Global.food
@onready var item_picker = $"ShoppingList/List Editor/ItemPicker"
@onready var item_counter = $"ShoppingList/List Editor/ItemCount"
@onready var shopping_list = $ShoppingList/ShoppingListText

func _ready() -> void:
	for item in ingredients: # set up item picker with ingredients
		item_picker.add_item(item)
	update_shopping_list()

func _on_update_button_pressed() -> void:
	var item = item_picker.get_item_text(item_picker.get_item_index(item_picker.get_selected_id()))
	var item_amount = item_counter.get_line_edit().text.to_int()
	update_shopping_list_item(item, item_amount)

func update_shopping_list_item(item: String, new_count: int) -> void:
	for list_item in Global.shopping_list:
		if list_item[0] == item:
			Global.shopping_list.erase(list_item)
	if new_count != 0:
		Global.shopping_list.append([item, new_count])
	update_shopping_list()

func update_shopping_list() -> void:
	var shopping_list_string = ""
	for item in Global.shopping_list:
		shopping_list_string += "[left]%s[/left]" %item[0]
		shopping_list_string += "[right]%s[/right]\n" %item[1]
	shopping_list.text = shopping_list_string
