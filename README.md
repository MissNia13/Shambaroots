# Shamba Roots — Season One

Godot 4 / GDScript. Canon repo for the game, owned by `MissNia13`.
Mark Kiprotich Mugun is the designer of record and the one who approves a merge.
Taydence Technologies owns the game; this repo is where it is built.

## What is in here

Not a game yet. It is the core of one, without art.

- **Clock** — 1 real second = 1 game minute. Day 1 starts 06:00. A season day is 24 real minutes.
- **Wallet** — one pot, two ledgers: KES (real money in the story) and M-SHAMBA (game ledger). Debits refuse instead of going negative.
- **Tea** — green leaf in batches, by pick day. Fresh for one day, stale for the second, waste after that. Waste cannot be sold. Leaving a delivery unattended costs you.
- **Save** — one JSON file in `user://`, versioned, loaded on boot.
- **Greybox scene** — clock, wallet, tea, one log line. Space picks 5 kg, S saves, L loads.

## Run it

1. Open the folder in Godot 4.x.
2. Import, press F5.
3. Space a few times, close it, reopen it. The clock and the tea should be where you left them.

## What is deliberately not here yet

Player, farm, village, shop, NPCs, Uncle Kamau, vehicles, Android export.
Season One is one farm, the Kapsean centre, and a tea-to-money loop. Everything else waits.

## Rules of the repo

- `main` is the only branch that gets merged into.
- One commit, one idea, message in plain words.
- No placeholder names in canon text. If a name is not decided, it is blank, not invented.
- Design changes go in `docs/` first, then in code.
