--!strict
local E = if script then require(script.Parent.Engine) else require("./Engine")
local C = E.Color3.fromRGB
return {
	ink = C(29, 38, 57),
	navy = C(36, 63, 101),
	blue = C(60, 122, 197),
	teal = C(47, 152, 150),
	cream = C(235, 224, 194),
	white = C(242, 239, 230),
	brick = C(161, 91, 72),
	gold = C(240, 181, 67),
	red = C(181, 47, 66),
	shadow = C(70, 32, 61),
	purple = C(116, 78, 143),
	grass = C(102, 143, 101),
	skin = C(224, 173, 125),
	skinDark = C(151, 98, 73),
	hair = C(59, 40, 35),
	metal = C(132, 150, 163),
	concrete = C(181, 188, 185),
	glow = C(111, 243, 200),
}
