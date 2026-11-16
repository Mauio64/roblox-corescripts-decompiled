local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(parent.React)
require(parent.Foundation)
local UIBlox = require(parent.UIBlox)
local LoadableImage = UIBlox.App.Loading.LoadableImage

local function SduiTileInsetImage(props)
	local v = not props.isContained and 0 or props.cardCornerRadius

	local createElement = React.createElement
	local tag = React.Tag
	local v2

	if props.testId then
		v2 = `data-testid={props.testId}`
	end

	local v3 = {
		[tag] = v2,
		Size = UDim2.new(1, 0, 1, v),
		BorderSizePixel = 0,
		ClipsDescendants = true
	}
	local backgroundColor

	if props.backgroundStyle then
		backgroundColor = props.backgroundStyle.Color3
	end

	v3.BackgroundColor3 = backgroundColor
	v3.BackgroundTransparency = not props.backgroundStyle and 1 or props.backgroundStyle.Transparency
	v3.ZIndex = -3
	local v4 = {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, props.cardCornerRadius)
		}),
		ThumbnailFrame = 0
	}

	local createElement2 = React.createElement
	local v5 = {
		Size = UDim2.new(1, props.imagePadding * -2, 1, props.imagePadding * -2 - v),
		Position = UDim2.fromOffset(props.imagePadding, props.imagePadding),
		BackgroundTransparency = 1
	}
	local thumbnail

	if props.imageComponent then
		thumbnail = props.imageComponent
	elseif props.image then
		thumbnail = React.createElement(LoadableImage, {
			BackgroundTransparency = 1,
			Image = props.image,
			Size = UDim2.new(1, 0, 1, 0),
			cornerRadius = UDim.new(0, props.imageCornerRadius),
			showFailedStateWhenLoadingFailed = true,
			useShimmerAnimationWhileLoading = true
		})
	end

	v4.ThumbnailFrame = createElement2("Frame", v5, { Thumbnail = thumbnail })
	return createElement("Frame", v3, v4)
end

return React.memo(SduiTileInsetImage)
