--!strict
local E = if script then require(script.Parent.Engine) else require("./Engine")
local G = if script then require(script.Parent.Geometry) else require("./Geometry")
local P = if script then require(script.Parent.Palette) else require("./Palette")
local V, C = E.Vector3.new, E.CFrame.new
local Characters = {}

local function detail(model, bone, name, size, cf, color, shape)
	local part = G.part(model, name, size, cf, color, shape)
	part:SetAttribute("Bone", bone)
	return part
end

local function face(head, monster)
	local gui = E.Instance.new("SurfaceGui")
	gui.Name, gui.Face, gui.CanvasSize = "Face", E.Enum.NormalId.Front, E.Vector2.new(256, 128)
	gui.Parent = head
	for i = 1, (if monster then 6 else 2) do
		local eye = E.Instance.new("TextLabel")
		eye.Name = "Eye" .. i
		eye.Size = E.UDim2.fromScale(0.2, 0.35)
		local x = if monster then 0.16 + ((i - 1) % 3) * 0.24 else 0.2 + (i - 1) * 0.4
		local y = if monster then 0.02 + math.floor((i - 1) / 3) * 0.26 else 0.17
		eye.Position = E.UDim2.fromScale(x, y)
		eye.BackgroundTransparency, eye.Text, eye.TextScaled = 1, "●", true
		eye.TextColor3, eye.FontFace =
			if monster then P.gold else P.ink,
			E.Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				E.Enum.FontWeight.Bold,
				E.Enum.FontStyle.Normal
			)
		eye.Parent = gui
	end
	local mouth = E.Instance.new("TextLabel")
	mouth.Name, mouth.Size, mouth.Position =
		"Mouth", E.UDim2.fromScale(0.5, 0.35), E.UDim2.fromScale(0.25, 0.6)
	mouth.BackgroundTransparency, mouth.TextScaled = 1, true
	mouth.Text, mouth.TextColor3, mouth.FontFace =
		"ᴗ",
		P.ink,
		E.Font.new(
			"rbxasset://fonts/families/GothamSSm.json",
			E.Enum.FontWeight.Bold,
			E.Enum.FontStyle.Normal
		)
	mouth.Parent = gui
end

local function motor(model, torso, limb, pivot)
	local joint = E.Instance.new("Motor6D")
	joint.Name, joint.Part0, joint.Part1 = limb.Name .. " Joint", torso, limb
	joint.C0, joint.C1 = torso.CFrame:Inverse() * pivot, limb.CFrame:Inverse() * pivot
	joint.Parent = torso
	limb:SetAttribute("JointPivot", pivot)
end

function Characters.create(parent, name, spec)
	local model = G.model(parent, name)
	local root = G.root(model)
	local monster = spec.monster == true
	local torso = G.part(model, "Torso", V(2, 2, 1), C(0, 3, 0), spec.shirt)
	local head = G.part(model, "Head", V(2, 1, 1), C(0, 4.5, 0), spec.skin)
	local mesh = E.Instance.new("SpecialMesh")
	mesh.MeshType, mesh.Scale, mesh.Parent = E.Enum.MeshType.Head, V(1, 1, 1), head
	local leftArm = G.part(model, "Left Arm", V(1, 2, 1), C(-1.5, 3, 0), spec.shirt)
	local rightArm = G.part(model, "Right Arm", V(1, 2, 1), C(1.5, 3, 0), spec.shirt)
	local leftLeg = G.part(model, "Left Leg", V(1, 2, 1), C(-0.5, 1, 0), spec.pants)
	local rightLeg = G.part(model, "Right Leg", V(1, 2, 1), C(0.5, 1, 0), spec.pants)
	for _, pair in
		{
			{ head, C(0, 4, 0) },
			{ leftArm, C(-1.5, 4, 0) },
			{ rightArm, C(1.5, 4, 0) },
			{ leftLeg, C(-0.5, 2, 0) },
			{ rightLeg, C(0.5, 2, 0) },
		}
	do
		motor(model, torso, pair[1], pair[2])
	end
	face(head, monster)
	for _, side in { -1, 1 } do
		local arm = if side < 0 then "Left Arm" else "Right Arm"
		local leg = if side < 0 then "Left Leg" else "Right Leg"
		detail(model, arm, arm .. " Cuff", V(1.04, 0.25, 1.04), C(side * 1.5, 2.55, 0), spec.accent)
		detail(model, arm, arm .. " Hand", V(1.01, 0.55, 1.01), C(side * 1.5, 2.24, 0), spec.skin)
		detail(model, leg, leg .. " Shoe", V(1.04, 0.36, 1.22), C(side * 0.5, 0.18, -0.1), P.ink)
		detail(model, leg, leg .. " Sole", V(1.06, 0.09, 1.24), C(side * 0.5, 0.045, -0.1), P.white)
	end
	if not monster then
		detail(model, "Head", "Hair Crown", V(2.08, 0.42, 1.12), C(0, 5, 0.05), spec.hair or P.hair, "Ball")
		for i = 1, 5 do
			detail(
				model,
				"Head",
				"Fringe" .. i,
				V(0.46, 0.46 + (i % 2) * 0.12, 0.35),
				C(-1.02 + i * 0.34, 4.9, -0.47) * E.CFrame.Angles(0, 0, math.rad(-12 + i * 4)),
				spec.hair or P.hair,
				"Wedge"
			)
		end
		detail(model, "Torso", "Collar", V(1.02, 0.17, 1.06), C(0, 3.92, 0), spec.accent)
		detail(model, "Torso", "Shirt Hem", V(2.03, 0.13, 1.03), C(0, 2.08, 0), spec.accent)
		detail(model, "Torso", "Chest Badge", V(0.35, 0.36, 0.07), C(-0.55, 3.4, -0.54), spec.accent)
	end
	if spec.coat then
		detail(model, "Torso", "Coat Left", V(0.85, 2.65, 0.15), C(-0.6, 2.75, -0.57), spec.shirt)
		detail(model, "Torso", "Coat Right", V(0.85, 2.65, 0.15), C(0.6, 2.75, -0.57), spec.shirt)
		detail(model, "Torso", "Utility Belt", V(2.08, 0.2, 1.1), C(0, 2.45, 0), P.hair)
	end
	if spec.helmet then
		detail(model, "Head", "Helmet Shell", V(2.22, 1.38, 1.28), C(0, 4.65, 0.08), P.metal, "Ball")
		detail(model, "Head", "Black Visor", V(1.95, 0.6, 0.18), C(0, 4.6, -0.65), P.ink)
		for _, side in { -1, 1 } do
			local lens = detail(
				model,
				"Head",
				"CameraLens" .. side,
				V(0.35, 0.35, 0.16),
				C(side * 0.65, 4.6, -0.79),
				P.red,
				"Ball"
			)
			lens.Material = E.Enum.Material.Neon
		end
	end
	if monster then
		detail(model, "Torso", "Shoulder Ruff", V(3.5, 1.5, 1.7), C(0, 3.7, 0.2), P.purple, "Ball")
		detail(model, "Torso", "Chest Bib", V(1.65, 1.5, 0.32), C(0, 3.05, -0.62), P.cream, "Ball")
		for _, side in { -1, 1 } do
			detail(
				model,
				"Head",
				"Ear" .. side,
				V(0.55, 0.9, 0.7),
				C(side * 1.05, 4.85, 0.05) * E.CFrame.Angles(0, 0, side * -0.45),
				P.purple,
				"Wedge"
			)
			detail(
				model,
				"Head",
				"HornBase" .. side,
				V(0.4, 0.7, 0.4),
				C(side * 0.75, 5.25, 0.1),
				P.cream,
				"Ball"
			)
			detail(
				model,
				"Head",
				"HornTip" .. side,
				V(0.3, 0.6, 0.35),
				C(side * 0.85, 5.65, 0.05) * E.CFrame.Angles(0, 0, side * -0.3),
				P.gold,
				"Wedge"
			)
			local arm = if side < 0 then "Left Arm" else "Right Arm"
			detail(model, arm, "Paw" .. side, V(1.4, 0.7, 1.35), C(side * 1.5, 2.05, -0.1), P.purple, "Ball")
			for toe = 1, 3 do
				detail(
					model,
					arm,
					"Claw" .. side .. toe,
					V(0.2, 0.2, 0.4),
					C(side * 1.5 - 0.5 + toe * 0.25, 1.95, -0.75),
					P.cream,
					"Wedge"
				)
			end
		end
		detail(model, "Head", "Lower Jaw", V(1.6, 0.32, 0.4), C(0, 4.15, -0.35), P.purple, "Ball")
	end
	-- Store bind transforms after detailing; sampling never depends on last frame.
	for _, part in model:GetChildren() do
		if part:IsA("BasePart") then
			part:SetAttribute("Bind", part.CFrame)
			if not part:GetAttribute("Bone") then
				part:SetAttribute("Bone", part.Name)
			end
		end
	end
	root:SetAttribute("Bone", "Root")
	model:SetAttribute("FilmRig", true)
	model:SetAttribute("Scale", spec.scale or 1)
	return model
end

function Characters.build(parent)
	local cast = G.model(parent, "Cast")
	local specifications = {
		Eli = { shirt = P.teal, pants = P.navy, skin = P.skin, accent = P.gold },
		Dad = { shirt = P.navy, pants = P.hair, skin = P.skin, accent = P.metal, coat = true, hair = P.metal },
		Lens = { shirt = P.ink, pants = P.ink, skin = P.skinDark, accent = P.red, helmet = true },
		Maya = { shirt = P.gold, pants = P.navy, skin = P.skinDark, accent = P.white },
		Noah = { shirt = P.blue, pants = P.ink, skin = P.skin, accent = P.white },
		Nia = { shirt = P.teal, pants = P.navy, skin = P.skinDark, accent = P.cream },
		Sam = { shirt = P.brick, pants = P.ink, skin = P.skin, accent = P.gold },
		Bea = { shirt = P.purple, pants = P.navy, skin = P.skin, accent = P.cream },
		Sol = { shirt = P.blue, pants = P.blue, skin = P.skinDark, accent = P.gold },
		Bristle = {
			shirt = P.purple,
			pants = P.purple,
			skin = P.purple,
			accent = P.cream,
			monster = true,
			scale = 1.65,
		},
	}
	for name, spec in specifications do
		Characters.create(cast, name, spec)
	end
	return cast
end

return Characters
