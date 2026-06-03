extends Node2D

var cases = [
	{
		"image": "afib.jpg",
		"mechanism_image": "afib_mechanism.png",
		"correct": "Atrial Fibrillation",
		"answers": ["Atrial Fibrillation", "Sinus Tachycardia", "Atrial Flutter", "Normal Sinus Rhythm"],
		"explanation": "Rhythm: Absent P waves, irregularly irregular ventricular rate, chaotic fibrillatory baseline. Mechanism: AF requires a trigger (focal pulmonary vein discharge) and substrate for maintenance. Sustained by focal activation or multiple wandering wavelets via re-entry circuits, amplified by left atrial dilation.",
		"citation": "Source: LITFL.com"
	},
	{
		"image": "sinustach.jpg",
		"mechanism_image": "sinustach_mechanism.jpg",
		"correct": "Sinus Tachycardia",
		"answers": ["Sinus Tachycardia", "Atrial Fibrillation", "SVT", "Atrial Flutter"],
		"explanation": "Rhythm: Regular rhythm, rate above 100 bpm, upright P waves before every QRS, normal PR interval. Mechanism: Increased sympathetic drive accelerates the sinoatrial node firing rate. Common causes include fever, pain, hypovolemia, anxiety, and exercise. Note: At very fast rates, the P wave may be hidden within the preceding T wave, creating a 'camel hump' appearance as shown in the image below.",
		"citation": "Source: LITFL.com"
	},
	{
		"image": "normsinus.jpg",
		"mechanism_image": "normsinus_mechanism.jpg",
		"correct": "Normal Sinus Rhythm",
		"answers": ["Normal Sinus Rhythm", "Sinus Bradycardia", "First Degree Heart Block", "Sinus Tachycardia"],
		"explanation": "Rhythm: Regular rate 60-100 bpm, upright P wave before every QRS, normal PR interval 120-200ms, normal QRS duration. Mechanism: The sinoatrial node fires at its intrinsic rate, conducting normally through the AV node and bundle of His to produce coordinated ventricular contraction.",
		"citation": "Source: LITFL.com"
	}
]

var current_case = {}
var used_cases = []
var time_left = 30.0
var time_expired = false
var answered = false
var score = 0

func _ready():
	load_new_case()
	$ResultScreen.visible = false
	$ResultScreen/NextButton.pressed.connect(_on_next_pressed)

func load_new_case():
	if used_cases.size() == cases.size():
		used_cases.clear()
	
	var available = []
	for i in range(cases.size()):
		if not used_cases.has(i):
			available.append(i)
	
	var index = available[randi() % available.size()]
	used_cases.append(index)
	current_case = cases[index]
	
	var ecg_texture = load("res://" + current_case.image)
	$ECGImage.texture = ecg_texture
	
	$Timer.text = "30s"
	$ScoreLabel.text = "Score: " + str(score)
	$Answer1.text = current_case.answers[0]
	$Answer2.text = current_case.answers[1]
	$Answer3.text = current_case.answers[2]
	$Answer4.text = current_case.answers[3]
	
	$Answer1.pressed.connect(_on_answer_pressed.bind(current_case.answers[0]))
	$Answer2.pressed.connect(_on_answer_pressed.bind(current_case.answers[1]))
	$Answer3.pressed.connect(_on_answer_pressed.bind(current_case.answers[2]))
	$Answer4.pressed.connect(_on_answer_pressed.bind(current_case.answers[3]))

func _process(delta):
	if time_left > 0 and not answered:
		time_left -= delta
		$Timer.text = str(int(time_left)) + "s"
	elif not time_expired and not answered:
		time_expired = true
		$Timer.text = "0s"
		_time_up()

func _time_up():
	show_result(false, "Time's Up! The answer was: " + current_case.correct)

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
	$ResultScreen/CitationLabel.text = current_case.citation
	var mechanism_texture = load("res://" + current_case.mechanism_image)
	$ResultScreen/MechanismImage.texture = mechanism_texture

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
	
	for btn in [$Answer1, $Answer2, $Answer3, $Answer4]:
		for connection in btn.pressed.get_connections():
			btn.pressed.disconnect(connection.callable)
	
	load_new_case()
