extends Control


signal pressed
signal buy_attempt(node)

@onready var button_node = $button_anchor/touch_button
@onready var sprite_node = $button_anchor/sprite
@onready var anchor_node = $button_anchor
@onready var marker_node = $marker
@onready var anim_play_node = $AnimationPlayer
@onready var audio_node = $AudioStreamPlayer2D

@export var sprite_frame:int = 0
@export var button_size:int = 256
@export var center_button:bool = true
@export var option_button:bool = true
@export var buy_button:bool = false

var reload_timer:float = .1
@export var enabled:bool = true

const RESPONSIVE_SIZE = true

func _ready() -> void:
	SignalBus.resize_screen.connect(update_button)
	update_initial()


func popped():
	# Emit signal
	pressed.emit()
	# Create timer and set up values
	var timer = Timer.new()
	timer.wait_time = reload_timer
	timer.one_shot = true
	# Connect timer timeout to _enable
	timer.connect("timeout", _enable)
	# Start timer
	timer.autostart = true
	# Add timer as child
	self.add_child(timer)
	# Change color if modulate is different from white
	if modulate.r!=1 or modulate.g!=1 or modulate.b!=1:
		if RenderingServer.get_default_clear_color()==modulate:
			RenderingServer.set_default_clear_color(Color.WHITE)
		else:
			RenderingServer.set_default_clear_color(modulate)

func scale_button():
	# Pick the smallest side of anchor_node as the button size
	if RESPONSIVE_SIZE:
		button_size = max(min(size.x, size.y), 128)
	# Define the scale factor
	var scale_factor = button_size/128.0
	# Scale sprite
	sprite_node.scale = Vector2(scale_factor, scale_factor)
	if center_button:
		sprite_node.centered = true
		sprite_node.position = Vector2(size.x/2, size.y/2)
	else:
		sprite_node.centered = false
		sprite_node.position = Vector2(0,0)
	# Scale CircleShape
	button_node.shape.radius = button_size*15.0/16.0/2.0
	button_node.position = Vector2(size.x/2, size.y/2)

func update_initial():
	# Define frame number
	if sprite_frame<=16 and sprite_frame>=12:
		if !option_button:
			reload_timer = Global.reload_timer
		sprite_frame = randi_range(12,16)
	# Do regular button update
	update_button()
	# Update sprite frame
	update_sprite_frame()

func update_button():
	# Update mute if it is a mute button
	if sprite_frame in [2,5,8,11]:
		update_mute()
	# Scale the button size
	scale_button()

func update_mute():
	if Global.mute_bool:
		if not sprite_frame in [5,11]:
			sprite_frame = 5
	else:
		if not sprite_frame in [2,8]:
			sprite_frame = 8

func update_sprite_frame():
	if enabled:
		sprite_node.frame = sprite_frame
	else:
		sprite_node.frame = 29

func _enable():
	enabled = true
	update_sprite_frame()

func _disable():
	enabled = false

func _vibrate():
	# Vibrate phone or handheld
	Input.vibrate_handheld(200)

func _on_touch_button_pressed() -> void:
	if enabled:
		if !buy_button:
			anim_play_node.play("pop")
		else:
			buy_attempt.emit(self)
