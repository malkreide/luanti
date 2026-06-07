--[[

  Octonauts Starter-Mod  🐙
  =========================

  Hallo Papa, hallo Forscher!

  Dieses Mod ist EUER Startpunkt. Jeder Abschnitt unten ist klein und macht
  genau EINE Sache. Sucht euch einen Abschnitt aus, aendert eine Zahl oder
  einen Text, speichert die Datei und schaut im Spiel, was passiert.

  Ein paar Dinge zum Wissen:
  * "core" ist das Spiel selbst. "core.irgendwas(...)" heisst:
    "Liebes Spiel, mach bitte irgendwas."
  * Alles was nach zwei Strichen kommt  -- so wie hier --  ist ein Kommentar.
    Das Spiel liest es nicht, es ist nur fuer uns Menschen zum Erklaeren.
  * Nach jeder Aenderung musst du die Welt neu laden (Spiel verlassen und
    wieder betreten), dann ist die Aenderung da.

  Viel Spass beim Forschen!  ⚓

]]

-- Mit "core.get_mod_storage()" bekommen wir einen kleinen Speicher, in dem
-- wir uns Dinge merken koennen - zum Beispiel, wo eure Basis ist.
local speicher = core.get_mod_storage()


--==========================================================================
--  TEIL 1: BAU-BLOECKE FUER DAS OCTOPOD
--==========================================================================
--  Hier bauen wir neue Bloecke. Probiert mal: aendere bei "description"
--  den Namen, oder male die Bild-Datei im Ordner "textures" neu an!

-- Eine weisse Wand mit oranger Streife - die Farben des Octopod.
core.register_node("octonauts:octopod_wall", {
	description = "Octopod-Wand",                       -- Name im Inventar
	tiles = {"octonauts_octopod_wall.png"},            -- Welches Bild?
	groups = {cracky = 3, oddly_breakable_by_hand = 2}, -- laesst sich mit der Hand abbauen
})

-- Ein Steuerpult mit bunten Knoepfen. Das Besondere: es LEUCHTET im Dunkeln!
-- Die Zahl bei "light_source" geht von 1 (ganz schwach) bis 14 (ganz hell).
core.register_node("octonauts:control_panel", {
	description = "Steuerpult (leuchtet)",
	tiles = {"octonauts_control_panel.png"},
	light_source = 13,                                  -- <-- diese Zahl mal aendern!
	groups = {cracky = 3, oddly_breakable_by_hand = 2},
})

-- Ein rundes Bullauge (Fenster), durch das man hindurchschauen kann.
core.register_node("octonauts:bullauge", {
	description = "Bullauge",
	drawtype = "glasslike",                             -- macht es glas-artig
	tiles = {"octonauts_bullauge.png"},
	paramtype = "light",
	sunlight_propagates = true,                         -- Licht scheint hindurch
	use_texture_alpha = "clip",
	groups = {cracky = 3, oddly_breakable_by_hand = 2},
})


--==========================================================================
--  TEIL 2: DER VEGIMAL-KEKS  (etwas zum Essen)
--==========================================================================
--  "register_craftitem" macht einen Gegenstand, der KEIN Block ist.
--  "core.item_eat(4)" heisst: beim Benutzen wird er gegessen und gibt
--  4 Punkte Leben zurueck. Mach aus der 4 ruhig eine 10 - dann macht der
--  Keks richtig satt!

core.register_craftitem("octonauts:vegimal_cookie", {
	description = "Vegimal-Keks (zum Essen draufklicken)",
	inventory_image = "octonauts_vegimal_cookie.png",
	on_use = core.item_eat(4),                          -- <-- diese Zahl mal aendern!
})


--==========================================================================
--  TEIL 3: DAS VEGIMAL  (ein freundliches Wesen)
--==========================================================================
--  Das ist ein "Entity" - eine Figur, die im Spiel herumsteht. Unser
--  Vegimal schwebt sanft auf und ab und lacht. Spawnen kann man es weiter
--  unten mit dem Befehl  /vegimal

core.register_entity("octonauts:vegimal", {
	initial_properties = {
		visual = "sprite",                              -- ein flaches Bild, das dich immer ansieht
		textures = {"octonauts_vegimal.png"},
		visual_size = {x = 1, y = 1},
		collisionbox = {-0.4, -0.5, -0.4, 0.4, 0.5, 0.4},
		physical = false,                               -- faellt nicht herunter, es schwebt
	},

	on_activate = function(self)
		self.zeit = 0
	end,

	on_step = function(self, dtime)
		-- Wir lassen es sanft auf und ab schweben.
		self.zeit = self.zeit + dtime
		local hoch_runter = math.sin(self.zeit * 2) * 0.4
		self.object:set_velocity({x = 0, y = hoch_runter, z = 0})
	end,
})


--==========================================================================
--  TEIL 4: ZAUBER-BEFEHLE  (im Chat mit  T  oeffnen, dann eintippen)
--==========================================================================

-- /octopod_hier  -> merkt sich deinen aktuellen Standort als "Basis"
core.register_chatcommand("octopod_hier", {
	description = "Merkt sich diesen Ort als deine Octopod-Basis",
	func = function(name, param)
		local spieler = core.get_player_by_name(name)
		if not spieler then
			return false, "Kein Spieler gefunden."
		end
		local pos = spieler:get_pos()
		speicher:set_string(name .. "_basis", core.pos_to_string(pos))
		return true, "Basis gespeichert! Mit /octopod kommst du hierher zurueck."
	end,
})

-- /octopod  -> bringt dich zurueck zu deiner gemerkten Basis
core.register_chatcommand("octopod", {
	description = "Teleportiert dich zu deiner Octopod-Basis",
	func = function(name, param)
		local spieler = core.get_player_by_name(name)
		if not spieler then
			return false, "Kein Spieler gefunden."
		end
		local gespeichert = speicher:get_string(name .. "_basis")
		if gespeichert == "" then
			return false, "Noch keine Basis! Stell dich irgendwohin und tippe /octopod_hier"
		end
		spieler:set_pos(core.string_to_pos(gespeichert))
		return true, "Willkommen zurueck im Octopod! 🐙"
	end,
})

-- /vegimal  -> setzt ein freundliches Vegimal direkt vor dich
core.register_chatcommand("vegimal", {
	description = "Setzt ein freundliches Vegimal vor dich",
	func = function(name, param)
		local spieler = core.get_player_by_name(name)
		if not spieler then
			return false, "Kein Spieler gefunden."
		end
		-- Ein bisschen vor den Spieler, in Blickrichtung, auf Augenhoehe.
		local pos = spieler:get_pos()
		local blick = spieler:get_look_dir()
		local ziel = {
			x = pos.x + blick.x * 2,
			y = pos.y + 1,
			z = pos.z + blick.z * 2,
		}
		core.add_entity(ziel, "octonauts:vegimal")
		return true, "Ein Vegimal ist aufgetaucht! 🟢"
	end,
})


-- Eine kleine Nachricht ins Server-Log, damit man sieht: das Mod laeuft.
core.log("action", "[octonauts] Das Octonauts-Starter-Mod ist geladen. Gute Reise! ⚓")
