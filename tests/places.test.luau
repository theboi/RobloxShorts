--!strict
local fs = require("@lune/fs")
local R = require("@lune/roblox")
local luau = require("@lune/luau")
for _, name in { "Power", "Gate" } do
	local place = R.deserializePlace(fs.readFile(`build/{name}.rbxlx`))
	local film = place.ReplicatedStorage.Film
	assert(film.Assets.Cast.Bristle and film.Assets.Cast.Eli, "Missing imported actor assets")
	assert(film.Episode.Value == string.lower(name), "Wrong startup film")
	assert(place.StarterPlayer.StarterPlayerScripts.Film:IsA("LocalScript"), "Film must run on client")
	assert(place.ServerScriptService.Bootstrap:IsA("Script"), "Missing player-spawn suppression")
	local scripts = 0
	for _, item in place:GetDescendants() do
		if item:IsA("LuaSourceContainer") then
			assert(#item.Source > 0, "Empty packaged script: " .. item.Name)
			luau.load(item.Source, { debugName = item.Name }) -- compile only; don't fake engine execution
			scripts += 1
		end
	end
	assert(scripts >= 15, "Missing runtime modules")
	print(`PASS: {name}.rbxlx imports and compiles {scripts} embedded Luau scripts`)
end
local gallery = R.deserializePlace(fs.readFile("build/AssetGallery.rbxlx"))
assert(gallery.Workspace.FilmAssets.School.Partition, "Gallery must include editable mechanisms")
print("PASS: AssetGallery.rbxlx deserializes with complete school assets")
