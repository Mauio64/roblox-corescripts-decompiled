return function()
	local model = Instance.new("Model")
	local humanoidRootPart = Instance.new("Part")
	humanoidRootPart.Name = "HumanoidRootPart"
	humanoidRootPart.Parent = model
	local humanoid = Instance.new("Humanoid")
	humanoid.Name = "Humanoid"
	humanoid.Parent = model
	local humanoidDescription = Instance.new("HumanoidDescription")
	humanoidDescription.Name = "HumanoidDescription"
	humanoidDescription.Parent = humanoid

	return model
end
