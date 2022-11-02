extends Node2D


var score = 0 

const tile_size = 8

export(Resource) var pellet_prefab
export var vulnerable_time := 7.0

var points_left = 261
var starting_pints = points_left
var current_ghost := 0
var ghost_names = ["Green", "Red", "Orange"]
var lives := 5
var vulnerable_ghosts := 0
var eaten_ghosts := 0
var ghost_bonus = 200
var mortal = true

onready var nav_2D = $Map1/Navigation2D
onready var ghosts = [$Ghosts/Green_ghost,$Ghosts/Red_Ghost,$Ghosts/Orange_Ghost]
onready var player = $Pacman

var scattering := false

	
func _physics_process(delta):
	if current_ghost >= ghosts.size():
		current_ghost = 0
		
	var ghost: Ghost = ghosts[current_ghost]
	# ghost.start()
	match ghost.state:
		Ghost.CHASE:
			var new_path
			match ghost.color:
				"Green":
					new_path = nav_2D.get_simple_path(ghost.position, player.position)
					
				"Red":
					var player_heading = player.position + (player.velocity.normalized() * 2 * tile_size)
					var blinky_vector = ($Ghosts/Red_Ghost.position - player_heading)
					var target_position = player_heading - blinky_vector
					new_path = nav_2D.get_simple_path(ghost.position, target_position)
				"Orange":
					var distance = ghost.position.distance_to(player.position)
					if distance > 8 * tile_size:
						new_path = nav_2D.get_simple_path(ghost.position, player.position)
					else:
						var target_position = player.position + (player.velocity.normalized() * -10 * tile_size)
						new_path = nav_2D.get_simple_path(ghost.position, target_position)
			# Apply the path.
			ghost.path = new_path
		Ghost.CORNER:
			if ghost.path.size() < 3:
				var new_pos
				match ghost.color:
					"Green":
						new_pos = Vector2(rand_range(264, 372), rand_range(24, 120))
					"Red":
						new_pos = Vector2(rand_range(264, 372), rand_range(156, 270))
					"Orange":
						new_pos = Vector2(rand_range(156, 264), rand_range(156, 270))
				
				# Apply the path.
				var new_path = nav_2D.get_simple_path(ghost.position, new_pos)
				ghost.path = new_path
		Ghost.SCARED:
			var new_pos = Vector2(rand_range(156, 372), rand_range(24, 270))
			var new_path = nav_2D.get_simple_path(ghost.position, new_pos)
			ghost.path = new_path
		Ghost.DIED:
			pass
			
		Ghost.INIT:
			pass
	current_ghost += 1
			



func _on_Map1_point_beated():
	$CanvasLayer.add_score(10)
	points_left -= 1
	if points_left == starting_pints -1:
		ghosts[0].start()
	if points_left == starting_pints -30:
		ghosts[1].start()
	if points_left == starting_pints -90:
		ghosts[2].start()
	if points_left == 0:
		won_game()

func won_game():
	get_tree().change_scene("res://scenes/end_screen_won.tscn")
	

func _on_Map1_power_pill():
	ghost_bonus = 200
	$CanvasLayer.add_score(50)
	for ghost in ghosts:
		ghost.scared()
	scattering = true
	$Timer.start(vulnerable_time)
	points_left -=1
	if points_left == 0 :
		won_game()
	


func _on_Ghost_ate_player(ghost):
	
	player.die()
	for ghost in ghosts:
		ghost.set_physics_process(false)
	set_physics_process(false)
	get_tree().change_scene("res://scenes/end_screen_defeated.tscn")

func _on_Timer_timeout():
	
	scattering != scattering
	if vulnerable_ghosts != 0 :
		vulnerable_ghosts = 0
	if scattering:
		$Timer.start(7)
		for ghost in ghosts:
			
			ghost.corner()
	else:
		$Timer.start(20)
		for ghost in ghosts:
			
			ghost.chase()		
		



func _on_Ghost_became_vulnerable():
	vulnerable_ghosts +=1
	


func _on_Player_ate_ghost(ghost):
	$nani.play()
	$CanvasLayer.add_score(ghost_bonus)
	var new_path = nav_2D.get_simple_path(ghost.position, Vector2(113, 146))
	ghost.path = new_path
	vulnerable_ghosts -= 1
	eaten_ghosts += 1


func _on_Ghost_restored():
	eaten_ghosts -= 1
