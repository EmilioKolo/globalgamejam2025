extends Node


# Control variables
var mute_bool = false
# System variables
var os_name = ''
# Bubble variables
var pop_total:int = 0
var pop_unspent:int = 0
var pop_value:int = 1
var grid_size:Vector2 = Vector2(4,4)
var reload_freq = 2.0
var reload_timer = 10.0/reload_freq
# Upgrade costs
var pop_val_cost = 10
var auto_cost = 10
var auto_sp_cost = 100
var grid_size_cost = 100
var reload_cost = 25
# Autopopper
var autopopper_counter = 0
var autopopper_freq = 5.0
var autopopper_timer = 10.0/autopopper_freq


func _ready():
	os_name = OS.get_name().to_lower()

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

func buy_auto_sp_upgrade():
	# Spend pops
	pop_unspent = pop_unspent - auto_sp_cost
	# Increase frequency
	autopopper_freq += 1
	# Recalculate speed
	autopopper_timer = 10.0/autopopper_freq
	# Increase auto_cost
	auto_sp_cost = cost_increase(auto_sp_cost)

func buy_size_upgrade():
	# Spend pops
	pop_unspent = pop_unspent - grid_size_cost
	# Increase size
	if grid_size.x>grid_size.y:
		grid_size.y+=1
	else:
		grid_size.x+=1
	# Increase grid_size_cost
	grid_size_cost = cost_increase(grid_size_cost, 10)

func buy_reload_upgrade():
	# Spend pops
	pop_unspent = pop_unspent - reload_cost
	# Increase reload frequency
	reload_freq += 1.0
	# Define reload_timer from reload_freq
	reload_timer = 10.0/reload_freq
	# Increase reload_cost
	reload_cost = cost_increase(reload_cost)

func shorten(n, decimals=4):
	# Define number and modifier variables
	var num = ''
	var mod = ''
	# Define length of number n
	var len_n = len(str(int(n)))
	# If the number is lower than 10k
	if len_n<=4:
		num = str(n)
		mod = ''
	# If the number is lower than 10m
	elif len_n<=6:
		num = str(n).substr(0,len_n-3)
		if len(num)<decimals:
			num = num+'.'+str(n).substr(len(num),decimals-len(num))
		mod = 'k'
	# If the number is lower than 10b
	elif len_n<=9:
		num = str(n).substr(0,len_n-6)
		if len(num)<decimals:
			num = num+'.'+str(n).substr(len(num),decimals-len(num))
		mod = 'm'
	# If the number is lower than 10t
	elif len_n<=12:
		num = str(n).substr(0,len_n-9)
		if len(num)<decimals:
			num = num+'.'+str(n).substr(len(num),decimals-len(num))
		mod = 'b'
	# If the number is lower than 10q
	elif len_n<=15:
		num = str(n).substr(0,len_n-12)
		if len(num)<decimals:
			num = num+'.'+str(n).substr(len(num),decimals-len(num))
		mod = 't'
	# If the number is bigger than 10q, I use scientific notation
	else:
		num = str(n)[0]+'.'+str(n).substr(1,decimals)
		mod = 'e'+str(len_n-1)
	var ret = str(num)+str(mod)
	return ret

func cost_increase(n, mult=1.5):
	return int(mult*n)

func load_game():
	pass

func save_game():
	pass
