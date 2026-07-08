return function() -- line: 4
	local Model = Instance.new("Model")

	Instance.new("Humanoid").Parent = Model

	local Part = Instance.new("Part")

	Part.Name = "HumanoidRootPart"
	Part.Size = Vector3.new(2, 2, 1)
	Part.Position = Vector3.new(0, 2, 0)
	Part.Transparency = 1
	Part.Parent = Model

	local Part2 = Instance.new("Part")

	Part2.Name = "Head"
	Part2.Size = Vector3.new(2, 1, 1)
	Part2.Position = Vector3.new(0, 5, 0)
	Part2.Shape = Enum.PartType.Ball
	Part2.Parent = Model

	local Part3 = Instance.new("Part")

	Part3.Name = "Torso"
	Part3.Size = Vector3.new(2, 2, 1)
	Part3.Position = Vector3.new(0, 3.5, 0)
	Part3.Parent = Model
	Model.PrimaryPart = Part

	return Model
end
