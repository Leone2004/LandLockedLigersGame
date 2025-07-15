extends Node

var day: int = 1
var money: float = 100.00
var customers = 3

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
		"shopping_list": shopping_list
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
	if MainMusic and not MainMusic.playing:
		MainMusic.play()

func set_music_volume(volume_db: float):
	if MainMusic:
		MainMusic.volume_db = volume_db
