extends Control
## Greybox for Season One: clock, wallet, tea, one save key. No art yet on purpose.

@onready var clock_label: Label = $Panel/VBox/Clock
@onready var wallet_label: Label = $Panel/VBox/Wallet
@onready var tea_label: Label = $Panel/VBox/Tea
@onready var log_label: Label = $Panel/VBox/Log

func _ready() -> void:
	GameClock.minute_passed.connect(_on_minute)
	Wallet.changed.connect(_on_wallet)
	Tea.changed.connect(_on_tea)
	Season.load_run()
	GameClock.seconds_per_minute = 1.0
	_refresh()
	_say("Season One greybox. Space = pick 5 kg, S = save, L = load.")

func _refresh() -> void:
	clock_label.text = GameClock.clock_text()
	_on_wallet(Wallet.kes, Wallet.m_shamba)
	_on_tea(Tea.fresh_kg(GameClock.day), Tea.stale_kg(GameClock.day), Tea.waste_kg(GameClock.day))

func _on_minute(_d: int, _h: int, _m: int) -> void:
	clock_label.text = GameClock.clock_text()

func _on_wallet(kes: int, shamba: int) -> void:
	wallet_label.text = "KES %d    M-SHAMBA %d" % [kes, shamba]

func _on_tea(fresh: float, stale: float, waste: float) -> void:
	tea_label.text = "Tea  fresh %.1f kg   stale %.1f kg   waste %.1f kg" % [fresh, stale, waste]

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_SPACE:
				Tea.add(5.0, GameClock.day)
				_say("Picked 5 kg on day %d. Leaf loses a band each day it sits." % GameClock.day)
			KEY_S:
				_say("Saved." if Season.save_run() else "Save failed, check the debugger.")
			KEY_L:
				_say("Loaded." if Season.load_run() else "No save yet.")

func _say(line: String) -> void:
	log_label.text = line
	print("[shamba] ", line)
