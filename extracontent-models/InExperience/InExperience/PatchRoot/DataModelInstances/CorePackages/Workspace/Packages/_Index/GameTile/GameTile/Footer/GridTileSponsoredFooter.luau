local GameTile = script:FindFirstAncestor("GameTile")
local GridTileIconTextFooter = require(GameTile.Footer.GridTileIconTextFooter)
local GridTileTextFooter = require(GameTile.Footer.GridTileTextFooter)

local parent = GameTile.Parent
local React = require(parent.React)
local Ads = require(parent.Ads)
local SponsoredTooltipHover = Ads.SponsoredTooltipHover
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local UIBlox = require(parent.UIBlox)
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
require(GameTile.GameTileTypes)
local getUserInputIsSelectionOnly = require(GameTile.Footer.getUserInputIsSelectionOnly)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Responsive = require(parent.Responsive)
local useBreakpointXOrLarger = Responsive.useBreakpointXOrLarger

function GridTileSponsoredFooter(props)
	local v = useLocalization({
		sponsoredText = "Feature.GamePage.Label.Sponsored",
		adText = "Feature.GamePage.Label.Ad"
	})

	local v2 = props.useLargerFont and 24 or 20
	local v3 = useBreakpointXOrLarger(Responsive.Keys.Medium)

	if not props.enableSponsoredFeedback then
		return React.createElement(GridTileIconTextFooter, {
			iconElement = React.createElement(SponsoredTooltipHover, {
				tooltipOrientation = TooltipOrientation.Bottom,
				onActivateTooltip = props.onActivateSponsoredTooltip,
				size = UDim2.fromOffset(v2, v2),
				position = UDim2.fromScale(0.5, 0.5),
				anchorPoint = Vector2.new(0.5, 0.5),
				selectable = getUserInputIsSelectionOnly(),
				supportTenFootUi = true
			}),
			text = v.sponsoredText,
			iconSize = props.useLargerFont and 24 or 20,
			useLargerFont = props.useLargerFont,
			isUnifiedGameTile = props.isUnifiedGameTile,
			gameTileLayoutType = props.gameTileLayoutType,
			isNarrowScreenXSmall = props.isNarrowScreenXSmall
		})
	end

	local element = React.createElement(GridTileTextFooter, {
		text = v.adText,
		useLargerFont = props.useLargerFont,
		isUnifiedGameTile = props.isUnifiedGameTile,
		shouldSizeToContentWidth = true
	})

	if v3 and props.isSponsoredRatingFooterAllowed and props.gameStatsElement then
		return React.createElement(View, {
			tag = "size-full-0 auto-y row align-y-center gap-xsmall clip"
		}, {
			AdLabelWrapper = React.createElement(View, {
				LayoutOrder = 1,
				Size = UDim2.new(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				SizeConstraint = Enum.SizeConstraint.RelativeXX,
				BackgroundTransparency = 1
			}, { Content = element }),
			DotSeparator = React.createElement(GridTileTextFooter, {
				LayoutOrder = 2,
				text = "•",
				useLargerFont = props.useLargerFont,
				isUnifiedGameTile = props.isUnifiedGameTile,
				shouldSizeToContentWidth = true
			}),
			GameStatsWrapper = React.createElement(View, {
				LayoutOrder = 3,
				Size = UDim2.new(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				SizeConstraint = Enum.SizeConstraint.RelativeXX,
				BackgroundTransparency = 1
			}, { Content = props.gameStatsElement })
		})
	end

	return element
end

return GridTileSponsoredFooter
