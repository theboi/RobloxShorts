--!strict
-- Catches missing cinematic assets and malformed export rigs before opening Studio.
local Builders = require("../src/shared/Assets")
local assets = Builders.build()
for _, folder in { "School", "Cast", "Props" } do
	assert(assets:FindFirstChild(folder), "Missing asset group: " .. folder)
end
local cast = assets.Cast
for _, name in { "Eli", "Dad", "Lens", "Maya", "Noah", "Nia", "Sam", "Bea", "Sol", "Bristle" } do
	local actor = cast:FindFirstChild(name)
	assert(actor and actor.PrimaryPart, "Missing pivot for " .. name)
	assert(actor:FindFirstChild("Head"), "Missing head for " .. name)
	assert(actor:FindFirstChild("Left Arm") and actor:FindFirstChild("Right Arm"), "Missing articulated arms")
	local motors, parts = 0, 0
	for _, child in actor:GetDescendants() do
		if child:IsA("Motor6D") then
			motors += 1
		end
		if child:IsA("BasePart") then
			parts += 1
			assert(child.Anchored, "Film geometry must not fall between takes")
			assert(child.Size.X > 0 and child.Size.Y > 0 and child.Size.Z > 0, "Invalid dimensions")
		end
	end
	assert(motors >= 5 and parts >= 12, "Actor lacks rig or appearance detail: " .. name)
	assert(actor.Head:FindFirstChild("Face"), "Missing expressive face: " .. name)
end
assert(assets.Props:FindFirstChild("Cape"), "Living cape required")
assert(assets.School:FindFirstChild("Partition"), "Climax mechanism required")
assert(assets.School:FindFirstChild("Shutter"), "Rescue mechanism required")
print("PASS: cast, rigs, geometry, faces, and story mechanisms")
