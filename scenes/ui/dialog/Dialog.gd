class_name Dialog extends Control

func display(who, key) -> void:
	$Panel/ColorRect/Label.text = who
	$Panel/MarginContainer/Label.text = key
	show()
