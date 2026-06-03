extends Node2D

var current_case = {
	"image": "afib.jpg",
	"correct": "Atrial Fibrillation",
	"answers": ["Atrial Fibrillation", "Sinus Tachycardia", "Atrial Flutter", "Normal Sinus Rhythm"],
	"explanation": "Atrial Fibrillation is identified by the absence of distinct P waves and an irregularly irregular rhythm. The ventricular rate is variable and the baseline shows chaotic fibrillatory waves."
}

var time_left = 30.0
var time_expired = false
var answered = false
var score = 0

func _ready():
	$Timer.text = "30s"
	$ScoreLabel.text = "Score: 0"
	$Answer1.text = current_case.answers[0]
	$Answer2.text = current_case.answers[1]
	$Answer3.text = current_case.answers[2]
	$Answer4.text = current_case.answers[3]
	
	$Answer1.pressed.connect(_on_answer_pressed.bind(current_case.answers[0]))
	$Answer2.pressed.connect(_on_answer_pressed.bind(current_case.answers[1]))
	$Answer3.pressed.connect(_on_answer_pressed.bind(current_case.answers[2]))
	$Answer4.pressed.connect(_on_answer_pressed.bind(current_case.answers[3]))
	
	$ResultScreen.visible = false
	$ResultScreen/NextButton.pressed.connect(_on_next_pressed)

func _process(delta):
	if time_left > 0 and not answered:
		time_left -= delta
		$Timer.text = str(int(time_left)) + "s"
	elif not time_expired and not answered:
		time_expired = true
		$Timer.text = "0s"
		_time_up()

func _time_up():
	show_result(false, "Time's up!")

func _on_answer_pressed(answer):
	if answered:
		return
	answered = true
	if answer == current_case.correct:
		score += 1
		$ScoreLabel.text = "Score: " + str(score)
		show_result(true, "Correct!")
	else:
		show_result(false, "Incorrect. The answer was: " + current_case.correct)

func show_result(correct, message):
	$ECGImage.visible = false
	$Answer1.visible = false
	$Answer2.visible = false
	$Answer3.visible = false
	$Answer4.visible = false
	$Timer.visible = false
	$ResultScreen.visible = true
	$ResultScreen/ResultLabel.text = message
	$ResultScreen/ExplanationLabel.text = current_case.explanation

func _on_next_pressed():
	$ECGImage.visible = true
	$Answer1.visible = true
	$Answer2.visible = true
	$Answer3.visible = true
	$Answer4.visible = true
	$Timer.visible = true
	$ResultScreen.visible = false
	answered = false
	time_expired = false
	time_left = 30.0
	$Timer.text = "30s"
