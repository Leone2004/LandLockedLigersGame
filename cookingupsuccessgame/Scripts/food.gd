extends Sprite2D

var pizza_food = [0,0,0,0,0]
signal place_item(id: int, value:int) #current signal idea to send to pizza object

func _on_button_pressed(item: int): # add item to pizza script
	if (pizza_food[item] == 0): # if item isn't on pizza
		if (Global.ingredients[item] > 0): #if you have enough of the item
			Global.ingredients[item] -= 1
			pizza_food[item] = 1
			print("placed: ", Global.food[item])
			print(Global.food[item], ": ", Global.ingredients[item])
			print("------------------------")
		else: # if you don't have any
			print("Not enough ", Global.food[item])
			print("------------------------")
	else: # remove item from pizza script
		Global.ingredients[item] += 1
		pizza_food[item] = 0
		print("removed: ", Global.food[item])
		print(Global.food[item], ": ", Global.ingredients[item])
		print("------------------------")
