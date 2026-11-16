--!strict
local fs = require("@lune/fs")
local roblox = require("@lune/roblox")
local Assets = require("../src/shared/Assets")
fs.writeDir("build/models")
local assets = Assets.build()
fs.writeFile("build/models/FilmAssets.rbxm", roblox.serializeModel({ assets }))
local count = 0
for _, item in assets:GetDescendants() do
	if item:IsA("BasePart") then
		count += 1
	end
end
print(`Built {count} Roblox parts across school, cast, and props`)
