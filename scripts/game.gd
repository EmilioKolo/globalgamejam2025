extends Control


func _ready() -> void:
	SignalBus.resize_screen.emit()

func _process(delta: float) -> void:
	SignalBus.resize_screen.emit()


func back_to_menu():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_exit_pressed() -> void:
	back_to_menu()

func _on_mute_pressed() -> void:
	Global.toggle_mute()
