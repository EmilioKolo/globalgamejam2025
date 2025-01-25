extends Node


# Control variables
var mute_bool = false
# Bubble variables
var pop_total:int = 0
var pop_unspent:int = 0
var pop_value:int = 1
var grid_size:Vector2 = Vector2(3,3)
var reload_freq = 2.0
var reload_timer = 10.0/reload_freq
# Upgrade costs
var pop_val_cost = 10
var auto_cost = 100
var grid_size_cost = 100
var reload_cost = 25
# Autopopper
var autopopper_counter = 0
var autopopper_timer = 2.0


func toggle_mute():
	mute_bool = !mute_bool
	SignalBus.toggle_sound.emit()
	# Get bus index for Master
	var bus_idx = AudioServer.get_bus_index("Master")
	# Use toggle to mute or unmute
	AudioServer.set_bus_mute(bus_idx, mute_bool)

func bubble_popped():
	# Increase pops
	pop_total += pop_value
	pop_unspent += pop_value
	# Emit pop signal
	SignalBus.bubble_pop.emit()

func buy_val_upgrade():
	# Spend pops
	pop_unspent = pop_unspent - pop_val_cost
	# Increase pop value
	pop_value += 1
	# Increase pop_val_cost
	pop_val_cost = cost_increase(pop_val_cost)

func buy_auto_upgrade():
	# Spend pops
	pop_unspent = pop_unspent - auto_cost
	# Add autopopper
	autopopper_counter += 1
	# Increase auto_cost
	auto_cost = cost_increase(auto_cost)

func buy_size_upgrade():
	# Spend pops
	pop_unspent = pop_unspent - grid_size_cost
	# Increase size
	if grid_size.x>grid_size.y:
		grid_size.y+=1
	else:
		grid_size.x+=1
	# Increase grid_size_cost
	grid_size_cost = cost_increase(grid_size_cost)

func buy_reload_upgrade():
	# Spend pops
	pop_unspent = pop_unspent - reload_cost
	# Increase reload frequency
	reload_freq += 1.0
	# Define reload_timer from reload_freq
	reload_timer = 10.0/reload_freq
	# Increase reload_cost
	reload_cost = cost_increase(reload_cost)

func cost_increase(n):
	return int(1.5*n)

func load_game():
	pass

func save_game():
	pass
