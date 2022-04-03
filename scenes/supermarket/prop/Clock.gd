class_name Clock extends Spatial

onready var pivot := $Pivot

export(bool) var running := false

func _ready() -> void:
	pivot.rotation_degrees = Vector3(0.0, 0.0, 0.0)

func _process(delta: float) -> void:
	if running:
		pivot.global_rotate(Vector3(0.0, 0.0, 1.0), deg2rad(delta * 360.0 / 300.0))
