extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed_start() -> void:
	$"../AudioStreamPlayer2D".play()
	await  $"../AudioStreamPlayer2D".finished
	$".."._next_level()
	pass # Replace with function body.


func _on_pressed_quit() -> void:
	$"../AudioStreamPlayer2D".play()
	await  $"../AudioStreamPlayer2D".finished
	pass # Replace with function body.


func _on_pressed_resume() -> void:
	$"../AudioStreamPlayer2D".play()
	await  $"../AudioStreamPlayer2D".finished
	pass # Replace with function body.
