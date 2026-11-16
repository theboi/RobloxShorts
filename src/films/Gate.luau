--!strict
local S = if script then require(script.Parent.Parent.Shared.Shot) else require("../shared/Shot")
local a, p, c, s = S.actor, S.prop, S.camera, S.make
return {
	id = "gate",
	title = "The Monster at the School Gate",
	story = "stories/02-the-monster-at-the-school-gate.md",
	shots = {
		s(
			"guard",
			6,
			"Our school hired a monster to keep monsters out. It was taller than the gate.",
			c(7, 9, -38, 0, 4, -19),
			{ Bristle = a(0, 0, -19), Nia = a(-7, 0, -24, "scared") }
		),
		s(
			"sniff",
			5,
			"Six eyes. Hands like shovels. It sniffed students, a teacher, and a cheese sandwich.",
			c(1, 5, -29, 0, 5, -19),
			{ Bristle = a(0, 0, -19, "kneel"), Bea = a(3, 0, -23, "reach") },
			{ Sandwich = p(2, 3, -21) }
		),
		s("sandwich", 4, "It ate the sandwich. Then let everybody through.", c(5, 5, -31, 0, 3, -20), {
			Bristle = a(0, 0, -19, "reach", nil, 0, "happy"),
			Nia = a(-5, 0, -24, "walk", { -5, 0, -14 }),
			Sam = a(5, 0, -25, "walk", { 5, 0, -15 }),
		}, { Sandwich = p(0, 6, -20) }, { cue = "chomp" }),
		s(
			"solarrives",
			5,
			"On Friday, Principal Sol landed in the courtyard.",
			c(6, 8, -31, 0, 3, -17),
			{ Sol = a(0, 5, -14, "idle", { 0, 0, -14 }), Bristle = a(-7, 0, -19) },
			{ Cape = { attach = "Sol", position = { 0, 0, 0 } } },
			{ cue = "whoosh" }
		),
		s(
			"attack",
			5,
			"The monster screamed. It leapt the gate and dragged him down.",
			c(8, 7, -26, 0, 3, -14),
			{ Bristle = a(-7, 0, -19, "pounce", { -1, 0, -14 }), Sol = a(0, 0, -14, "fall") },
			{ Cape = p(0, 0, -13) },
			{ cue = "impact" }
		),
		s(
			"faulty",
			5,
			'Sol stood up smiling. "Faulty equipment. Lock it in the gym."',
			c(2, 5, -23, 0, 3, -14),
			{ Sol = a(0, 0, -14, "point", nil, 0, "happy"), Bristle = a(-7, 0, -14, "scared") },
			{ Cape = { attach = "Sol", position = { 0, 0, 0 } } }
		),
		s(
			"caged",
			4,
			"They locked it away. But Bea had filmed what happened.",
			c(55, 6, 6, 59, 4, 25),
			{ Bristle = a(59, 0, 26, "kneel", nil, 0, "sad"), Bea = a(54, 0, 18) }
		),
		s(
			"evidence",
			6,
			"We watched again. The creature had grabbed his cape. Only his cape.",
			c(7, 7, -25, 0, 3, -14),
			{ Bristle = a(-3, 0, -14, "reach"), Sol = a(0, 0, -14, "scared") },
			{ Cape = p(-1, 0, -14) },
			{ replay = true }
		),
		s(
			"curl",
			5,
			"One corner curled around its wrist. There wasn't any wind.",
			c(-1, 4.8, -18, -1, 3.5, -13),
			{ Bristle = a(-3, 0, -14, "reach"), Sol = a(0, 0, -14) },
			{ Cape = p(-1, 0, -14) },
			{ capeReach = 1, replay = true, cue = "rustle" }
		),
		s(
			"daylight",
			5,
			"Sol hadn't come outside at lunch all week.",
			c(-47, 5, 5, -45, 4, 20),
			{ Sol = a(-45, 0, 20) },
			{ Cape = { attach = "Sol", position = { 0, 0, 0 } } }
		),
		s(
			"stepped",
			5,
			"Yesterday, he snapped at a little kid who stepped on his cape.",
			c(3, 5, -8, 0, 3, 0),
			{ Sol = a(0, 0, 0, "point", nil, 0, "angry"), Sam = a(2, 0, 1, "scared", nil, 0, "scared") },
			{ Cape = { attach = "Sol", position = { 0, 0, 0 } } }
		),
		s(
			"photo",
			6,
			"In our class photo, everyone was still. Except the fabric reaching toward Bea.",
			c(0, 3.2, -5.5, 0, 3, 0),
			{},
			{ ClassPhoto = p(0, 0, 0) }
		),
		s("investigate", 5, "We went to his office while he was at assembly.", c(-45, 6, 0, -45, 3, 17), {
			Nia = a(-48, 0, 9, "walk", { -48, 0, 18 }, 180),
			Bea = a(-44, 0, 9, "walk", { -44, 0, 18 }, 180),
			Sam = a(-40, 0, 9, "walk", { -40, 0, 18 }, 180),
		}),
		s(
			"order",
			5,
			"Inside his desk was the guardian's delivery form. Sol had ordered it himself.",
			c(-45, 4, 15, -45, 3, 21),
			{ Nia = a(-48, 0, 19, "reach") },
			{ Instructions = p(-45, 0, 20) }
		),
		s(
			"instruction",
			7,
			'"If I tell you to leave, do not obey me. Get it off before I hurt someone."',
			c(-45, 3.1, 14, -45, 3, 20),
			{},
			{ Instructions = p(-45, 0, 20) }
		),
		s(
			"doorclick",
			4,
			"Behind us, the door clicked shut.",
			c(-44, 5, 22, -45, 3, 8),
			{ Sol = a(-45, 0, 8, "idle", nil, 180), Nia = a(-48, 0, 19, "scared", nil, 0, "scared") },
			{ Cape = { attach = "Sol", position = { 0, 0, 0 } } },
			{ cue = "click" }
		),
		s(
			"caught",
			6,
			'His cape slid across the handle. "You children should be in assembly."',
			c(-46, 5, 18, -45, 3, 8),
			{ Sol = a(-45, 0, 8, "point", nil, 180), Sam = a(-42, 0, 20, "scared") },
			{ Cape = { attach = "Sol", position = { 0, 0, 0 } } },
			{ capeReach = 1 }
		),
		s(
			"blinds",
			5,
			"Bea pulled the blinds open. Sunlight struck the cape. It recoiled.",
			c(-49, 6, 7, -51, 4, 17),
			{ Bea = a(-54, 0, 17, "reach"), Sol = a(-48, 0, 12, "strain") },
			{ Cape = { attach = "Sol", position = { 0, 0, 0 } } },
			{ blindsOpen = true, sunlight = true, cue = "rustle" }
		),
		s(
			"himagain",
			5,
			'For a second, he sounded like himself. "The gym. Go."',
			c(-48, 4.8, 4, -48, 3, 12),
			{ Sol = a(-48, 0, 12, "strain", nil, 0, "sad") },
			{ Cape = { attach = "Sol", position = { 0, 0, 0 } } },
			{ sunlight = true }
		),
		s("run", 5, "We ran. Sam slammed the corridor door behind us.", c(-44, 5, -16, -45, 3, -4), {
			Nia = a(-48, 0, -1, "run", { -48, 0, -9 }),
			Bea = a(-44, 0, -1, "run", { -44, 0, -9 }),
			Sam = a(-46, 0, 1, "reach"),
		}, {}, { doorClosed = true, cue = "impact" }),
		s(
			"pin",
			6,
			'Red fabric caught in the door. Sol stopped. "Don\'t open it!"',
			c(-44, 5, -5, -45, 3, 4),
			{ Sol = a(-45, 0, 5, "strain", nil, 0, "sad"), Sam = a(-45, 0, 0, "scared") },
			{ Cape = p(-45, 0, 3.8) },
			{ doorClosed = true, capePinned = true }
		),
		s(
			"free",
			4,
			"It pulled free. His hand hit the window. We ran faster.",
			c(-45, 5, -5, -45, 3, 4),
			{ Sol = a(-45, 0, 5, "point", nil, 0, "angry") },
			{ Cape = { attach = "Sol", position = { 0, 0, 0 } } },
			{ doorClosed = true, cue = "impact" }
		),
		s(
			"unlock",
			5,
			"Bea unlocked the cage. The guardian crawled out and pushed her behind it.",
			c(53, 6, 7, 59, 4, 24),
			{ Bea = a(57, 0, 21, "reach"), Bristle = a(59, 0, 26, "walk", { 59, 0, 21 }) },
			{},
			{ cageOpen = true, cue = "click" }
		),
		s(
			"gymarrival",
			5,
			"Sol floated through the gym doors. The cape spread across the room.",
			c(49, 6, 23, 50, 4, 0),
			{ Sol = a(50, 1.5, -2, "idle", { 50, 1.5, 5 }, 180), Bristle = a(59, 0, 21, "scared") },
			{ Cape = { attach = "Sol", position = { 0, 0, 0 } } },
			{ capeReach = 2, cageOpen = true }
		),
		s("bait", 5, 'I stood beneath the partition. "Over here."', c(46, 5, 4, 50, 3, 14), {
			Nia = a(50, 0, 16, "wave", nil, 0, "scared"),
			Sol = a(50, 0, 5, "reach", nil, 180),
			Sam = a(34, 0, 13, "point"),
		}, { Cape = { attach = "Sol", position = { 0, 0, 0 } } }, { capeReach = 2, cageOpen = true }),
		s(
			"track",
			5,
			'The red edge crossed the floor track. "Now!"',
			c(52, 2, 18, 50, 1, 12),
			{ Sol = a(50, 0, 9, "reach", { 50, 0, 13 }, 180), Nia = a(50, 0, 16, "run", { 56, 0, 16 }) },
			{ Cape = p(50, 0, 11) },
			{ capeReach = 2, cageOpen = true, cue = "rustle" }
		),
		s(
			"partition",
			5,
			"The partition clamped onto the fabric. Sol fell onto the mat.",
			c(54, 7, 22, 50, 3, 13),
			{ Sol = a(50, 0, 14, "fall"), Nia = a(56, 0, 16, "scared"), Bristle = a(59, 0, 20, "reach") },
			{ Cape = p(50, 0, 12) },
			{ partitionClosed = true, capePinned = true, cageOpen = true, cue = "impact" }
		),
		s(
			"separate",
			5,
			"The cape kept pulling without him. The guardian pounced.",
			c(56, 6, 23, 50, 3, 13),
			{ Sol = a(50, 0, 16, "prone"), Bristle = a(59, 0, 20, "pounce", { 51, 0, 13 }) },
			{ Cape = p(50, 0, 12) },
			{ partitionClosed = true, capePinned = true, cageOpen = true, cue = "rustle" }
		),
		s(
			"silence",
			4,
			"We heard fabric tear. Then nothing.",
			c(58, 4.8, 20, 56, 3, 16),
			{ Nia = a(56, 0, 16, "scared"), Sam = a(59, 0, 16, "scared"), Bea = a(62, 0, 16, "scared") },
			{},
			{ partitionClosed = true, cageOpen = true }
		),
		s(
			"monday",
			6,
			"On Monday, Sol walked through the gate in an ordinary jacket. The monster sniffed him.",
			c(7, 8, -35, 0, 4, -19),
			{
				Sol = a(0, 0, -25, "walk", { 0, 0, -21 }),
				Bristle = a(0, 0, -16, "kneel", nil, 180),
				Bea = a(5, 0, -22),
			}
		),
		s(
			"belly",
			5,
			"Then it rolled onto its back. He scratched its belly.",
			c(7, 5, -28, 0, 2, -20),
			{ Bristle = a(0, 0, -20, "prone", nil, 0, "happy"), Sol = a(3, 0, -20, "pet", nil, 90, "happy") }
		),
		s(
			"cheese",
			6,
			"Bea offered her sandwich. This time, it waited until she took the cheese out.",
			c(5, 5, -30, 0, 3, -20),
			{
				Bristle = a(0, 0, -20, "kneel", nil, 0, "happy"),
				Bea = a(3, 0, -23, "reach", nil, 0, "happy"),
				Sol = a(-4, 0, -20),
			},
			{ Sandwich = p(2, 3, -22) },
			{ noCheese = true }
		),
	},
}
