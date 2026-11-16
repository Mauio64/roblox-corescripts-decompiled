local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local UIBlox = require(CorePackages.Packages.UIBlox)

local loadableImage = UIBlox.App.Loading.LoadableImage
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

return function(p2)
	local v5 = useDesignTokens()
	return React.createElement(
		"Frame",
		{
			Size = UDim2.fromOffset(v5.Size.Size_2400, v5.Size.Size_2400),
			BackgroundTransparency = 0
		},
		{
			AvatarThumbnail = React.createElement(loadableImage, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, v5.Size.Size_2400, 0, v5.Size.Size_2400),
				ScaleType = Enum.ScaleType.Fit,
				BackgroundTransparency = 1,
				Image = p2.thumbnailUrl,
				useShimmerAnimationWhileLoading = true,
				ZIndex = 2
			})
		}
	)
end
