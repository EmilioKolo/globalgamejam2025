extends Node


var pop_counter:int = 0
var mute_bool = false


func toggle_mute():
	mute_bool = !mute_bool
	SignalBus.toggle_sound.emit()

func load_game():
	pass

func save_game():
	pass
