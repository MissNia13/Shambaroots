extends Node
## Green leaf tea, the only tradeable in Season One.
## Freshness is per delivery day. Leaf loses a quality band each game day it sits,
## and a batch past its last band is waste. Leaving a delivery unattended costs you.

signal changed(kg_fresh: float, kg_stale: float, kg_waste: float)

const BAND_FRESH_HOURS := 24
const BAND_STALE_HOURS := 48

var _batches: Array = [] # [{ "kg": float, "picked_day": int }]

func add(kg: float, picked_day: int) -> void:
	if kg <= 0.0:
		return
	_batches.append({"kg": kg, "picked_day": picked_day})
	_emit()

func total_kg() -> float:
	var t := 0.0
	for b in _batches:
		t += float(b["kg"])
	return t

func fresh_kg(now_day: int) -> float:
	var t := 0.0
	for b in _batches:
		if _age_days(b, now_day) < 1:
			t += float(b["kg"])
	return t

func stale_kg(now_day: int) -> float:
	var t := 0.0
	for b in _batches:
		if _age_days(b, now_day) == 1:
			t += float(b["kg"])
	return t

func waste_kg(now_day: int) -> float:
	var t := 0.0
	for b in _batches:
		if _age_days(b, now_day) > 1:
			t += float(b["kg"])
	return t

## Sell only what is still sellable. Returns kg actually sold.
func sell(kg: float, now_day: int) -> float:
	var remaining := kg
	var sold := 0.0
	var kept: Array = []
	for b in _batches:
		var age := _age_days(b, now_day)
		if age > 1:
			continue # waste, not sellable
		var take: float = min(float(b["kg"]), remaining)
		b["kg"] = float(b["kg"]) - take
		remaining -= take
		sold += take
		if float(b["kg"]) > 0.0001:
			kept.append(b)
	_batches = kept
	_emit()
	return sold

## Take only one freshness band out of stock. Market uses this so a fresh kg
## is never quietly sold at stale money (or the reverse).
func take_band(band: String, now_day: int) -> float:
	var taken := 0.0
	var kept: Array = []
	for b in _batches:
		var age := _age_days(b, now_day)
		var is_fresh := age < 1
		var is_stale := age == 1
		var match_band := (band == "fresh" and is_fresh) or (band == "stale" and is_stale)
		if match_band:
			taken += float(b["kg"])
		else:
			kept.append(b)
	_batches = kept
	_emit()
	return taken

func clear_waste(now_day: int) -> float:
	var cleared := 0.0
	var kept: Array = []
	for b in _batches:
		if _age_days(b, now_day) > 1:
			cleared += float(b["kg"])
		else:
			kept.append(b)
	_batches = kept
	_emit()
	return cleared

func _age_days(b: Dictionary, now_day: int) -> int:
	return now_day - int(b["picked_day"])

func _emit() -> void:
	var d: int = GameClock.day if GameClock else 1
	changed.emit(fresh_kg(d), stale_kg(d), waste_kg(d))

func to_dict() -> Dictionary:
	return {"batches": _batches.duplicate(true)}

func from_dict(d: Dictionary) -> void:
	_batches = d.get("batches", []).duplicate(true)
	_emit()
