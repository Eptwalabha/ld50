extends Spatial


onready var label : Label = $Viewport/Control/ColorRect/MarginContainer/Label
export(String) var text = "text"

func _ready() -> void:
	label.text = text
