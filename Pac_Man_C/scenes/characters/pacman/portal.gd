extends Area2D

export(int) var id = 0 
var lock_portal = false

func do_lock():
	lock_portal = true
	yield(get_tree().create_timer(0.1), "timeout")
	lock_portal = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
