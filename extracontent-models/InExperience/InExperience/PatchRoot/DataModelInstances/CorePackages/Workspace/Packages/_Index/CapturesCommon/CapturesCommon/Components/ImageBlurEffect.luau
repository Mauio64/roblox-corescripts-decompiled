local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local BlurDirection = require(ParentParent.Enums.BlurDirection)

local function getImageRect(p1, vector2: Vector2) -- line: 24
	-- upvalues: BlurDirection (copy)
	local vector2X = vector2.X
	local vector2Y = vector2.Y

	if p1 == BlurDirection.Up then
		return Vector2.new(0, 0), Vector2.new(vector2X, 1)
	end

	if p1 == BlurDirection.Down then
		return Vector2.new(0, vector2Y - 1), Vector2.new(vector2X, 1)
	end

	if p1 == BlurDirection.Left then
		return Vector2.new(0, 0), Vector2.new(1, vector2Y)
	end

	if p1 == BlurDirection.Right then
		return Vector2.new(vector2X - 1, 0), Vector2.new(1, vector2Y)
	end

	return nil
end
local function getGradientRotation(p2) -- line: 40
	-- upvalues: BlurDirection (copy)
	if p2 == BlurDirection.Up then
		return 270
	end

	if p2 == BlurDirection.Down then
		return 90
	end

	if p2 == BlurDirection.Left then
		return 180
	end

	if p2 == BlurDirection.Right then
		return 0
	end

	return nil
end
local function getRadialGradientPosition(p3) -- line: 54
	-- upvalues: BlurDirection (copy)
	if p3 == BlurDirection.Up then
		return UDim2.fromScale(0.5, 1)
	end

	if p3 == BlurDirection.Down then
		return UDim2.fromScale(0.5, 0)
	end

	if p3 == BlurDirection.Left then
		return UDim2.fromScale(1, 0.5)
	end

	if p3 == BlurDirection.Right then
		return UDim2.fromScale(0, 0.5)
	end

	return nil
end
local function getTransparency(n1: number, p4) -- line: 68
	if not p4 then
		return n1
	end

	return p4:map(function(p5) -- line: 76
		-- upvalues: n1 (copy)
		return n1 + (1 - n1) * p5
	end)
end
local function ImageBlurEffect(t1: {[any]: any}) -- line: 81
	-- upvalues: getImageRect (copy), getRadialGradientPosition (copy), React (copy), getTransparency (copy), BlurDirection (copy)
	local v19 = if not t1.gradientColor then Color3.new(0, 0, 0) else t1.gradientColor
	local v20, v21 = getImageRect(t1.direction, t1.imageSize)
	local v22 = getRadialGradientPosition(t1.direction)
	local v23 = React.useMemo(function() -- line: 86
		-- upvalues: getTransparency (copy), t1 (copy)
		return getTransparency(0, t1.transparencyBinding)
	end, { t1.transparencyBinding })
	local v24 = React.useMemo(function() -- line: 90
		-- upvalues: getTransparency (copy), t1 (copy)
		return getTransparency(0.9, t1.transparencyBinding)
	end, { t1.transparencyBinding })
	local v25 = React.useMemo(function() -- line: 94
		-- upvalues: getTransparency (copy), t1 (copy)
		return getTransparency(0.8, t1.transparencyBinding)
	end, { t1.transparencyBinding })
	local createElement = React.createElement
	local t2 = {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		AnchorPoint = t1.AnchorPoint,
		Image = t1.image,
		ImageRectOffset = v20,
		ImageRectSize = v21,
		ImageTransparency = v23,
		Position = t1.Position,
		ScaleType = Enum.ScaleType.Crop,
		Size = t1.Size,
		ZIndex = t1.ZIndex
	}
	local t3 = {}
	local createElement2 = React.createElement
	local t4 = {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(1, v19)
		})
	}
	local direction = t1.direction

	t4.Rotation = if direction ~= BlurDirection.Up then if direction ~= BlurDirection.Down then if direction ~= BlurDirection.Left then if direction ~= BlurDirection.Right then nil else 0 else 180 else 90 else 270
	t4.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.3),
		NumberSequenceKeypoint.new(0.5, 0.5),
		NumberSequenceKeypoint.new(1, 1)
	})
	t3.UIGradient = createElement2("UIGradient", t4)
	t3.RadialBlur = React.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/shadowblurmask.png",
		ZIndex = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		ImageTransparency = v24,
		Position = v22,
		ScaleType = Enum.ScaleType.Crop,
		Size = UDim2.fromScale(2, 2)
	})
	t3.SoftEdges = React.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/VR/edgeBlur.png",
		ZIndex = 2,
		AnchorPoint = Vector2.new(0.5, 0.5),
		ImageTransparency = v25,
		Position = v22,
		ScaleType = Enum.ScaleType.Crop,
		Size = UDim2.fromScale(1.5, 2)
	})

	return createElement("ImageLabel", t2, t3)
end

return ImageBlurEffect
