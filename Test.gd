extends Node2D

var config = "res://art/motConfig.json"
var move_color = Color("ba844b")
var correct_color = Color("4bba62")
var wrong_color = Color("ba4b4b")
var user_id = ""
const storage = "user://DATASTORGE.json" # mac用user，win用res

var current_again_remain = 7

onready var bg = $Background
onready var bg_position = bg.rect_position
onready var t_1 = $Sprite1
onready var t_2 = $Sprite2
onready var t_3 = $Sprite3
onready var t_4 = $Sprite4
onready var t_5 = $Sprite5
onready var t_6 = $Sprite6
onready var t_7 = $Sprite7
onready var t_8 = $Sprite8
onready var t_9 = $Sprite9
onready var t_10 = $Sprite10
onready var t_11 = $Sprite11
onready var t_12 = $Sprite12
onready var t_list = [t_1,t_2,t_3,t_4,t_5,t_6,t_7,t_8,t_9,t_10,t_11,t_12]
onready var fps_timer = $FPSTimer
onready var show_tgt_timer = $ShowTargetTimer
onready var unpaint_tgt_timer = $UnpaintTargetTimer
onready var btn = $Button
onready var fdb_timer = $FeedbackTimer
onready var lbl = $Label

onready var show_list = []
onready var target_list = []
onready var target_red = preload("res://art/rRed.png")
onready var normal_grey = preload("res://art/greyCross.png")
onready var choiced_green = preload("res://art/rGreen.png")
onready var target_show_times = 4
onready var current_target_show_times = 0
onready var ready_to_choice = false

func read_json_file(file_path):
	var file = File.new()
	if file.file_exists(file_path):
		file.open(file_path, File.READ)
		var content_as_text = file.get_as_text()
		var content_as_dictionary = parse_json(content_as_text)
		return content_as_dictionary
	else:
		return []
	
onready var conf = read_json_file(config)
onready var max_items = len(conf)
onready var item_id = 0
onready var target_index = 0
onready var current_item = 0
onready var current_iter = 0
onready var ctrl = 0
onready var max_iter = 0
onready var correct_count = 0
onready var total_clicked = 0
onready var correct_list = []

var data_storage = [] 

func load_saver():
	data_storage = read_json_file(storage)

func save_json_data():
	var file = File.new()
	file.open(storage,File.WRITE)
	file.store_line(to_json(data_storage))

func commit_to_json(data):
	load_saver()
	data_storage.append(data)
	save_json_data()

#onready var SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
#onready var db_name = "user://database"
#onready var db = 0
#onready var table_name = "event_record"

func clean_last_item():
	current_iter = 0
	current_target_show_times = 0
	show_list = []
	target_list = []
	ready_to_choice = false
	correct_count = 0
	total_clicked = 0
	correct_list = []
	for t in t_list:
		t.hide()
		t.position = Vector2(0,0)

func yeild_conf():
	item_id = conf[current_item]["itemID"]
	target_index = conf[current_item]["targetPlaneIndex"]
	ctrl = conf[current_item]["ctrl"]
	max_iter = len(ctrl[0])
	current_item += 1
	clean_last_item()
	lbl.text = "进度 " + str(current_item) + "/" + str(max_items)

#func commit_To_DB(data):
#	db.open_db()
#	db.insert_row(table_name,data)
#	db.close_db()

#func read_From_DB(): 
# db.open_db()
# var tableName = "scoreboard"
# db.query("select * from " + tableName + ";")
# var result = db.query_result
# print(result)

func find_show():
	var num_show = len(ctrl)
	show_list.append_array(t_list.slice(0,num_show-1))
	for t in show_list:
		t.show()
		t.texture = normal_grey

func find_target():
	for i in target_index:
		target_list.append(show_list[i])

func paint_target():
	current_target_show_times += 1
	for t in target_list:
		t.texture = target_red

func unpaint_target():
	for t in target_list:
		t.texture = normal_grey

func unpaint_all():
	for t in show_list:
		t.texture = normal_grey

func update_position():
	if current_iter >= max_iter:
		return
	else:
		for i in range(len(show_list)):
			var pos = Vector2(bg_position[0]+ctrl[i][current_iter][0],bg_position[1]-ctrl[i][current_iter][1])
			show_list[i].position = pos
		current_iter += 1

# Called when the node enters the scene tree for the first time.
func _ready():
#	db = SQLite.new()
#	db.path = db_name
	btn.text = "Again(" + str(current_again_remain) + " times left)"
	bg_position[1] = bg_position[1]+832
	yeild_conf()
	find_show()
	find_target()
	update_position()
	print(item_id)


func _on_FPSTimer_timeout():
	fps_timer.stop()
	update_position()
	if current_iter < max_iter:
		fps_timer.start()
	else:
		ready_to_choice = true
		btn.disabled = false
		btn.text = "Next"


func _on_ShowTargetTimer_timeout():
	show_tgt_timer.stop()
	paint_target()
	if current_target_show_times <= target_show_times:
		unpaint_tgt_timer.start()
	else:
		unpaint_target()
		fps_timer.start()

func _on_UnpaintTargetTimer_timeout():
	unpaint_tgt_timer.stop()
	unpaint_target()
	show_tgt_timer.start()

func find_which_one(current):
	match current:
		t_1:
			return 0
		t_2:
			return 1
		t_3:
			return 2
		t_4:
			return 3
		t_5:
			return 4
		t_6:
			return 5
		t_7:
			return 6
		t_8:
			return 7
		t_9:
			return 8
		t_10:
			return 9
		t_11:
			return 10
		t_12:
			return 11

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		var click_pos = event.position
		click_pos = [click_pos[0],click_pos[1]-1080]
		var data:Dictionary = Dictionary()
		data["time_stamp"] = str(OS.get_system_time_msecs())
		data["item_id"] = str(item_id)
		data["user_id"] = str(user_id)
		if ready_to_choice == true:
			for t in show_list:
				var dis = [click_pos[0]-t.position[0],click_pos[1]-t.position[1]]
				if abs(dis[0])<=22.5 and abs(dis[1])<=22.5:
					data["which_one"] = find_which_one(t)
					data["event_type"] = "click"
					if t.texture != choiced_green:
						t.texture = choiced_green
						total_clicked += 1
						data["total_click"] = total_clicked
						data["if_cancle"] = 0
						if target_list.has(t):
							correct_list.append(target_index[target_list.find(t)])
							correct_count += 1
							data["correct_count"] = correct_count
							data["correct_list"] = str(correct_list)
							commit_to_json(data)
						else: 
							data["correct_count"] = correct_count
							data["correct_list"] = str(correct_list)
							commit_to_json(data)
						break
					else:
						t.texture = normal_grey
						total_clicked -= 1
						data["total_click"] = total_clicked
						data["if_cancle"] = 1
						if target_list.has(t):
							correct_list.pop_back()
							correct_count -= 1
							data["correct_count"] = correct_count
							data["correct_list"] = str(correct_list)
							commit_to_json(data)
						else: 
							data["correct_count"] = correct_count
							data["correct_list"] = str(correct_list)
							commit_to_json(data)
						break
		else:
			pass

func again_pressed():
	var data:Dictionary = Dictionary()
	data["time_stamp"] = str(OS.get_system_time_msecs())
	data["item_id"] = str(item_id)
	data["user_id"] = str(user_id)
	data["event_type"] = str(current_again_remain) + "-" + str(current_iter)
	data["correct_count"] = correct_count
	data["correct_list"] = str(correct_list)
	data["total_click"] = total_clicked
	data["if_cancle"] = 0
	data["which_one"] = -1
	commit_to_json(data)

func result_check():
	if correct_count == len(target_list) and total_clicked<=len(target_list):
		bg.color = correct_color
	else:
		bg.color = wrong_color
	fdb_timer.start()
	var data:Dictionary = Dictionary()
	data["time_stamp"] = str(OS.get_system_time_msecs())
	data["item_id"] = str(item_id)
	data["user_id"] = str(user_id)
	data["event_type"] = "result"
	data["correct_count"] = correct_count
	data["correct_list"] = str(correct_list)
	data["total_click"] = total_clicked
	data["if_cancle"] = 0
	data["which_one"] = -1
	commit_to_json(data)

func _on_Button_pressed():
	unpaint_all()
	if current_iter < max_iter:
		again_pressed()
		current_again_remain -= 1
		btn.text = "Again(" + str(current_again_remain) + " times left)"
		fps_timer.stop()
		clean_last_item()
		find_show()
		find_target()
		update_position()
		show_tgt_timer.start()
		if current_again_remain >0:
			btn.text = "Again(" + str(current_again_remain) + " times left)"
		elif current_again_remain ==0:
			btn.text = "Run Out Of Agains"
			btn.disabled = true
	else:
		if current_again_remain >0:
			btn.text = "Again(" + str(current_again_remain) + " times left)"
		elif current_again_remain ==0:
			btn.text = "Run Out Of Agains"
			btn.disabled = true
		if "lx" in item_id:
			result_check()
			yeild_conf()
		else:
			if current_item <= max_items:
				yeild_conf()
				find_show()
				find_target()
				update_position()
				show_tgt_timer.start()
			else:
				self.hide()


func _on_FeedbackTimer_timeout():
	fdb_timer.stop()
	bg.color = move_color
	find_show()
	find_target()
	update_position()
	show_tgt_timer.start()
