extends Node
## The Kapsean buyer. The only way tea becomes money in Season One.
## Price is set by freshness band, not by haggling: fresh pays well, stale pays
## half, waste pays nothing. This is what makes the day matter.

const PRICE_FRESH_KG := 45
const PRICE_STALE_KG := 22

func quote(now_day: int) -> Dictionary:
	var fresh: float = Tea.fresh_kg(now_day)
	var stale: float = Tea.stale_kg(now_day)
	var kes := int(round(fresh * PRICE_FRESH_KG + stale * PRICE_STALE_KG))
	return {"fresh": fresh, "stale": stale, "kes": kes}

## Sell everything still sellable. Returns what actually moved.
func sell_all(now_day: int) -> Dictionary:
	var fresh_sold: float = Tea.take_band("fresh", now_day)
	var stale_sold: float = Tea.take_band("stale", now_day)
	var kes := int(round(fresh_sold * PRICE_FRESH_KG + stale_sold * PRICE_STALE_KG))
	if kes > 0:
		Wallet.credit_kes(kes)
	return {"fresh": fresh_sold, "stale": stale_sold, "kes": kes}
