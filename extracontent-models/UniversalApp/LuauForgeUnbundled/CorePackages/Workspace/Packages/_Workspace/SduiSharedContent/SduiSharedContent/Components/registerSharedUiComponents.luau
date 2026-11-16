local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")
local sduiComponentType = SduiCoreSystem.SduiComponentType
local sduiParsers = SduiCoreSystem.SduiParsers
local getSduiComponentRegistry = SduiCoreSystem.getSduiComponentRegistry

local parseBooleanProp_ = sduiParsers.parseBooleanProp_
local parseCallbackProp_ = sduiParsers.parseCallbackProp_
local parseColorTokenProp_ = sduiParsers.parseColorTokenProp_
local parseIntegerProp_ = sduiParsers.parseIntegerProp_
local parseNumberProp_ = sduiParsers.parseNumberProp_
local parseStringProp_ = sduiParsers.parseStringProp_
local parseUDim2Prop_ = sduiParsers.parseUDim2Prop_
local parseUiComponentProp_ = sduiParsers.parseUiComponentProp_
local parseVector2Prop_ = sduiParsers.parseVector2Prop_
local getLuaTableEnumParser = sduiParsers.getLuaTableEnumParser
local fFlagSduiCardComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiCardComponent
local FFlagSduiContentRowStateLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Flags/FFlagSduiContentRowStateLayer")
local FFlagSDUIContentRowSelectable = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Flags/FFlagSDUIContentRowSelectable")
local fFlagSduiListComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiListComponents
local fFlagSduiAccordionComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiAccordionComponent
local fFlagSduiExpandableListItem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiExpandableListItem
local fFlagSduiBannerComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiBannerComponent
local fFlagSduiSheetComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiSheetComponent
local fFlagSduiSystemBannerComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiSystemBannerComponent
local fFlagSduiBannerContextComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiBannerContextComponent
local fFlagSduiViewportVisibilityComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiViewportVisibilityComponent
local fFlagSduiInteractableTileWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiInteractableTileWrapper
local fFlagSduiDevStoreSeeAllSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiDevStoreSeeAllSupport
local fFlagSduiPlayWithReward = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiPlayWithReward
local fFlagSduiPlayWithRewardRefactor = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiPlayWithRewardRefactor
local fFlagSduiShimmerTextComponentEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiShimmerTextComponentEnabled
local fFlagSduiTooltipComponentEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiTooltipComponentEnabled
local fFlagSduiRevealTextComponentEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiRevealTextComponentEnabled
local fFlagSduiAiOverviewEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiAiOverviewEnabled
local fFlagSduiPreferredTextSizeLineBudgets = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiPreferredTextSizeLineBudgets

local fFlagSduiVerticalListWithImpressionsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiVerticalListWithImpressionsEnabled

local fFlagSduiCollectionCarouselPlaceholderItem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiCollectionCarouselPlaceholderItem
local fFlagLuaAppSduiVideoThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagLuaAppSduiVideoThumbnail
local fFlagEnableGameJoinEarlyAccess = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagEnableGameJoinEarlyAccess
local fFlagSduiReactionsComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiReactionsComponent

local function registerSharedUiComponents()
	local v5 = {
		[sduiComponentType.DetailsPageImageHeader] = {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiDetailsPageImageHeader")
			end
		},
		[sduiComponentType.AvatarGroup] = {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiAvatarGroup")
			end
		},
		[sduiComponentType.Card] = fFlagSduiCardComponent and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiCard")
			end
		} or nil,
		[sduiComponentType.Coachmark] = {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiCoachmark")
			end
		},
		[sduiComponentType.Banner] = fFlagSduiBannerComponent and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiBanner")
			end
		} or nil,
		[sduiComponentType.Sheet] = fFlagSduiSheetComponent and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiSheet")
			end
		} or nil,
		[sduiComponentType.SystemBanner] = fFlagSduiSystemBannerComponent and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiSystemBanner")
			end
		} or nil,
		[sduiComponentType.BannerContext] = fFlagSduiBannerContextComponent and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiBannerContext")
			end
		} or nil,
		[sduiComponentType.ViewportVisibility] = fFlagSduiViewportVisibilityComponent and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiViewportVisibility")
			end
		} or nil,
		[sduiComponentType.InteractableTileWrapper] = fFlagSduiInteractableTileWrapper and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiInteractableTileWrapper")
			end
		} or nil,
		[sduiComponentType.CircleIcon] = {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiCircleIcon")
			end
		},
		[sduiComponentType.Icon] = {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiIcon")
			end,
			propParsers = {
				name = getLuaTableEnumParser(Foundation.Enums.IconName, "string"),
				style = parseColorTokenProp_,
				size = getLuaTableEnumParser(Foundation.Enums.IconSize, "string"),
				variant = getLuaTableEnumParser(Foundation.Enums.IconVariant, "string"),
				anchorPoint = parseVector2Prop_,
				layoutOrder = parseIntegerProp_,
				position = parseUDim2Prop_,
				visible = parseBooleanProp_,
				zIndex = parseNumberProp_,
				testId = parseStringProp_
			}
		},
		[sduiComponentType.IconButton] = {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiIconButton")
			end
		},
		[sduiComponentType.LinkText] = {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiLinkText")
			end
		},
		[sduiComponentType.ShimmerText] = fFlagSduiShimmerTextComponentEnabled and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiShimmerText")
			end
		} or nil,
		[sduiComponentType.RevealText] = fFlagSduiRevealTextComponentEnabled and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiRevealText")
			end
		} or nil,
		[sduiComponentType.LineLimitedText] = fFlagSduiPreferredTextSizeLineBudgets and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiLineLimitedText")
			end
		} or nil,
		[sduiComponentType.ContentRatingLabel] = {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiContentRatingLabel")
			end
		},
		[sduiComponentType.MediaGallery] = {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiMediaGallery")
			end
		},
		[sduiComponentType.VideoPlayer] = fFlagLuaAppSduiVideoThumbnail and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiVideoPlayer")
			end
		} or nil,
		[sduiComponentType.ActionBar] = {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiActionBar")
			end
		},
		[sduiComponentType.PlayButtonContextualMessage] = {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiPlayButtonContextualMessage")
			end
		},
		[sduiComponentType.PlusEarlyAccessUpsell] = fFlagEnableGameJoinEarlyAccess and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiPlusEarlyAccessUpsell")
			end
		} or nil
	}

	local playWithReward = sduiComponentType.PlayWithReward
	local v6

	if not fFlagSduiPlayWithRewardRefactor then
		v6 = fFlagSduiPlayWithReward and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiPlayWithReward")
			end
		} or nil
	end

	v5[playWithReward] = v6

	local contentRow = sduiComponentType.ContentRow
	local v7 = {
		getLazyComponent = function()
			return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiContentRow")
		end,
		propParsers = 0
	}

	local v8 = {
		leading = parseUiComponentProp_,
		content = parseUiComponentProp_,
		trailing = parseUiComponentProp_,
		onActivated = parseCallbackProp_,
		stateLayerAffordance = 0,
		selectable = 0,
		tag = 0,
		leadingTag = 0,
		contentTag = 0,
		trailingTag = 0,
		layoutOrder = 0,
		position = 0,
		zIndex = 0,
		testId = 0
	}

	local v9 = if FFlagSduiContentRowStateLayer then getLuaTableEnumParser(Foundation.Enums.StateLayerAffordance, "string") else nil
	v8.stateLayerAffordance = v9

	v8.selectable = if FFlagSDUIContentRowSelectable then parseBooleanProp_ else nil
	v8.tag = parseStringProp_
	v8.leadingTag = parseStringProp_
	v8.contentTag = parseStringProp_
	v8.trailingTag = parseStringProp_
	v8.layoutOrder = parseIntegerProp_
	v8.position = parseUDim2Prop_
	v8.zIndex = parseNumberProp_
	v8.testId = parseStringProp_
	v7.propParsers = v8
	v5[contentRow] = v7

	v5[sduiComponentType.ListRoot] = fFlagSduiListComponents and {
		getLazyComponent = function()
			return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiListRoot")
		end
	} or nil

	v5[sduiComponentType.ExpandableListItem] = fFlagSduiExpandableListItem and {
		getLazyComponent = function()
			return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiExpandableListItem")
		end
	} or nil

	v5[sduiComponentType.ListItem] = fFlagSduiListComponents and {
		getLazyComponent = function()
			return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiListItem")
		end
	} or nil

	v5[sduiComponentType.Accordion] = fFlagSduiAccordionComponent and {
		getLazyComponent = function()
			return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiAccordion")
		end
	} or nil

	v5[sduiComponentType.AccordionItem] = fFlagSduiAccordionComponent and {
		getLazyComponent = function()
			return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiAccordionItem")
		end
	} or nil

	v5[sduiComponentType.SubscriptionCell] = fFlagSduiDevStoreSeeAllSupport and {
		getLazyComponent = function()
			return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiSubscriptionCell")
		end
	} or nil

	v5[sduiComponentType.Tooltip] = fFlagSduiTooltipComponentEnabled and {
		getLazyComponent = function()
			return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiTooltip")
		end
	} or nil

	v5[sduiComponentType.FilterPillsCarousel] = {
		getLazyComponent = function()
			return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiFilterPillsCarousel")
		end
	}

	v5[sduiComponentType.Placeholder] = {
		getLazyComponent = function()
			return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiPlaceholder")
		end
	}

	v5[sduiComponentType.PlaceholderTile] = fFlagSduiCollectionCarouselPlaceholderItem and {
		getLazyComponent = function()
			return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiPlaceholderTile")
		end
	} or nil

	v5[sduiComponentType.PlaceholderWrapper] = {
		getLazyComponent = function()
			return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiPlaceholderWrapper")
		end
	}

	v5[sduiComponentType.Skeleton] = {
		getLazyComponent = function()
			return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiSkeleton")
		end
	}

	v5[sduiComponentType.AiOverview] = fFlagSduiAiOverviewEnabled and {
		getLazyComponent = function()
			return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiAiOverview")
		end
	} or nil

	v5[sduiComponentType.VerticalListWithImpressions] = fFlagSduiVerticalListWithImpressionsEnabled and {
		getLazyComponent = function()
			return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiVerticalListWithImpressions")
		end
	} or nil

	v5[sduiComponentType.Reactions] = fFlagSduiReactionsComponent and {
		getLazyComponent = function()
			return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiReactions")
		end
	} or nil

	getSduiComponentRegistry().registerComponentDefinitions(v5)
end

return registerSharedUiComponents
