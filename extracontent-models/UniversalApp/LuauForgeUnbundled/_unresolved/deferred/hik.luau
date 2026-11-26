local InsertService = game:GetService("InsertService")

local module = require("@luauforge/bundled/fCh")
local Extents = require("@game/CorePackages/Packages/_Index/UGCValidation/UGCValidation/util/Extents")

local v5 = {}

local set = { [Extents.X] = true, [Extents.Y] = true, [Extents.Z] = true }

function v5.setPositionAdornee(instance, adornee, p2)
	for i, billboardGui in instance:GetChildren() do
		if billboardGui.Name == "Line" then
			local weld = billboardGui:FindFirstChild("Weld")
			weld.Part1 = p2
		elseif billboardGui:IsA("BillboardGui") and set[billboardGui.Name] then
			billboardGui.Adornee = p2
		elseif billboardGui:IsA("BillboardGui") and billboardGui.Name == "Selection" then
			billboardGui.Adornee = adornee
		end
	end
end

function v5.setRotationAdornee(instance, p2)
	for i, child in instance:GetChildren() do
		if child:IsA("MeshPart") then
			local weld = child:FindFirstChild("Weld")
			weld.Part1 = p2
		elseif child:IsA("BillboardGui") then
			child.Adornee = p2
		elseif child:IsA("LineHandleAdornment") then
			child.Adornee = p2
		end
	end
end

function v5.setScaleAdornee(instance, adornee)
	for i, billboardGui in instance:GetChildren() do
		if billboardGui:IsA("BillboardGui") then
			billboardGui.Adornee = adornee
		end
	end
end

local function makeAxisLabel(p2, studsOffsetWorldSpace, sizeOffset, textColor, parent, p3)
	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Size = UDim2.new(0, p3, 0, p3)
	billboardGui.AlwaysOnTop = true
	billboardGui.StudsOffsetWorldSpace = studsOffsetWorldSpace
	billboardGui.SizeOffset = sizeOffset
	billboardGui.Name = p2

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = p2
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.Text = p2
	textLabel.TextColor3 = textColor
	textLabel.TextScaled = true
	textLabel.BackgroundTransparency = 1
	textLabel.Parent = billboardGui
	textLabel.FontFace = module.FontFace
	billboardGui.Parent = parent
end

function v5.getAxisPositionLabelOffset(p2, p3)
	if p2 == Extents.X then
		return (Vector3.new(-p3, 0, 0))
	end

	if p2 == Extents.Y then
		return (Vector3.new(0, p3, 0))
	end

	return (Vector3.new(0, 0, -p3))
end

function v5.createPositionAxis(parent, p2, p3, p4, data)
	local v6 = p3 / 2

	for k, v7 in module.LineHandleData do
		local v8

		if v7.Direction > 0 then
			v8 = v6 + math.abs(data[v7.LimitKey])
		else
			v8 = v6 + math.abs(p4[v7.LimitKey])
		end

		local line = Instance.new("Part")
		line.Shape = Enum.PartType.Cylinder
		line.Name = "Line"
		line.Color = v7.Color3
		line.CFrame = v7.Orientation
		line.Transparency = 0.15
		line.Size = Vector3.new(v8, module.LineDiameter, module.LineDiameter)

		local weld = Instance.new("Weld")
		weld.Part0 = line
		weld.C0 = CFrame.new((Vector3.new(-v8 / 2, 0, 0))) * v7.Orientation
		weld.Parent = line

		line.Parent = parent
	end

	local vector2 = Vector2.new(0, 0.5)
	makeAxisLabel(
		Extents.X,
		v5.getAxisPositionLabelOffset(Extents.X, v6 + data.xPosition),
		vector2,
		module.XAxisColor,
		parent,
		p2
	)

	makeAxisLabel(
		Extents.Y,
		v5.getAxisPositionLabelOffset(Extents.Y, v6 + data.yPosition),
		Vector2.new(0, 0.5),
		module.YAxisColor,
		parent,
		p2
	)

	makeAxisLabel(
		Extents.Z,
		v5.getAxisPositionLabelOffset(Extents.Z, v6 + data.zPosition),
		vector2,
		module.ZAxisColor,
		parent,
		p2
	)
end

function v5.getLargestAxisSize(data)
	local x = math.abs(data.X)
	local y = math.abs(data.Y)
	local z = math.abs(data.Z)

	if y <= x and z <= x then
		return x
	end

	if x <= y and z <= y then
		return y
	end

	return z
end

function v5.getScreenDiameter(p2)
	local largestAxisSize = v5.getLargestAxisSize(p2.Size)
	local position = p2.Position
	local v6 = largestAxisSize / 2
	local v7 = position + Vector3.new(0, v6, 0)
	local v8 = position - Vector3.new(0, v6, 0)
	local camera = workspace:FindFirstChild("Camera")
	assert(camera, "Assert camera not nil")
	return (camera:WorldToScreenPoint(v7) - camera:WorldToScreenPoint(v8)).magnitude + 20
end

function v5.createBillboardRing(p2, parent, image, name)
	local billboardGui = Instance.new("BillboardGui")
	local screenDiameter = v5.getScreenDiameter(p2)
	billboardGui.Size = UDim2.new(0, screenDiameter, 0, screenDiameter)
	billboardGui.AlwaysOnTop = true
	billboardGui.Name = name

	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(1, 0, 1, 0)
	imageLabel.Image = image
	imageLabel.BackgroundTransparency = 1
	imageLabel.Parent = billboardGui
	imageLabel.ImageColor3 = module.ZAxisColor
	billboardGui.Parent = parent
end

function v5.createSelectionDot(parent, image, name)
	local billboardGui = Instance.new("BillboardGui")

	billboardGui.Size = UDim2.new(0, 10, 0, 10)
	billboardGui.AlwaysOnTop = true
	billboardGui.Name = name

	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(1, 0, 1, 0)
	imageLabel.Image = image
	imageLabel.BackgroundTransparency = 1
	imageLabel.Parent = billboardGui
	imageLabel.ImageColor3 = Color3.new(1, 1, 1)
	billboardGui.Parent = parent
end

function v5.getAxisRotationLabelOffset(p2, p3)
	local v6 = p3 + 0.2

	if p2 == Extents.X then
		return (Vector3.new(0, v6, 0))
	end

	if p2 == Extents.Y then
		return (Vector3.new(v6, 0, 0))
	end

	local v7 = v6 / 1.4142135623730951
	return (Vector3.new(v7, v7, 0))
end

function v5.loadRingPart()
	return InsertService:LoadLocalAsset("rbxasset://models/AccessoryAdjustment/Ring.rbxm")
end

function v5.createRotationAxis(parent, p2, p3, instance)
	local v6 = p2 + 0.25

	for k, v7 in module.RingData do
		local rotationAxis = instance:Clone()
		rotationAxis.Name = "RotationAxis"
		rotationAxis.Color = v7.Color3
		local weld = Instance.new("Weld")
		weld.Part0 = rotationAxis
		weld.C0 = v7.Orientation
		local originalOrientation = Instance.new("CFrameValue")
		originalOrientation.Value = v7.Orientation
		originalOrientation.Name = "OriginalOrientation"
		originalOrientation.Parent = rotationAxis
		weld.Parent = rotationAxis
		rotationAxis.Size = Vector3.new(v6, 1 / 49 * v6, v6)
		rotationAxis.Parent = parent
	end

	local v7 = v6 / 2
	makeAxisLabel(
		Extents.X,
		v5.getAxisRotationLabelOffset(Extents.X, v7),
		Vector2.new(),
		module.XAxisColor,
		parent,
		p3
	)

	makeAxisLabel(
		Extents.Y,
		v5.getAxisRotationLabelOffset(Extents.Y, v7),
		Vector2.new(),
		module.YAxisColor,
		parent,
		p3
	)

	makeAxisLabel(
		Extents.Z,
		v5.getAxisRotationLabelOffset(Extents.Z, v7),
		Vector2.new(),
		module.ZAxisColor,
		parent,
		p3
	)
end

function v5.setUpCameraConnection(p2, instance)
	local camera = workspace:FindFirstChild("Camera")
	assert(camera, "Assert camera not nil")
	return camera:GetPropertyChangedSignal("CFrame"):Connect(function()
		local screenDiameter = v5.getScreenDiameter(p2)

		for i, child in instance:GetChildren() do
			if child.Name == "Selection" or child.Name == "Scale" then
				child.Size = UDim2.fromOffset(screenDiameter, screenDiameter)
			end
		end
	end)
end

function v5.setUpSizeConnection(instance, instance2)
	return instance:GetPropertyChangedSignal("Size"):Connect(function()
		for i, child in instance2:GetChildren() do
			local screenDiameter = v5.getScreenDiameter(instance)

			if child.Name == "Scale" then
				child.Size = UDim2.fromOffset(screenDiameter, screenDiameter)
			end
		end
	end)
end

return v5
