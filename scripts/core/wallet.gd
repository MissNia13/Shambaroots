extends Node
## One shared pot: real money (KES) and the in-game ledger (M-SHAMBA).
## Debits return false instead of going negative.

signal changed(kes: int, m_shamba: int)

var kes := 0
var m_shamba := 0

func credit_kes(amount: int) -> void:
	if amount <= 0:
		return
	kes += amount
	changed.emit(kes, m_shamba)

func debit_kes(amount: int) -> bool:
	if amount <= 0:
		return true
	if kes < amount:
		return false
	kes -= amount
	changed.emit(kes, m_shamba)
	return true

func credit_shamba(amount: int) -> void:
	if amount <= 0:
		return
	m_shamba += amount
	changed.emit(kes, m_shamba)

func debit_shamba(amount: int) -> bool:
	if amount <= 0:
		return true
	if m_shamba < amount:
		return false
	m_shamba -= amount
	changed.emit(kes, m_shamba)
	return true

func to_dict() -> Dictionary:
	return {"kes": kes, "m_shamba": m_shamba}

func from_dict(d: Dictionary) -> void:
	kes = int(d.get("kes", 0))
	m_shamba = int(d.get("m_shamba", 0))
	changed.emit(kes, m_shamba)
