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


--==========================================================================
--  TEIL 5: OCTOPOD-BAUSET  (passende Bloecke zum Zusammenbauen)
--==========================================================================
--  Alle diese Bloecke passen farblich und stilistisch zusammen.
--  Probiert mal: baut einen Raum aus Innenwand + Boden + Dach + Saeule +
--  Lichtdecke und schaut, wie ein echtes Octopod-Zimmer aussehen koennte!

-- Saubere weisse Innenwand (fuer das Innere des Octopod)
core.register_node("octonauts:inner_wall", {
	description = "Octopod-Innenwand (weiss)",
	tiles = {"octonauts_inner_wall.png"},
	groups = {cracky = 3, oddly_breakable_by_hand = 2},
})

-- Grauer Boden mit Raster-Muster
core.register_node("octonauts:floor", {
	description = "Octopod-Boden",
	tiles = {"octonauts_floor.png"},
	groups = {cracky = 3, oddly_breakable_by_hand = 2},
})

-- Dunkles Dach / Decke von aussen
core.register_node("octonauts:roof", {
	description = "Octopod-Dach",
	tiles = {"octonauts_roof.png"},
	groups = {cracky = 3, oddly_breakable_by_hand = 2},
})

-- Silberne Saeule  (Forscher-Aufgabe fuer spaeter: mache sie mit "nodebox"
-- rund und duenner -- dann sieht sie wie eine echte Saeule aus!)
core.register_node("octonauts:column", {
	description = "Octopod-Saeule (silber)",
	tiles = {"octonauts_column.png"},
	groups = {cracky = 3, oddly_breakable_by_hand = 2},
})

-- Leuchtende Decken-Lichtroehren  (leuchtet hell wie eine Raumstation)
core.register_node("octonauts:light_panel", {
	description = "Lichtdecke (leuchtet sehr hell)",
	tiles = {"octonauts_light_panel.png"},
	light_source = 14,                              -- maximale Helligkeit!
	groups = {cracky = 3, oddly_breakable_by_hand = 2},
})


--==========================================================================
--  TEIL 6: DER GUP  (ein fahrendes Mini-U-Boot)
--==========================================================================
--  Der Gup ist ein echtes Fahrzeug aus der Octonauts-Welt.
--  Er schwimmt durch die Luft (und auch durch Wasser!) und wechselt
--  alle paar Sekunden selbstaendig die Richtung.
--
--  Probiert mal: aendere "geschwindigkeit" von 2 auf 4 -- dann faehrt der
--  Gup doppelt so schnell!

local GUP_GESCHWINDIGKEIT = 2          -- <-- diese Zahl mal aendern!
local GUP_RICHTUNGSWECHSEL_MIN = 2     -- mindestens 2 Sekunden geradeaus
local GUP_RICHTUNGSWECHSEL_MAX = 5     -- hoechstens 5 Sekunden geradeaus

core.register_entity("octonauts:gup", {
	initial_properties = {
		visual          = "sprite",
		textures        = {"octonauts_gup.png"},
		visual_size     = {x = 2.5, y = 2.0},      -- gross genug um ihn gut zu sehen
		collisionbox    = {-1.0, -0.7, -1.0, 1.0, 0.7, 1.0},
		physical        = false,                    -- schwebt, faellt nicht
		static_save     = false,                    -- verschwindet beim Neuladen
	},

	on_activate = function(self)
		self.zeit         = 0
		self.richtung_t   = 0
		self.naechste_wahl = 0         -- sofort eine Richtung wuerfeln
		self.vx           = 0
		self.vy           = 0
		self.vz           = 0
	end,

	on_step = function(self, dtime)
		self.zeit       = self.zeit + dtime
		self.richtung_t = self.richtung_t + dtime

		-- Zeit fuer einen Richtungswechsel?
		if self.richtung_t >= self.naechste_wahl then
			self.richtung_t  = 0
			self.naechste_wahl = GUP_RICHTUNGSWECHSEL_MIN +
				math.random() * (GUP_RICHTUNGSWECHSEL_MAX - GUP_RICHTUNGSWECHSEL_MIN)

			if math.random() < 0.15 then
				-- manchmal kurz anhalten (wie ein echter Gup, der schaut)
				self.vx, self.vy, self.vz = 0, 0, 0
			else
				-- zufaelligen Winkel wuerfeln (horizontal)
				local winkel = math.random() * math.pi * 2
				local hoch   = (math.random() - 0.5) * GUP_GESCHWINDIGKEIT * 0.6
				self.vx = math.cos(winkel) * GUP_GESCHWINDIGKEIT
				self.vy = hoch
				self.vz = math.sin(winkel) * GUP_GESCHWINDIGKEIT
				-- Gup in Fahrtrichtung drehen
				self.object:set_yaw(math.atan2(-self.vx, -self.vz))
			end
		end

		-- Geschwindigkeit setzen (mit sanftem Auf-Ab-Schwingen ueberlagert)
		local schwingen = math.sin(self.zeit * 1.8) * 0.25
		self.object:set_velocity({
			x = self.vx,
			y = self.vy + schwingen,
			z = self.vz,
		})
	end,
})

-- /gup  -> setzt einen Gup direkt vor den Spieler
core.register_chatcommand("gup", {
	description = "Setzt einen Gup vor dich (er faehrt dann alleine los!)",
	func = function(name, param)
		local spieler = core.get_player_by_name(name)
		if not spieler then
			return false, "Kein Spieler gefunden."
		end
		local pos  = spieler:get_pos()
		local blick = spieler:get_look_dir()
		local ziel = {
			x = pos.x + blick.x * 3,
			y = pos.y + 1.5,
			z = pos.z + blick.z * 3,
		}
		core.add_entity(ziel, "octonauts:gup")
		return true, "Gup startet! Haltet euch fest! 🟡🐙"
	end,
})


-- Eine kleine Nachricht ins Server-Log, damit man sieht: das Mod laeuft.
core.log("action", "[octonauts] Das Octonauts-Starter-Mod ist geladen. Gute Reise! ⚓")
