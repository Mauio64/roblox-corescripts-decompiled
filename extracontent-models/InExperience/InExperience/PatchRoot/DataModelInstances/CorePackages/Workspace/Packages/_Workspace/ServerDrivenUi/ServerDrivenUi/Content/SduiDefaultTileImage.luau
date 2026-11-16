local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

require(parent.Foundation)
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local LoadableImage = UIBlox.App.Loading.LoadableImage

local function SduiDefaultTileImage(props)
	local createElement = React.createElement
	local backgroundColor

	if props.thumbnailBackgroundStyle then
		backgroundColor = props.thumbnailBackgroundStyle.Color3 or nil
	end

	local v = {
		BackgroundColor3 = backgroundColor,
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
	local scaleType

	if props.isContained then
		scaleType = Enum.ScaleType.Tile
	end

	v.ScaleType = scaleType
	local tileSize

	if props.isContained then
		tileSize = UDim2.new(1, 0, 1, -props.cardCornerRadius)
	end

	v.TileSize = tileSize
	return createElement(LoadableImage, v)
end

return SduiDefaultTileImage
