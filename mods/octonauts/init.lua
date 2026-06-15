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
		-- Tuut-Tuut! (Sound-Datei liegt in sounds/octonauts_gup_horn.ogg)
		core.sound_play("octonauts_gup_horn", {
			pos             = ziel,
			gain            = 1.0,
			max_hear_distance = 32,
		})
		return true, "Gup startet! Haltet euch fest! 🟡🐙"
	end,
})


--==========================================================================
--  TEIL 7: KORALLENRIFF-BAUSET
--==========================================================================
--  Diese Bloecke sind fuer das Meer gemacht!
--  Baut sie zusammen mit Wasser fuer ein echtes Oktonauten-Riff.
--  Probiert mal: stellt euch ins Wasser und tippt /korallen_bauen
--  dann erscheint ein ganzes Riff um euch herum!

-- Rote Ast-Koralle (waechst wie ein Baum)
core.register_node("octonauts:coral_red", {
	description = "Rote Koralle",
	tiles = {"octonauts_coral_red.png"},
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
})

-- Blaue Faecher-Koralle
core.register_node("octonauts:coral_blue", {
	description = "Blaue Koralle",
	tiles = {"octonauts_coral_blue.png"},
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
})

-- Gehirnkoralle (sieht aus wie ein Gehirn, das ist kein Witz!)
core.register_node("octonauts:coral_brain", {
	description = "Gehirnkoralle",
	tiles = {"octonauts_coral_brain.png"},
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
})

-- Meeresboden-Sand (etwas dunkler als normaler Sand)
core.register_node("octonauts:ocean_sand", {
	description = "Meeresboden-Sand",
	tiles = {"octonauts_ocean_sand.png"},
	groups = {crumbly = 3, oddly_breakable_by_hand = 3},
})

-- Unterwasserfels mit gruenen Algen-Flecken
core.register_node("octonauts:ocean_rock", {
	description = "Unterwasserfels (mit Algen)",
	tiles = {"octonauts_ocean_rock.png"},
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
})

-- Seegras (Pflanze: geht durch Wasser, kann man nicht draufstehen)
core.register_node("octonauts:seagrass", {
	description = "Seegras",
	drawtype = "plantlike",                         -- flache Pflanzen-Darstellung
	tiles = {"octonauts_seagrass.png"},
	inventory_image = "octonauts_seagrass.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,                            -- kann durch Wasser ersetzt werden
	groups = {oddly_breakable_by_hand = 3, flora = 1},
})

-- Seeanemone (Pflanze: bunte Tentakel)
core.register_node("octonauts:anemone", {
	description = "Seeanemone",
	drawtype = "plantlike",
	tiles = {"octonauts_anemone.png"},
	inventory_image = "octonauts_anemone.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {oddly_breakable_by_hand = 3, flora = 1},
})


--==========================================================================
--  TEIL 8: BAUMEISTER-BEFEHLE
--==========================================================================
--  Mit diesen Befehlen erschafft ihr auf Knopfdruck eine fertige Welt!
--
--  /octopod_bauen  -->  ein ganzes Octopod-Zimmer waechst um euch herum
--  /korallen_bauen -->  ein Korallenriff erscheint vor euren Fuessen

-- Hilfsfunktion: setzt einen Block an einer Position relativ zum Spieler
local function s(basis, dx, dy, dz, block)
	core.set_node({
		x = basis.x + dx,
		y = basis.y + dy,
		z = basis.z + dz,
	}, {name = block})
end

-- Hilfsfunktion: raeume einen quaderfoermigen Bereich leer (Luft)
local function leere(basis, x1, y1, z1, x2, y2, z2)
	for dx = x1, x2 do
		for dy = y1, y2 do
			for dz = z1, z2 do
				s(basis, dx, dy, dz, "air")
			end
		end
	end
end

-- /octopod_bauen  -----------------------------------------------------------
core.register_chatcommand("octopod_bauen", {
	description = "Baut ein Octopod-Zimmer um den Spieler herum",
	privs = {interact = true},
	func = function(name, param)
		local spieler = core.get_player_by_name(name)
		if not spieler then return false, "Kein Spieler gefunden." end

		-- Spielerposition auf ganze Zahl runden (Bloecke sind ganze Zahlen)
		local p = vector.floor(spieler:get_pos())

		-- Masse: hw = halbe Breite (Raum wird 2*hw+1 = 9 Bloecke breit)
		--         ht = Innenhoehe (4 Bloecke - gut fuer Spieler + Luft)
		local hw, ht = 4, 4

		-- 1. Alles erst leeren (damit kein alter Block steckenbleibt)
		leere(p, -hw, -1, -hw, hw, ht, hw)

		-- 2. Boden
		for dx = -hw, hw do
			for dz = -hw, hw do
				s(p, dx, -1, dz, "octonauts:floor")
			end
		end

		-- 3. Leuchtende Decke
		for dx = -hw, hw do
			for dz = -hw, hw do
				s(p, dx, ht, dz, "octonauts:light_panel")
			end
		end

		-- 4. Vier Ausssenwaende
		for dy = 0, ht - 1 do
			for i = -hw, hw do
				s(p,   i, dy, -hw, "octonauts:octopod_wall")  -- Suedwand
				s(p,   i, dy,  hw, "octonauts:octopod_wall")  -- Nordwand
				s(p, -hw, dy,   i, "octonauts:octopod_wall")  -- Westwand
				s(p,  hw, dy,   i, "octonauts:octopod_wall")  -- Ostwand
			end
		end

		-- 5. Bullaugen: je eines in der Mitte jeder Wand, auf halber Hoehe
		local my = math.floor(ht / 2)
		s(p,   0, my, -hw, "octonauts:bullauge")
		s(p,   0, my,  hw, "octonauts:bullauge")
		s(p, -hw, my,   0, "octonauts:bullauge")
		s(p,  hw, my,   0, "octonauts:bullauge")

		-- 6. Innensaeulen an den vier Ecken (eine Reihe innen)
		local ci = hw - 1
		for dy = 0, ht - 1 do
			s(p, -ci, dy, -ci, "octonauts:column")
			s(p,  ci, dy, -ci, "octonauts:column")
			s(p, -ci, dy,  ci, "octonauts:column")
			s(p,  ci, dy,  ci, "octonauts:column")
		end

		-- 7. Steuerpult an der Suedseite (innen, am Boden)
		s(p, 0, 0, -(hw - 1), "octonauts:control_panel")

		return true, "Das Octopod ist gebaut! Schaut euch um! 🐙  (Tipp: /octopod_hier nicht vergessen)"
	end,
})


-- /korallen_bauen  ----------------------------------------------------------
core.register_chatcommand("korallen_bauen", {
	description = "Laesst ein Korallenriff um den Spieler herum entstehen",
	privs = {interact = true},
	func = function(name, param)
		local spieler = core.get_player_by_name(name)
		if not spieler then return false, "Kein Spieler gefunden." end

		local p = vector.floor(spieler:get_pos())
		local sz = 5   -- Halbgroesse: Riff ist 11x11 Bloecke

		-- 1. Bereich leeren und Meeresboden legen
		leere(p, -sz, 0, -sz, sz, 6, sz)
		for dx = -sz, sz do
			for dz = -sz, sz do
				s(p, dx, -1, dz, "octonauts:ocean_sand")
			end
		end

		-- 2. Korallengruppen (vordesigntes Layout)
		--    Format: {dx, dz, hoehe, block}
		local korallen = {
			-- rote Gruppe (links hinten)
			{-4, -4, 3, "octonauts:coral_red"},
			{-3, -4, 2, "octonauts:coral_red"},
			{-4, -3, 2, "octonauts:coral_red"},
			{-3, -3, 4, "octonauts:coral_red"},
			-- blaue Gruppe (rechts vorne)
			{ 3,  3, 3, "octonauts:coral_blue"},
			{ 4,  3, 2, "octonauts:coral_blue"},
			{ 3,  4, 4, "octonauts:coral_blue"},
			{ 4,  4, 2, "octonauts:coral_blue"},
			-- Gehirnkorallen (rechts hinten + links vorne)
			{ 3, -4, 2, "octonauts:coral_brain"},
			{ 4, -3, 2, "octonauts:coral_brain"},
			{-4,  3, 2, "octonauts:coral_brain"},
			{-3,  4, 2, "octonauts:coral_brain"},
			-- Mitte: grosser Korallen-Turm
			{ 0,  0, 5, "octonauts:coral_red"},
			{ 1,  0, 3, "octonauts:coral_blue"},
			{-1,  0, 3, "octonauts:coral_blue"},
			{ 0,  1, 4, "octonauts:coral_brain"},
			{ 0, -1, 3, "octonauts:coral_brain"},
		}
		for _, k in ipairs(korallen) do
			for dy = 0, k[3] - 1 do
				s(p, k[1], dy, k[2], k[4])
			end
		end

		-- 3. Felsen (leicht erhoben)
		local felsen = {{-4, 0}, {0, -4}, {4, -1}, {-2, 4}, {2, -3}, {-5, -2}, {5, 2}}
		for _, f in ipairs(felsen) do
			s(p, f[1],  0, f[2], "octonauts:ocean_rock")
			s(p, f[1],  1, f[2], "octonauts:ocean_rock")
		end

		-- 4. Seegras (ueberall auf dem Sand verteilt)
		local gras = {
			{-2,-1},{-1,-2},{ 1, 1},{ 2,-1},{ 0, 2},{-1, 1},
			{ 3, 0},{ 0,-3},{-3, 0},{ 1,-2},{-2, 2},{ 4,-2},
			{-4, 1},{ 2, 4},{ 0, 3},{-3,-1},{ 1,-4},{-1, 3},
		}
		for _, g in ipairs(gras) do
			s(p, g[1], 0, g[2], "octonauts:seagrass")
		end

		-- 5. Seeanemonen (etwas seltener, an schattigen Stellen)
		local anemonen = {{-4, 2},{3, -3},{-2, 5},{4, -5},{-5, 4},{1, 5}}
		for _, a in ipairs(anemonen) do
			s(p, a[1], 0, a[2], "octonauts:anemone")
		end

		return true, "Ein Korallenriff ist aufgetaucht! Willkommen in der Tiefsee! 🪸🐠"
	end,
})


--==========================================================================
--  TEIL 9: DIE KRABBE  (ein echtes Tier - braucht eine "Mob-API")
--==========================================================================
--  Bis hierher kam unser Mod ganz ohne Hilfe aus. Bloecke, Keks, Gup und
--  Vegimal haben wir komplett selbst gebaut.
--
--  Ein "richtiges" Tier ist aber viel Arbeit: Es soll herumlaufen, Leben
--  (Herzen) haben, vor Gefahr fliehen, vielleicht gezaehmt werden ...
--  Dafuer gibt es fertige Helfer-Mods, eine sogenannte "Mob-API":
--
--    * mobs_redo  (heisst als Mod "mobs")  -> fuer Minetest Game & Co.
--    * mcl_mobs                             -> fuer VoxeLibre / Mineclonia
--
--  Wir machen die Krabbe OPTIONAL: Ist eine dieser Mob-APIs da, bekommst du
--  eine echte, laufende Krabbe. Ist KEINE da, ueberspringen wir sie einfach -
--  alles andere im Mod funktioniert trotzdem ganz normal weiter.

-- Zuerst nachschauen, welche Mob-API ueberhaupt vorhanden ist.
-- "core.get_modpath(...)" gibt den Ordner zurueck, wenn die Mod da ist -
-- sonst "nil" (also "nichts").
local hat_mobs_redo = core.get_modpath("mobs")     ~= nil
local hat_mcl_mobs  = core.get_modpath("mcl_mobs") ~= nil

if hat_mobs_redo then
	-- ===== Variante A: mobs_redo (Minetest Game) ==========================
	mobs:register_mob("octonauts:krabbe", {
		type            = "animal",                 -- ein friedliches Tier
		passive         = true,                     -- tut niemandem etwas
		hp_min          = 5,
		hp_max          = 10,
		armor           = 100,
		collisionbox    = {-0.3, -0.3, -0.3, 0.3, 0.0, 0.3},
		visual          = "sprite",                 -- flaches Bild wie beim Vegimal
		textures        = {{"octonauts_krabbe.png"}},
		visual_size     = {x = 0.9, y = 0.9},
		makes_footstep_sound = false,
		walk_velocity   = 1,                        -- gemuetliches Krabbeltempo
		run_velocity    = 2,                        -- wenn sie erschrickt
		jump            = true,
		view_range      = 8,
		fall_damage     = false,
		water_damage    = 0,                        -- Krabben moegen Wasser :)
		fear_height     = 4,
	})
	-- Spawn-Ei fuers Kreativ-Inventar (zum Hinsetzen der Krabbe):
	mobs:register_egg("octonauts:krabbe", "Octonauts-Krabbe",
		"octonauts_krabbe.png")

elseif hat_mcl_mobs then
	-- ===== Variante B: mcl_mobs (VoxeLibre / Mineclonia) ==================
	mcl_mobs.register_mob("octonauts:krabbe", {
		type            = "animal",
		passive         = true,
		hp_min          = 5,
		hp_max          = 10,
		xp_min          = 1,
		xp_max          = 3,
		armor           = 100,
		collisionbox    = {-0.3, -0.3, -0.3, 0.3, 0.0, 0.3},
		visual          = "sprite",
		textures        = {{"octonauts_krabbe.png"}},
		visual_size     = {x = 0.9, y = 0.9},
		makes_footstep_sound = false,
		walk_velocity   = 1,
		run_velocity    = 2,
		jump            = true,
		view_range      = 8,
		fall_damage     = false,
		water_damage    = 0,
		fear_height     = 4,
	})
	-- Spawn-Ei (mcl_mobs nutzt zwei Farben fuer das Ei-Aussehen):
	mcl_mobs.register_egg("octonauts:krabbe", "Octonauts-Krabbe",
		"#dc4628", "#96281466")
end

-- /krabbe  -> setzt eine Krabbe vor dich (falls eine Mob-API vorhanden ist)
core.register_chatcommand("krabbe", {
	description = "Setzt eine Krabbe vor dich (braucht eine Mob-API)",
	func = function(name, param)
		local spieler = core.get_player_by_name(name)
		if not spieler then
			return false, "Kein Spieler gefunden."
		end

		-- Gibt es ueberhaupt eine Krabbe? Nur wenn eine Mob-API da war.
		if not (hat_mobs_redo or hat_mcl_mobs) then
			return false, "Fuer eine echte Krabbe brauchst du eine Mob-API "
				.. "(mobs_redo oder mcl_mobs). Alles andere im Mod geht aber!"
		end

		-- Ein Stueck vor den Spieler, in Blickrichtung, auf den Boden.
		local pos   = spieler:get_pos()
		local blick = spieler:get_look_dir()
		local ziel  = {
			x = pos.x + blick.x * 2,
			y = pos.y,
			z = pos.z + blick.z * 2,
		}
		core.add_entity(ziel, "octonauts:krabbe")
		return true, "Eine Krabbe krabbelt heran! 🦀"
	end,
})

-- Eine Notiz ins Log, damit man sieht, welcher Fall eingetreten ist.
if hat_mobs_redo then
	core.log("action", "[octonauts] Mob-API 'mobs_redo' gefunden - Krabbe ist aktiv. 🦀")
elseif hat_mcl_mobs then
	core.log("action", "[octonauts] Mob-API 'mcl_mobs' gefunden - Krabbe ist aktiv. 🦀")
else
	core.log("action", "[octonauts] Keine Mob-API gefunden - die Krabbe wird "
		.. "uebersprungen, alles andere laeuft normal weiter.")
end


-- Eine kleine Nachricht ins Server-Log, damit man sieht: das Mod laeuft.
core.log("action", "[octonauts] Das Octonauts-Starter-Mod ist geladen. Gute Reise! ⚓")
