local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local SduiSharedContentParent = SduiSharedContent.Parent
local React = require(SduiSharedContentParent.React)
local Foundation = require(SduiSharedContentParent.Foundation)
local SduiCoreSystem = require(SduiSharedContentParent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiComponentType = SduiCoreSystem.SduiComponentType
local SduiParsers = SduiCoreSystem.SduiParsers
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry
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
local FFlagSduiCardComponent = require(SduiSharedContentParent.SharedFlags).FFlagSduiCardComponent
local v22 = game:DefineFastFlag("SduiCoachmarkComponent", false)
local v23 = game:DefineFastFlag("LuaAppEnableCustomAnalyticsEvent", false)
local FFlagSduiSystemBannerComponent = require(SduiSharedContentParent.SharedFlags).FFlagSduiSystemBannerComponent
local FFlagSduiChartsSupport = require(SduiSharedContentParent.SharedFlags).FFlagSduiChartsSupport
local FFlagSduiExperienceDetailsSupport = require(SduiSharedContentParent.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagSduiEventDetailsSupport = require(SduiSharedContentParent.SharedFlags).FFlagSduiEventDetailsSupport
local FFlagLuaAppUnlockUpsellSupport = require(SduiSharedContentParent.SharedFlags).FFlagLuaAppUnlockUpsellSupport
local FFlagSduiDevStoreSeeAllSupport = require(SduiSharedContentParent.SharedFlags).FFlagSduiDevStoreSeeAllSupport
local FFlagSduiPlayWithReward = require(SduiSharedContentParent.SharedFlags).FFlagSduiPlayWithReward
local FFlagSduiDismissPromptAction = require(SduiSharedContentParent.SharedFlags).FFlagSduiDismissPromptAction
local FFlagSduiShimmerTextComponentEnabled = require(SduiSharedContentParent.SharedFlags).FFlagSduiShimmerTextComponentEnabled
local FFlagSduiTooltipComponentEnabled = require(SduiSharedContentParent.SharedFlags).FFlagSduiTooltipComponentEnabled
local FFlagLuaAppSduiPlaceholderSupport = require(SduiSharedContentParent.SharedFlags).FFlagLuaAppSduiPlaceholderSupport
local FFlagSduiSkeletonComponentEnabled = require(SduiSharedContentParent.SharedFlags).FFlagSduiSkeletonComponentEnabled
local FFlagSduiRevealTextComponentEnabled = require(SduiSharedContentParent.SharedFlags).FFlagSduiRevealTextComponentEnabled
local FFlagSduiAiOverviewEnabled = require(SduiSharedContentParent.SharedFlags).FFlagSduiAiOverviewEnabled
local FFlagSduiCollectionCarouselPlaceholderItem = require(SduiSharedContentParent.SharedFlags).FFlagSduiCollectionCarouselPlaceholderItem
local FFlagSduiShowToastAction = require(SduiSharedContentParent.SharedFlags).FFlagSduiShowToastAction

local function registerSharedActions() -- line: 53
	-- upvalues: SduiActionType (copy), FFlagSduiChartsSupport (copy), v23 (copy), SduiSharedContent (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiDismissPromptAction (copy), FFlagSduiShowToastAction (copy), getSduiActionHandlerRegistry (copy)
	local t1 = {
		[SduiActionType.CustomAnalyticsEvent] = if not FFlagSduiChartsSupport and not v23 then nil else {
			skipUnifiedLogging = true,
			lazyHandler = function() -- line: 61
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Actions.SduiAnalyticsEventAction)
			end
		},
		[SduiActionType.LoadMoreFromApi] = {
			skipUnifiedLogging = true,
			lazyHandler = function() -- line: 68
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Actions.SduiLoadMoreFromApi)
			end
		},
		[SduiActionType.RefreshFromApi] = if not FFlagSduiChartsSupport then nil else {
			skipUnifiedLogging = true,
			lazyHandler = function() -- line: 75
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Actions.SduiRefreshFromApi)
			end
		},
		[SduiActionType.Share] = {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 82
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Actions.SduiShareAction)
			end
		},
		[SduiActionType.OpenSocialProofUserListSheet] = if not FFlagSduiExperienceDetailsSupport then nil else {
			skipUnifiedLogging = true,
			lazyHandler = function() -- line: 89
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Actions.SduiOpenSocialProofUserListSheetAction)
			end
		},
		[SduiActionType.DismissPrompt] = if not FFlagSduiDismissPromptAction then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 97
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Actions.SduiDismissPromptAction)
			end
		},
		[SduiActionType.ShowToast] = if not FFlagSduiShowToastAction then nil else {
			skipUnifiedLogging = false,
			lazyHandler = function() -- line: 105
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Actions.SduiShowToastAction)
			end
		}
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(t1)
end
local function registerSharedUiComponents() -- line: 115
	-- upvalues: SduiComponentType (copy), SduiSharedContent (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiCardComponent (copy), v22 (copy), FFlagSduiSystemBannerComponent (copy), FFlagLuaAppUnlockUpsellSupport (copy), getLuaTableEnumParser (copy), Foundation (copy), parseColorTokenProp_ (copy), parseVector2Prop_ (copy), parseIntegerProp_ (copy), parseUDim2Prop_ (copy), parseBooleanProp_ (copy), parseNumberProp_ (copy), parseStringProp_ (copy), FFlagSduiEventDetailsSupport (copy), FFlagSduiShimmerTextComponentEnabled (copy), FFlagSduiRevealTextComponentEnabled (copy), FFlagSduiPlayWithReward (copy), parseUiComponentProp_ (copy), parseCallbackProp_ (copy), FFlagSduiDevStoreSeeAllSupport (copy), FFlagSduiTooltipComponentEnabled (copy), FFlagSduiChartsSupport (copy), FFlagLuaAppSduiPlaceholderSupport (copy), FFlagSduiCollectionCarouselPlaceholderItem (copy), FFlagSduiSkeletonComponentEnabled (copy), FFlagSduiAiOverviewEnabled (copy), getSduiComponentRegistry (copy)
	local t2 = {
		[SduiComponentType.DetailsPageImageHeader] = {
			getLazyComponent = function() -- line: 118
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiDetailsPageImageHeader)
			end
		},
		[SduiComponentType.AvatarGroup] = if not FFlagSduiExperienceDetailsSupport then nil else {
			getLazyComponent = function() -- line: 124
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiAvatarGroup)
			end
		},
		[SduiComponentType.Card] = if not FFlagSduiCardComponent then nil else {
			getLazyComponent = function() -- line: 131
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiCard)
			end
		},
		[SduiComponentType.Coachmark] = if not v22 then nil else {
			getLazyComponent = function() -- line: 138
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiCoachmark)
			end
		},
		[SduiComponentType.SystemBanner] = if not FFlagSduiSystemBannerComponent then nil else {
			getLazyComponent = function() -- line: 145
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiSystemBanner)
			end
		},
		[SduiComponentType.CircleIcon] = if not FFlagSduiExperienceDetailsSupport then nil else {
			getLazyComponent = function() -- line: 152
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiCircleIcon)
			end
		},
		[SduiComponentType.Icon] = if not FFlagSduiExperienceDetailsSupport and not FFlagLuaAppUnlockUpsellSupport then nil else {
			getLazyComponent = function() -- line: 159
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiIcon)
			end,
			propParsers = if not FFlagLuaAppUnlockUpsellSupport then nil else {
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
		[SduiComponentType.IconButton] = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else {
			getLazyComponent = function() -- line: 181
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiIconButton)
			end
		},
		[SduiComponentType.LinkText] = if not FFlagSduiExperienceDetailsSupport then nil else {
			getLazyComponent = function() -- line: 189
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiLinkText)
			end
		},
		[SduiComponentType.ShimmerText] = if not FFlagSduiShimmerTextComponentEnabled then nil else {
			getLazyComponent = function() -- line: 196
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiShimmerText)
			end
		},
		[SduiComponentType.RevealText] = if not FFlagSduiRevealTextComponentEnabled then nil else {
			getLazyComponent = function() -- line: 203
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiRevealText)
			end
		},
		[SduiComponentType.ContentRatingLabel] = if not FFlagSduiExperienceDetailsSupport then nil else {
			getLazyComponent = function() -- line: 210
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiContentRatingLabel)
			end
		},
		[SduiComponentType.MediaGallery] = if not FFlagSduiExperienceDetailsSupport then nil else {
			getLazyComponent = function() -- line: 217
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiMediaGallery)
			end
		},
		[SduiComponentType.ActionBar] = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else {
			getLazyComponent = function() -- line: 224
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiActionBar)
			end
		},
		[SduiComponentType.PlayButtonContextualMessage] = if not FFlagSduiExperienceDetailsSupport then nil else {
			getLazyComponent = function() -- line: 231
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiPlayButtonContextualMessage)
			end
		},
		[SduiComponentType.PlayWithReward] = if not FFlagSduiPlayWithReward then nil else {
			getLazyComponent = function() -- line: 238
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiPlayWithReward)
			end
		},
		[SduiComponentType.ContentRow] = if not FFlagSduiExperienceDetailsSupport and (not FFlagLuaAppUnlockUpsellSupport and not FFlagSduiEventDetailsSupport) then nil else {
			getLazyComponent = function() -- line: 247
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiContentRow)
			end,
			propParsers = if not FFlagLuaAppUnlockUpsellSupport then nil else {
				leading = parseUiComponentProp_,
				content = parseUiComponentProp_,
				trailing = parseUiComponentProp_,
				onActivated = parseCallbackProp_,
				tag = parseStringProp_,
				leadingTag = parseStringProp_,
				contentTag = parseStringProp_,
				trailingTag = parseStringProp_,
				layoutOrder = parseIntegerProp_,
				position = parseUDim2Prop_,
				zIndex = parseNumberProp_,
				testId = parseStringProp_
			}
		},
		[SduiComponentType.SubscriptionCell] = if not FFlagSduiDevStoreSeeAllSupport then nil else {
			getLazyComponent = function() -- line: 270
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiSubscriptionCell)
			end
		},
		[SduiComponentType.Tooltip] = if not FFlagSduiTooltipComponentEnabled then nil else {
			getLazyComponent = function() -- line: 277
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiTooltip)
			end
		},
		[SduiComponentType.FilterPillsCarousel] = if not FFlagSduiChartsSupport then nil else {
			getLazyComponent = function() -- line: 284
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiFilterPillsCarousel)
			end
		},
		[SduiComponentType.Placeholder] = if not FFlagLuaAppSduiPlaceholderSupport then nil else {
			getLazyComponent = function() -- line: 291
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiPlaceholder)
			end
		},
		[SduiComponentType.PlaceholderTile] = if not FFlagSduiCollectionCarouselPlaceholderItem then nil else {
			getLazyComponent = function() -- line: 298
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiPlaceholderTile)
			end
		},
		[SduiComponentType.PlaceholderWrapper] = if not FFlagLuaAppSduiPlaceholderSupport then nil else {
			getLazyComponent = function() -- line: 305
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiPlaceholderWrapper)
			end
		},
		[SduiComponentType.Skeleton] = if not FFlagSduiSkeletonComponentEnabled then nil else {
			getLazyComponent = function() -- line: 312
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiSkeleton)
			end
		},
		[SduiComponentType.AiOverview] = if not FFlagSduiAiOverviewEnabled then nil else {
			getLazyComponent = function() -- line: 319
				-- upvalues: SduiSharedContent (copy)
				return require(SduiSharedContent.Components.SduiAiOverview)
			end
		}
	}

	getSduiComponentRegistry().registerComponentDefinitions(t2)
end
local function SduiSharedRegister() -- line: 329
	-- upvalues: React (copy), registerSharedActions (copy), registerSharedUiComponents (copy)
	React.useEffect(function() -- line: 330
		-- upvalues: registerSharedActions (copy), registerSharedUiComponents (copy)
		registerSharedActions()
		registerSharedUiComponents()
	end, {})

	return nil
end

return React.memo(SduiSharedRegister)
