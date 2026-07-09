local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)

require(Parent.Foundation)

local LoadableImage = require(Parent.UIBlox).App.Loading.LoadableImage

local function SduiTileInsetImage(t1: {[any]: any}) -- line: 50
	-- upvalues: React (copy), LoadableImage (copy)
	local v6 = not t1.isContained and 0 or t1.cardCornerRadius

	return React.createElement("Frame", {
		[React.Tag] = if not t1.testId then nil else `data-testid={ t1.testId }`,
		Size = UDim2.new(1, 0, 1, v6),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		BackgroundColor3 = if not t1.backgroundStyle then nil else t1.backgroundStyle.Color3,
		BackgroundTransparency = not t1.backgroundStyle and 1 or t1.backgroundStyle.Transparency,
		ZIndex = -3
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, t1.cardCornerRadius)
		}),
		ThumbnailFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, t1.imagePadding * -2, 1, t1.imagePadding * -2 - v6),
			Position = UDim2.fromOffset(t1.imagePadding, t1.imagePadding)
		}, {
			Thumbnail = if not t1.imageComponent then if not t1.image then nil else React.createElement(LoadableImage, {
				BackgroundTransparency = 1,
				showFailedStateWhenLoadingFailed = true,
				useShimmerAnimationWhileLoading = true,
				Image = t1.image,
				Size = UDim2.new(1, 0, 1, 0),
				cornerRadius = UDim.new(0, t1.imageCornerRadius)
			}) else t1.imageComponent
		})
	})
end

return React.memo(SduiTileInsetImage)
