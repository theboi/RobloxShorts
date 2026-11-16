--!strict
local fs = require("@lune/fs")
local R = require("@lune/roblox")
local G = require("../src/shared/Geometry")
local P = require("../src/shared/Palette")
local Assets = require("../src/shared/Assets")
local Motion = require("../src/shared/Motion")
local place = R.Instance.new("DataModel")
local world = R.Instance.new("Workspace")
world.Parent = place
local assets = Assets.build()
assets.Parent = world
G.part(world, "GalleryStage", R.Vector3.new(100, 0.5, 45), R.CFrame.new(0, -0.3, -65), P.cream)
local names = { "Eli", "Dad", "Lens", "Maya", "Noah", "Ada", "Nia", "Sam", "Bea", "Sol", "Bristle" }
for i, name in names do
	local x, z = ((i - 1) % 6) * 7 - 18, -75 + math.floor((i - 1) / 6) * 12
	local rig = assets.Cast:FindFirstChild(name)
	Motion.applyActor(rig, { position = { x, 0, z } }, 0, 0)
	local plaque =
		G.part(world, name .. " Label", R.Vector3.new(3.5, 0.8, 0.15), R.CFrame.new(x, 0.6, z - 2), P.navy)
	G.label(plaque, name)
end
for index, prop in assets.Props:GetChildren() do
	G.pivot(prop, R.CFrame.new(-34 + ((index - 1) % 10) * 7, 0, -45 + math.floor((index - 1) / 10) * 9))
end
local camera = R.Instance.new("Camera")
camera.Name, camera.CFrame, camera.FieldOfView =
	"GalleryCamera", R.CFrame.lookAt(R.Vector3.new(10, 21, -108), R.Vector3.new(0, 4, -66)), 55
camera.Parent, world.CurrentCamera = world, camera
fs.writeFile("build/AssetGallery.rbxlx", R.serializePlace(place, true))
print("Built AssetGallery.rbxlx: editable school, cast lineup, and prop library")
