extends Control


var code = ''

func _ready() -> void:
	SignalBus.resize_screen.emit()

func _process(delta: float) -> void:
	SignalBus.resize_screen.emit()

func change_scene(scene_name):
	if scene_name == 'play':
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func button_clicked(n):
	code = code+str(n)
	if len(code)==6:
		if code=='466854':
			enable_cheat()
			code = ''
		else:
			print('Code '+code+' is incorrect.')
			code = ''

func enable_cheat():
	print('Code is correct!')
	pass

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
