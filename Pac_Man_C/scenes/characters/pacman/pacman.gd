extends KinematicBody2D
class_name Pacman

signal player_reset

const ACCEL = 500
const MAX_SPEED = 50
const FRICTION = 500

var velocity = Vector2.ZERO
onready var state_machine = $AnimationTree.get("parameters/playback")

func _ready():
	pass # Replace with function body.
	
	
func _physics_process(delta):
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCEL * delta)
		state_machine.travel("walk_right")
		
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		state_machine.travel("walk_right")

	if velocity.x < 0:
		$Sprite.scale.x = -1
	elif velocity.x > 0:
		$Sprite.scale.x = 1
		
	if velocity.y < 0:
		state_machine.travel("walk_up")
	elif velocity.y > 0 :
		state_machine.travel("walk_down")
		
	velocity = move_and_slide(velocity)
	
	

func reset():
	position = Vector2(108,221)
	state_machine.travel("idle")
	emit_signal("player_reset")
	
func die():
	state_machine.travel("die")
	
	set_physics_process(false)

func _on_Area2D_area_entered(area):
	

	if(area.is_in_group("portal")):
		if(!area.lock_portal):
			for portal in get_tree().get_nodes_in_group("portal"):
				if(portal!=area):
					if(portal.id == area.id):
						if(!portal.lock_portal):
							area.do_lock()
							global_position =  portal.global_position 
							$vent.play()
							
