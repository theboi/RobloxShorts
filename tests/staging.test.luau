--!strict
local R = require("@lune/roblox")
local Assets = require("../src/shared/Assets")
local Scene = require("../src/shared/Scene")
local Motion = require("../src/shared/Motion")
local scene = Scene.create(Assets.build(), R.Instance.new("Folder"))
local function apply(shot, alpha)
	shot.actors, shot.props = shot.actors or {}, shot.props or {}
	Scene.apply(scene, { shot = shot, alpha = alpha, elapsed = alpha })
end
-- A prone actor disappearing under the floor destroys the climax.
local rig = scene.cast.Sol.model
Motion.applyActor(rig, { pose = "prone", position = { 0, 0, 0 } }, 0, 1)
assert(rig.Torso.CFrame.Position.Y > 0.5, "prone torso must stay above the ground")
assert(rig.Head.CFrame.Position.Y > 0, "prone head must stay above the ground")
-- The partition must enclose the cape at the centre, not stop short of it.
apply({ partition = 1 }, 0)
local minX, maxX = math.huge, -math.huge
for _, item in scene.mechanisms.Partition.parts do
	if item.part.Name == "Fold" then
		minX = math.min(minX, item.part.CFrame.Position.X - item.part.Size.X / 2)
		maxX = math.max(maxX, item.part.CFrame.Position.X + item.part.Size.X / 2)
	end
end
assert(minX < 35 and maxX > 65, "partition needs opposing banks across gym width")
local before = scene.mechanisms.Partition.model:FindFirstChild("Fold").CFrame
apply({ partition = 1 }, 0.75)
assert(
	(before.Position - scene.mechanisms.Partition.model:FindFirstChild("Fold").CFrame.Position).Magnitude
		< 0.001,
	"closed partition must stay closed across cuts"
)
apply({ shutter = 1 }, 0)
assert(scene.mechanisms.Shutter.model.Root.CFrame.Position.Y == 0, "closed shutter must hold on seek")
local burst = { position = { 0, 0, 0 }, to = { 10, 0, 0 }, travel = { 0.4, 0.45 } }
assert(Motion.position(burst, 0.2).X == 0, "burst needs anticipation hold")
assert(Motion.position(burst, 0.5).X == 10, "burst must finish quickly then hold")
apply({ partition = 1, capePinned = true, props = { Cape = { position = { 50, 0, 12 } } } }, 0.5)
for _, part in scene.props.Cape.model:GetChildren() do
	if part:GetAttribute("Row") then
		assert(
			math.abs(part.CFrame.Position.Z - 12) <= 0.25,
			"pinned fabric must contact the partition plane"
		)
	end
end
local gate = require("../src/films/Gate")
for _, shot in gate.shots do
	if shot.id == "bait" then
		apply(shot, 0.5)
		local cloth = scene.props.Cape.model:FindFirstChild("Fabric5_0")
		assert(cloth.CFrame.Position.Z > 7, "cape must reach toward Nia and partition, not behind Sol")
	end
end
apply({ night = true }, 0)
assert(#scene.lights == 4, "courtyard needs practical lights for the blackout")
for _, light in scene.lights do
	assert(not light.Enabled, "blackout must switch practical lights off")
end
apply({}, 0)
for _, light in scene.lights do
	assert(light.Enabled, "seeking out of blackout must restore practical lights")
end
print("PASS: ground contact, partition/cape contact and direction, stable holds, burst timing")
