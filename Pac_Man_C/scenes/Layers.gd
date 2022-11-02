extends CanvasLayer
var score = 0

func add_score(value):
	score += value
	$Score_count.text = str(score)

func reset():
	score =0
	$Score_count.text = "0000"
