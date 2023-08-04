extends Node2D

@export var default_line2d: Line2D
@export var rainbow_line2d: Line2D

var all_lines: Array[Line2D] = []
var current_line: Line2D

var throttling = false	
func _unhandled_input(event):	
	if event.is_action_pressed("Undo"): undo()
	
	if event.is_action_pressed("Draw Simple Line"):
		current_line = default_line2d.duplicate()
		all_lines.append(current_line)
		add_child(current_line)
		
	if event.is_action_pressed("Draw Rainbow Line"):
		current_line = rainbow_line2d.duplicate()
		all_lines.append(current_line)
		add_child(current_line)

	if event.is_action_released("Draw Simple Line") \
		or event.is_action_released("Draw Rainbow Line"):
		current_line = null
		
	if throttling: return
	if event is InputEventMouseMotion and current_line:
		current_line.add_point(event.position)
	throttle(0.02)

func throttle(seconds):
	throttling = true
	await get_tree().create_timer(seconds).timeout
	throttling = false

func undo():
	if all_lines.size():
		var to_delete = all_lines.pop_back()
		to_delete.queue_free()

