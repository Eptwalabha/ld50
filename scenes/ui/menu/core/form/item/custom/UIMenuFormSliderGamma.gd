class_name UIMenuFormSliderGamma
extends UIMenuFormSlider

onready var helper : MarginContainer = $VBox/Helper
onready var gamma_texture : TextureRect = $VBox/Helper/HBoxContainer/GammaTexture

func _ready() -> void:
	helper.visible = false

func _on_Slider_value_changed(value: float) -> void:
	current_value = value
	emit_signal("value_changed", value)
	var new_gamma : float = lerp(Data.GAMMA_MIN, Data.GAMMA_MAX, value)
	gamma_texture.material.set_shader_param("gamma", new_gamma)

func enter() -> void:
	.enter()
	helper.visible = true

func exit() -> void:
	.exit()
	helper.visible = false

func _on_UIMenuFormSliderGamma_pressed() -> void:
	helper.visible = true
