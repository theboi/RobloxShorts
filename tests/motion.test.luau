--!strict
local E = require("@lune/roblox")
local Motion = require("../src/shared/Motion")
local Characters = require("../src/shared/Characters")
local rig = Characters.create(nil, "Subject", {
	shirt = E.Color3.new(0, 1, 1),
	pants = E.Color3.new(),
	skin = E.Color3.new(1, 1, 0),
	accent = E.Color3.new(1, 1, 1),
})
local state = { position = { 0, 0, 0 }, to = { 10, 0, 0 }, pose = "walk" }
assert(Motion.position(state, 0.5).X == 5, "root path must interpolate")
Motion.applyActor(rig, state, 0.5, 0.5)
local before = rig.Head.CFrame
Motion.applyActor(rig, { position = { 50, 0, 0 }, pose = "fall" }, 2, 1)
Motion.applyActor(rig, state, 0.5, 0.5)
assert((before.Position - rig.Head.CFrame.Position).Magnitude < 0.001, "seeking must reconstruct bind pose")
local left = rig["Left Arm"]
assert(
	(left.CFrame.Position - E.Vector3.new(3.5, 3, 0)).Magnitude > 0.01,
	"walk must articulate limbs, not slide the whole rig"
)
Motion.applyActor(rig, { position = { 0, 0, 0 }, scale = 2 }, 0, 0)
Motion.applyActor(rig, { position = { 0, 0, 0 }, scale = 2 }, 0, 0)
assert(rig.Torso.Size.X == 4, "repeated sampling must not compound scale")
print("PASS: actor paths, joint posing, backwards seeking, stable scale")
