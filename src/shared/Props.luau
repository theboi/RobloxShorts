--!strict
local E = if script then require(script.Parent.Engine) else require("./Engine")
local G = if script then require(script.Parent.Geometry) else require("./Geometry")
local P = if script then require(script.Parent.Palette) else require("./Palette")
local V, C = E.Vector3.new, E.CFrame.new
local Props = {}

function Props.build(parent)
	local props = G.model(parent, "Props")
	local function model(name)
		local result = G.model(props, name)
		G.root(result)
		return result
	end
	local bench = model("Bench")
	for z = -0.7, 0.7, 0.7 do
		G.part(bench, "SeatSlat", V(7, 0.2, 0.5), C(0, 1.7, z), P.hair).Material = E.Enum.Material.Wood
	end
	for _, x in { -2.7, 2.7 } do
		G.part(bench, "Leg", V(0.25, 1.6, 1.8), C(x, 0.8, 0), P.navy)
	end
	G.part(bench, "Back", V(7, 1.6, 0.2), C(0, 2.6, 0.9), P.hair)
	local mop = model("Mop")
	G.part(mop, "Handle", V(0.15, 5.4, 0.15), C(0, 2.9, 0), P.gold, "Cylinder").Shape = E.Enum.PartType.Block
	for i = -3, 3 do
		G.part(mop, "Cotton", V(0.2, 0.22, 1.3), C(i * 0.2, 0.15, 0), P.cream)
	end
	local coat = model("CoatShield")
	for i = -3, 3 do
		G.part(coat, "CoatFold", V(0.65, 3.8, 0.2), C(i * 0.6, 3, (i % 2) * 0.14), P.navy)
	end
	local cape = model("Cape")
	for row = 1, 5 do
		for column = -1, 1 do
			local segment = G.part(
				cape,
				"Fabric" .. row .. "_" .. column,
				V(1.02 + row * 0.1, 0.85, 0.16),
				C(column * (0.9 + row * 0.08), 4.1 - row * 0.68, 0.8 + row * 0.13),
				if column == 0 then P.red else P.shadow
			)
			segment:SetAttribute("Row", row)
			segment:SetAttribute("Bind", segment.CFrame)
		end
	end
	G.part(cape, "Clasp", V(0.55, 0.4, 0.2), C(0, 4, 0.55), P.gold, "Ball")
	local bin = model("Bin")
	G.part(bin, "Body", V(2, 2.4, 2), C(0, 1.2, 0), P.metal)
	G.part(bin, "Rim", V(2.2, 0.18, 2.2), C(0, 2.4, 0), P.navy)
	local core = model("PowerCore")
	G.part(core, "Housing", V(2, 2.8, 1.5), C(0, 1.4, 0), P.navy)
	local crystal = G.part(core, "Crystal", V(0.8, 1.8, 1.6), C(0, 1.6, 0), P.glow, "Ball")
	crystal.Material = E.Enum.Material.Neon
	local paper = model("RejectionSlip")
	G.label(
		G.part(paper, "Paper", V(1.8, 1.2, 0.04), C(0, 3, 0), P.white),
		"TRYOUTS\nNOT SELECTED",
		nil,
		P.ink
	)
	local form = model("Instructions")
	G.label(
		G.part(form, "Paper", V(3.7, 2.6, 0.04), C(0, 3, 0), P.white),
		"GUARDIAN ORDER\nIf I tell you to leave, do not obey me.\nGet it off before I hurt someone.",
		nil,
		P.ink
	)
	local photo = model("ClassPhoto")
	G.part(photo, "Frame", V(4, 3, 0.2), C(0, 3, 0), P.hair)
	G.part(photo, "Backing", V(3.7, 2.7, 0.08), C(0, 3, -0.15), P.cream)
	for i = -1, 1 do
		G.part(photo, "StudentHead", V(0.5, 0.5, 0.1), C(i * 1.05, 3.3, -0.24), P.skin, "Ball")
		G.part(photo, "StudentBody", V(0.6, 0.7, 0.08), C(i * 1.05, 2.7, -0.24), P.blue)
	end
	G.part(
		photo,
		"ReachingFabric",
		V(1.4, 0.2, 0.1),
		C(0.65, 3.35, -0.35) * E.CFrame.Angles(0, 0, -0.4),
		P.red
	)
	local sandwich = model("Sandwich")
	for _, layer in
		{ { "BreadBottom", 0.2, P.cream }, { "Cheese", 0.38, P.gold }, { "BreadTop", 0.56, P.cream } }
	do
		G.part(sandwich, layer[1], V(1, 0.18, 0.8), C(0, layer[2], 0), layer[3], "Wedge")
	end
	local release = model("Release")
	G.part(release, "Box", V(0.6, 1, 0.3), C(0, 3, 0), P.red)
	G.label(release.Box, "GATE", nil, P.white)
	local dust = model("Dust")
	for i = 1, 12 do
		local particle = G.part(
			dust,
			"Cloud" .. i,
			V(1.1, 1.1, 1.1),
			C(math.sin(i * 2.4) * 1.2, 2 + i * 0.18, math.cos(i * 2.4)),
			P.cream,
			"Ball"
		)
		particle.Transparency = 0.6
	end
	return props
end

return Props
