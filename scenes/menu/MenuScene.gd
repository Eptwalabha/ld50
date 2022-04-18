extends Spatial

onready var ad : AdScreen = $Viewport/PromoAd
onready var cashiers : Spatial = $SuperMarket/Cashiers

func _ready() -> void:
	ad.on = true
	for cashier in cashiers.get_children():
		cashier.player_ready_to_checkout()
	new_promotion()

func new_promotion() -> void:
	ad.set_current_promotion(Data.ITEMS[randi() % len(Data.ITEMS)], 10.0)

func _on_Promotion_timeout() -> void:
	new_promotion()
