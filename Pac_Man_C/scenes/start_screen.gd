extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$amogus.play() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_start_btn_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")


func _on_quit_btn_pressed():
	get_tree().quit() # Replace with function body.
