local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local React = require(parent3.React)
local useStyle = require(parent2.Core.Style.useStyle)
local ImageSetComponent = require(parent2.Core.ImageSet.ImageSetComponent)
local Images = require(parent3.UIBlox.App.ImageSet.Images)
require(parent.ImageSet.ImagesTypes)
require(parent2.App.Style.StyleTypes)

local function renderHalfCircle(props, p)
	local layoutOrder = props.layoutOrder
	local isLeft = props.isLeft
	local rotation = props.rotation
	local progressImage = props.progressImage

	local iconDefault = p.Theme.IconDefault
	local divider = p.Theme.Divider

	local createElement = React.createElement
	local v = {
		LayoutOrder = layoutOrder,
		Size = UDim2.fromScale(0.5, 1),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ClipsDescendants = true
	}

	local createElement2 = React.createElement
	local label = ImageSetComponent.Label
	local v2 = {
		Size = UDim2.fromScale(2, 1),
		AnchorPoint = 0,
		Image = 0,
		BackgroundTransparency = 1
	}
	local anchorPoint

	if not isLeft then
		anchorPoint = Vector2.new(0.5, 0)
	end

	v2.AnchorPoint = anchorPoint
	v2.Image = progressImage
	return createElement("Frame", v, {
		CircleImage = createElement2(label, v2, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = rotation,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, iconDefault.Color),
					ColorSequenceKeypoint.new(0.499, iconDefault.Color),
					ColorSequenceKeypoint.new(0.5, divider.Color),
					ColorSequenceKeypoint.new(1, divider.Color)
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, iconDefault.Transparency),
					NumberSequenceKeypoint.new(0.499, iconDefault.Transparency),
					NumberSequenceKeypoint.new(0.5, divider.Transparency),
					NumberSequenceKeypoint.new(1, divider.Transparency)
				})
			})
		})
	})
end

local function ProgressIcon(props)
	local progress = props.progress
	local isHolding = props.isHolding
	local image = if isHolding then props.iconHolding else props.icon
	local progressImage

	if isHolding then
		progressImage = Images["icons/controls/keys/hold_button_assets/hold_Pressed_RadialFill"]
	else
		progressImage = Images["icons/controls/keys/hold_button_assets/hold_Unpressed_RadialFill"]
	end

	local image2

	if isHolding then
		image2 = Images["icons/controls/keys/hold_button_assets/hold_Pressed_Arrow"]
	else
		image2 = Images["icons/controls/keys/hold_button_assets/hold_Unpressed_Arrow"]
	end

	local v = useStyle()

	local rotation = React.useMemo(function()
		return progress:map(function(value)
			return (math.clamp((value or 0) * 314 + 23, 180, 337))
		end)
	end, { progress })

	local rotation2 = React.useMemo(function()
		return progress:map(function(value)
			return (math.clamp((value or 0) * 314 + 23, 23, 180))
		end)
	end, { progress })

	local imageTransparency = React.useMemo(function()
		return progress:map(function(p: number?)
			if p then
				return (math.clamp(0.8 - p * 0.8, 0, 0.8))
			end

			return 0
		end)
	end, { progress })

	return React.createElement(
		"Frame",
		{ Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, BackgroundTransparency = 1 },
		{
			Progress = React.createElement(
				"Frame",
				{
					Size = UDim2.fromScale(1, 1),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					ZIndex = 1
				},
				{
					UIListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					Left = renderHalfCircle(
						{
							layoutOrder = 1,
							isLeft = true,
							progressImage = progressImage,
							rotation = rotation
						},
						v
					),
					Right = renderHalfCircle(
						{ layoutOrder = 2, progressImage = progressImage, rotation = rotation2 },
						v
					)
				}
			),
			Icon = React.createElement(ImageSetComponent.Label, {
				Size = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Image = image,
				ImageColor3 = v.Theme.IconEmphasis.Color,
				ImageTransparency = imageTransparency,
				BackgroundTransparency = 1,
				ZIndex = 2
			}),
			Arrow = React.createElement(ImageSetComponent.Label, {
				Size = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0),
				Image = image2,
				ImageColor3 = v.Theme.IconEmphasis.Color,
				ImageTransparency = 0,
				BackgroundTransparency = 1,
				ZIndex = 3
			})
		}
	)
end

return ProgressIcon
