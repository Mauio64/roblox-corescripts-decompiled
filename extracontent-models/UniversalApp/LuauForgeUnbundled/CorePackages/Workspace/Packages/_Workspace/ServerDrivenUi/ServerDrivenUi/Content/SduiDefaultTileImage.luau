require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local loadableImage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UIBlox").App.Loading.LoadableImage

local function SduiDefaultTileImage(props)
	local createElement = React.createElement
	local v7 = if props.thumbnailBackgroundStyle then props.thumbnailBackgroundStyle.Color3 or nil else nil
	local v6 = {
		BackgroundColor3 = v7,
		BackgroundTransparency = props.thumbnailBackgroundStyle and props.thumbnailBackgroundStyle.Transparency or 1,
		Image = props.image,
		Size = UDim2.new(1, 0, 1, not props.isContained and 0 or props.cardCornerRadius),
		cornerRadius = UDim.new(0, props.cardCornerRadius),
		showFailedStateWhenLoadingFailed = true,
		useShimmerAnimationWhileLoading = true,
		ZIndex = -2,
		ScaleType = 0,
		TileSize = 0
	}

	local v8 = if props.isContained then Enum.ScaleType.Tile else nil
	v6.ScaleType = v8
	local v9 = if props.isContained then UDim2.new(1, 0, 1, -props.cardCornerRadius) else nil
	v6.TileSize = v9
	return createElement(loadableImage, v6)
end

return SduiDefaultTileImage
