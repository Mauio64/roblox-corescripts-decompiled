local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local parent = SduiSharedContent.Parent

local Foundation = require(parent.Foundation)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiComponentType = SduiCoreSystem.SduiComponentType
local SduiParsers = SduiCoreSystem.SduiParsers
local getSduiComponentRegistry = SduiCoreSystem.getSduiComponentRegistry

local parseBooleanProp_ = SduiParsers.parseBooleanProp_
local parseCallbackProp_ = SduiParsers.parseCallbackProp_
local parseColorTokenProp_ = SduiParsers.parseColorTokenProp_
local parseIntegerProp_ = SduiParsers.parseIntegerProp_
local parseNumberProp_ = SduiParsers.parseNumberProp_
local parseStringProp_ = SduiParsers.parseStringProp_
local parseUDim2Prop_ = SduiParsers.parseUDim2Prop_
local parseUiComponentProp_ = SduiParsers.parseUiComponentProp_
local parseVector2Prop_ = SduiParsers.parseVector2Prop_
local getLuaTableEnumParser = SduiParsers.getLuaTableEnumParser
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiCardComponent = SharedFlags.FFlagSduiCardComponent
local FFlagSduiContentRowStateLayer = require(SduiSharedContent.Flags.FFlagSduiContentRowStateLayer)
local FFlagSDUIContentRowSelectable = require(SduiSharedContent.Flags.FFlagSDUIContentRowSelectable)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiListComponents = SharedFlags2.FFlagSduiListComponents
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSduiAccordionComponent = SharedFlags3.FFlagSduiAccordionComponent
local SharedFlags4 = require(parent.SharedFlags)
local FFlagSduiExpandableListItem = SharedFlags4.FFlagSduiExpandableListItem
local SharedFlags5 = require(parent.SharedFlags)
local FFlagSduiBannerComponent = SharedFlags5.FFlagSduiBannerComponent
local SharedFlags6 = require(parent.SharedFlags)
local FFlagSduiSheetComponent = SharedFlags6.FFlagSduiSheetComponent
local SharedFlags7 = require(parent.SharedFlags)
local FFlagSduiSystemBannerComponent = SharedFlags7.FFlagSduiSystemBannerComponent
local SharedFlags8 = require(parent.SharedFlags)
local FFlagSduiBannerContextComponent = SharedFlags8.FFlagSduiBannerContextComponent
local SharedFlags9 = require(parent.SharedFlags)
local FFlagSduiViewportVisibilityComponent = SharedFlags9.FFlagSduiViewportVisibilityComponent
local SharedFlags10 = require(parent.SharedFlags)
local FFlagSduiInteractableTileWrapper = SharedFlags10.FFlagSduiInteractableTileWrapper
local SharedFlags11 = require(parent.SharedFlags)
local FFlagSduiDevStoreSeeAllSupport = SharedFlags11.FFlagSduiDevStoreSeeAllSupport
local SharedFlags12 = require(parent.SharedFlags)
local FFlagSduiPlayWithReward = SharedFlags12.FFlagSduiPlayWithReward
local SharedFlags13 = require(parent.SharedFlags)
local FFlagSduiPlayWithRewardRefactor = SharedFlags13.FFlagSduiPlayWithRewardRefactor
local SharedFlags14 = require(parent.SharedFlags)
local FFlagSduiShimmerTextComponentEnabled = SharedFlags14.FFlagSduiShimmerTextComponentEnabled
local SharedFlags15 = require(parent.SharedFlags)
local FFlagSduiTooltipComponentEnabled = SharedFlags15.FFlagSduiTooltipComponentEnabled
local SharedFlags16 = require(parent.SharedFlags)
local FFlagSduiRevealTextComponentEnabled = SharedFlags16.FFlagSduiRevealTextComponentEnabled
local SharedFlags17 = require(parent.SharedFlags)
local FFlagSduiAiOverviewEnabled = SharedFlags17.FFlagSduiAiOverviewEnabled
local SharedFlags18 = require(parent.SharedFlags)
local FFlagSduiPreferredTextSizeLineBudgets = SharedFlags18.FFlagSduiPreferredTextSizeLineBudgets

local SharedFlags19 = require(parent.SharedFlags)
local FFlagSduiVerticalListWithImpressionsEnabled = SharedFlags19.FFlagSduiVerticalListWithImpressionsEnabled

local SharedFlags20 = require(parent.SharedFlags)
local FFlagSduiCollectionCarouselPlaceholderItem = SharedFlags20.FFlagSduiCollectionCarouselPlaceholderItem
local SharedFlags21 = require(parent.SharedFlags)
local FFlagLuaAppSduiVideoThumbnail = SharedFlags21.FFlagLuaAppSduiVideoThumbnail
local SharedFlags22 = require(parent.SharedFlags)
local FFlagEnableGameJoinEarlyAccess = SharedFlags22.FFlagEnableGameJoinEarlyAccess
local SharedFlags23 = require(parent.SharedFlags)
local FFlagSduiReactionsComponent = SharedFlags23.FFlagSduiReactionsComponent

local function registerSharedUiComponents()
	local v = {
		[SduiComponentType.DetailsPageImageHeader] = {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiDetailsPageImageHeader)
			end
		},
		[SduiComponentType.AvatarGroup] = {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiAvatarGroup)
			end
		},
		[SduiComponentType.Card] = FFlagSduiCardComponent and {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiCard)
			end
		} or nil,
		[SduiComponentType.Coachmark] = {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiCoachmark)
			end
		},
		[SduiComponentType.Banner] = FFlagSduiBannerComponent and {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiBanner)
			end
		} or nil,
		[SduiComponentType.Sheet] = FFlagSduiSheetComponent and {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiSheet)
			end
		} or nil,
		[SduiComponentType.SystemBanner] = FFlagSduiSystemBannerComponent and {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiSystemBanner)
			end
		} or nil,
		[SduiComponentType.BannerContext] = FFlagSduiBannerContextComponent and {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiBannerContext)
			end
		} or nil,
		[SduiComponentType.ViewportVisibility] = FFlagSduiViewportVisibilityComponent and {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiViewportVisibility)
			end
		} or nil,
		[SduiComponentType.InteractableTileWrapper] = FFlagSduiInteractableTileWrapper and {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiInteractableTileWrapper)
			end
		} or nil,
		[SduiComponentType.CircleIcon] = {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiCircleIcon)
			end
		},
		[SduiComponentType.Icon] = {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiIcon)
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
		[SduiComponentType.IconButton] = {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiIconButton)
			end
		},
		[SduiComponentType.LinkText] = {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiLinkText)
			end
		},
		[SduiComponentType.ShimmerText] = FFlagSduiShimmerTextComponentEnabled and {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiShimmerText)
			end
		} or nil,
		[SduiComponentType.RevealText] = FFlagSduiRevealTextComponentEnabled and {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiRevealText)
			end
		} or nil,
		[SduiComponentType.LineLimitedText] = FFlagSduiPreferredTextSizeLineBudgets and {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiLineLimitedText)
			end
		} or nil,
		[SduiComponentType.ContentRatingLabel] = {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiContentRatingLabel)
			end
		},
		[SduiComponentType.MediaGallery] = {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiMediaGallery)
			end
		},
		[SduiComponentType.VideoPlayer] = FFlagLuaAppSduiVideoThumbnail and {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiVideoPlayer)
			end
		} or nil,
		[SduiComponentType.ActionBar] = {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiActionBar)
			end
		},
		[SduiComponentType.PlayButtonContextualMessage] = {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiPlayButtonContextualMessage)
			end
		},
		[SduiComponentType.PlusEarlyAccessUpsell] = FFlagEnableGameJoinEarlyAccess and {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiPlusEarlyAccessUpsell)
			end
		} or nil
	}

	local playWithReward = SduiComponentType.PlayWithReward
	local v2

	if not FFlagSduiPlayWithRewardRefactor then
		v2 = FFlagSduiPlayWithReward and {
			getLazyComponent = function()
				return require(SduiSharedContent.Components.SduiPlayWithReward)
			end
		} or nil
	end

	v[playWithReward] = v2

	local contentRow = SduiComponentType.ContentRow
	local v3 = {
		getLazyComponent = function()
			return require(SduiSharedContent.Components.SduiContentRow)
		end,
		propParsers = 0
	}

	local propParsers = {
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
	local stateLayerAffordance

	if FFlagSduiContentRowStateLayer then
		stateLayerAffordance = getLuaTableEnumParser(Foundation.Enums.StateLayerAffordance, "string")
	end

	propParsers.stateLayerAffordance = stateLayerAffordance
	local selectable

	if FFlagSDUIContentRowSelectable then
		selectable = parseBooleanProp_
	end

	propParsers.selectable = selectable
	propParsers.tag = parseStringProp_
	propParsers.leadingTag = parseStringProp_
	propParsers.contentTag = parseStringProp_
	propParsers.trailingTag = parseStringProp_
	propParsers.layoutOrder = parseIntegerProp_
	propParsers.position = parseUDim2Prop_
	propParsers.zIndex = parseNumberProp_
	propParsers.testId = parseStringProp_
	v3.propParsers = propParsers
	v[contentRow] = v3

	v[SduiComponentType.ListRoot] = FFlagSduiListComponents and {
		getLazyComponent = function()
			return require(SduiSharedContent.Components.SduiListRoot)
		end
	} or nil

	v[SduiComponentType.ExpandableListItem] = FFlagSduiExpandableListItem and {
		getLazyComponent = function()
			return require(SduiSharedContent.Components.SduiExpandableListItem)
		end
	} or nil

	v[SduiComponentType.ListItem] = FFlagSduiListComponents and {
		getLazyComponent = function()
			return require(SduiSharedContent.Components.SduiListItem)
		end
	} or nil

	v[SduiComponentType.Accordion] = FFlagSduiAccordionComponent and {
		getLazyComponent = function()
			return require(SduiSharedContent.Components.SduiAccordion)
		end
	} or nil

	v[SduiComponentType.AccordionItem] = FFlagSduiAccordionComponent and {
		getLazyComponent = function()
			return require(SduiSharedContent.Components.SduiAccordionItem)
		end
	} or nil

	v[SduiComponentType.SubscriptionCell] = FFlagSduiDevStoreSeeAllSupport and {
		getLazyComponent = function()
			return require(SduiSharedContent.Components.SduiSubscriptionCell)
		end
	} or nil

	v[SduiComponentType.Tooltip] = FFlagSduiTooltipComponentEnabled and {
		getLazyComponent = function()
			return require(SduiSharedContent.Components.SduiTooltip)
		end
	} or nil

	v[SduiComponentType.FilterPillsCarousel] = {
		getLazyComponent = function()
			return require(SduiSharedContent.Components.SduiFilterPillsCarousel)
		end
	}

	v[SduiComponentType.Placeholder] = {
		getLazyComponent = function()
			return require(SduiSharedContent.Components.SduiPlaceholder)
		end
	}

	v[SduiComponentType.PlaceholderTile] = FFlagSduiCollectionCarouselPlaceholderItem and {
		getLazyComponent = function()
			return require(SduiSharedContent.Components.SduiPlaceholderTile)
		end
	} or nil

	v[SduiComponentType.PlaceholderWrapper] = {
		getLazyComponent = function()
			return require(SduiSharedContent.Components.SduiPlaceholderWrapper)
		end
	}

	v[SduiComponentType.Skeleton] = {
		getLazyComponent = function()
			return require(SduiSharedContent.Components.SduiSkeleton)
		end
	}

	v[SduiComponentType.AiOverview] = FFlagSduiAiOverviewEnabled and {
		getLazyComponent = function()
			return require(SduiSharedContent.Components.SduiAiOverview)
		end
	} or nil

	v[SduiComponentType.VerticalListWithImpressions] = FFlagSduiVerticalListWithImpressionsEnabled and {
		getLazyComponent = function()
			return require(SduiSharedContent.Components.SduiVerticalListWithImpressions)
		end
	} or nil

	v[SduiComponentType.Reactions] = FFlagSduiReactionsComponent and {
		getLazyComponent = function()
			return require(SduiSharedContent.Components.SduiReactions)
		end
	} or nil

	getSduiComponentRegistry().registerComponentDefinitions(v)
end

return registerSharedUiComponents
