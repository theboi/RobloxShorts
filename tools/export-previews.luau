--!strict
-- Exports authored instance geometry for offline silhouette review, not engine footage.
local fs = require("@lune/fs")
local serde = require("@lune/serde")
local R = require("@lune/roblox")
local Assets = require("../src/shared/Assets")
local Motion = require("../src/shared/Motion")
local Scene = require("../src/shared/Scene")
local assets = Assets.build()
fs.writeDir("build/previews")
local function vector(v)
	return { v.X, v.Y, v.Z }
end
local function export(model, path, camera, target, title)
	local parts = {}
	for _, item in model:GetDescendants() do
		if item:IsA("BasePart") and item.Transparency < 0.95 then
			local cf = item.CFrame
			local shape = "Block"
			if item:IsA("WedgePart") then
				shape = "Wedge"
			elseif item:IsA("Part") then
				shape = item.Shape.Name
			end
			if item:FindFirstChildOfClass("SpecialMesh") then
				shape = "Head"
			end
			local face = item:FindFirstChild("Face")
			local lettering = item:FindFirstChild("Lettering")
			table.insert(parts, {
				name = item.Name,
				size = vector(item.Size),
				position = vector(cf.Position),
				right = vector(cf.RightVector),
				up = vector(cf.UpVector),
				back = vector(-cf.LookVector),
				color = { item.Color.R, item.Color.G, item.Color.B },
				shape = shape,
				face = if face then #face:GetChildren() - 1 else nil,
				text = if lettering then lettering.Text.Text else nil,
			})
		end
	end
	fs.writeFile(
		path,
		serde.encode("json", { parts = parts, camera = camera, target = target, title = title }, true)
	)
end
for _, name in { "Eli", "Dad", "Lens", "Sol", "Bristle" } do
	local rig = assets.Cast:FindFirstChild(name)
	Motion.applyActor(
		rig,
		{ position = { 0, 0, 0 }, pose = if name == "Bristle" then "reach" else "idle" },
		0,
		0
	)
	local scale = rig:GetAttribute("Scale")
	export(
		rig,
		`build/previews/{name}.json`,
		{ 8 * scale, 6 * scale, -12 * scale },
		{ 0, 2.7 * scale, 0 },
		name
	)
end
local scene = Scene.create(assets, R.Instance.new("Folder"))
for _, film in { require("../src/films/Power"), require("../src/films/Gate") } do
	for _, index in { 1, 5, 10, 15, 20, 25, #film.shots } do
		local shot = film.shots[index]
		Scene.apply(scene, { shot = shot, alpha = 0.5, elapsed = shot.duration * 0.5 })
		export(
			scene.folder,
			`build/previews/{film.id}-{shot.id}.json`,
			vector(Motion.position(shot.camera, 0.5)),
			shot.camera.target,
			`{film.id}: {shot.id}`
		)
	end
end
print("Exported model and selected-shot geometry for offline review")
