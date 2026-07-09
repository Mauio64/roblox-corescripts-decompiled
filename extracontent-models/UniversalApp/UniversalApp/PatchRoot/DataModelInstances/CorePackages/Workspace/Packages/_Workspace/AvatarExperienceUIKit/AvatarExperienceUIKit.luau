local BackgroundLayers = require(script.BackgroundLayers.BackgroundLayers)
local ItemCard = script.ItemCard
local ItemCard2 = require(ItemCard.ItemCard)
local ItemCardAnimationStateIndicator = require(ItemCard.ItemCardAnimationStateIndicator)
local ItemCardBadge = require(ItemCard.ItemCardBadge)
local ItemCardCreatorName = require(ItemCard.ItemCardCreatorName)
local ItemCardFooter = require(ItemCard.ItemCardFooter)
local ItemCardHeader = require(ItemCard.ItemCardHeader)
local ItemCardHeaderCornersOverlay = require(ItemCard.ItemCardHeaderCornersOverlay)
local ItemCardIcon = require(ItemCard.ItemCardIcon)
local ItemCardPriceLine = require(ItemCard.ItemCardPriceLine)
local ItemCardStatus = require(ItemCard.ItemCardStatus)
local ItemCardThumbnail = require(ItemCard.ItemCardThumbnail)
local ItemCardTitle = require(ItemCard.ItemCardTitle)
local Widget = script.Widget
local WidgetHeader = require(Widget.WidgetHeader)
local WidgetLayout = require(Widget.WidgetLayout)
local WidgetListItem = require(Widget.WidgetListItem)
local Grid = require(script.Grid.Grid)
local VirtualizedFeed = require(script.VirtualizedFeed.VirtualizedFeed)
local AXTooltip = require(script.AXTooltip.AXTooltip)
local CategoryMenu = require(script.CategoryMenu.CategoryMenu)
local TabGroup = require(script.TabGroup.TabGroup)
local TimerBadge = require(script.TimerBadge.TimerBadge)
local ScrollingFrameWithIndicators = require(script.ScrollingFrameWithIndicators.ScrollingFrameWithIndicators)
local CategoryMenuButtonsLocationEnum = require(script.CategoryMenu.CategoryMenuButtonsLocationEnum)
local useRemainingTime = require(script.Utils.useRemainingTime)
local getRemainingTime = require(script.Utils.getRemainingTime)
local getItemCountForRow = require(script.Utils.getItemCountForRow)
local getLocalizedPrice = require(ItemCard.Utils.getLocalizedPrice)

return {
	CategoryMenu = CategoryMenu,
	TabGroup = TabGroup,
	TimerBadge = TimerBadge,
	ScrollingFrameWithIndicators = ScrollingFrameWithIndicators,
	CategoryMenuButtonsLocationEnum = CategoryMenuButtonsLocationEnum,
	ItemCardComponents = {
		ItemCard = ItemCard2,
		ItemCardAnimationStateIndicator = ItemCardAnimationStateIndicator,
		ItemCardBadge = ItemCardBadge,
		ItemCardCreatorName = ItemCardCreatorName,
		ItemCardFooter = ItemCardFooter,
		ItemCardHeader = ItemCardHeader,
		ItemCardHeaderCornersOverlay = ItemCardHeaderCornersOverlay,
		ItemCardIcon = ItemCardIcon,
		ItemCardPriceLine = ItemCardPriceLine,
		ItemCardStatus = ItemCardStatus,
		ItemCardThumbnail = ItemCardThumbnail,
		ItemCardTitle = ItemCardTitle
	},
	WidgetComponents = {
		WidgetHeader = WidgetHeader,
		WidgetLayout = WidgetLayout,
		WidgetListItem = WidgetListItem
	},
	BackgroundLayersComponents = {
		BackgroundLayers = BackgroundLayers
	},
	GridComponents = {
		Grid = Grid
	},
	AXTooltipComponents = {
		AXTooltip = AXTooltip
	},
	FeedComponents = {
		VirtualizedFeed = VirtualizedFeed
	},
	Hooks = {
		useRemainingTime = useRemainingTime
	},
	Utils = {
		getRemainingTime = getRemainingTime,
		getItemCountForRow = getItemCountForRow,
		getLocalizedPrice = getLocalizedPrice
	},
	["jest.config"] = script["jest.config"]
}
