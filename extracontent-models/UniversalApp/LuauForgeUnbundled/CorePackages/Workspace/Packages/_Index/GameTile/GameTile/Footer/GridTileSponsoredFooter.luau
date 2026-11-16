local GridTileIconTextFooter = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/GridTileIconTextFooter")
local GridTileTextFooter = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/GridTileTextFooter")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local sponsoredTooltipHover = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Ads").SponsoredTooltipHover
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Localization").Hooks.useLocalization
local tooltipOrientation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UIBlox").App.Dialog.Enum.TooltipOrientation
require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileTypes")
local getUserInputIsSelectionOnly = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/getUserInputIsSelectionOnly")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation").View
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Responsive")
local useBreakpointXOrLarger = Responsive.useBreakpointXOrLarger

function LUAUFORGE_MODULE_GLOBALS_bLS_GridTileSponsoredFooter(props)
	local v5 = useLocalization({
		sponsoredText = "Feature.GamePage.Label.Sponsored",
		adText = "Feature.GamePage.Label.Ad"
	})

	local v6 = props.useLargerFont and 24 or 20
	local v7 = useBreakpointXOrLarger(Responsive.Keys.Medium)

	if not props.enableSponsoredFeedback then
		return React.createElement(GridTileIconTextFooter, {
			iconElement = React.createElement(sponsoredTooltipHover, {
				tooltipOrientation = tooltipOrientation.Bottom,
				onActivateTooltip = props.onActivateSponsoredTooltip,
				size = UDim2.fromOffset(v6, v6),
				position = UDim2.fromScale(0.5, 0.5),
				anchorPoint = Vector2.new(0.5, 0.5),
				selectable = getUserInputIsSelectionOnly(),
				supportTenFootUi = true
			}),
			text = v5.sponsoredText,
			iconSize = props.useLargerFont and 24 or 20,
			useLargerFont = props.useLargerFont,
			isUnifiedGameTile = props.isUnifiedGameTile,
			gameTileLayoutType = props.gameTileLayoutType,
			isNarrowScreenXSmall = props.isNarrowScreenXSmall
		})
	end

	local element = React.createElement(GridTileTextFooter, {
		text = v5.adText,
		useLargerFont = props.useLargerFont,
		isUnifiedGameTile = props.isUnifiedGameTile,
		shouldSizeToContentWidth = true
	})

	if v7 and props.isSponsoredRatingFooterAllowed and props.gameStatsElement then
		return React.createElement(
			view,
			{ tag = "size-full-0 auto-y row align-y-center gap-xsmall clip" },
			{
				AdLabelWrapper = React.createElement(view, {
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
				GameStatsWrapper = React.createElement(view, {
					LayoutOrder = 3,
					Size = UDim2.new(0, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					SizeConstraint = Enum.SizeConstraint.RelativeXX,
					BackgroundTransparency = 1
				}, { Content = props.gameStatsElement })
			}
		)
	end

	return element
end

return LUAUFORGE_MODULE_GLOBALS_bLS_GridTileSponsoredFooter
