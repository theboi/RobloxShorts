--!strict
local E = if script then require(script.Parent.Engine) else require("./Engine")
local Motion = if script then require(script.Parent.Motion) else require("./Motion")
local P = if script then require(script.Parent.Palette) else require("./Palette")
local Scene = {}
local C, V = E.CFrame.new, E.Vector3.new

local function remember(model)
	local root = if model.PrimaryPart then model.PrimaryPart.CFrame else E.CFrame.identity
	local parts = {}
	for _, child in model:GetDescendants() do
		if child:IsA("BasePart") then
			table.insert(
				parts,
				{ part = child, bind = root:Inverse() * child.CFrame, alpha = child.Transparency }
			)
		end
	end
	return { model = model, parts = parts, root = root }
end

local function place(entry, frame, visible)
	for _, item in entry.parts do
		item.part.CFrame = frame * item.bind
		item.part.Transparency = if visible then item.alpha else 1
	end
	for _, child in entry.model:GetDescendants() do
		if child:IsA("SurfaceGui") then
			child.Enabled = visible
		end
	end
end

function Scene.create(assets, parent)
	local folder = E.Instance.new("Folder")
	folder.Name, folder.Parent = "FilmScene", parent
	local school, cast, props = assets.School:Clone(), assets.Cast:Clone(), assets.Props:Clone()
	school.Parent, cast.Parent, props.Parent = folder, folder, folder
	local self = { folder = folder, school = school, cast = {}, props = {}, mechanisms = {} }
	for _, model in cast:GetChildren() do
		self.cast[model.Name] = remember(model)
	end
	for _, model in props:GetChildren() do
		self.props[model.Name] = remember(model)
	end
	for _, name in { "Shutter", "Landing", "Blinds", "CorridorDoor", "Partition", "Cage" } do
		self.mechanisms[name] = remember(school:FindFirstChild(name))
	end
	return self
end

function Scene.apply(self, sample)
	local shot, alpha, t = sample.shot, sample.alpha, sample.elapsed
	local actorFrames = {}
	for name, entry in self.cast do
		local state = shot.actors[name]
		place(entry, E.CFrame.identity, state ~= nil)
		if state then
			actorFrames[name] = Motion.applyActor(entry.model, state, t, alpha)
		end
	end
	for name, entry in self.props do
		local state = shot.props[name]
		local frame = E.CFrame.identity
		if state then
			frame = Motion.frame(state, alpha)
			if state.attach then
				frame = actorFrames[state.attach] * frame
			end
		end
		place(entry, frame, state ~= nil)
		if state and name == "Cape" then
			for _, item in entry.parts do
				local row = item.part:GetAttribute("Row")
				if row then
					local sway = math.sin(t * 3 + row * 0.5) * (if shot.capePinned then 0.03 else 0.12)
					local spread = shot.capeReach or 0
					local localCF = item.bind
					local offset = V(
						localCF.Position.X * (1 + spread * 0.9),
						localCF.Position.Y,
						localCF.Position.Z + sway + spread * row * 0.3
					)
					item.part.CFrame = frame * C(offset) * localCF.Rotation
				end
			end
		elseif state and name == "Sandwich" then
			entry.model.Cheese.Transparency = if shot.noCheese then 1 else 0
		end
	end
	for name, entry in self.mechanisms do
		local frame = entry.root
		if name == "Shutter" then
			frame = C(0, if shot.shutterClosed then 9 * (1 - alpha) else 9, -20)
		end
		if name == "Landing" then
			frame = entry.root * C(0, -(shot.landingDrop or 0) * alpha, 0)
		end
		if name == "Blinds" and shot.blindsOpen then
			frame = entry.root * C(0, 5, 0)
		end
		if name == "CorridorDoor" and not shot.doorClosed then
			frame = entry.root * E.CFrame.Angles(0, math.rad(-85), 0)
		end
		if name == "Partition" then
			-- Two banks approach a central gap; each bank's bind x positions are sampled.
			place(entry, frame, true)
			local openness = if shot.partitionClosed then 1 - alpha else 1
			for _, item in entry.parts do
				if item.part.Name == "Fold" then
					item.part.CFrame = frame
						* C(item.bind.Position.X * (1 - openness * 0.9), item.bind.Position.Y, 0)
				end
			end
			continue
		end
		if name == "Cage" and shot.cageOpen then
			frame = entry.root * C(0, 10, 0)
		end
		place(entry, frame, true)
	end
	local lens = self.cast.Lens.model
	for _, part in lens:GetChildren() do
		if string.sub(part.Name, 1, 10) == "CameraLens" then
			part.Color = if shot.lenses == "green" then P.glow else P.red
		end
	end
	return shot.camera
end

return Scene
