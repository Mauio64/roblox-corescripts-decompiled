local GameTile = script:FindFirstAncestor("GameTile")
local GridTileIconTextFooter = require(GameTile.Footer.GridTileIconTextFooter)
local GridTileTextFooter = require(GameTile.Footer.GridTileTextFooter)
local GameTileParent = GameTile.Parent
local React = require(GameTileParent.React)
local SponsoredTooltipHover = require(GameTileParent.Ads).SponsoredTooltipHover
local useLocalization = require(GameTileParent.Localization).Hooks.useLocalization
local TooltipOrientation = require(GameTileParent.UIBlox).App.Dialog.Enum.TooltipOrientation

require(GameTile.GameTileTypes)

local getUserInputIsSelectionOnly = require(GameTile.Footer.getUserInputIsSelectionOnly)
local View = require(GameTileParent.Foundation).View
local Responsive = require(GameTileParent.Responsive)
local useBreakpointXOrLarger = Responsive.useBreakpointXOrLarger

function GridTileSponsoredFooter(t1: {[any]: any}) -- line: 31
	-- upvalues: useLocalization (copy), useBreakpointXOrLarger (copy), Responsive (copy), React (copy), GridTileTextFooter (copy), View (copy), GridTileIconTextFooter (copy), SponsoredTooltipHover (copy), TooltipOrientation (copy), getUserInputIsSelectionOnly (copy)
	local v14 = useLocalization({
		sponsoredText = "Feature.GamePage.Label.Sponsored",
		adText = "Feature.GamePage.Label.Ad"
	})
	local v15 = not t1.useLargerFont and 20 or 24
	local v16 = useBreakpointXOrLarger(Responsive.Keys.Medium)

	if t1.enableSponsoredFeedback then
		local v17 = React.createElement(GridTileTextFooter, {
			shouldSizeToContentWidth = true,
			text = v14.adText,
			useLargerFont = t1.useLargerFont,
			isUnifiedGameTile = t1.isUnifiedGameTile
		})

		if v16 and t1.isSponsoredRatingFooterAllowed and t1.gameStatsElement then
			return React.createElement(View, {
				tag = "size-full-0 auto-y row align-y-center gap-xsmall clip"
			}, {
				AdLabelWrapper = React.createElement(View, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					SizeConstraint = Enum.SizeConstraint.RelativeXX
				}, {
					Content = v17
				}),
				DotSeparator = React.createElement(GridTileTextFooter, {
					LayoutOrder = 2,
					text = "•",
					shouldSizeToContentWidth = true,
					useLargerFont = t1.useLargerFont,
					isUnifiedGameTile = t1.isUnifiedGameTile
				}),
				GameStatsWrapper = React.createElement(View, {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					SizeConstraint = Enum.SizeConstraint.RelativeXX
				}, {
					Content = t1.gameStatsElement
				})
			})
		end

		return v17
	end

	return React.createElement(GridTileIconTextFooter, {
		iconElement = React.createElement(SponsoredTooltipHover, {
			supportTenFootUi = true,
			tooltipOrientation = TooltipOrientation.Bottom,
			onActivateTooltip = t1.onActivateSponsoredTooltip,
			size = UDim2.fromOffset(v15, v15),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5),
			selectable = getUserInputIsSelectionOnly()
		}),
		text = v14.sponsoredText,
		iconSize = not t1.useLargerFont and 20 or 24,
		useLargerFont = t1.useLargerFont,
		isUnifiedGameTile = t1.isUnifiedGameTile,
		gameTileLayoutType = t1.gameTileLayoutType,
		isNarrowScreenXSmall = t1.isNarrowScreenXSmall
	})
end

return GridTileSponsoredFooter
