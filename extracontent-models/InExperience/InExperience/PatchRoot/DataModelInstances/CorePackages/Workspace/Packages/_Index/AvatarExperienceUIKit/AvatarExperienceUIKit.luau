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
local ItemCardIndicatorStack = require(ItemCard.ItemCardIndicatorStack)
local ItemCardPriceLine = require(ItemCard.ItemCardPriceLine)
local ItemCardStatus = require(ItemCard.ItemCardStatus)
local ItemCardThumbnail = require(ItemCard.ItemCardThumbnail)
local ItemCardThumbnailSkeleton = require(ItemCard.ItemCardThumbnailSkeleton)
local ItemCardTitle = require(ItemCard.ItemCardTitle)
local Widget = script.Widget
local WidgetHeader = require(Widget.WidgetHeader)
local WidgetLayout = require(Widget.WidgetLayout)
local WidgetListItem = require(Widget.WidgetListItem)
local Grid = require(script.Grid.Grid)
local VirtualizedFeed = require(script.VirtualizedFeed.VirtualizedFeed)
local useFlatListScrollPerformanceTracker = require(script.VirtualizedFeed.useFlatListScrollPerformanceTracker)
local AXTooltip = require(script.AXTooltip.AXTooltip)
return {
	CategoryMenu = require(script.CategoryMenu.CategoryMenu),
	TabGroup = require(script.TabGroup.TabGroup),
	TimerBadge = require(script.TimerBadge.TimerBadge),
	ScrollingFrameWithIndicators = require(script.ScrollingFrameWithIndicators.ScrollingFrameWithIndicators),
	CategoryMenuButtonsLocationEnum = require(script.CategoryMenu.CategoryMenuButtonsLocationEnum),
	ItemCardComponents = {
		ItemCard = ItemCard2,
		ItemCardAnimationStateIndicator = ItemCardAnimationStateIndicator,
		ItemCardBadge = ItemCardBadge,
		ItemCardCreatorName = ItemCardCreatorName,
		ItemCardFooter = ItemCardFooter,
		ItemCardHeader = ItemCardHeader,
		ItemCardHeaderCornersOverlay = ItemCardHeaderCornersOverlay,
		ItemCardIcon = ItemCardIcon,
		ItemCardIndicatorStack = ItemCardIndicatorStack,
		ItemCardPriceLine = ItemCardPriceLine,
		ItemCardStatus = ItemCardStatus,
		ItemCardThumbnail = ItemCardThumbnail,
		ItemCardThumbnailSkeleton = ItemCardThumbnailSkeleton,
		ItemCardTitle = ItemCardTitle
	},
	WidgetComponents = {
		WidgetHeader = WidgetHeader,
		WidgetLayout = WidgetLayout,
		WidgetListItem = WidgetListItem
	},
	BackgroundLayersComponents = { BackgroundLayers = BackgroundLayers },
	GridComponents = { Grid = Grid },
	AXTooltipComponents = { AXTooltip = AXTooltip },
	FeedComponents = { VirtualizedFeed = VirtualizedFeed },
	Hooks = {
		useRemainingTime = require(script.Utils.useRemainingTime),
		useFlatListScrollPerformanceTracker = useFlatListScrollPerformanceTracker
	},
	Utils = {
		getRemainingTime = require(script.Utils.getRemainingTime),
		getItemCountForRow = require(script.Utils.getItemCountForRow),
		getLocalizedPrice = require(ItemCard.Utils.getLocalizedPrice)
	},
	["jest.config"] = script["jest.config"]
}
