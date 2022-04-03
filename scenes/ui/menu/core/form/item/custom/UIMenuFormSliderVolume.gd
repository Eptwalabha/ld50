class_name UIMenuFormSliderVolume
extends UIMenuFormSlider

export(String) var bus_name := "Master"

func _ready() -> void:
	slider.set_bus(bus_name)
