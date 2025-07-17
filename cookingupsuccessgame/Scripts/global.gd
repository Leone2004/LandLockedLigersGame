extends Node

var day: int = 1
var money: float = 100.00
var customers = 3
var satisfied_customers = [false, false, false]  # Track which customers are satisfied

# Suggested New Variable System
var ingredients = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
var food = ["pepperoni", "cheese", "mushrooms", "sauce", "olives", "peppers", "bacon", "ham", "anchovies", "garlic", "pineapple", "tomato", "onion", "sausage"]

# Shopping List Global
var shopping_list = Array() # shopping_list[i][0] is item, while shopping_list[i][1] is the ammount of the item

func save_game():
	var save_data = {
		"day": day,
		"money": money,
		"ingredients": ingredients,
		"shopping_list": shopping_list,
		"satisfied_customers": satisfied_customers
	}
	var file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()

func load_game():
	if FileAccess.file_exists("user://savegame.save"):
		var file = FileAccess.open("user://savegame.save", FileAccess.READ)
		var data = file.get_as_text()
		file.close()
		var save_data = JSON.parse_string(data)
		if typeof(save_data) == TYPE_DICTIONARY:
			day = save_data.get("day", 1)
			money = save_data.get("money", 100.0)
			ingredients = save_data.get("ingredients", [0,0,0,0,0,0,0,0,0,0,0,0,0,0])
			shopping_list = save_data.get("shopping_list", [])
			satisfied_customers = save_data.get("satisfied_customers", [false, false, false])
		else:
			print("Save file corrupted or invalid.")
	else:
		print("No save file found.")

func _ready():
	load_game()
	# Start the main music
	start_main_music()

# Music management functions
func start_main_music():
	# Check if MainMusic exists before trying to use it
	if has_node("/root/MainMusic") or get_node_or_null("/root/MainMusic"):
		var main_music = get_node_or_null("/root/MainMusic")
		if main_music and not main_music.playing:
			main_music.play()

func set_music_volume(volume_db: float):
	var main_music = get_node_or_null("/root/MainMusic")
	if main_music:
		main_music.volume_db = volume_db

# recipes to be used accross the game
var recipes = [
	["Pepperoni", ["pepperoni"]],
	["Cheesy Garlic", ["garlic"]],
	["Mushroom", ["mushrooms"]],
	["Garlic Pepperoni", ["garlic", "pepperoni"]],
	["Hawaiian", ["ham", "pineapple"]],
	["Three Meat", ["pepperoni", "sausage", "ham"]],
	["Meat Lovers", ["sausage", "bacon", "ham", "pepperoni"]],
	["Veggie", ["peppers", "onion", "mushrooms", "olives", "tomato", "anchovies"]],
	["I Want Everything", ["sausage", "onion", "anchovies", "garlic", "tomato", "mushrooms", "bacon", "ham", "olives", "peppers", "pepperoni", "pineapple"]],
]
