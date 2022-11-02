extends KinematicBody2D
class_name Ghost

signal player_ate_ghost
signal ghost_ate_player
signal ghost_became_vulnerable
signal ghost_restored

export var speed = 25
export var state_speed = 1
export var color = "Green"
var state = INIT
var init_pos
enum {
	INIT,
	CHASE,
	CORNER,
	SCARED,
	DIED
}

func _ready():
	init_pos = position
	state_machine.travel("idle")

var path = PoolVector2Array()
onready var state_machine = $AnimationTree.get("parameters/playback")


func _physics_process(delta):
	if path.size() == 0:
		
		if state == DIED:
			
			state =CHASE
			emit_signal("ghost_restored")
			
	var distance_to_move = speed * delta
	var speed_config = 1
	
	while distance_to_move > 0 and path.size() > 0:
		var distance_to_next = position.distance_to(path[0])
		if distance_to_move <= distance_to_next :
			match state:
				DIED:
					
					speed_config = 2
				SCARED:
					speed_config = 0.7
			position += position.direction_to(path[0]) * distance_to_move *speed_config
			reproduce_animation(path[0])
			# reproduce_animation(distance_to_move)
		else:
			position = path[0]
			path.remove(0)
		distance_to_move -= distance_to_next
		
func start():
	state = CHASE


func chase():
	if state == CORNER or state == SCARED:
		state = CHASE

func corner():
	if state != INIT and state != DIED:
		state = CORNER

func scared():
	if state != INIT and state != DIED:
		state = SCARED
		emit_signal("ghost_became_vulnerable")
		

	
	
func reproduce_animation(path_go):
	match state:
		INIT,CHASE,CORNER:
			state_machine.travel("walk")
			if position.x < path_go.x:
				$Sprite.scale.x = 1
			elif position.x > path_go.x :
				$Sprite.scale.x = -1
		DIED:
			state_machine.travel("die")
		
		SCARED:
			state_machine.travel("idle")
			$Sprite.scale.x = 1
			$Sprite.scale.x = -1
		
func reset():
	position = init_pos
	state = INIT
	path = PoolVector2Array([])
	state_machine.travel("idle")

func warp_to(pos):
	global_position = pos
	path.resize(0)



func _on_Hurt_box_body_entered(body):
	if body is Pacman:
		if state == SCARED:
			emit_signal("player_ate_ghost", self)
			state = DIED
		elif state == CHASE or state == CORNER:
			emit_signal("ghost_ate_player", self)
