extends Control


signal pressed

@onready var button_node = $button_anchor/touch_button
@onready var sprite_node = $button_anchor/sprite
@onready var anchor_node = $button_anchor
@onready var marker_node = $marker

@export var sprite_frame:int = 0
@export var button_size:int = 256


func _ready() -> void:
	SignalBus.resize_screen.connect(update_button)
	update_button()


func scale_button():
	print(self)
	print(button_size)
	print(marker_node.position)
	# Define the scale factor
	var scale_factor = button_size/128.0
	# Scale sprite
	sprite_node.scale = Vector2(scale_factor, scale_factor)
	# Scale CircleShape
	button_node.shape.radius = button_size*15/16/2
	button_node.position = Vector2(button_size/2, button_size/2)

func update_button():
	# Define frame number
	sprite_node.frame = sprite_frame
	# Pick the smallest side of anchor_node as the button size
	button_size = max(min(size.x, size.y), 128)
	# Scale the button with the new button_size
	scale_button()


func _on_touch_button_pressed() -> void:
	emit_signal("pressed")
