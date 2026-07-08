return function() -- line: 4
	local Model = Instance.new("Model")
	local Part = Instance.new("Part")

	Part.Name = "HumanoidRootPart"
	Part.Parent = Model

	local Humanoid = Instance.new("Humanoid")

	Humanoid.Name = "Humanoid"
	Humanoid.Parent = Model

	local HumanoidDescription = Instance.new("HumanoidDescription")

	HumanoidDescription.Name = "HumanoidDescription"
	HumanoidDescription.Parent = Humanoid

	return Model
end
