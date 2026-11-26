local module = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/BackgroundLayers/BackgroundLayers")

local module2 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/ItemCard")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/ItemCardAnimationStateIndicator")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/ItemCardBadge")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/ItemCardCreatorName")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/ItemCardFooter")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/ItemCardHeader")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/ItemCardHeaderCornersOverlay")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/ItemCardIcon")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/ItemCardIndicatorStack")
local module11 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/ItemCardPriceLine")
local module12 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/ItemCardStatus")
local module13 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/ItemCardThumbnail")
local module14 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/ItemCardThumbnailSkeleton")
local module15 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/ItemCardTitle")

local module16 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/Widget/WidgetHeader")
local module17 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/Widget/WidgetLayout")
local module18 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/Widget/WidgetListItem")
local module19 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/Grid/Grid")
local module20 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/VirtualizedFeed/VirtualizedFeed")
local module21 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/VirtualizedFeed/useFlatListScrollPerformanceTracker")
local module22 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/AXTooltip/AXTooltip")
return {
	CategoryMenu = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/CategoryMenu/CategoryMenu"),
	TabGroup = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/TabGroup/TabGroup"),
	TimerBadge = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/TimerBadge/TimerBadge"),
	ScrollingFrameWithIndicators = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ScrollingFrameWithIndicators/ScrollingFrameWithIndicators"),
	CategoryMenuButtonsLocationEnum = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/CategoryMenu/CategoryMenuButtonsLocationEnum"),
	ItemCardComponents = {
		ItemCard = module2,
		ItemCardAnimationStateIndicator = module3,
		ItemCardBadge = module4,
		ItemCardCreatorName = module5,
		ItemCardFooter = module6,
		ItemCardHeader = module7,
		ItemCardHeaderCornersOverlay = module8,
		ItemCardIcon = module9,
		ItemCardIndicatorStack = module10,
		ItemCardPriceLine = module11,
		ItemCardStatus = module12,
		ItemCardThumbnail = module13,
		ItemCardThumbnailSkeleton = module14,
		ItemCardTitle = module15
	},
	WidgetComponents = {
		WidgetHeader = module16,
		WidgetLayout = module17,
		WidgetListItem = module18
	},
	BackgroundLayersComponents = { BackgroundLayers = module },
	GridComponents = { Grid = module19 },
	AXTooltipComponents = { AXTooltip = module22 },
	FeedComponents = { VirtualizedFeed = module20 },
	Hooks = {
		useRemainingTime = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/Utils/useRemainingTime"),
		useFlatListScrollPerformanceTracker = module21
	},
	Utils = {
		getRemainingTime = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/Utils/getRemainingTime"),
		getItemCountForRow = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/Utils/getItemCountForRow"),
		getLocalizedPrice = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/Utils/getLocalizedPrice")
	}
}
