--!strict
local E = if script then require(script.Parent.Engine) else require("./Engine")
local G = if script then require(script.Parent.Geometry) else require("./Geometry")
local P = if script then require(script.Parent.Palette) else require("./Palette")
local V, C = E.Vector3.new, E.CFrame.new
local School = {}

local function block(parent, name, size, position, color, material)
	local part = G.part(parent, name, V(table.unpack(size)), C(table.unpack(position)), color)
	if material then
		part.Material = material
	end
	return part
end

local function tree(parent, x, z)
	block(parent, "Trunk", { 0.8, 5, 0.8 }, { x, 2.5, z }, P.hair, E.Enum.Material.Wood)
	for _, offset in { { 0, 6, 0 }, { -1.2, 5.3, 0 }, { 1.1, 5.6, 0.3 } } do
		G.part(parent, "Canopy", V(4, 3.4, 3.8), C(x + offset[1], offset[2], z + offset[3]), P.grass, "Ball")
	end
end

local function room(parent, name, x, z, width, depth)
	local model = G.model(parent, name)
	block(model, "Floor", { width, 0.3, depth }, { x, -0.15, z }, P.cream, E.Enum.Material.WoodPlanks)
	block(model, "BackWall", { width, 10, 0.45 }, { x, 5, z + depth / 2 }, P.cream)
	block(model, "LeftWall", { 0.45, 10, depth }, { x - width / 2, 5, z }, P.cream)
	block(model, "Skirting", { width, 0.3, 0.55 }, { x, 0.2, z + depth / 2 - 0.1 }, P.navy)
	-- Open front and right walls are deliberate camera access, not a fully enclosed game map.
	return model
end

function School.build(parent)
	local school = G.model(parent, "School")
	block(school, "Ground", { 160, 0.6, 130 }, { 0, -0.6, 10 }, P.grass, E.Enum.Material.Grass)
	block(school, "Courtyard", { 58, 0.25, 45 }, { 0, -0.125, 0 }, P.concrete, E.Enum.Material.Concrete)
	for _, x in { -23, 23 } do
		for _, z in { -14, 15 } do
			block(school, "LampPost", { 0.25, 9, 0.25 }, { x, 4.5, z }, P.navy)
			local lantern = block(school, "Lantern", { 1.1, 0.45, 1.1 }, { x, 9, z }, P.cream)
			local light = E.Instance.new("PointLight")
			light.Name, light.Range, light.Brightness, light.Shadows = "CourtyardLight", 48, 3, true
			light.Color, light.Parent = P.cream, lantern
		end
	end
	for x = -24, 24, 8 do
		block(school, "Paving Joint", { 0.05, 0.02, 42 }, { x, 0.02, 0 }, P.metal)
	end
	block(school, "SchoolFacade", { 58, 12, 2 }, { 0, 6, 24 }, P.brick, E.Enum.Material.Brick)
	block(school, "Cornice", { 60, 0.6, 2.8 }, { 0, 12, 24 }, P.cream)
	block(school, "BaseCourse", { 58, 1, 2.2 }, { 0, 0.5, 23.9 }, P.navy)
	for x = -24, 24, 8 do
		block(school, "WindowFrame", { 4.8, 5.2, 0.3 }, { x, 7, 22.8 }, P.cream)
		block(school, "WindowGlass", { 4.2, 4.6, 0.15 }, { x, 7, 22.55 }, P.blue)
		block(school, "Mullion", { 0.13, 4.6, 0.2 }, { x, 7, 22.4 }, P.white)
	end
	local sign = block(school, "SchoolSign", { 13, 1.8, 0.3 }, { 0, 10.7, 22.6 }, P.navy)
	G.label(sign, "NORTHSTAR ACADEMY")
	for _, x in { -27, 27 } do
		block(school, "GatePillar", { 2, 8, 2 }, { x, 4, -20 }, P.brick)
		for z = -15, 15, 10 do
			tree(school, x + (if x < 0 then -7 else 7), z)
		end
	end
	for _, x in { -18, 18 } do
		block(school, "FenceRail", { 16, 0.2, 0.2 }, { x, 5, -20 }, P.navy)
		for dx = -7, 7, 1 do
			block(school, "FenceBar", { 0.15, 6, 0.15 }, { x + dx, 3, -20 }, P.navy)
		end
	end
	local shutter = G.model(school, "Shutter")
	local gate = G.model(school, "EntryGate")
	G.root(gate)
	for x = 0.5, 17.5, 1 do
		block(gate, "GateBar", { 0.15, 6, 0.15 }, { x, 3, 0 }, P.navy)
	end
	for _, y in { 0.5, 5.5 } do
		block(gate, "GateRail", { 18, 0.2, 0.2 }, { 9, y, 0 }, P.navy)
	end
	G.pivot(gate, C(-9, 0, -20))
	G.root(shutter)
	for y = 0.5, 8, 0.5 do
		block(shutter, "SteelSlat", { 19, 0.45, 0.3 }, { 0, y, 0 }, P.metal, E.Enum.Material.Metal)
	end
	G.pivot(shutter, C(0, 9, -20))
	local stairs = G.model(school, "Stairs")
	for step = 1, 6 do
		block(
			stairs,
			"Step" .. step,
			{ 7, step * 0.5, 1.5 },
			{ 17, step * 0.25, 12 + step * 1.5 },
			P.concrete
		)
	end
	local landing = G.model(school, "Landing")
	G.root(landing)
	block(landing, "Slab", { 8, 0.45, 5 }, { 0, 0, 0 }, P.concrete)
	for _, x in { -3.8, 3.8 } do
		block(landing, "RailPost", { 0.12, 2.7, 0.12 }, { x, 1.5, 0 }, P.navy)
	end
	block(landing, "Rail", { 8, 0.15, 0.15 }, { 0, 2.8, 0 }, P.navy)
	G.pivot(landing, C(17, 3.1, 21))
	local office = room(school, "Office", -45, 18, 22, 22)
	block(office, "DeskTop", { 8, 0.4, 3.8 }, { -45, 3, 22 }, P.hair, E.Enum.Material.Wood)
	for _, x in { -48, -42 } do
		block(office, "DeskLeg", { 0.4, 3, 3 }, { x, 1.5, 22 }, P.hair)
	end
	block(office, "Window", { 0.2, 5, 8 }, { -55.6, 6, 18 }, P.blue)
	local blinds = G.model(school, "Blinds")
	G.root(blinds)
	for y = 0, 4.5, 0.5 do
		block(blinds, "Slat", { 0.25, 0.35, 8 }, { 0, y, 0 }, P.white)
	end
	G.pivot(blinds, C(-55.3, 3.5, 18))
	local corridor = room(school, "Corridor", -45, -5, 22, 18)
	for x = -53, -37, 2 do
		block(corridor, "Locker", { 1.8, 6.2, 0.8 }, { x, 3.1, 3.2 }, P.teal)
		block(corridor, "Handle", { 0.12, 0.6, 0.15 }, { x + 0.5, 3.3, 2.7 }, P.metal)
	end
	local door = G.model(school, "CorridorDoor")
	G.root(door)
	block(door, "DoorPanel", { 5, 8, 0.3 }, { 2.5, 4, 0 }, P.navy)
	block(door, "DoorWindow", { 3, 2.4, 0.35 }, { 2.5, 5.4, -0.02 }, P.blue)
	block(door, "PushBar", { 3.5, 0.18, 0.3 }, { 2.5, 3, -0.3 }, P.metal)
	G.pivot(door, C(-48, 0, 4))
	local gym = room(school, "Gym", 50, 12, 36, 36)
	for _, x in { 38, 62 } do
		block(gym, "CourtLine", { 0.1, 0.03, 28 }, { x, 0.03, 12 }, P.white)
	end
	block(gym, "CentreLine", { 32, 0.03, 0.1 }, { 50, 0.03, 12 }, P.white)
	block(gym, "CrashMat", { 10, 0.5, 8 }, { 50, 0.25, 14 }, P.blue)
	local partition = G.model(school, "Partition")
	G.root(partition)
	for _, side in { -1, 1 } do
		for x = 0.55, 17.05, 1.1 do
			block(
				partition,
				"Fold",
				{ 1.1, 10, 0.5 },
				{ side * x, 5, 0 },
				if math.floor(x) % 2 == 0 then P.navy else P.blue
			)
		end
	end
	G.pivot(partition, C(50, 0, 12))
	block(gym, "PartitionTrack", { 36, 0.04, 0.15 }, { 50, 0.03, 12 }, P.metal)
	local cage = G.model(school, "Cage")
	G.root(cage)
	for x = -4, 4, 0.8 do
		block(cage, "Bar", { 0.15, 9, 0.15 }, { x, 4.5, 0 }, P.metal)
	end
	for _, y in { 0.3, 8.7 } do
		block(cage, "Crossbar", { 8, 0.2, 0.2 }, { 0, y, 0 }, P.navy)
	end
	G.pivot(cage, C(59, 0, 23))
	return school
end

return School
