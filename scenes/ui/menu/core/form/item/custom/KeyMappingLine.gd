class_name KeyMappingLine extends HBoxContainer

export(String) var label := "key"
export(int) var scancode := KEY_UP
export(String) var arrow := "arrow_up"

func update_labels() -> void:
	$Label.text = label
	$Key.text = OS.get_scancode_string(Data.get_scancode_for(label))
	$Arrow.text = arrow
