extends Control


func _ready() -> void:
	SignalBus.resize_screen.emit()

func change_scene(scene_name):
	if scene_name == 'play':
		get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_play_pressed() -> void:
	change_scene('play')

func _on_exit_pressed() -> void:
	get_parent().queue_free()

func _on_mute_pressed() -> void:
	Global.toggle_mute()
