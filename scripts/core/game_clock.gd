extends Node
## Season One clock: 1 real second = 1 game minute.
## A season day is 1440 game minutes (24 real minutes). Starts Day 1, 06:00.

signal minute_passed(day: int, hour: int, minute: int)
signal day_passed(day: int)

const MINUTES_PER_DAY := 1440
const START_MINUTE := 6 * 60

var seconds_per_minute := 1.0
var running := true
var day := 1
var minute_of_day := START_MINUTE

var _accum := 0.0

func _process(delta: float) -> void:
	if not running or seconds_per_minute <= 0.0:
		return
	_accum += delta
	while _accum >= seconds_per_minute:
		_accum -= seconds_per_minute
		advance_minute()

func advance_minute() -> void:
	minute_of_day += 1
	if minute_of_day >= MINUTES_PER_DAY:
		minute_of_day = 0
		day += 1
		day_passed.emit(day)
	minute_passed.emit(day, hour(), minute())

func hour() -> int:
	return int(minute_of_day / 60.0)

func minute() -> int:
	return minute_of_day % 60

func clock_text() -> String:
	return "Day %d   %02d:%02d" % [day, hour(), minute()]

func is_daytime() -> bool:
	return minute_of_day >= 6 * 60 and minute_of_day < 19 * 60

## Test / event helper: jump forward to a wall time without emitting per-minute noise.
func fast_forward_to(h: int, m: int) -> void:
	var target := (h * 60 + m) % MINUTES_PER_DAY
	var guard := 0
	while minute_of_day != target and guard < MINUTES_PER_DAY + 1:
		advance_minute()
		guard += 1

func to_dict() -> Dictionary:
	return {"day": day, "minute_of_day": minute_of_day}

func from_dict(d: Dictionary) -> void:
	day = int(d.get("day", 1))
	minute_of_day = int(d.get("minute_of_day", START_MINUTE))
	_accum = 0.0
