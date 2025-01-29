extends Control

# Left panel
@onready var pops_label = $columns/left_panel/pops/pop_counter/pops
@onready var total_label = $columns/left_panel/pops/pop_counter_total/pops
@onready var pop_profit_label = $columns/left_panel/stats/pop_value/pop_profit/pop_profit
@onready var pop_reload_label = $columns/left_panel/stats/pop_value/reload_time/pop_profit
@onready var autopop_label = $columns/left_panel/stats/autopop/autopop_counter/autopop_counter
@onready var autopop_reload_label = $columns/left_panel/stats/autopop/autopop_reload/autopop_reload
@onready var pop_val_cost_label = $columns/left_panel/pop_upgrade/cost
@onready var auto_up_label = $columns/left_panel/auto_upgrade/cost
@onready var auto_sp_up_label = $columns/left_panel/auto_sp_upgrade/cost
@onready var size_up_label = $columns/left_panel/size_upgrade/cost
@onready var reload_up_label = $columns/left_panel/reload_upgrade/cost
# Right panel
@onready var bubble_grid_node = $columns/right_panel/bubble_grid
# Outside of panels
@onready var auto_node = $autopoppers

# Autopopper variables
var curr_autopoppers = 0
var queued_autopops = 0
# Grid variables
var bubbles_in_grid = 0
# Preoad bubble_scene
var bubble_scene = preload("res://scenes/responsive_touch.tscn")

func _ready() -> void:
	SignalBus.resize_screen.emit()
	update_grid()
	SignalBus.bubble_pop.connect(update_labels)
	update_labels()
	update_autopopper()

func _process(delta: float) -> void:
	SignalBus.resize_screen.emit()


func queue_autopop():
	queued_autopops += 1

func update_autopopper():
	# Check if a new autopopper is needed
	while Global.autopopper_counter > curr_autopoppers:
		# Add an autopopper
		add_autopopper()
		# Count the new autopopper
		curr_autopoppers += 1
		# Await to add one more autopopper
		var timer = Timer.new()
		timer.wait_time = 0.05
		timer.one_shot = true
		# Start timer
		timer.autostart = true
		# Add timer as child to self
		self.add_child(timer)
		await timer.timeout
		timer.queue_free()
		

func update_autopopper_timer():
	# Go through autopoppers
	for apt in auto_node.get_children():
		# Change timer wait_time
		apt.wait_time = Global.autopopper_timer

func add_autopopper():
	# Create timer and set up values
	var timer = Timer.new()
	timer.wait_time = Global.autopopper_timer
	timer.one_shot = false
	# Connect timer timeout to queue_autopop
	timer.connect("timeout", queue_autopop)
	# Start timer
	timer.autostart = true
	# Add timer as child to auto_node
	auto_node.add_child(timer)

func autopop():
	var l_bub = bubble_grid_node.get_children()
	l_bub.shuffle()
	# Go through bubbles in bubble_grid_node
	for bub in l_bub:
		# Check that bubble is enabled
		if bub.enabled:
			# Check if there are queued_autopops
			if queued_autopops > 0:
				# Pop bubble
				bub.anim_play_node.play("pop")
				# Discount queue
				queued_autopops -= 1

func update_grid():
	# Remove all bubbles from grid
	for bub in bubble_grid_node.get_children():
		bubble_grid_node.remove_child(bub)
		bub.queue_free()
	# Restart bubbles_in_grid counter
	bubbles_in_grid = 0
	# Define grid shape
	bubble_grid_node.columns = Global.grid_size.x
	# Add bubbles until the grid is full
	var grid_n = Global.grid_size.x * Global.grid_size.y
	while bubbles_in_grid<grid_n:
		# Instantiate bubble_scene
		var bubble_instance = bubble_scene.instantiate()
		bubble_instance.sprite_frame = 12
		bubble_instance.option_button = false
		# Connect instance to Global.bubble_popped
		bubble_instance.pressed.connect(Global.bubble_popped)
		# Add instance to grid
		bubble_grid_node.add_child(bubble_instance)
		# Count bubbles in grid
		bubbles_in_grid += 1
	# Update values on all bubbles in grid
	update_bubble_options()

func update_bubble_options():
	for bub in bubble_grid_node.get_children():
		bub.reload_timer = Global.reload_timer

func update_labels():
	# Update number of pops
	pops_label.text = Global.shorten(Global.pop_unspent)
	total_label.text = Global.shorten(Global.pop_total)
	# Update costs of upgrades
	pop_val_cost_label.text = Global.shorten(Global.pop_val_cost)
	auto_up_label.text = Global.shorten(Global.auto_cost)
	auto_sp_up_label.text = Global.shorten(Global.auto_sp_cost)
	size_up_label.text = Global.shorten(Global.grid_size_cost)
	reload_up_label.text = Global.shorten(Global.reload_cost)
	# Update stats
	pop_profit_label.text = str(Global.pop_value)
	pop_reload_label.text = str(Global.reload_timer).substr(0,4)
	autopop_label.text = str(Global.autopopper_counter)
	autopop_reload_label.text = str(Global.autopopper_timer).substr(0,4)

func back_to_menu():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_exit_pressed() -> void:
	back_to_menu()

func _on_mute_pressed() -> void:
	Global.toggle_mute()

func _on_pop_up_buy_attempt(node: Variant) -> void:
	# Check for enough available pops
	if Global.pop_unspent >= Global.pop_val_cost:
		node.anim_play_node.play("pop")
		Global.buy_val_upgrade()
		update_labels()

func _on_auto_up_buy_attempt(node: Variant) -> void:
	# Check for enough available pops
	if Global.pop_unspent >= Global.auto_cost:
		node.anim_play_node.play("pop")
		Global.buy_auto_upgrade()
		update_labels()
		update_autopopper()

func _on_size_up_buy_attempt(node: Variant) -> void:
	# Check for enough available pops
	if Global.pop_unspent >= Global.grid_size_cost:
		node.anim_play_node.play("pop")
		Global.buy_size_upgrade()
		update_labels()
		update_grid()

func _on_reload_up_buy_attempt(node: Variant) -> void:
	# Check for enough available pops
	if Global.pop_unspent >= Global.reload_cost:
		node.anim_play_node.play("pop")
		Global.buy_reload_upgrade()
		update_labels()
		update_bubble_options()

func _on_auto_sp_up_buy_attempt(node: Variant) -> void:
	# Check for enough available pops
	if Global.pop_unspent >= Global.auto_sp_cost:
		node.anim_play_node.play("pop")
		Global.buy_auto_sp_upgrade()
		update_labels()
		update_autopopper_timer()
