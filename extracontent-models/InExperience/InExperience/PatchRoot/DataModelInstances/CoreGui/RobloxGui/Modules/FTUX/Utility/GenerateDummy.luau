local t1 = {}
local t2 = {}
local t3 = {
	ID = 0,
	Type = "Model",
	Properties = {
		Name = "Safety Bubble Dummy",
		PrimaryPart = "_R:1_"
	},
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
			Children = {{
				ID = 2,
				Type = "Motor6D",
				Properties = {
					Part1 = "_R:3_",
					Name = "Root Hip",
					Part0 = "_R:1_",
					MaxVelocity = 0.10000000149011612,
					C1 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
					C0 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
				},
				Children = {}
			}}
		},
		{
			ID = 3,
			Type = "Part",
			Properties = {
				Size = Vector3.new(2, 2, 1),
				Name = "Torso",
				BottomSurface = Enum.SurfaceType.Smooth,
				TopSurface = Enum.SurfaceType.Smooth
			},
			Children = {
				{
					ID = 4,
					Type = "Motor6D",
					Properties = {
						Part1 = "_R:9_",
						Name = "Left Hip",
						Part0 = "_R:3_",
						MaxVelocity = 0.10000000149011612,
						C1 = CFrame.new(-0.5, 1, 0, -4.371138828673793E-08, 0, -1, 0, 0.9999999403953552, 0, 1, 0, -4.371138828673793E-08),
						C0 = CFrame.new(-1, -1, 0, -4.371138828673793E-08, 0, -1, 0, 0.9999999403953552, 0, 1, 0, -4.371138828673793E-08)
					},
					Children = {}
				},
				{
					ID = 5,
					Type = "Motor6D",
					Properties = {
						Part1 = "_R:10_",
						Name = "Right Hip",
						Part0 = "_R:3_",
						MaxVelocity = 0.10000000149011612,
						C1 = CFrame.new(0.5, 1, 0, -4.371138828673793E-08, 0, 1, 0, 0.9999999403953552, 0, -1, 0, -4.371138828673793E-08),
						C0 = CFrame.new(1, -1, 0, -4.371138828673793E-08, 0, 1, -0, 0.9999999403953552, 0, -1, 0, -4.371138828673793E-08)
					},
					Children = {}
				},
				{
					ID = 6,
					Type = "Motor6D",
					Properties = {
						Part1 = "_R:11_",
						Name = "Left Shoulder",
						Part0 = "_R:3_",
						MaxVelocity = 0.10000000149011612,
						C1 = CFrame.new(0.5, 0.5, 0, -4.371138828673793E-08, 0, -1, 0, 0.9999999403953552, 0, 1, 0, -4.371138828673793E-08),
						C0 = CFrame.new(-1, 0.5, 0, -4.371138828673793E-08, 0, -1, 0, 0.9999999403953552, 0, 1, 0, -4.371138828673793E-08)
					},
					Children = {}
				},
				{
					ID = 7,
					Type = "Motor6D",
					Properties = {
						Part1 = "_R:12_",
						Name = "Right Shoulder",
						Part0 = "_R:3_",
						MaxVelocity = 0.10000000149011612,
						C1 = CFrame.new(-0.5, 0.5, 0, -4.371138828673793E-08, 0, 1, 0, 0.9999999403953552, 0, -1, 0, -4.371138828673793E-08),
						C0 = CFrame.new(1, 0.5, 0, -4.371138828673793E-08, 0, 1, -0, 0.9999999403953552, 0, -1, 0, -4.371138828673793E-08)
					},
					Children = {}
				},
				{
					ID = 8,
					Type = "Motor6D",
					Properties = {
						Part1 = "_R:13_",
						Name = "Neck",
						Part0 = "_R:3_",
						MaxVelocity = 0.10000000149011612,
						C1 = CFrame.new(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
						C0 = CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
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
				Position = Vector3.new(-0.5, -1.9999998807907104, 0),
				BottomSurface = Enum.SurfaceType.Smooth,
				CFrame = CFrame.new(-0.5, -1.9999998807907104, 0, 1, 0, 0, 0, 0.9999998807907104, 0, 0, 0, 1),
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
				Position = Vector3.new(0.5, -1.9999998807907104, 0),
				BottomSurface = Enum.SurfaceType.Smooth,
				CFrame = CFrame.new(0.5, -1.9999998807907104, 0, 1, 0, 0, 0, 0.9999998807907104, 0, 0, 0, 1),
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
				Position = Vector3.new(-1.5, 5.960464477539063E-08, 0),
				BottomSurface = Enum.SurfaceType.Smooth,
				CFrame = CFrame.new(-1.5, 5.960464477539063E-08, 0, 1, 0, 0, 0, 0.9999998807907104, 0, 0, 0, 1),
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
				Position = Vector3.new(1.5, 5.960464477539063E-08, 0),
				BottomSurface = Enum.SurfaceType.Smooth,
				CFrame = CFrame.new(1.5, 5.960464477539063E-08, 0, 1, 0, 0, 0, 0.9999998807907104, 0, 0, 0, 1),
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
					Properties = {
						Name = "Face",
						Texture = "rbxasset://textures/face.png"
					},
					Children = {}
				},
				{
					ID = 15,
					Type = "SpecialMesh",
					Properties = {
						Scale = Vector3.new(1.25, 1.25, 1.25)
					},
					Children = {}
				}
			}
		},
		{
			ID = 16,
			Type = "Humanoid",
			Properties = {},
			Children = {}
		}
	}
}

local function Scan(p1, p2, p3, p4) -- line: 316
	-- upvalues: t2 (copy), t1 (copy), Scan (copy)
	local v9 = Instance.new(p1.Type)

	if p1.ID then
		local v10 = t2[p1.ID]

		if v10 then
			v10[1][v10[2]] = v9
			t2[p1.ID] = nil
		else
			t1[p1.ID] = v9
		end
	end

	for k, v in pairs(p1.Properties) do
		local v13 = v

		if type(v13) == "string" then
			local num = tonumber(v13:match("^_R:(%w+)_$"))

			if num then
				if t1[num] then
					v13 = t1[num]
				else
					t2[num] = {
						v9,
						k
					}
					v13 = nil
				end
			end
		end

		v9[k] = v13
	end

	for _, v in pairs(p1.Children) do
		Scan(v, v9, p3, p4)
	end

	v9.Parent = p2

	if v9:IsA("Part") then
		v9.Position = v9.Position + p3
		v9.Orientation = v9.Orientation + p4
		v9.Anchored = true
	end

	return v9
end

return function(p5, p6) -- line: 354
	-- upvalues: Scan (copy), t3 (copy)
	return (Scan(t3, nil, p5, p6))
end
