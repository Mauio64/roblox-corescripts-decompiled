local parent = script:FindFirstAncestor("CollectionViews").Parent

local React = require(parent.React)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local UIBlox = require(parent.UIBlox)

local useStyle = UIBlox.Core.Style.useStyle
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiComponentsUseFoundationTokens = SharedFlags.FFlagSduiComponentsUseFoundationTokens

local function CollectionBackgroundMural(props)
	local color3, v

	if FFlagSduiComponentsUseFoundationTokens then
		local v2 = useTokens()
		color3 = v2.Color.Extended.Black.Black_100.Color3
		v = v2.Color.Surface.Surface_0.Color3
	else
		v = useStyle().Theme.BackgroundDefault.Color

		color3 = useDesignTokens().Color.Extended.Black.Black_100.Color3
	end

	return React.createElement("ImageLabel", {
		ImageTransparency = 0,
		Image = props.backgroundMuralUrl,
		BackgroundTransparency = 1,
		Size = props.containerSizeBinding:map(function(vector2: Vector2)
			return UDim2.new(1, 0, 0, vector2.Y)
		end),
		ZIndex = props.ZIndex or -1,
		LayoutOrder = props.LayoutOrder,
		ScaleType = Enum.ScaleType.Crop
	}, {
		GradientFrame = React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 0,
				BorderSizePixel = 0
			},
			{
				Gradient = React.createElement("UIGradient", {
					Rotation = 90,
					Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, color3), ColorSequenceKeypoint.new(1, v) }),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0)
					})
				})
			}
		)
	})
end

return React.memo(CollectionBackgroundMural)
