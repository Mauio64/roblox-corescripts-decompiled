local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local flaggedMutedError = require(GameTileParent.Loggers).flaggedMutedError
local useTokens = require(GameTileParent.Foundation).Hooks.useTokens
local React = require(GameTileParent.React)
local GameTileConstants = require(GameTile.GameTileConstants)
local GameTileOverlayBadge = require(GameTile.Overlays.GameTileOverlayBadge)

require(GameTile.GameTileTypes)

local TileBadgeIconNamesByType = GameTileConstants.TileBadgeIconNamesByType
local TileBadgeComponentTypeValues = GameTileConstants.TileBadgeComponentTypeValues

local function getBadgeStyleOptions(p1, p2) -- line: 19
	-- upvalues: TileBadgeComponentTypeValues (copy), flaggedMutedError (copy)
	local t1 = {
		[TileBadgeComponentTypeValues.Pill] = {
			backgroundColorStyle = p1.Color.Extended.White.White_90,
			contentColorStyle = p1.LightMode.Content.Emphasis,
			cornerRadius = UDim.new(1, 0),
			verticalPadding = p1.Size.Size_150
		},
		[TileBadgeComponentTypeValues.RoundedRectangle] = {
			backgroundColorStyle = p1.Color.Extended.Black.Black_90,
			contentColorStyle = p1.DarkMode.Content.Emphasis,
			cornerRadius = UDim.new(0.2, 0),
			verticalPadding = p1.Size.Size_100
		}
	}
	local v15 = p2 and t1[p2]

	if p2 ~= nil and not v15 then
		flaggedMutedError("GameTileOverlayBadgeInvalidComponentTypeError", `Unsupported game tile badge component type: { p2 }`)
	end

	return v15 or t1[TileBadgeComponentTypeValues.Pill]
end
local function GameTileThumbnailBadges(t2: {[any]: any}) -- line: 47
	-- upvalues: useTokens (copy), React (copy), GameTileConstants (copy), flaggedMutedError (copy), TileBadgeIconNamesByType (copy), GameTileOverlayBadge (copy), getBadgeStyleOptions (copy)
	local v17 = useTokens()
	local Medium = v17.Padding.Medium
	local v19, v20 = React.useBinding(0)
	local v21 = React.useCallback(function(p3) -- line: 55
		-- upvalues: v20 (copy), Medium (ref)
		local AbsoluteSizeX = p3.AbsoluteSize.X

		v20(AbsoluteSizeX - Medium * 2)
	end, { Medium })
	local t3 = {}

	for v23, v24 in t2.tileBadgesByPosition do
		local v25 = nil
		local v26 = nil
		local v27 = GameTileConstants.TileBadgePositionCalculators[v23]

		if v27 then
			v25, v26 = v27(Medium)
		else
			flaggedMutedError("GameTileOverlayBadgeInvalidPositionError", `Unsupported game tile badge position: { v23 }`)
		end

		if #v24 > 0 then
			local v28 = v24[1]
			local t4 = nil

			if v28.icons and #v28.icons > 0 then
				t4 = {}

				for _, v31 in v28.icons do
					local v32 = TileBadgeIconNamesByType[v31]

					if v32 then
						table.insert(t4, v32)
					else
						warn(`Unsupported game tile badge icon type: { v31 }`)
					end
				end
			end

			t3[v23 .. "TileBadge"] = React.createElement(GameTileOverlayBadge, {
				Position = v25,
				AnchorPoint = v26,
				maxWidthBinding = v19,
				icons = t4,
				text = v28.text,
				styleOptions = getBadgeStyleOptions(v17, v28.tileBadgeComponentType)
			})
		end
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		[React.Change.AbsoluteSize] = v21
	}, t3)
end

return React.memo(GameTileThumbnailBadges)
