extends Node2D

onready var test_page = $Test
onready var en_page = $Entrance
onready var test_start_timer = $Test/UnpaintTargetTimer
onready var edt = $Entrance/LineEdit
onready var label = $Entrance/RichTextLabel

func _ready():
	print(get_node("Test").user_id)

func restart():
	edt.clear()
	edt.show()
	label.clear()


func _on_Control_hide():
	get_node("Test").user_id = edt.text
	test_page.show()
	test_start_timer.start()


func _on_Test_hide():
	restart()
	en_page.show()
