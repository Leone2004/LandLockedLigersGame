extends Area2D

func _process(delta: float) -> void:
	check_for_selling()
	pass

func check_for_selling() -> void:
	var overlapping_areas: Array[Area2D] = get_overlapping_areas()
	for area in overlapping_areas:
		if area.has_method("sell_pizza"):
			area.sell_pizza()
			# Looks for pizza
			return
