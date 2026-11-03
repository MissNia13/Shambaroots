extends Node
## Save/load for a Season One run. One JSON file in user:// so a crash
## or a closed laptop never costs a day of play.

signal loaded()
signal saved()

const SAVE_PATH := "user://season_one.json"
const SAVE_VERSION := 1

func snapshot() -> Dictionary:
	return {
		"version": SAVE_VERSION,
		"saved_at_unix": int(Time.get_unix_time_from_system()),
		"clock": GameClock.to_dict(),
		"wallet": Wallet.to_dict(),
		"tea": Tea.to_dict(),
	}

func save_run() -> bool:
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f == null:
		push_error("Shamba Roots: cannot open save at %s" % SAVE_PATH)
		return false
	f.store_string(JSON.stringify(snapshot(), "\t"))
	f.close()
	saved.emit()
	return true

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func load_run() -> bool:
	if not has_save():
		return false
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if f == null:
		return false
	var raw := f.get_as_text()
	f.close()
	var parsed: Variant = JSON.parse_string(raw)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Shamba Roots: save file is not valid JSON, keeping it untouched")
		return false
	var d: Dictionary = parsed
	if int(d.get("version", 0)) != SAVE_VERSION:
		push_warning("Shamba Roots: save version %s, expected %s" % [d.get("version"), SAVE_VERSION])
	GameClock.from_dict(d.get("clock", {}))
	Wallet.from_dict(d.get("wallet", {}))
	Tea.from_dict(d.get("tea", {}))
	loaded.emit()
	return true

func delete_save() -> void:
	if has_save():
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))
