extends Control

const instru = "res://art/motInstru.json"

onready var edt = $LineEdit
onready var btn = $Button
onready var label = $RichTextLabel

func read_json_file(file_path):
	var file = File.new()
	file.open(file_path, File.READ)
	var content_as_text = file.get_as_text()
	var content_as_dictionary = parse_json(content_as_text)
	return content_as_dictionary

var inst = read_json_file(instru)
var stage = 0

func _on_Button_pressed():
	if stage < 1:
		edt.hide()
		label.show()
		label.set_text(inst["testGuideWords"])
		stage += 1
	else:
		self.hide()
		stage = 0
