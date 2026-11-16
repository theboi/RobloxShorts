--!strict
-- Catches missing models, illegal attachment references, unseekable shots, and export corruption.
local R = require("@lune/roblox")
local Assets = require("../src/shared/Assets")
local Timeline = require("../src/shared/Timeline")
local Scene = require("../src/shared/Scene")
local films = { require("../src/films/Power"), require("../src/films/Gate") }
local assets = Assets.build()
local roundtrip = R.deserializeModel(R.serializeModel({ assets }))[1]
local parent = R.Instance.new("Folder")
local scene = Scene.create(roundtrip, parent)
for _, film in films do
	local timeline = Timeline.compile(film.shots)
	assert(timeline.duration >= 120 and timeline.duration <= 210, "film pacing outside production range")
	for index, shot in film.shots do
		assert(shot.text and #shot.text > 0 and shot.camera, "Missing narration or camera: " .. shot.id)
		for name in shot.actors do
			assert(scene.cast[name], "Unknown actor: " .. name)
		end
		for name, prop in shot.props do
			assert(scene.props[name], "Unknown prop: " .. name)
			if prop.attach then
				assert(shot.actors[prop.attach], "Attachment target is not in shot")
			end
		end
		for _, alpha in { 0, 0.5, 1 } do
			local sample = { shot = shot, alpha = alpha, elapsed = alpha * shot.duration }
			Scene.apply(scene, sample)
			for _, item in scene.folder:GetDescendants() do
				if item:IsA("BasePart") then
					local pos = item.CFrame.Position
					assert(
						pos.X == pos.X and pos.Y == pos.Y and pos.Z == pos.Z,
						"NaN geometry in " .. shot.id
					)
				end
			end
		end
		-- Reverse seeks exercise transitions from the end of a shot back to its start.
		Scene.apply(scene, { shot = shot, alpha = 0, elapsed = 0 })
	end
	print(
		`PASS: {film.id}: {#film.shots} shots, {timeline.duration}s, all assets sampled at start/middle/end`
	)
end
