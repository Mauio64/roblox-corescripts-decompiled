local module = require("@luauforge/bundled/drY")
local module2 = require("@luauforge/bundled/drd")
local verticalTile = module2.App.Tile.VerticalTile
local verticalTileThumbnail = module2.App.Tile.VerticalTileThumbnail

local function AppFeaturedTile(props)
	local hasBackground = props.hasBackground or false

	local v5 = props.renderActionRow and (props.hasBackground and 48 or 40) or 0

	local thumbnailOverlay = props.thumbnailOverlay
	local v6 = module.useCallback(function()
		local element = module.createElement(verticalTileThumbnail, {
			aspectRatio = 1,
			isTopRounded = true,
			isBottomRounded = not hasBackground,
			thumbnail = props.thumbnail
		})

		if thumbnailOverlay then
			return module.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 1, 0),
					SizeConstraint = Enum.SizeConstraint.RelativeXX,
					BackgroundTransparency = 1
				},
				{
					Thumbnail = element,
					ThumbnailOverlay = module.createElement(
						"Frame",
						{
							Size = UDim2.fromScale(1, 1),
							BackgroundTransparency = 1,
							ZIndex = 2
						},
						{ Content = thumbnailOverlay }
					)
				}
			)
		end

		return element
	end, { hasBackground, props.thumbnail, thumbnailOverlay })

	return module.createElement(verticalTile, {
		hasOutline = props.hasOutline,
		hasBackground = hasBackground,
		isHoverEnabled = hasBackground,
		isOverlayVisible = hasBackground,
		onActivated = props.onActivated,
		renderTopContent = v6,
		renderBottomContent = props.renderBottomPanel,
		renderFooterRow = props.renderActionRow,
		reservedBottomHeight = v5
	})
end

return AppFeaturedTile
