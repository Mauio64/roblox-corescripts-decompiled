local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/React")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Style").useDesignTokens
local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/UIBlox").Core.Style.useStyle
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Foundation").Hooks.useTokens
local fFlagSduiComponentsUseFoundationTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/SharedFlags").FFlagSduiComponentsUseFoundationTokens

local function CollectionBackgroundMural(props)
	local color3, v5

	if fFlagSduiComponentsUseFoundationTokens then
		local v6 = useTokens()
		color3 = v6.Color.Extended.Black.Black_100.Color3
		v5 = v6.Color.Surface.Surface_0.Color3
	else
		v5 = useStyle().Theme.BackgroundDefault.Color

		color3 = useDesignTokens().Color.Extended.Black.Black_100.Color3
	end

	return React.createElement("ImageLabel", {
		ImageTransparency = 0,
		Image = props.backgroundMuralUrl,
		BackgroundTransparency = 1,
		Size = props.containerSizeBinding:map(function(p2)
			return UDim2.new(1, 0, 0, p2.Y)
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
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, color3),
						ColorSequenceKeypoint.new(1, v5)
					}),
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
