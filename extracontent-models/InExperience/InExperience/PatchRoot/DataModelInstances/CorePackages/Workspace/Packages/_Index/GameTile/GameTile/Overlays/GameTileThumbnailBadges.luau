local GameTile = script:FindFirstAncestor("GameTile")

local parent = GameTile.Parent
local Loggers = require(parent.Loggers)
local flaggedMutedError = Loggers.flaggedMutedError
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local React = require(parent.React)

local GameTileConstants = require(GameTile.GameTileConstants)
local GameTileOverlayBadge = require(GameTile.Overlays.GameTileOverlayBadge)
require(GameTile.GameTileTypes)
local TileBadgeIconNamesByType = GameTileConstants.TileBadgeIconNamesByType
local TileBadgeComponentTypeValues = GameTileConstants.TileBadgeComponentTypeValues

local function getBadgeStyleOptions(data, tileBadgeComponentType)
	local v = {
		[TileBadgeComponentTypeValues.Pill] = {
			backgroundColorStyle = data.Color.Extended.White.White_90,
			contentColorStyle = data.LightMode.Content.Emphasis,
			cornerRadius = UDim.new(1, 0),
			verticalPadding = data.Size.Size_150
		},
		[TileBadgeComponentTypeValues.RoundedRectangle] = {
			backgroundColorStyle = data.Color.Extended.Black.Black_90,
			contentColorStyle = data.DarkMode.Content.Emphasis,
			cornerRadius = UDim.new(0.2, 0),
			verticalPadding = data.Size.Size_100
		}
	}

	local v2 = tileBadgeComponentType and v[tileBadgeComponentType]

	if tileBadgeComponentType ~= nil and not v2 then
		flaggedMutedError(
			"GameTileOverlayBadgeInvalidComponentTypeError",
			`Unsupported game tile badge component type: {tileBadgeComponentType}`
		)
	end

	return v2 or v[TileBadgeComponentTypeValues.Pill]
end

local function GameTileThumbnailBadges(p)
	local v = useTokens()
	local padding = p.padding or v.Padding.Medium

	local maxWidthBinding, v2 = React.useBinding(0)

	local v3 = React.useCallback(function(p2)
		v2(p2.AbsoluteSize.X - padding * 2)
	end, { padding })

	local children = {}

	for k, tileBadge in p.tileBadgesByPosition do
		local position = nil
		local anchorPoint = nil
		local tileBadgePositionCalculator = GameTileConstants.TileBadgePositionCalculators[k]

		if tileBadgePositionCalculator then
			position, anchorPoint = tileBadgePositionCalculator(padding)
		else
			flaggedMutedError("GameTileOverlayBadgeInvalidPositionError", `Unsupported game tile badge position: {k}`)
		end

		if not (#tileBadge > 0) then
			continue
		end

		local v4 = tileBadge[1]
		local tileBadgeIconNames

		if v4.icons and #v4.icons > 0 then
			tileBadgeIconNames = {}

			for _, icon in v4.icons do
				local tileBadgeIconName = TileBadgeIconNamesByType[icon]

				if tileBadgeIconName then
					table.insert(tileBadgeIconNames, tileBadgeIconName)
				else
					warn(`Unsupported game tile badge icon type: {icon}`)
				end
			end
		end

		children[k .. "TileBadge"] = React.createElement(GameTileOverlayBadge, {
			Position = position,
			AnchorPoint = anchorPoint,
			maxWidthBinding = maxWidthBinding,
			icons = tileBadgeIconNames,
			text = v4.text,
			styleOptions = getBadgeStyleOptions(v, v4.tileBadgeComponentType)
		})
	end

	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			[React.Change.AbsoluteSize] = v3
		},
		children
	)
end

return React.memo(GameTileThumbnailBadges)
