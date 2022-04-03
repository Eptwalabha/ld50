class_name SettingsVideo
extends GameSubMenuPanel

onready var resolutions : UIMenuFormSelect = $Video/Items/Resolutions

func _ready() -> void:
	var conf = Data.current_config.data
	$Game/Items/Language.set_value(conf['language'])
	$Game/Items/Crosshair.set_value("true" if conf['crosshair_visible'] else "false")
	$Video/Items/Fullscreen.set_value("true" if conf['fullscreen'] else "false")
	$Video/Items/FoV.set_value(Data.get_player_fov_value())
	$Video/Items/Vsync.set_value(Data.get_vsync_value())
	set_resolutions("16:9")

func set_resolutions(ratio: String) -> void:
	resolutions.set_choices(get_resolutions_from_ratio(ratio))

func update_resolutions(ratio: String) -> void:
	resolutions.update_choices(get_resolutions_from_ratio(ratio))

func get_resolutions_from_ratio(ratio: String) -> Array:
	var ratio_part = ratio.split(":")
	var factor = ratio_part[0].to_float() / ratio_part[1].to_float()
	var ratio_resolutions := []
	for w in Data.WIDTH_RESOLUTIONS:
		var h := int(w / factor)
		var i = "%s x %s" % [w, h]
		ratio_resolutions.push_back(i)
	return ratio_resolutions

func update_current_resolution() -> void:
	var resolution = resolutions.get_value().split("x")
	var width = resolution[0].strip_edges().to_int()
	var height = resolution[1].strip_edges().to_int()
	Data.set_screen_resolution(Vector2(width, height))

func _on_Language_value_changed(new_local) -> void:
	Data.set_language(new_local)

func _on_Fullscreen_value_changed(value) -> void:
	Data.set_fullscreen(value == "true")

func _on_Ratio_value_changed(new_ratio) -> void:
	update_resolutions(new_ratio)

func _on_Resolutions_value_changed(_value) -> void:
	update_current_resolution()

func _on_FoV_value_changed(value) -> void:
	Data.set_player_fov(value)

func _on_Gamma_value_changed(value) -> void:
	Data.set_gamma(value)

func _on_Crosshair_value_changed(value) -> void:
	Data.set_crossair_visibility(value == "true")


func _on_Gamma_focus_entered() -> void:
	$Video/Items/GammaImage.visible = true

func _on_Gamma_focus_exited() -> void:
	$Video/Items/GammaImage.visible = false


func _on_Vsync_value_changed(value) -> void:
	Data.set_vsync(value == "true")
