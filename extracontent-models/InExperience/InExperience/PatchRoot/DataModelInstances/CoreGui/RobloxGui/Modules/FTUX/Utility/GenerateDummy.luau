local instancesById = {}
local v = {}

local v2 = {
	ID = 0,
	Type = "Model",
	Properties = { Name = "Safety Bubble Dummy", PrimaryPart = "_R:1_" },
	Children = {
		{
			ID = 1,
			Type = "Part",
			Properties = {
				Transparency = 0.5,
				Name = "HumanoidRootPart",
				Size = Vector3.new(2, 2, 1),
				Anchored = true,
				BottomSurface = Enum.SurfaceType.Smooth,
				TopSurface = Enum.SurfaceType.Smooth
			},
			Children = {
				{
					ID = 2,
					Type = "Motor6D",
					Properties = {
						Part1 = "_R:3_",
						Name = "Root Hip",
						C1 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
						C0 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
						Part0 = "_R:1_",
						MaxVelocity = 0.10000000149011612
					},
					Children = {}
				}
			}
		},
		{
			ID = 3,
			Type = "Part",
			Properties = {
				Size = Vector3.new(2, 2, 1),
				BottomSurface = Enum.SurfaceType.Smooth,
				Name = "Torso",
				TopSurface = Enum.SurfaceType.Smooth
			},
			Children = {
				{
					ID = 4,
					Type = "Motor6D",
					Properties = {
						Part1 = "_R:9_",
						Name = "Left Hip",
						C1 = CFrame.new(
							-0.5,
							1,
							0,
							-4.371138828673793e-8,
							0,
							-1,
							0,
							0.9999999403953552,
							0,
							1,
							0,
							-4.371138828673793e-8
						),
						C0 = CFrame.new(
							-1,
							-1,
							0,
							-4.371138828673793e-8,
							0,
							-1,
							0,
							0.9999999403953552,
							0,
							1,
							0,
							-4.371138828673793e-8
						),
						Part0 = "_R:3_",
						MaxVelocity = 0.10000000149011612
					},
					Children = {}
				},
				{
					ID = 5,
					Type = "Motor6D",
					Properties = {
						Part1 = "_R:10_",
						Name = "Right Hip",
						C1 = CFrame.new(
							0.5,
							1,
							0,
							-4.371138828673793e-8,
							0,
							1,
							0,
							0.9999999403953552,
							0,
							-1,
							0,
							-4.371138828673793e-8
						),
						C0 = CFrame.new(
							1,
							-1,
							0,
							-4.371138828673793e-8,
							0,
							1,
							-0,
							0.9999999403953552,
							0,
							-1,
							0,
							-4.371138828673793e-8
						),
						Part0 = "_R:3_",
						MaxVelocity = 0.10000000149011612
					},
					Children = {}
				},
				{
					ID = 6,
					Type = "Motor6D",
					Properties = {
						Part1 = "_R:11_",
						Name = "Left Shoulder",
						C1 = CFrame.new(
							0.5,
							0.5,
							0,
							-4.371138828673793e-8,
							0,
							-1,
							0,
							0.9999999403953552,
							0,
							1,
							0,
							-4.371138828673793e-8
						),
						C0 = CFrame.new(
							-1,
							0.5,
							0,
							-4.371138828673793e-8,
							0,
							-1,
							0,
							0.9999999403953552,
							0,
							1,
							0,
							-4.371138828673793e-8
						),
						Part0 = "_R:3_",
						MaxVelocity = 0.10000000149011612
					},
					Children = {}
				},
				{
					ID = 7,
					Type = "Motor6D",
					Properties = {
						Part1 = "_R:12_",
						Name = "Right Shoulder",
						C1 = CFrame.new(
							-0.5,
							0.5,
							0,
							-4.371138828673793e-8,
							0,
							1,
							0,
							0.9999999403953552,
							0,
							-1,
							0,
							-4.371138828673793e-8
						),
						C0 = CFrame.new(
							1,
							0.5,
							0,
							-4.371138828673793e-8,
							0,
							1,
							-0,
							0.9999999403953552,
							0,
							-1,
							0,
							-4.371138828673793e-8
						),
						Part0 = "_R:3_",
						MaxVelocity = 0.10000000149011612
					},
					Children = {}
				},
				{
					ID = 8,
					Type = "Motor6D",
					Properties = {
						Part1 = "_R:13_",
						Name = "Neck",
						C1 = CFrame.new(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
						C0 = CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
						Part0 = "_R:3_",
						MaxVelocity = 0.10000000149011612
					},
					Children = {}
				}
			}
		},
		{
			ID = 9,
			Type = "Part",
			Properties = {
				Size = Vector3.new(1, 2, 1),
				Name = "Left Leg",
				CanCollide = false,
				BottomSurface = Enum.SurfaceType.Smooth,
				CFrame = CFrame.new(-0.5, -1.9999998807907104, 0, 1, 0, 0, 0, 0.9999998807907104, 0, 0, 0, 1),
				Position = Vector3.new(-0.5, -1.9999999, 0),
				TopSurface = Enum.SurfaceType.Smooth
			},
			Children = {}
		},
		{
			ID = 10,
			Type = "Part",
			Properties = {
				Size = Vector3.new(1, 2, 1),
				Name = "Right Leg",
				CanCollide = false,
				BottomSurface = Enum.SurfaceType.Smooth,
				CFrame = CFrame.new(0.5, -1.9999998807907104, 0, 1, 0, 0, 0, 0.9999998807907104, 0, 0, 0, 1),
				Position = Vector3.new(0.5, -1.9999999, 0),
				TopSurface = Enum.SurfaceType.Smooth
			},
			Children = {}
		},
		{
			ID = 11,
			Type = "Part",
			Properties = {
				Size = Vector3.new(1, 2, 1),
				Name = "Left Arm",
				CanCollide = false,
				BottomSurface = Enum.SurfaceType.Smooth,
				CFrame = CFrame.new(-1.5, 5.960464477539063e-8, 0, 1, 0, 0, 0, 0.9999998807907104, 0, 0, 0, 1),
				Position = Vector3.new(-1.5, 5.9604645e-8, 0),
				TopSurface = Enum.SurfaceType.Smooth
			},
			Children = {}
		},
		{
			ID = 12,
			Type = "Part",
			Properties = {
				Size = Vector3.new(1, 2, 1),
				Name = "Right Arm",
				CanCollide = false,
				BottomSurface = Enum.SurfaceType.Smooth,
				CFrame = CFrame.new(1.5, 5.960464477539063e-8, 0, 1, 0, 0, 0, 0.9999998807907104, 0, 0, 0, 1),
				Position = Vector3.new(1.5, 5.9604645e-8, 0),
				TopSurface = Enum.SurfaceType.Smooth
			},
			Children = {}
		},
		{
			ID = 13,
			Type = "Part",
			Properties = {
				Name = "Head",
				Position = Vector3.new(0, 1.5, 0),
				Size = Vector3.new(2, 1, 1),
				CFrame = CFrame.new(0, 1.5, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				BottomSurface = Enum.SurfaceType.Smooth,
				TopSurface = Enum.SurfaceType.Smooth
			},
			Children = {
				{
					ID = 14,
					Type = "Decal",
					Properties = { Name = "Face", Texture = "rbxasset://textures/face.png" },
					Children = {}
				},
				{
					ID = 15,
					Type = "SpecialMesh",
					Properties = { Scale = Vector3.new(1.25, 1.25, 1.25) },
					Children = {}
				}
			}
		},
		{ ID = 16, Type = "Humanoid", Properties = {}, Children = {} }
	}
}
local function Scan(data, parent, p, p2)
	local instance = Instance.new(data.Type)

	if data.ID then
		local v3 = v[data.ID]

		if v3 then
			v3[1][v3[2]] = instance
			v[data.ID] = nil
		else
			instancesById[data.ID] = instance
		end
	end

	for k, property in pairs(data.Properties) do
		if type(property) == "string" then
			local v3 = tonumber(property:match("^_R:(%w+)_$"))

			if v3 then
				if instancesById[v3] then
					property = instancesById[v3]
				else
					v[v3] = { instance, k }
					property = nil
				end
			end
		end

		instance[k] = property
	end

	for _, child in pairs(data.Children) do
		Scan(child, instance, p, p2)
	end

	instance.Parent = parent

	if instance:IsA("Part") then
		instance.Position += p
		instance.Orientation += p2
		instance.Anchored = true
	end

	return instance
end

return function(p, p2)
	return (Scan(v2, nil, p, p2))
end
