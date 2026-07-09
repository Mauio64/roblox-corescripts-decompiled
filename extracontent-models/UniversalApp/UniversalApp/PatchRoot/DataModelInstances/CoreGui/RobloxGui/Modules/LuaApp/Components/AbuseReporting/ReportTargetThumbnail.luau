local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local LoadableImage = require(CorePackages.Packages.UIBlox).App.Loading.LoadableImage
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: useDesignTokens (copy), React (copy), LoadableImage (copy)
	local v6 = useDesignTokens()

	return React.createElement("Frame", {
		BackgroundTransparency = 0,
		Size = UDim2.fromOffset(v6.Size.Size_2400, v6.Size.Size_2400)
	}, {
		AvatarThumbnail = React.createElement(LoadableImage, {
			BackgroundTransparency = 1,
			useShimmerAnimationWhileLoading = true,
			ZIndex = 2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, v6.Size.Size_2400, 0, v6.Size.Size_2400),
			ScaleType = Enum.ScaleType.Fit,
			Image = t1.thumbnailUrl
		})
	})
end
