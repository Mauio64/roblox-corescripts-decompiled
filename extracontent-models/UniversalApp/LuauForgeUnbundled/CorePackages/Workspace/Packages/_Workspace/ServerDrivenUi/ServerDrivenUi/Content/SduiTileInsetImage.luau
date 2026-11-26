local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local loadableImage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UIBlox").App.Loading.LoadableImage

local function SduiTileInsetImage(props)
	local v5 = not props.isContained and 0 or props.cardCornerRadius

	local createElement = React.createElement
	local tag = React.Tag
	local v8 = if props.testId then `data-testid={props.testId}` else nil
	local v7 = {
		[tag] = v8,
		Size = UDim2.new(1, 0, 1, v5),
		BorderSizePixel = 0,
		ClipsDescendants = true
	}

	local v9 = if props.backgroundStyle then props.backgroundStyle.Color3 else nil
	v7.BackgroundColor3 = v9
	v7.BackgroundTransparency = not props.backgroundStyle and 1 or props.backgroundStyle.Transparency
	v7.ZIndex = -3
	local v10 = {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, props.cardCornerRadius)
		}),
		ThumbnailFrame = 0
	}

	local createElement2 = React.createElement
	local v12 = {
		Size = UDim2.new(1, -2 * props.imagePadding, 1, -2 * props.imagePadding - v5),
		Position = UDim2.fromOffset(props.imagePadding, props.imagePadding),
		BackgroundTransparency = 1
	}
	local v14

	if props.imageComponent then
		v14 = props.imageComponent
	elseif props.image then
		v14 = React.createElement(loadableImage, {
			BackgroundTransparency = 1,
			Image = props.image,
			Size = UDim2.new(1, 0, 1, 0),
			cornerRadius = UDim.new(0, props.imageCornerRadius),
			showFailedStateWhenLoadingFailed = true,
			useShimmerAnimationWhileLoading = true
		})
	end

	v10.ThumbnailFrame = createElement2("Frame", v12, { Thumbnail = v14 })
	return createElement("Frame", v7, v10)
end

return React.memo(SduiTileInsetImage)
