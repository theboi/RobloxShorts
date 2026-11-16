--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Film = ReplicatedStorage:WaitForChild("Film")
local Timeline = require(Film.Shared.Timeline)
local Scene = require(Film.Shared.Scene)
local Motion = require(Film.Shared.Motion)
local Config = require(Film.Settings)
local films = { power = require(Film.Films.Power), gate = require(Film.Films.Gate) }
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
while not camera do
	workspace:GetPropertyChangedSignal("CurrentCamera"):Wait()
	camera = workspace.CurrentCamera
end
local oldScene = workspace:FindFirstChild("FilmScene")
if oldScene then
	oldScene:Destroy()
end
local scene = Scene.create(Film.Assets, workspace)
local controls = Instance.new("Folder")
controls.Name = "FilmControl"
controls.Parent = workspace
controls:SetAttribute("Episode", Film.Episode.Value)
controls:SetAttribute("Paused", true)
controls:SetAttribute("SeekTime", 0)
controls:SetAttribute("Clean", false)
controls:SetAttribute("Captions", true)

local gui = Instance.new("ScreenGui")
gui.Name, gui.ResetOnSpawn, gui.IgnoreGuiInset = "FilmPreview", false, true
gui.Parent = player:WaitForChild("PlayerGui")
local function label(name, size, position)
	local item = Instance.new("TextLabel")
	item.Name, item.Size, item.Position = name, size, position
	item.BackgroundColor3, item.BackgroundTransparency = Color3.fromRGB(15, 20, 32), 0.15
	item.TextColor3, item.TextWrapped = Color3.new(1, 1, 1), true
	item.FontFace, item.TextSize = Font.fromEnum(Enum.Font.GothamBold), 20
	item.Parent = gui
	return item
end
local hud = label("ReviewControls", UDim2.new(1, 0, 0, 74), UDim2.fromScale(0, 0))
local caption = label("Caption", UDim2.fromScale(0.84, 0.16), UDim2.fromScale(0.08, 0.69))
caption.TextSize = 26
local safe = Instance.new("Frame")
safe.Name, safe.BackgroundTransparency = "SafeArea", 1
safe.Size, safe.Position, safe.Parent = UDim2.fromScale(0.84, 0.78), UDim2.fromScale(0.08, 0.07), gui
local stroke = Instance.new("UIStroke")
stroke.Color, stroke.Transparency, stroke.Parent = Color3.fromRGB(240, 181, 67), 0.3, safe

local connections = {}
local film, timeline, position, epoch, playing = nil, nil, 0, 0, false
local cueSounds = {}
for name, id in Config.soundIds do
	if id ~= "" then
		local sound = Instance.new("Sound")
		sound.Name, sound.SoundId, sound.Volume, sound.Parent = name, id, 0.4, gui
		cueSounds[name] = sound
	end
end
local previousIndex = 0
local function stopAudio()
	for _, sound in cueSounds do
		sound:Stop()
	end
end
local function seek(seconds)
	position = math.clamp(seconds, 0, timeline.duration)
	epoch = os.clock() - position
	previousIndex = 0
	stopAudio()
end
local function loadFilm(id)
	assert(films[id], "Unknown film: " .. tostring(id))
	film = films[id]
	timeline = Timeline.compile(film.shots)
	controls:SetAttribute("Duration", timeline.duration)
	seek(0)
end
loadFilm(controls:GetAttribute("Episode"))
table.insert(
	connections,
	controls:GetAttributeChangedSignal("Episode"):Connect(function()
		local ok, err = pcall(loadFilm, controls:GetAttribute("Episode"))
		if not ok then
			warn(err)
		end
	end)
)
table.insert(
	connections,
	controls:GetAttributeChangedSignal("SeekTime"):Connect(function()
		seek(controls:GetAttribute("SeekTime"))
	end)
)
table.insert(
	connections,
	controls:GetAttributeChangedSignal("Paused"):Connect(function()
		playing = not controls:GetAttribute("Paused")
		epoch = os.clock() - position
		if not playing then
			stopAudio()
		end
	end)
)
local function nextShot(direction)
	local sample = Timeline.sample(timeline, position)
	local index = math.clamp(sample.index + direction, 1, #timeline.shots)
	seek(timeline.starts[index])
end
table.insert(
	connections,
	UserInputService.InputBegan:Connect(function(input, processed)
		if processed or UserInputService:GetFocusedTextBox() then
			return
		end
		local key = input.KeyCode
		if key == Enum.KeyCode.Space then
			controls:SetAttribute("Paused", not controls:GetAttribute("Paused"))
		end
		if key == Enum.KeyCode.R then
			seek(0)
		end
		if key == Enum.KeyCode.Left then
			seek(position - 5)
		end
		if key == Enum.KeyCode.Right then
			seek(position + 5)
		end
		if key == Enum.KeyCode.LeftBracket then
			nextShot(-1)
		end
		if key == Enum.KeyCode.RightBracket then
			nextShot(1)
		end
		if key == Enum.KeyCode.One then
			controls:SetAttribute("Episode", "power")
		end
		if key == Enum.KeyCode.Two then
			controls:SetAttribute("Episode", "gate")
		end
		if key == Enum.KeyCode.H then
			controls:SetAttribute("Clean", not controls:GetAttribute("Clean"))
		end
		if key == Enum.KeyCode.C then
			controls:SetAttribute("Captions", not controls:GetAttribute("Captions"))
		end
	end)
)
local function render()
	if playing then
		position = math.min(os.clock() - epoch, timeline.duration)
		if position >= timeline.duration then
			controls:SetAttribute("Paused", true)
		end
	end
	local sample = Timeline.sample(timeline, position)
	Scene.apply(scene, sample)
	local shot = sample.shot
	camera.CameraType = Enum.CameraType.Scriptable
	camera.FieldOfView = shot.camera.fov
	camera.CFrame = CFrame.lookAt(
		Motion.position(shot.camera, sample.alpha),
		Vector3.new(table.unpack(shot.camera.target))
	)
	Lighting.ClockTime = shot.clockTime or 14
	Lighting.Brightness = if shot.night then 0.7 else 2.2
	Lighting.Ambient = if shot.night then Color3.fromRGB(30, 46, 65) else Color3.fromRGB(110, 115, 130)
	Lighting.OutdoorAmbient = Color3.fromRGB(135, 141, 157)
	Lighting.ExposureCompensation = if shot.sunlight then 0.4 else 0
	local clean = controls:GetAttribute("Clean")
	hud.Visible, safe.Visible = not clean, not clean
	UserInputService.MouseIconEnabled = not clean
	caption.Visible = controls:GetAttribute("Captions")
	-- Preview captions are chunked by shot; editable SRT is exported for final typography/timing.
	caption.Text = shot.text
	hud.Text = string.format(
		"%s  |  %05.1f / %.0fs  |  %s\nSpace play · R reset · ←/→ seek · [/] shot · 1/2 film · H clean · C captions",
		film.title,
		position,
		timeline.duration,
		shot.id
	)
	controls:SetAttribute("CurrentTime", position)
	controls:SetAttribute("ShotId", shot.id)
	if previousIndex ~= sample.index and playing then
		local sound = if shot.cue then cueSounds[shot.cue] else nil
		if sound then
			sound:Play()
		end
	end
	previousIndex = sample.index
end
pcall(function()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
end)
RunService:BindToRenderStep("RobloxShortsFilm", Enum.RenderPriority.Camera.Value + 1, render)
script.Destroying:Connect(function()
	RunService:UnbindFromRenderStep("RobloxShortsFilm")
	for _, connection in connections do
		connection:Disconnect()
	end
	stopAudio()
	gui:Destroy()
	controls:Destroy()
	scene.folder:Destroy()
	UserInputService.MouseIconEnabled = true
end)
render()
print("RobloxShorts ready. Space plays. 1/2 switch stories. H hides review controls.")
