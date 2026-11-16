--!strict
local S = if script then require(script.Parent.Parent.Shared.Shot) else require("../shared/Shot")
local a, p, c, s = S.actor, S.prop, S.camera, S.make
local film = {
	id = "power",
	title = "My Power Stops When You Look at Me",
	story = "stories/01-my-power-stops-when-you-look.md",
	shots = {
		s(
			"tryouts",
			6,
			"At superhero tryouts, Maya lifted a bench. Noah floated above it.",
			c(-1, 6, -21, 0, 3, 0),
			{ Maya = a(-3, 0, 0, "lift"), Noah = a(3, 2, 0) },
			{ Bench = p(-3, 4, 1) }
		),
		s(
			"watched",
			5,
			"I stood on the starting line. Everyone watched. Nothing happened.",
			c(0, 4, -9, 0, 3, 0),
			{
				Eli = a(0, 0, 0, "strain", nil, 0, "sad"),
				Maya = a(-5, 0, -2, "idle", nil, -112),
				Noah = a(5, 0, -2, "idle", nil, 112),
			}
		),
		s(
			"rule",
			6,
			"My power only works when nobody can see me. Difficult to prove in front of an audience.",
			c(1, 5, -11, 0, 3, 0, { -1, 5, -10 }),
			{ Eli = a(0, 0, 0, "idle", nil, 0, "sad") },
			{ RejectionSlip = p(1.5, 0, -0.8) }
		),
		s(
			"caretaker",
			5,
			'Dad was mopping outside. "How did it go?"',
			c(-9, 5, -10, -5, 3, 0),
			{ Eli = a(-3, 0, 0), Dad = a(-7, 0, 0, "reach") },
			{ Mop = p(-7, 0, -1) }
		),
		s(
			"rejected",
			5,
			'I showed him the rejection slip. "Walk home with me?"',
			c(-3, 4, -9, -5, 3, 0),
			{ Eli = a(-3, 0, 0, "reach"), Dad = a(-7, 0, 0) },
			{ RejectionSlip = p(-4, 0, -1), Mop = p(-8, 0, 0) }
		),
		s(
			"cloth",
			5,
			"I wanted to be alone. Behind me, Dad covered a security camera with his cloth.",
			c(-7, 6, -11, -5, 4, 0),
			{ Eli = a(-3, 0, 0, "walk", { 4, 0, -5 }), Dad = a(-7, 0, 0, "reach") },
			{ SecurityCamera = p(-7, 0, 0), CleaningCloth = p(-7, 0, -0.65) },
			{ cue = "cloth" }
		),
		s(
			"arrival",
			5,
			"Then the courtyard gate folded inward. A man in a mirrored helmet walked through.",
			c(4, 6, -5, 0, 3, -17),
			{ Lens = a(0, 0, -22, "walk", { 0, 0, -15 }, 180) },
			{},
			{ gateFrom = 0, gateAngle = 85, cue = "impact" }
		),
		s(
			"core",
			5,
			"He was looking for the school's power core.",
			c(2, 4, -6, 0, 3, -15),
			{ Lens = a(0, 0, -15, "point", nil, 180) },
			{ PowerCore = p(0, 0, 15) }
		),
		s(
			"pinned",
			5,
			"He sent a bench across the yard. Noah's leg was trapped.",
			c(8, 5, -7, 4, 2, 0),
			{ Noah = a(4, 0, 0, "scared", nil, 0, "scared"), Lens = a(0, 0, -15, "point", nil, 180) },
			{ Bench = p(-9, 0, 0, { 4, 0, 0 }) },
			{ cue = "impact" }
		),
		s(
			"blindspot",
			5,
			"Lens turned toward the exit. For half a second, nobody was looking at Noah.",
			c(-8, 6, -8, 0, 3, 0),
			{
				Eli = a(-7, 0, 3, "run", { 2, 0, 1 }),
				Lens = a(0, 0, -15, "point", nil, 90),
				Noah = a(4, 0, 0, "scared"),
			},
			{ Bench = p(4, 0, 0) }
		),
		s(
			"firstrescue",
			4,
			"When he turned back, the bench was empty.",
			c(7, 4, -7, 4, 1, 0),
			{ Lens = a(0, 0, -15, "idle", nil, 180, "angry") },
			{ Bench = p(4, 0, 0) },
			{ cue = "whoosh" }
		),
		s(
			"stairs",
			5,
			"Maya was trapped on the stairs. I knocked over a bin.",
			c(10, 7, 4, 17, 5, 19),
			{ Maya = a(17, 3.4, 19, "scared", nil, 0, "scared"), Eli = a(8, 0, 10, "point") },
			{ Bin = p(8, 0, 9, { 10, 0, 9 }) },
			{ cue = "impact" }
		),
		s(
			"secondrescue",
			5,
			"Lens looked toward the sound. Maya landed beside Noah at the gate.",
			c(7, 5, -30, 3, 3, -23),
			{ Maya = a(1, 0, -23, "scared"), Noah = a(5, 0, -23, "sit"), Eli = a(-1, 0, -23, "run") },
			{},
			{ cue = "whoosh" }
		),
		s(
			"spotted",
			5,
			'Lens looked at the stairs. Then straight at me. "There you are."',
			c(1, 4.8, -8, 0, 4, -15),
			{ Lens = a(0, 0, -15, "point", nil, 180, "angry"), Eli = a(0, 0, 0, "scared") }
		),
		s(
			"dust",
			5,
			'I threw dust. Two lights blinked on his helmet. "Cameras."',
			c(0, 5, -9, 0, 4, -15),
			{ Lens = a(0, 0, -15, "idle", nil, 180), Eli = a(0, 0, -6, "point") },
			{ Dust = p(0, 1, -13) },
			{ lenses = "red", cue = "beep" }
		),
		s(
			"nightvision",
			5,
			"I cut the lights. His lenses turned green. Night vision.",
			c(0, 5, -9, 0, 4.5, -15),
			{ Lens = a(0, 0, -15, "idle", nil, 180) },
			{},
			{ night = true, lenses = "green", cue = "beep" }
		),
		s(
			"laststudent",
			5,
			"Across the yard, the damaged landing began to sink. One student was still on it.",
			c(9, 8, 6, 17, 5, 21),
			{ Ada = a(17, 3.4, 21, "scared", { 17, 3.1, 21 }, 0, "scared") },
			{},
			{ landingDrop = 0.3, cue = "creak" }
		),
		s(
			"dadarrives",
			5,
			'Dad stepped out with his mop. "School is closed."',
			c(-6, 5, -23, -4, 3, -12),
			{ Dad = a(-8, 0, -12, "walk", { -6, 0, -12 }), Lens = a(0, 0, -15, "idle", nil, 90) },
			{ Mop = p(-6, 0, -13) }
		),
		s(
			"burst",
			4,
			"Dad moved three metres in a blink. Then dropped to one knee.",
			c(-5, 5, -23, -3, 3, -12),
			{ Dad = a(-6, 0, -12, "strain", { -3, 0, -12 }), Lens = a(0, 0, -15, "idle", nil, 90) },
			{},
			{ cue = "whoosh" }
		),
		s(
			"inheritance",
			6,
			'"You too?" "Since I was your age."',
			c(-3, 4, -20, -3, 2, -12),
			{ Dad = a(-3, 0, -12, "kneel", nil, 0, "sad"), Eli = a(-7, 0, -9, "scared") },
			{ Mop = p(-4, 0, -12) }
		),
		s(
			"strain",
			6,
			"Both cameras turned toward him. Dad stood. Another impossible step.",
			c(-1, 5, -22, -2, 3, -12),
			{
				Dad = a(-3, 0, -12, "strain", { -2, 0, -12 }, 0, "angry"),
				Lens = a(0, 0, -15, "point", nil, 90),
			},
			{ Mop = p(-3, 0, -12) },
			{ lenses = "green", cue = "creak" }
		),
		s(
			"realization",
			6,
			"He wasn't trying to reach Lens. He was moving between us.",
			c(0, 8, -27, 0, 3, -10),
			{
				Dad = a(-2, 0, -12, "strain", { 0, 0, -12 }),
				Lens = a(0, 0, -15, "point", nil, 180),
				Eli = a(0, 0, -5),
			}
		),
		s(
			"dontwatch",
			5,
			'"Eli. Stop watching me." I looked toward the student.',
			c(4, 5, -8, 0, 3, -5),
			{ Eli = a(0, 0, -5, "idle", nil, -147, "scared"), Dad = a(0, 0, -12, "shield") }
		),
		s(
			"covered",
			5,
			"Dad lifted his coat across the lenses. The landing broke.",
			c(5, 7, -17, 0, 4, -13),
			{ Dad = a(0, 0, -12, "shield", nil, 180), Lens = a(0, 0, -15, "scared", nil, 180) },
			{ CoatShield = p(0, 1.5, -14.1) },
			{ landingDrop = 2, cue = "impact" }
		),
		s(
			"catch",
			5,
			"Behind the coat, I moved. Caught her. Carried her through the exit.",
			c(10, 11, 7, 17, 6, 19),
			{ Eli = a(10, 0, 12, "run", { 17, 0.4, 19 }), Ada = a(17, 3.2, 21, "fall", nil, 0, "scared") },
			{},
			{ landingDrop = 2.6, cue = "whoosh" }
		),
		s(
			"release",
			4,
			"Then I pulled the emergency shutter release.",
			c(-7, 4, -25, -9, 3, -19),
			{ Eli = a(-9, 0, -19, "point") },
			{ Release = p(-9, 0, -20) },
			{ cue = "beep" }
		),
		s(
			"contained",
			5,
			"The steel gate dropped between Lens and the school. Dad was on our side.",
			c(0, 7, -34, 0, 4, -20),
			{
				Eli = a(-6, 0, -24),
				Dad = a(-2, 0, -24, "kneel"),
				Maya = a(3, 0, -24),
				Noah = a(7, 0, -24),
				Ada = a(9, 0, -24),
				Lens = a(0, 0, -15, "idle", nil, 180, "angry"),
			},
			{},
			{ shutterFrom = 0, shutter = 1, cue = "impact" }
		),
		s(
			"after",
			6,
			'Later, Dad sat with an ice pack on his knee. "You could have told me."',
			c(-4, 5, -10, 0, 3, 0),
			{ Dad = a(-1.5, 0, 0, "sit"), Eli = a(2, 0, 0) },
			{ Bench = p(0, 0, 0), IcePack = p(-1.5, 1.6, -0.7) }
		),
		s(
			"tryagain",
			6,
			'He handed me the slip. On the back, a starting line. "Try again?"',
			c(1, 4, -9, 0, 3, 0),
			{ Dad = a(-2, 0, 0, "reach"), Eli = a(2, 0, 0) },
			{ StartingSlip = p(0, 0, -1) }
		),
		s(
			"onestep",
			6,
			'He watched. I took one ordinary step. "That is where I started," he said.',
			c(2, 5, -12, 0, 3, 0, { 1, 5, -11 }),
			{
				Dad = a(-2, 0, 0, "idle", nil, -90, "happy"),
				Eli = a(2, 0, 0, "walk", { 2, 0, -0.7 }, 0, "happy"),
			}
		),
	},
}

-- Explicit sequence defaults are expanded once, so every shot remains independently seekable.
local byId = {}
for _, shot in film.shots do
	byId[shot.id] = shot
end
local blackout = false
local evening = false
for _, shot in film.shots do
	if shot.id == "arrival" then
		evening = true
	end
	if shot.id == "after" then
		evening = false
	end
	if shot.id == "nightvision" then
		blackout = true
	end
	if shot.id == "after" then
		blackout = false
	end
	shot.night = blackout
	shot.clockTime = if evening then 19 else 14
	if blackout then
		shot.lenses = "green"
	end
end
byId.blindspot.actors.Eli.travel = { 0.45, 0.5 }
byId.burst.actors.Dad.travel = { 0.4, 0.45 }
byId.catch.actors.Eli.travel = { 0.35, 0.4 }
return film
