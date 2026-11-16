--!strict
local E = if script then require(script.Parent.Engine) else require("./Engine")
local V, C = E.Vector3.new, E.CFrame.new
local Motion = {}

function Motion.position(state, alpha: number): Vector3
	local a = state.position or { 0, 0, 0 }
	local b = state.to or a
	local t = math.clamp(alpha, 0, 1)
	if state.ease == "smooth" then
		t = t * t * (3 - 2 * t)
	end
	return V(a[1] + (b[1] - a[1]) * t, a[2] + (b[2] - a[2]) * t, a[3] + (b[3] - a[3]) * t)
end

function Motion.frame(state, alpha: number): CFrame
	local yaw = (state.yaw or 0) + ((state.yawTo or state.yaw or 0) - (state.yaw or 0)) * alpha
	return C(Motion.position(state, alpha)) * E.CFrame.Angles(0, math.rad(yaw), 0)
end

local function rotation(x, y, z)
	return E.CFrame.Angles(math.rad(x), math.rad(y), math.rad(z))
end

function Motion.pose(pose: string, seconds: number, alpha: number)
	local swing = math.sin(seconds * 9) * 32
	local joints = {
		["Head"] = E.CFrame.identity,
		["Left Arm"] = E.CFrame.identity,
		["Right Arm"] = E.CFrame.identity,
		["Left Leg"] = E.CFrame.identity,
		["Right Leg"] = E.CFrame.identity,
	}
	local body = E.CFrame.identity
	if pose == "walk" or pose == "run" then
		local gain = if pose == "run" then 1.6 else 1
		joints["Left Arm"], joints["Right Arm"] = rotation(swing * gain, 0, -5), rotation(-swing * gain, 0, 5)
		joints["Left Leg"], joints["Right Leg"] = rotation(-swing * gain, 0, 0), rotation(swing * gain, 0, 0)
		body = C(0, math.abs(math.sin(seconds * 9)) * 0.08, 0)
			* rotation(if pose == "run" then -12 else -3, 0, 0)
	elseif pose == "point" then
		joints["Right Arm"] = rotation(-85, 0, 0)
	elseif pose == "reach" or pose == "shield" then
		joints["Left Arm"], joints["Right Arm"] = rotation(-100, 0, -25), rotation(-100, 0, 25)
	elseif pose == "scared" then
		joints["Left Arm"], joints["Right Arm"] = rotation(-65, 0, -20), rotation(-65, 0, 20)
		joints.Head = rotation(0, math.sin(seconds * 3) * 12, 0)
	elseif pose == "kneel" then
		body = C(0, -0.85, 0) * rotation(-12, 0, 0)
		joints["Right Leg"], joints["Left Leg"] = rotation(75, 0, 0), rotation(-35, 0, 0)
	elseif pose == "fall" then
		body = C(0, -2.4 * alpha, 0) * rotation(-85 * alpha, 0, 0)
		joints["Left Arm"], joints["Right Arm"] = rotation(-70, 0, -35), rotation(-70, 0, 35)
	elseif pose == "prone" then
		body = C(0, -2.4, 0) * rotation(-85, 0, 0)
	elseif pose == "pounce" then
		body = C(0, math.sin(alpha * math.pi) * 3, 0) * rotation(-30, 0, 0)
		joints["Left Arm"], joints["Right Arm"] = rotation(-110, 0, -20), rotation(-110, 0, 20)
	elseif pose == "wave" then
		joints["Right Arm"] = rotation(0, 0, 150 + math.sin(seconds * 5) * 15)
	elseif pose == "sit" then
		body = C(0, -0.3, 0)
		joints["Left Leg"], joints["Right Leg"] = rotation(-90, 0, 0), rotation(-90, 0, 0)
	elseif pose == "pet" then
		joints["Right Arm"] = rotation(-60 + math.sin(seconds * 5) * 8, 0, 15)
	elseif pose == "strain" then
		body = C(0, math.sin(seconds * 24) * 0.025, 0) * rotation(-15, 0, 0)
		joints["Left Arm"], joints["Right Arm"] = rotation(-25, 0, -20), rotation(-25, 0, 20)
	end
	return body, joints
end

function Motion.applyActor(model: Model, state, seconds: number, alpha: number)
	local rootFrame = Motion.frame(state, alpha)
	local body, joints = Motion.pose(state.pose or "idle", seconds, alpha)
	local scale = state.scale or model:GetAttribute("Scale") or 1
	local bones = {}
	for _, name in { "Root", "Torso", "Head", "Left Arm", "Right Arm", "Left Leg", "Right Leg" } do
		local part = model:FindFirstChild(name)
		local pivot = part:GetAttribute("JointPivot")
		bones[name] = if pivot then body * pivot * joints[name] * pivot:Inverse() else body
	end
	for _, part in model:GetChildren() do
		if part:IsA("BasePart") then
			local bind = part:GetAttribute("Bind")
			local cf = (bones[part:GetAttribute("Bone")] or body) * bind
			part.Size = (part:GetAttribute("BaseSize") or part.Size) -- initialized once below
			if not part:GetAttribute("BaseSize") then
				part:SetAttribute("BaseSize", part.Size)
			end
			part.Size = part:GetAttribute("BaseSize") * scale
			part.CFrame = rootFrame * C(cf.Position * scale) * cf.Rotation
			if part.Name == "Root" then
				part.Transparency = 1
			end
		end
	end
	local face = model.Head:FindFirstChild("Face")
	if face then
		face.Mouth.Text = ({ scared = "O", angry = "—", sad = "⌢", happy = "ᴗ", neutral = "—" })[state.face or "happy"]
			or "ᴗ"
	end
	return rootFrame
end

return Motion
