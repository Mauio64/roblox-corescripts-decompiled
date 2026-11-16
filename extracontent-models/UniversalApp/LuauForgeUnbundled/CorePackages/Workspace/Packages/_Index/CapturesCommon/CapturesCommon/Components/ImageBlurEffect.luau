local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/React")

local BlurDirection = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Enums/BlurDirection")

local function getImageRect(direction, imageSize)
	local x = imageSize.X
	local y = imageSize.Y

	if direction == BlurDirection.Up then
		return Vector2.new(0, 0), Vector2.new(x, 1)
	end

	if direction == BlurDirection.Down then
		return Vector2.new(0, y - 1), Vector2.new(x, 1)
	end

	if direction == BlurDirection.Left then
		return Vector2.new(0, 0), Vector2.new(1, y)
	end

	if direction == BlurDirection.Right then
		return Vector2.new(x - 1, 0), Vector2.new(1, y)
	end

	return nil
end

local function getGradientRotation(p2): nil | number
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

local function getRadialGradientPosition(direction)
	if direction == BlurDirection.Up then
		return UDim2.fromScale(0.5, 1)
	end

	if direction == BlurDirection.Down then
		return UDim2.fromScale(0.5, 0)
	end

	if direction == BlurDirection.Left then
		return UDim2.fromScale(1, 0.5)
	end

	if direction == BlurDirection.Right then
		return UDim2.fromScale(0, 0.5)
	end

	return nil
end

local function getTransparency(p2, transparencyBinding)
	if transparencyBinding then
		return transparencyBinding:map(function(p3)
			return p2 + (1 - p2) * p3
		end)
	end

	return p2
end

local function ImageBlurEffect(props)
	local v5 = if props.gradientColor then props.gradientColor else Color3.new(0, 0, 0)
	local imageRect, v6 = getImageRect(props.direction, props.imageSize)
	local radialGradientPosition = getRadialGradientPosition(props.direction)

	local v7 = React.useMemo(function()
		return getTransparency(0, props.transparencyBinding)
	end, { props.transparencyBinding })

	local v8 = React.useMemo(function()
		return getTransparency(0.9, props.transparencyBinding)
	end, { props.transparencyBinding })

	local v9 = React.useMemo(function()
		return getTransparency(0.8, props.transparencyBinding)
	end, { props.transparencyBinding })

	local createElement = React.createElement
	local v10 = {
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Image = props.image,
		ImageRectOffset = imageRect,
		ImageRectSize = v6,
		ImageTransparency = v7,
		Position = props.Position,
		ScaleType = Enum.ScaleType.Crop,
		Size = props.Size,
		ZIndex = props.ZIndex
	}

	local createElement2 = React.createElement
	local v11 = {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(1, v5)
		}),
		Rotation = 0,
		Transparency = 0
	}

	local direction = props.direction
	v11.Rotation = direction == BlurDirection.Up and 270
		or direction == BlurDirection.Down and 90
		or direction == BlurDirection.Left and 180
		or direction == BlurDirection.Right and 0
		or nil
	v11.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.3),
		NumberSequenceKeypoint.new(0.5, 0.5),
		NumberSequenceKeypoint.new(1, 1)
	})
	return createElement("ImageLabel", v10, {
		UIGradient = createElement2("UIGradient", v11),
		RadialBlur = React.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/shadowblurmask.png",
			ImageTransparency = v8,
			Position = radialGradientPosition,
			ScaleType = Enum.ScaleType.Crop,
			Size = UDim2.fromScale(2, 2),
			ZIndex = 1
		}),
		SoftEdges = React.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/VR/edgeBlur.png",
			ImageTransparency = v9,
			Position = radialGradientPosition,
			ScaleType = Enum.ScaleType.Crop,
			Size = UDim2.fromScale(1.5, 2),
			ZIndex = 2
		})
	})
end

return ImageBlurEffect
