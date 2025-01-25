extends Control


signal pressed

@onready var button_node = $button_anchor/touch_button
@onready var sprite_node = $button_anchor/sprite
@onready var anchor_node = $button_anchor
@onready var marker_node = $marker

@export var sprite_frame:int = 0
@export var button_size:int = 256
@export var center_button:bool = true

const RESPONSIVE_SIZE = true

func _ready() -> void:
	SignalBus.resize_screen.connect(update_button)
	update_initial()


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
	button_node.shape.radius = button_size*15/16/2
	button_node.position = Vector2(size.x/2, size.y/2)

func update_initial():
	# Define frame number
	if sprite_frame<=16 and sprite_frame>=12:
		sprite_node.frame = randi_range(12,16)
	else:
		sprite_node.frame = sprite_frame
	# Do regular button update
	update_button()

func update_button():
	# Update mute if it is a mute button
	if sprite_frame in [2,5,8,11]:
		update_mute()
	# Scale the button size
	scale_button()

func update_mute():
	if Global.mute_bool:
		if sprite_frame in [5,11]:
			sprite_node.frame = sprite_frame
		else:
			sprite_node.frame = 5
	else:
		if sprite_frame in [2,8]:
			sprite_node.frame = sprite_frame
		else:
			sprite_node.frame = 8


func _on_touch_button_pressed() -> void:
	emit_signal("pressed")
