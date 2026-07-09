local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.AccessoryAdjustment.Constants)
local AxisType = require(Modules.AvatarExperience.AccessoryAdjustment.Enum.AxisType)
local t1 = {}
local t2 = {
	[AxisType.X] = true,
	[AxisType.Y] = true,
	[AxisType.Z] = true
}

function t1.setPositionAdornee(p1, p2, p3) -- line: 18
	-- upvalues: t2 (copy)
	for _, child in p1:GetChildren() do
		if child.Name == "Line" then
			child:FindFirstChild("Weld").Part1 = p3
		elseif child:IsA("BillboardGui") and t2[child.Name] then
			child.Adornee = p3
		elseif child:IsA("BillboardGui") and child.Name == "Selection" then
			child.Adornee = p2
		end
	end
end
function t1.setRotationAdornee(p4, p5) -- line: 31
	for _, child in p4:GetChildren() do
		if child:IsA("MeshPart") then
			child:FindFirstChild("Weld").Part1 = p5
		elseif child:IsA("BillboardGui") then
			child.Adornee = p5
		elseif child:IsA("LineHandleAdornment") then
			child.Adornee = p5
		end
	end
end
function t1.setScaleAdornee(p6, p7) -- line: 44
	for _, child in p6:GetChildren() do
		if child:IsA("BillboardGui") then
			child.Adornee = p7
		end
	end
end

local function makeAxisLabel(p8, vector3: Vector3, vector2: Vector2, color3: Color3, p9, n1: number) -- line: 52
	-- upvalues: Constants (copy)
	local BillboardGui = Instance.new("BillboardGui")

	BillboardGui.Size = UDim2.new(0, n1, 0, n1)
	BillboardGui.AlwaysOnTop = true
	BillboardGui.StudsOffsetWorldSpace = vector3
	BillboardGui.SizeOffset = vector2
	BillboardGui.Name = p8

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = p8
	TextLabel.Size = UDim2.new(1, 0, 1, 0)
	TextLabel.Text = p8
	TextLabel.TextColor3 = color3
	TextLabel.TextScaled = true
	TextLabel.BackgroundTransparency = 1
	TextLabel.Parent = BillboardGui
	TextLabel.FontFace = Constants.FontFace
	BillboardGui.Parent = p9
end

function t1.getAxisPositionLabelOffset(p10, p11) -- line: 79
	-- upvalues: AxisType (copy)
	if p10 == AxisType.X then
		return (Vector3.new(-p11, 0, 0))
	end

	if p10 == AxisType.Y then
		return (Vector3.new(0, p11, 0))
	end

	return (Vector3.new(0, 0, -p11))
end
function t1.createPositionAxis(p12, n2: number, n3: number, p13, p14) -- line: 89
	-- upvalues: Constants (copy), makeAxisLabel (copy), AxisType (copy), t1 (copy)
	local v35 = n3 / 2

	for _, v37 in Constants.LineHandleData do
		local v38 = if not (v37.Direction > 0) then v35 + math.abs(p13[v37.LimitKey]) else v35 + math.abs(p14[v37.LimitKey])
		local Part = Instance.new("Part")

		Part.Shape = Enum.PartType.Cylinder
		Part.Name = "Line"
		Part.Color = v37.Color3
		Part.CFrame = v37.Orientation
		Part.Transparency = 0.15
		Part.Size = Vector3.new(v38, Constants.LineDiameter, Constants.LineDiameter)

		local Weld = Instance.new("Weld")

		Weld.Part0 = Part
		Weld.C0 = CFrame.new((Vector3.new(-v38 / 2, 0, 0))) * v37.Orientation
		Weld.Parent = Part
		Part.Parent = p12
	end

	local vector2 = Vector2.new(0, 0.5)

	makeAxisLabel(AxisType.X, t1.getAxisPositionLabelOffset(AxisType.X, v35 + p14.xPosition), vector2, Constants.XAxisColor, p12, n2)
	makeAxisLabel(AxisType.Y, t1.getAxisPositionLabelOffset(AxisType.Y, v35 + p14.yPosition), Vector2.new(0, 0.5), Constants.YAxisColor, p12, n2)
	makeAxisLabel(AxisType.Z, t1.getAxisPositionLabelOffset(AxisType.Z, v35 + p14.zPosition), vector2, Constants.ZAxisColor, p12, n2)
end
function t1.getLargestAxisSize(vector3: Vector3) -- line: 148
	local v43 = math.abs(vector3.X)
	local v44 = math.abs(vector3.Y)
	local v45 = math.abs(vector3.Z)

	if v44 <= v43 and v45 <= v43 then
		return v43
	end

	if v43 <= v44 and v45 <= v44 then
		return v44
	end

	return v45
end
function t1.getScreenDiameter(p15) -- line: 161
	-- upvalues: t1 (copy)
	local v47 = t1.getLargestAxisSize(p15.Size)
	local p15Position = p15.Position
	local v49 = v47 / 2
	local v50 = p15Position + Vector3.new(0, v49, 0)
	local v51 = p15Position - Vector3.new(0, v49, 0)
	local Camera = workspace:FindFirstChild("Camera")

	assert(Camera, "Assert camera not nil")

	return (Camera:WorldToScreenPoint(v50) - Camera:WorldToScreenPoint(v51)).magnitude + 20
end
function t1.createBillboardRing(p16, p17, s1: string, p18) -- line: 175
	-- upvalues: t1 (copy), Constants (copy)
	local BillboardGui = Instance.new("BillboardGui")
	local v58 = t1.getScreenDiameter(p16)

	BillboardGui.Size = UDim2.new(0, v58, 0, v58)
	BillboardGui.AlwaysOnTop = true
	BillboardGui.Name = p18

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Size = UDim2.new(1, 0, 1, 0)
	ImageLabel.Image = s1
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Parent = BillboardGui
	ImageLabel.ImageColor3 = Constants.ZAxisColor
	BillboardGui.Parent = p17
end
function t1.createSelectionDot(p19, s2: string, p20) -- line: 191
	local BillboardGui = Instance.new("BillboardGui")

	BillboardGui.Size = UDim2.new(0, 10, 0, 10)
	BillboardGui.AlwaysOnTop = true
	BillboardGui.Name = p20

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Size = UDim2.new(1, 0, 1, 0)
	ImageLabel.Image = s2
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Parent = BillboardGui
	ImageLabel.ImageColor3 = Color3.new(1, 1, 1)
	BillboardGui.Parent = p19
end
function t1.getAxisRotationLabelOffset(p21, n4: number) -- line: 207
	-- upvalues: AxisType (copy)
	local v67 = n4 + 0.2

	if p21 == AxisType.X then
		return (Vector3.new(0, v67, 0))
	end

	if p21 == AxisType.Y then
		return (Vector3.new(v67, 0, 0))
	end

	local v68 = v67 / 1.4142135623730951

	return (Vector3.new(v68, v68, 0))
end
function t1.createRotationAxis(p22, n5: number, n6: number, p23) -- line: 218
	-- upvalues: Constants (copy), makeAxisLabel (copy), AxisType (copy), t1 (copy)
	local v73 = n5 + 0.25

	for _, v75 in Constants.RingData do
		local clone = p23:Clone()

		clone.Name = "RotationAxis"
		clone.Color = v75.Color3

		local Weld = Instance.new("Weld")

		Weld.Part0 = clone
		Weld.C0 = v75.Orientation

		local CFrameValue = Instance.new("CFrameValue")

		CFrameValue.Value = v75.Orientation
		CFrameValue.Name = "OriginalOrientation"
		CFrameValue.Parent = clone
		Weld.Parent = clone
		clone.Size = Vector3.new(v73, v73 * 0.02040816326530612, v73)
		clone.Parent = p22
	end

	local v79 = v73 / 2

	makeAxisLabel(AxisType.X, t1.getAxisRotationLabelOffset(AxisType.X, v79), Vector2.new(), Constants.XAxisColor, p22, n6)
	makeAxisLabel(AxisType.Y, t1.getAxisRotationLabelOffset(AxisType.Y, v79), Vector2.new(), Constants.YAxisColor, p22, n6)
	makeAxisLabel(AxisType.Z, t1.getAxisRotationLabelOffset(AxisType.Z, v79), Vector2.new(), Constants.ZAxisColor, p22, n6)
end
function t1.setUpCameraConnection(p24, p25) -- line: 262
	-- upvalues: t1 (copy)
	local Camera = workspace:FindFirstChild("Camera")

	assert(Camera, "Assert camera not nil")

	return Camera:GetPropertyChangedSignal("CFrame"):Connect(function() -- line: 265
		-- upvalues: t1 (copy), p24 (copy), p25 (copy)
		local v85 = t1.getScreenDiameter(p24)

		for _, child in p25:GetChildren() do
			if child.Name == "Selection" or child.Name == "Scale" then
				child.Size = UDim2.fromOffset(v85, v85)
			end
		end
	end)
end
function t1.setUpSizeConnection(p26, p27) -- line: 275
	-- upvalues: t1 (copy)
	return p26:GetPropertyChangedSignal("Size"):Connect(function() -- line: 276
		-- upvalues: p27 (copy), t1 (copy), p26 (copy)
		for _, child in p27:GetChildren() do
			local v90 = t1.getScreenDiameter(p26)

			if child.Name == "Scale" then
				child.Size = UDim2.fromOffset(v90, v90)
			end
		end
	end)
end

return t1
