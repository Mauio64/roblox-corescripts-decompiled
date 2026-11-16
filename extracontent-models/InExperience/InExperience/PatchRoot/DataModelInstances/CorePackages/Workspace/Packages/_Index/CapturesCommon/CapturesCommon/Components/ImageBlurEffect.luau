local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local BlurDirection = require(parent.Enums.BlurDirection)

local function getImageRect(direction, imageSize: Vector2)
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

local function getGradientRotation(direction): nil | number -- 1 equivalent call inferred from this helper
	if direction == BlurDirection.Up then
		return 270
	end

	if direction == BlurDirection.Down then
		return 90
	end

	if direction == BlurDirection.Left then
		return 180
	end

	return if direction == BlurDirection.Right then 0 else nil
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

local function getTransparency(p: number, transparencyBinding)
	if transparencyBinding then
		return transparencyBinding:map(function(p2)
			return p + (1 - p) * p2
		end)
	end

	return p
end

local function ImageBlurEffect(props)
	local v

	if props.gradientColor then
		v = props.gradientColor
	else
		v = Color3.new(0, 0, 0)
	end

	local imageRect, imageRectSize = getImageRect(props.direction, props.imageSize)
	local radialGradientPosition = getRadialGradientPosition(props.direction)

	local imageTransparency = React.useMemo(function()
		return getTransparency(0, props.transparencyBinding)
	end, { props.transparencyBinding })

	local imageTransparency2 = React.useMemo(function()
		return getTransparency(0.9, props.transparencyBinding)
	end, { props.transparencyBinding })

	local imageTransparency3 = React.useMemo(function()
		return getTransparency(0.8, props.transparencyBinding)
	end, { props.transparencyBinding })

	return React.createElement("ImageLabel", {
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Image = props.image,
		ImageRectOffset = imageRect,
		ImageRectSize = imageRectSize,
		ImageTransparency = imageTransparency,
		Position = props.Position,
		ScaleType = Enum.ScaleType.Crop,
		Size = props.Size,
		ZIndex = props.ZIndex
	}, {
		UIGradient = React.createElement("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, v)
			}),
			Rotation = getGradientRotation(props.direction), -- inferred equivalent call
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.3),
				NumberSequenceKeypoint.new(0.5, 0.5),
				NumberSequenceKeypoint.new(1, 1)
			})
		}),
		RadialBlur = React.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/shadowblurmask.png",
			ImageTransparency = imageTransparency2,
			Position = radialGradientPosition,
			ScaleType = Enum.ScaleType.Crop,
			Size = UDim2.fromScale(2, 2),
			ZIndex = 1
		}),
		SoftEdges = React.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/VR/edgeBlur.png",
			ImageTransparency = imageTransparency3,
			Position = radialGradientPosition,
			ScaleType = Enum.ScaleType.Crop,
			Size = UDim2.fromScale(1.5, 2),
			ZIndex = 2
		})
	})
end

return ImageBlurEffect
