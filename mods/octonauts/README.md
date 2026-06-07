# Octonauts Starter-Mod 🐙⚓

Ein kleines Einsteiger-Mod für Luanti, gemacht zum **gemeinsamen Entdecken
und Erweitern** – ideal für ein Kind (ca. 6 Jahre) und einen Elternteil.

Es funktioniert in **jedem** Luanti-Spiel und braucht keine anderen Mods.

## Was ist drin?

| Was            | Wie es heißt                | Was es macht                                  |
|----------------|-----------------------------|-----------------------------------------------|
| 🧱 Block       | **Octopod-Wand**            | Weiße Wand mit oranger Streife – zum Bauen.    |
| 💡 Block       | **Steuerpult**              | Bunte Knöpfe, **leuchtet im Dunkeln**.         |
| 🔵 Block       | **Bullauge**                | Rundes Fenster, durchsichtig.                  |
| 🍪 Gegenstand  | **Vegimal-Keks**            | Draufklicken = essen, gibt Leben zurück.       |
| 🟢 Wesen       | **Vegimal**                 | Schwebt freundlich auf und ab.                 |

### Zauber-Befehle (im Chat mit `T` öffnen)
- `/octopod_hier` – merkt sich den aktuellen Ort als deine Basis.
- `/octopod` – teleportiert dich zurück zu deiner Basis.
- `/vegimal` – setzt ein freundliches Vegimal vor dich.

## Installieren

1. Den ganzen Ordner `octonauts` kopieren nach:
   - **Windows:** `%APPDATA%\Minetest\mods\`
   - **Linux:** `~/.minetest/mods/`
   - **macOS:** `~/Library/Application Support/minetest/mods/`
2. Luanti starten → Welt auswählen → **„Mods konfigurieren"** → `octonauts`
   einschalten (Häkchen). Tipp: Spielt zum Bauen im **Kreativmodus**.
3. Welt starten. Die Blöcke und der Keks liegen im Kreativ-Inventar
   (Suchfeld: `octo` oder `vegimal`).

## Gemeinsam erweitern – Forscher-Aufgaben 🔬

Öffnet `init.lua` mit einem Texteditor. Die Datei ist in nummerierte Teile
geteilt und voll mit Erklärungen. Nach **jeder** Änderung: Welt verlassen und
neu betreten, dann ist die Änderung da.

1. **Leicht:** In Teil 1 beim Steuerpult die Zahl `light_source = 13` auf `5`
   stellen – leuchtet es schwächer? Dann auf `14` – heller?
2. **Leicht:** In Teil 2 aus `core.item_eat(4)` ein `core.item_eat(10)` machen –
   jetzt macht der Keks viel mehr satt.
3. **Mittel:** Eine Textur neu malen! Öffne z. B.
   `textures/octonauts_vegimal.png` in einem Malprogramm und gib dem Vegimal
   ein neues Gesicht. (Standard wiederherstellen: `python3 make_textures.py`)
4. **Mittel:** Einen neuen Block dazu erfinden – kopiere in Teil 1 einen ganzen
   `core.register_node(...)`-Block, gib ihm einen neuen Namen (z. B.
   `octonauts:koralle`) und eine eigene Textur.

Wenn ihr das Lua-Programmieren vertiefen wollt, ist das
**Luanti Modding Book** ein toller, bebilderter Begleiter:
<https://rubenwardy.com/minetest_modding_book/>

## Dateien

- `init.lua` – das eigentliche Mod (mit vielen Kommentaren).
- `mod.conf` – Name & Beschreibung des Mods.
- `textures/` – die Bilder der Blöcke und Wesen.
- `make_textures.py` – erzeugt die Standard-Texturen neu (nur Python nötig).

Viel Spaß beim Forschen! ⚓
