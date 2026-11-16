--!strict
local E = if script then require(script.Parent.Engine) else require("./Engine")
local Characters = if script then require(script.Parent.Characters) else require("./Characters")
local School = if script then require(script.Parent.School) else require("./School")
local Props = if script then require(script.Parent.Props) else require("./Props")
local Assets = {}

function Assets.build()
	local assets = E.Instance.new("Folder")
	assets.Name = "FilmAssets"
	School.build(assets)
	Characters.build(assets)
	Props.build(assets)
	return assets
end

return Assets
