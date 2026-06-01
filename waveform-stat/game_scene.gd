extends Node2D

var current_case = {
	"image": "",
	"correct": "Atrial Fibrillation",
	"answers": ["Atrial Fibrillation", "Sinus Tachycardia", "Atrial Flutter", "Normal Sinus Rhythm"]
}

var time_left = 30.0
var time_expired = false

func _ready():
	$Timer.text = "30s"
	$Answer1.text = current_case.answers[0]
	$Answer2.text = current_case.answers[1]
	$Answer3.text = current_case.answers[2]
	$Answer4.text = current_case.answers[3]
	
	$Answer1.pressed.connect(_on_answer_pressed.bind(current_case.answers[0]))
	$Answer2.pressed.connect(_on_answer_pressed.bind(current_case.answers[1]))
	$Answer3.pressed.connect(_on_answer_pressed.bind(current_case.answers[2]))
	$Answer4.pressed.connect(_on_answer_pressed.bind(current_case.answers[3]))

func _process(delta):
	if time_left > 0:
		time_left -= delta
		$Timer.text = str(int(time_left)) + "s"
	elif not time_expired:
		time_expired = true
		$Timer.text = "0s"
		_time_up()

func _time_up():
	print("Time's up!")

func _on_answer_pressed(answer):
	if answer == current_case.correct:
		print("Correct!")
	else:
		print("Wrong! Correct answer: " + current_case.correct)
