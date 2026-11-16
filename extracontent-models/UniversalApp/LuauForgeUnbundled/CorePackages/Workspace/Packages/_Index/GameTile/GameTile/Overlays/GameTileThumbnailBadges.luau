local flaggedMutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Loggers").flaggedMutedError
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation").Hooks.useTokens
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")

local GameTileConstants = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileConstants")
local GameTileOverlayBadge = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Overlays/GameTileOverlayBadge")
require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileTypes")
local tileBadgeIconNamesByType = GameTileConstants.TileBadgeIconNamesByType
local tileBadgeComponentTypeValues = GameTileConstants.TileBadgeComponentTypeValues

local function getBadgeStyleOptions(data, tileBadgeComponentType)
	local v5 = {
		[tileBadgeComponentTypeValues.Pill] = {
			backgroundColorStyle = data.Color.Extended.White.White_90,
			contentColorStyle = data.LightMode.Content.Emphasis,
			cornerRadius = UDim.new(1, 0),
			verticalPadding = data.Size.Size_150
		},
		[tileBadgeComponentTypeValues.RoundedRectangle] = {
			backgroundColorStyle = data.Color.Extended.Black.Black_90,
			contentColorStyle = data.DarkMode.Content.Emphasis,
			cornerRadius = UDim.new(0.2, 0),
			verticalPadding = data.Size.Size_100
		}
	}

	local v6 = tileBadgeComponentType and v5[tileBadgeComponentType]

	if tileBadgeComponentType ~= nil and not v6 then
		flaggedMutedError(
			"GameTileOverlayBadgeInvalidComponentTypeError",
			`Unsupported game tile badge component type: {tileBadgeComponentType}`
		)
	end

	return v6 or v5[tileBadgeComponentTypeValues.Pill]
end

local function GameTileThumbnailBadges(p2)
	local v5 = useTokens()
	local padding = p2.padding or v5.Padding.Medium

	local v6, v7 = React.useBinding(0)

	local v8 = React.useCallback(function(p3)
		v7(p3.AbsoluteSize.X - 2 * padding)
	end, { padding })

	local children = {}

	for k, tileBadge in p2.tileBadgesByPosition do
		local v9 = nil
		local v10 = nil
		local tileBadgePositionCalculator = GameTileConstants.TileBadgePositionCalculators[k]

		if tileBadgePositionCalculator then
			v9, v10 = tileBadgePositionCalculator(padding)
		else
			flaggedMutedError(
				"GameTileOverlayBadgeInvalidPositionError",
				`Unsupported game tile badge position: {k}`
			)
		end

		if not (#tileBadge > 0) then
			continue
		end

		local v11 = tileBadge[1]
		local tileBadgeIconNames

		if v11.icons and #v11.icons > 0 then
			tileBadgeIconNames = {}

			for k2, icon in v11.icons do
				local tileBadgeIconName = tileBadgeIconNamesByType[icon]

				if tileBadgeIconName then
					table.insert(tileBadgeIconNames, tileBadgeIconName)
				else
					warn(`Unsupported game tile badge icon type: {icon}`)
				end
			end
		end

		children[k .. "TileBadge"] = React.createElement(GameTileOverlayBadge, {
			Position = v9,
			AnchorPoint = v10,
			maxWidthBinding = v6,
			icons = tileBadgeIconNames,
			text = v11.text,
			styleOptions = getBadgeStyleOptions(v5, v11.tileBadgeComponentType)
		})
	end

	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			[React.Change.AbsoluteSize] = v8
		},
		children
	)
end

return React.memo(GameTileThumbnailBadges)
