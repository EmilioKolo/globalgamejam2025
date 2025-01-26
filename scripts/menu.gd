extends Control


@onready var exit_button_node = $columns/right_panel2/exit
@onready var debug_label = $columns/right_panel1/pad/debug_label

var code = ''
const CORRECT_CODE = '466854'
var web_play:bool = false

func _ready() -> void:
	web_play = Global.os_name == 'web'
	SignalBus.resize_screen.emit()

func _process(_delta: float) -> void:
	SignalBus.resize_screen.emit()

func change_scene(scene_name):
	if scene_name == 'play':
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func button_clicked(n):
	code = code+str(n)
	if len(code)>=len(CORRECT_CODE):
		if code==CORRECT_CODE:
			enable_cheats()
			code = ''
		else:
			_flash_message(code)
			code = ''

func enable_cheats():
	_flash_message('Cheats enabled')
	Global.pop_total = 999999999
	Global.pop_unspent = 999999999

func change_color(newcolor_base, newcolor_accent):
	RenderingServer.set_default_clear_color(newcolor_base)

func _flash_message(text):
	# Remove all previous timers
	for t in debug_label.get_children():
		t.queue_free()
	# Change debut_label text
	debug_label.text = str(text)
	# Create timer and set up values
	var timer = Timer.new()
	timer.wait_time = 5.0
	timer.one_shot = true
	# Connect timer timeout to queue_autopop
	timer.connect("timeout", _delete_message)
	timer.connect("timeout", timer.queue_free)
	# Start timer
	timer.autostart = true
	# Add timer as child to auto_node
	debug_label.add_child(timer)

func _delete_message():
	debug_label.text = ''

func _on_play_pressed() -> void:
	change_scene('play')

func _on_exit_pressed() -> void:
	if web_play:
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	else:
		get_tree().quit()

func _on_mute_pressed() -> void:
	Global.toggle_mute()

func _on_button_1_pressed() -> void:
	button_clicked(1)

func _on_button_2_pressed() -> void:
	button_clicked(2)

func _on_button_3_pressed() -> void:
	button_clicked(3)

func _on_button_4_pressed() -> void:
	button_clicked(4)

func _on_button_5_pressed() -> void:
	button_clicked(5)

func _on_button_6_pressed() -> void:
	button_clicked(6)

func _on_button_7_pressed() -> void:
	button_clicked(7)

func _on_button_8_pressed() -> void:
	button_clicked(8)
