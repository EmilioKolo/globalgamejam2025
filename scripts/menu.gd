extends Control


@onready var exit_button_node = $columns/right_panel2/exit

var code = ''
const CORRECT_CODE = '466854'

func _ready() -> void:
	if OS.get_name().to_lower()=="web":
		exit_button_node.enabled = false
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
			print('Code '+code+' is incorrect.')
			code = ''

func enable_cheats():
	print('Code is correct!')
	Global.pop_total = 999999999
	Global.pop_unspent = 999999999

func change_color(newcolor_base, newcolor_accent):
	RenderingServer.set_default_clear_color(newcolor_base)

func _on_play_pressed() -> void:
	change_scene('play')

func _on_exit_pressed() -> void:
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
