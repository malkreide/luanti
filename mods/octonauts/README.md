# Octonauts Starter-Mod 🐙⚓

Ein kleines Einsteiger-Mod für Luanti, gemacht zum **gemeinsamen Entdecken
und Erweitern** – ideal für ein Kind (ca. 6 Jahre) und einen Elternteil.

Es funktioniert in **jedem** Luanti-Spiel und braucht keine anderen Mods.

## Was ist drin?

### Baublöcke

| Was            | Wie es heißt                | Was es macht                                  |
|----------------|-----------------------------|-----------------------------------------------|
| 🧱 Block       | **Octopod-Wand**            | Weiße Außenwand mit oranger Streife.           |
| 🤍 Block       | **Octopod-Innenwand**       | Sauberes Weiß für das Innere.                  |
| ⬜ Block       | **Octopod-Boden**           | Graues Raster-Muster für den Fußboden.         |
| ⬛ Block       | **Octopod-Dach**            | Dunkle Außendecke mit Rillen.                  |
| ⚙️ Block      | **Octopod-Säule**           | Silbernes Rohr als Stütze oder Deko.           |
| 💡 Block       | **Lichtdecke**              | Leuchtröhren-Decke – **maximale Helligkeit**.  |
| 💡 Block       | **Steuerpult**              | Bunte Knöpfe, leuchtet im Dunkeln.             |
| 🔵 Block       | **Bullauge**                | Rundes Glasfenster, durchsichtig.              |

### Gegenstände & Wesen

| Was            | Wie es heißt                | Was es macht                                  |
|----------------|-----------------------------|-----------------------------------------------|
| 🍪 Gegenstand  | **Vegimal-Keks**            | Draufklicken = essen, gibt Leben zurück.       |
| 🟢 Wesen       | **Vegimal**                 | Schwebt freundlich auf und ab.                 |
| 🟡 Wesen       | **Gup**                     | Fährt selbständig durch die Luft, wechselt alle paar Sekunden die Richtung. |

### Zauber-Befehle (im Chat mit `T` öffnen)
- `/octopod_hier` – merkt sich den aktuellen Ort als deine Basis.
- `/octopod` – teleportiert dich zurück zu deiner Basis.
- `/vegimal` – setzt ein freundliches Vegimal vor dich.
- `/gup` – startet einen Gup direkt vor dir – er fährt dann alleine los!

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

1. **Leicht:** Beim Steuerpult (Teil 1) `light_source = 13` auf `5` stellen –
   leuchtet es schwächer? Dann auf `14` – maximum!
2. **Leicht:** In Teil 2 aus `core.item_eat(4)` ein `core.item_eat(10)` machen –
   jetzt macht der Keks viel mehr satt.
3. **Leicht:** Im Gup (Teil 6) `GUP_GESCHWINDIGKEIT = 2` auf `4` stellen –
   der Gup fährt doppelt so schnell!
4. **Mittel:** `GUP_RICHTUNGSWECHSEL_MIN` und `..._MAX` ändern – macht den Gup
   nervöser (kleine Zahlen) oder ruhiger (große Zahlen).
5. **Mittel:** Eine Textur neu malen! Öffne `textures/octonauts_gup.png` in
   einem Malprogramm und gib dem Gup eine andere Farbe (Gup-B ist blau!).
   Standard wiederherstellen: `python3 make_textures.py`
6. **Fortgeschritten:** Einen neuen Block erfinden – kopiere einen
   `core.register_node(...)`-Block, vergib einen neuen Namen (z. B.
   `octonauts:koralle`) und male eine eigene Textur dazu.

Wenn ihr das Lua-Programmieren vertiefen wollt, ist das
**Luanti Modding Book** ein toller, bebilderter Begleiter:
<https://rubenwardy.com/minetest_modding_book/>

## Dateien

- `init.lua` – das eigentliche Mod (mit vielen Kommentaren).
- `mod.conf` – Name & Beschreibung des Mods.
- `textures/` – die Bilder der Blöcke und Wesen.
- `make_textures.py` – erzeugt die Standard-Texturen neu (nur Python nötig).

Viel Spaß beim Forschen! ⚓
