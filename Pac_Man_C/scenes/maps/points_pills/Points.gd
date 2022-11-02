extends Area2D
class_name Points

signal point_beated


func _on_Points_body_entered(body):
	if body is Pacman:
		
		emit_signal("point_beated")
		queue_free()
