class_name DigitalClock extends Spatial

onready var screen : DigitalClockScreen = $Viewport/Screen

export(bool) var running := false
var time : int = 60

func _ready() -> void:
	screen.reset(120, true)

func start(the_time: float) -> void:
	time = int(the_time)
	screen.reset(time, true)

func reset(is_running : bool = true) -> void:
	screen.reset(time, is_running)

func add_time_bonus(time_bonus: float) -> void:
	screen.add_time_bonus(time_bonus)

func _on_Screen_ticked() -> void:
	$TicTac.play()
