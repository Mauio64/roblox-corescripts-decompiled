local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local VerticalTile = UIBlox.App.Tile.VerticalTile
local VerticalTileThumbnail = UIBlox.App.Tile.VerticalTileThumbnail
local FFlagLuaAppGameTileLockedBadge = require(Parent.SharedFlags).FFlagLuaAppGameTileLockedBadge

local function AppFeaturedTile(t1: {[any]: any}) -- line: 33
	-- upvalues: FFlagLuaAppGameTileLockedBadge (copy), React (copy), VerticalTileThumbnail (copy), VerticalTile (copy)
	local v9 = t1.hasBackground or false
	local n1 = 0

	if t1.renderActionRow then
		n1 = not t1.hasBackground and 40 or 48
	end

	local v11 = if not FFlagLuaAppGameTileLockedBadge then nil else t1.thumbnailOverlay
	local v12 = React.useCallback(function() -- line: 44
		-- upvalues: React (copy), VerticalTileThumbnail (copy), v9 (copy), t1 (copy), FFlagLuaAppGameTileLockedBadge (copy), v11 (copy)
		local v13 = React.createElement(VerticalTileThumbnail, {
			aspectRatio = 1,
			isTopRounded = true,
			isBottomRounded = not v9,
			thumbnail = t1.thumbnail
		})

		if FFlagLuaAppGameTileLockedBadge and v11 then
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				SizeConstraint = Enum.SizeConstraint.RelativeXX
			}, {
				Thumbnail = v13,
				ThumbnailOverlay = React.createElement("Frame", {
					BackgroundTransparency = 1,
					ZIndex = 2,
					Size = UDim2.fromScale(1, 1)
				}, {
					Content = v11
				})
			})
		end

		return v13
	end, {
		if not FFlagLuaAppGameTileLockedBadge then t1.hasBackground else v9,
		t1.thumbnail,
		v11
	})

	return React.createElement(VerticalTile, {
		hasOutline = t1.hasOutline,
		hasBackground = v9,
		isHoverEnabled = v9,
		isOverlayVisible = v9,
		onActivated = t1.onActivated,
		renderTopContent = v12,
		renderBottomContent = t1.renderBottomPanel,
		renderFooterRow = t1.renderActionRow,
		reservedBottomHeight = n1
	})
end

return AppFeaturedTile
