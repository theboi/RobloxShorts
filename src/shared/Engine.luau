--!strict
-- One portability boundary. Offline model generation uses real Lune Roblox instances.
if game then
	return {
		Instance = Instance,
		Vector3 = Vector3,
		CFrame = CFrame,
		Color3 = Color3,
		Enum = Enum,
		Vector2 = Vector2,
		UDim2 = UDim2,
		Font = Font,
	}
end
return require("@lune/roblox")
