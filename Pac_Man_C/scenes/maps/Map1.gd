extends Node2D
signal power_pill
signal point_beated



func _ready():
	$ambient.play()


func _on_Points_point_beated():
	
	emit_signal("point_beated")
	
	
	
	
	





func _on_Power_pill_point_beated():
	$omae.play()
	emit_signal("power_pill")
