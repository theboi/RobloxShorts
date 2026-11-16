--!strict
local E = if script then require(script.Parent.Engine) else require("./Engine")
local G = {}

function G.part(
	parent: Instance,
	name: string,
	size: Vector3,
	cf: CFrame,
	color: Color3,
	shape: string?
): BasePart
	local part = E.Instance.new(if shape == "Wedge" then "WedgePart" else "Part")
	part.Name, part.Size, part.CFrame, part.Color = name, size, cf, color
	part.Anchored, part.CanCollide, part.CanTouch, part.CanQuery = true, false, false, false
	part.Material = E.Enum.Material.SmoothPlastic
	part.TopSurface, part.BottomSurface = E.Enum.SurfaceType.Smooth, E.Enum.SurfaceType.Smooth
	if shape == "Ball" then
		part.Shape = E.Enum.PartType.Ball
	end
	if shape == "Cylinder" then
		part.Shape = E.Enum.PartType.Cylinder
	end
	part.Parent = parent
	return part
end

function G.model(parent: Instance?, name: string): Model
	local model = E.Instance.new("Model")
	model.Name, model.Parent = name, parent
	return model
end

function G.label(part: BasePart, text: string, face: Enum.NormalId?, color: Color3?)
	local gui = E.Instance.new("SurfaceGui")
	gui.Name, gui.Face, gui.CanvasSize = "Lettering", face or E.Enum.NormalId.Front, E.Vector2.new(700, 300)
	gui.Parent = part
	local label = E.Instance.new("TextLabel")
	label.Name, label.Size = "Text", E.UDim2.fromScale(1, 1)
	label.BackgroundTransparency, label.TextScaled, label.TextWrapped = 1, true, true
	label.FontFace, label.TextColor3, label.Text =
		E.Font.new(
			"rbxasset://fonts/families/GothamSSm.json",
			E.Enum.FontWeight.Bold,
			E.Enum.FontStyle.Normal
		),
		color or E.Color3.new(1, 1, 1),
		text
	label.Parent = gui
	return label
end

function G.root(model: Model)
	local root = G.part(model, "Root", E.Vector3.new(0.2, 0.2, 0.2), E.CFrame.identity, E.Color3.new())
	root.Transparency = 1
	model.PrimaryPart = root
	return root
end

function G.pivot(model: Model, target: CFrame)
	assert(model.PrimaryPart, "Model needs an explicit root: " .. model.Name)
	local delta = target * model.PrimaryPart.CFrame:Inverse()
	for _, part in model:GetDescendants() do
		if part:IsA("BasePart") then
			part.CFrame = delta * part.CFrame
		end
	end
end

return G
