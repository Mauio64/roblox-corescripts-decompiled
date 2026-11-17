local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(BuildExperience.Components.ModelPicker.ModelPickerTypes)
local FFlagBuildExperienceModelPicker = require(BuildExperience.Flags.FFlagBuildExperienceModelPicker)

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FFlagBuildAdUpsell = require(BuildExperience.Flags.FFlagBuildAdUpsell)
local FFlagBuildAdUpsellPinned = require(BuildExperience.Flags.FFlagBuildAdUpsellPinned)
local FFlagBuildAdsManagerUniverseUrl = require(BuildExperience.Flags.FFlagBuildAdsManagerUniverseUrl)
local FFlagBuildAgentAdCampaignCard = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignCard)

local chatConstants = require(BuildExperience.Chat.chatConstants)
local ChatPermissionsContext = require(BuildExperience.Chat.ChatPermissionsContext)
local ChatScrollAnchorContext = require(BuildExperience.Chat.ChatScrollAnchorContext)
require(BuildExperience.Chat.chatTypes)

local ChatCardEmphasisPositionProvider = require(BuildExperience.Components.Chat.ChatCardEmphasis.ChatCardEmphasisPositionProvider)
local FFlagBuildExperienceChatCardEmphasis = require(BuildExperience.Flags.FFlagBuildExperienceChatCardEmphasis)
local BuildEmptyState = require(BuildExperience.Components.BuildEmptyState.BuildEmptyState)
local enabled = CreatorAgentChat.experimentOverride.isEnabled()
local AgentSpecDebugSheet

if enabled then
	AgentSpecDebugSheet = require(BuildExperience.Components.AgentSpecDebug.AgentSpecDebugSheet)
else
	AgentSpecDebugSheet = nil
end

local BuildOverflowMenuButton = require(BuildExperience.Components.BuildPillMenu.BuildOverflowMenuButton)
local PlayButton = require(BuildExperience.Components.PlayButton.PlayButton)
local BuyMoreRobuxCard = require(BuildExperience.Components.Chat.BuyMoreRobuxCard)
local ChatActions = require(BuildExperience.Components.Chat.ChatActions)
local ChatMessageList = require(BuildExperience.Components.Chat.ChatMessageList)
local FFlagBuildExperienceAnswerForm = require(BuildExperience.Flags.FFlagBuildExperienceAnswerForm)
local AnswerFormContainer

if FFlagBuildExperienceAnswerForm then
	AnswerFormContainer = require(BuildExperience.Components.AnswerForm.AnswerFormContainer)
else
	AnswerFormContainer = nil
end

local PushNotificationsUpsellCard = require(BuildExperience.Components.Chat.PushNotificationsUpsellCard)
local AdUpsellMilestoneContainer

if FFlagBuildAdUpsell then
	AdUpsellMilestoneContainer = require(BuildExperience.Components.Ads.AdUpsellMilestone.AdUpsellMilestoneContainer)
else
	AdUpsellMilestoneContainer = nil
end

local CreateAdCampaignSheetContainer

if FFlagBuildAdUpsell then
	CreateAdCampaignSheetContainer = require(BuildExperience.Components.Ads.CreateAdCampaignSheet.CreateAdCampaignSheetContainer)
else
	CreateAdCampaignSheetContainer = nil
end

local AdCampaignCreatedToast

if FFlagBuildAdUpsell then
	AdCampaignCreatedToast = require(BuildExperience.Components.Ads.AdCampaignCreatedToast)
else
	AdCampaignCreatedToast = nil
end

require(BuildExperience.Stores.GetBuildOverflowMenuStore)

require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary
require(BuildExperience.Chat.useChatSessionCore)
local FFlagEnableBuildAdPromotion = require(BuildExperience.Flags.FFlagEnableBuildAdPromotion)

local FFlagBuildExperienceChatAccordionScrollAnchor = require(BuildExperience.Flags.FFlagBuildExperienceChatAccordionScrollAnchor)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)
require(BuildExperience.useGamePermissions)
local useScrollPerformanceTracker = require(BuildExperience.Telemetry.useScrollPerformanceTracker)

local Divider = Foundation.Divider
local IconButton = Foundation.IconButton
local ScrollView = Foundation.ScrollView
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens

local function groupAdUpsellCardsByAnchorIndex(adUpsellCards)
	local result = {}

	for _, item in adUpsellCards do
		if item.anchorIndex == nil then
			continue
		end

		local v = result[item.anchorIndex] or {}
		table.insert(v, item)
		result[item.anchorIndex] = v
	end

	return result
end

local function renderAdUpsells(props, p, ref, adUpsellCongrats: string?)
	local clone = table.clone(p)

	if FFlagBuildAdUpsell and FFlagBuildAdUpsellPinned and props.adUpsellCongratsAnchorIndex ~= nil then
		clone.AdUpsellCongrats = React.createElement(Text, {
			LayoutOrder = props.adUpsellCongratsAnchorIndex * chatConstants.MESSAGE_LAYOUT_ORDER_STRIDE + 1,
			Text = adUpsellCongrats,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis",
			testId = "AdUpsellCongrats"
		})
	end

	if FFlagBuildAdUpsell and not FFlagBuildAdUpsellPinned then
		local v = groupAdUpsellCardsByAnchorIndex(props.adUpsellCards)

		for k, v2 in v do
			local ids = {}
			local children = {}

			for _, v3 in v2 do
				table.insert(ids, v3.id)
				local id = v3.id
				local createElement = React.createElement
				local v4 = {
					anchorId = v3.id,
					order = v3.order,
					isImpressed = v3.isImpressed,
					congratsText = adUpsellCongrats,
					freePromotionsRemaining = 0,
					isCreatePending = 0,
					isCreateDisabled = 0,
					isPageVisible = 0,
					onCreate = 0,
					onDismiss = 0,
					onImpression = 0,
					scrollingFrameRef = 0
				}
				local freePromotionsRemaining

				if FFlagBuildAgentAdCampaignCard then
					freePromotionsRemaining = props.adUpsellFreePromotionsRemaining
				end

				v4.freePromotionsRemaining = freePromotionsRemaining

				v4.isCreatePending = props.isAdUpsellCreatePending
				v4.isCreateDisabled = props.isAdUpsellCreateDisabled
				v4.isPageVisible = props.isAdUpsellVisible
				v4.onCreate = props.onAdUpsellCreate
				v4.onDismiss = props.onAdUpsellDismiss
				v4.onImpression = props.onAdUpsellImpression
				v4.scrollingFrameRef = ref
				children[id] = createElement(AdUpsellMilestoneContainer, v4)

				if FFlagBuildExperienceChatCardEmphasis then
					children[v3.id] = React.createElement(ChatCardEmphasisPositionProvider, {
						messageOrder = k * chatConstants.MESSAGE_LAYOUT_ORDER_STRIDE + 1,
						segmentOrder = v3.order
					}, children[v3.id])
				end
			end

			clone[`AdUpsellGroup:{table.concat(ids, "|")}`] = React.createElement(View, {
				LayoutOrder = k * chatConstants.MESSAGE_LAYOUT_ORDER_STRIDE + 1,
				tag = "col gap-medium size-full-0 auto-y",
				testId = `AdUpsellGroup.{k}`
			}, children)
		end
	end

	local children = {}

	if not (FFlagBuildAdUpsell and FFlagBuildAdUpsellPinned) then
		return clone, children
	end

	for _, adUpsellCard in props.adUpsellCards do
		local id = adUpsellCard.id
		local createElement = React.createElement
		local v = {
			anchorId = adUpsellCard.id,
			order = adUpsellCard.order,
			isImpressed = adUpsellCard.isImpressed,
			freePromotionsRemaining = 0,
			isCreatePending = 0,
			isCreateDisabled = 0,
			isPageVisible = 0,
			onCreate = 0,
			onDismiss = 0,
			onImpression = 0
		}
		local freePromotionsRemaining

		if FFlagBuildAgentAdCampaignCard then
			freePromotionsRemaining = props.adUpsellFreePromotionsRemaining
		end

		v.freePromotionsRemaining = freePromotionsRemaining

		v.isCreatePending = props.isAdUpsellCreatePending
		v.isCreateDisabled = props.isAdUpsellCreateDisabled
		v.isPageVisible = props.isAdUpsellVisible
		v.onCreate = props.onAdUpsellCreate
		v.onDismiss = props.onAdUpsellDismiss
		v.onImpression = props.onAdUpsellImpression
		children[id] = createElement(AdUpsellMilestoneContainer, v)
	end

	return clone, children
end

local function BuildChatPageView(props)
	local v = FFlagBuildExperienceAnswerForm and props.answerForm ~= nil
	local state, setState

	if enabled then
		state, setState = React.useState(false)
	else
		state = false
		setState = nil
	end

	local v2 = {
		composerPlaceholder = LocalizationStrings.CHAT_COMPOSER_PLACEHOLDER,
		adUpsellCongrats = 0,
		adCampaignCreated = 0,
		adCampaignCreatedView = 0
	}
	local adUpsellCongrats

	if FFlagBuildAdUpsell then
		if props.adUpsellFreePromotionsRemaining == 1 then
			adUpsellCongrats = LocalizationStrings.AD_UPSELL_CONGRATS_SINGULAR
		else
			adUpsellCongrats = {
				LocalizationStrings.AD_UPSELL_CONGRATS,
				promotionCount = props.adUpsellFreePromotionsRemaining
			}
		end
	end

	v2.adUpsellCongrats = adUpsellCongrats
	local adCampaignCreated

	if FFlagBuildAdUpsell then
		adCampaignCreated = LocalizationStrings.ADS_STATS_CREATE_SUCCESS
	end

	v2.adCampaignCreated = adCampaignCreated
	local adCampaignCreatedView

	if FFlagBuildAdUpsell then
		adCampaignCreatedView = LocalizationStrings.AD_CAMPAIGN_CARD_VIEW
	end

	v2.adCampaignCreatedView = adCampaignCreatedView
	local v3 = useLocalization(v2)

	local v4 = useTokens()
	local ref = React.useRef(nil)
	useScrollPerformanceTracker("LuaApp_Build_Chat_Scroll", ref)

	local scrollingFrameRef = React.useCallback(function(current)
		ref.current = current
		props.scrollingFrameRef(current)
	end, { props.scrollingFrameRef })

	local v5 = {
		isPageVisible = props.isAdUpsellVisible,
		scrollingFrameRef = ref,
		isAgentAdCampaignCreateDisabled = props.isAgentAdCampaignCreateDisabled,
		messages = props.messages,
		clockBinding = props.clockBinding,
		localToolActions = props.localToolActions,
		emptyState = 0,
		isHistoryLoading = 0,
		onPlaytest = 0,
		onPublish = 0,
		isPlaytestLoading = 0,
		onAgentAdCampaignOfferSelected = 0,
		getAgentAdCampaignCardState = 0,
		onAgentAdCampaignActive = 0
	}
	local emptyState

	if not v then
		emptyState = React.createElement(BuildEmptyState)
	end

	v5.emptyState = emptyState
	v5.isHistoryLoading = props.isHistoryLoading
	v5.onPlaytest = props.onPlaytest
	v5.onPublish = props.onPublish
	v5.isPlaytestLoading = props.isPlaytestLoading
	local onAgentAdCampaignOfferSelected

	if FFlagBuildAgentAdCampaignCard then
		onAgentAdCampaignOfferSelected = props.onAgentAdCampaignOfferSelected
	end

	v5.onAgentAdCampaignOfferSelected = onAgentAdCampaignOfferSelected
	local getAgentAdCampaignCardState

	if FFlagBuildAgentAdCampaignCard then
		getAgentAdCampaignCardState = props.getAgentAdCampaignCardState
	end

	v5.getAgentAdCampaignCardState = getAgentAdCampaignCardState
	local onAgentAdCampaignActive

	if FFlagBuildAgentAdCampaignCard then
		onAgentAdCampaignActive = props.onAgentAdCampaignActive
	end

	v5.onAgentAdCampaignActive = onAgentAdCampaignActive
	local chatMessageList = ChatMessageList(v5)
	local v6 = false

	for _, message in props.messages do
		if message.kind == "user_message" then
			v6 = true
			break
		end
	end

	local MESSAGE_LAYOUT_ORDER_STRIDE = chatConstants.MESSAGE_LAYOUT_ORDER_STRIDE

	if props.showPushNotificationsUpsell and v6 and props.isAssistantResponding then
		chatMessageList.PushNotificationsUpsell = React.createElement(PushNotificationsUpsellCard, {
			LayoutOrder = (#props.messages + 1) * MESSAGE_LAYOUT_ORDER_STRIDE,
			isRequestPending = props.isPushNotificationsRequestPending,
			shouldOpenSettings = props.shouldOpenPushNotificationsSettings,
			onNotifyMe = props.onNotifyMe,
			onOpenSettings = props.onOpenPushNotificationsSettings,
			onNotNow = props.onNotNow
		})
	end

	local v7, v8 = renderAdUpsells(props, chatMessageList, ref, v3.adUpsellCongrats)

	if v then
		v7.AnswerForm = React.createElement(AnswerFormContainer, {
			LayoutOrder = (#props.messages + 2) * chatConstants.MESSAGE_LAYOUT_ORDER_STRIDE,
			state = props.answerForm,
			actions = props.localToolActions,
			onSubmitText = props.onSubmitAnswerText,
			onStop = props.onStop,
			errorText = props.composerErrorText,
			isReadOnly = props.isChatReadOnly
		})
	end

	local v9 = FFlagBuildExperienceChatAccordionScrollAnchor and {
		ScrollAnchor = React.createElement(
			ChatScrollAnchorContext.Provider,
			{ value = props.anchorScrollToInstance },
			v7
		)
	} or v7

	local v10 = FFlagBuildCheckGamePermissions and {
		Permissions = React.createElement(ChatPermissionsContext.Provider, {
			value = props.chatPermissions
		}, v9)
	} or v9

	local createElement = React.createElement
	local v11 = {
		tag = {
			["composition-content-body size-full-0 auto-y"] = true,
			["col gap-medium"] = props.showBuyMoreRobuxCard or FFlagBuildAdUpsellPinned and #props.adUpsellCards > 0
		},
		testId = "BuildChatPage.ActionBody"
	}
	local buyMoreRobux

	if props.showBuyMoreRobuxCard then
		buyMoreRobux = React.createElement(BuyMoreRobuxCard, {
			LayoutOrder = 1,
			title = props.buyMoreRobuxCardTitle,
			description = props.buyMoreRobuxCardDescription,
			primaryActionText = props.buyMoreRobuxCardPrimaryActionText,
			onPrimaryAction = props.onBuyMoreRobuxCardPrimaryAction,
			secondaryActionText = props.buyMoreRobuxCardSecondaryActionText,
			onSecondaryAction = props.onBuyMoreRobuxCardSecondaryAction
		})
	end

	local adUpsells

	if FFlagBuildAdUpsell and FFlagBuildAdUpsellPinned and #props.adUpsellCards > 0 then
		adUpsells = React.createElement(View, {
			LayoutOrder = props.showBuyMoreRobuxCard and 2 or 1,
			tag = "col gap-medium size-full-0 auto-y",
			testId = "BuildChatPage.AdUpsells"
		}, v8)
	end

	local footer

	if not v then
		local createElement2 = React.createElement
		local layoutOrder

		if props.showBuyMoreRobuxCard then
			layoutOrder = FFlagBuildAdUpsellPinned and #props.adUpsellCards > 0 and 3 or 2
		else
			layoutOrder = FFlagBuildAdUpsellPinned and #props.adUpsellCards > 0 and 2 or nil
		end

		local modelPicker

		if FFlagBuildExperienceModelPicker then
			modelPicker = props.modelPicker
		end

		footer = createElement2(ChatActions, {
			LayoutOrder = layoutOrder,
			modelPicker = modelPicker,
			composerText = props.composerText,
			composerErrorText = props.composerErrorText,
			onComposerChanged = props.onComposerChanged,
			promptChips = props.promptChips,
			isPromptChipsLoading = props.isPromptChipsLoading,
			onPromptChipActivated = props.onPromptChipActivated,
			onPromptChipExhausted = props.onPromptChipExhausted,
			images = props.composerImages,
			onImagesChanged = props.onComposerImagesChanged,
			onRetryImage = props.onRetryComposerImage,
			isSendBlocked = props.isComposerSendBlocked,
			resourceAttachments = props.composerResourceAttachments,
			onRemoveResourceAttachment = props.onRemoveComposerResourceAttachment,
			placeholder = v3.composerPlaceholder,
			textBoxRef = props.textBoxRef,
			isAssistantResponding = props.isAssistantResponding,
			canStopAssistantResponse = props.canStopAssistantResponse,
			canSendWhileResponding = props.canSendWhileResponding,
			isReadOnly = props.isChatReadOnly,
			onSend = props.onSend,
			onStop = props.onStop
		})
	end

	local element = createElement(View, v11, {
		BuyMoreRobux = buyMoreRobux,
		AdUpsells = adUpsells,
		Footer = footer
	})

	local createElement2 = React.createElement
	local v12 = {
		onAbsolutePositionChanged = props.onPageMetricsChanged,
		onAbsoluteSizeChanged = props.onPageMetricsChanged,
		tag = "col align-x-center size-full bg-surface-0",
		padding = {
			bottom = UDim.new(0, props.paddingBottom)
		}
	}

	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local library

	if FFlagBuildExperienceLibrary then
		library = React.createElement(IconButton, {
			LayoutOrder = 5,
			icon = IconName.SquaresGridPlus,
			isCircular = true,
			isDisabled = props.isLibraryDisabled,
			onActivated = props.onOpenLibrary,
			size = InputSize.Large,
			testId = "BuildChatPage.LibraryButton",
			variant = ButtonVariant.Utility
		})
	end

	local children2 = {
		Library = library,
		Back = React.createElement(IconButton, {
			LayoutOrder = 1,
			icon = IconName.ChevronLargeLeft,
			isCircular = true,
			onActivated = props.onClose,
			size = InputSize.Large,
			testId = "BuildChatPage.BackButton"
		}),
		Title = 0,
		Play = 0,
		AgentSpec = 0,
		Overflow = 0
	}

	local createElement5 = React.createElement
	local text

	if props.isNewGameTarget then
		text = chatConstants.BUILD_CHAT_PAGE_TITLE
	else
		text = props.target.experienceName
	end

	children2.Title = createElement5(Text, {
		LayoutOrder = 2,
		Text = text,
		tag = "fill text-heading-small text-align-x-left text-truncate-split content-emphasis"
	})

	children2.Play = React.createElement(PlayButton, {
		LayoutOrder = 3,
		activeIcon = IconName.PlaySmall,
		inActiveIcon = IconName.PlaySmall,
		isActive = true,
		isDisabled = props.isNewGameTarget and not props.hasPublishedTurn,
		isUnavailable = props.isPlaytestDisabled,
		onActivated = props.onPlayActivated,
		variant = ButtonVariant.Utility
	})
	local agentSpec

	if enabled and (not FFlagBuildExperienceModelPicker or props.modelPicker == nil) then
		local createElement6 = React.createElement

		local icon = { name = IconName.LabBeaker, variant = 0 }
		local variant

		if props.agentSpecVersion == nil then
			variant = IconVariant.Regular
		else
			variant = IconVariant.Filled
		end

		icon.variant = variant
		agentSpec = createElement6(IconButton, {
			LayoutOrder = 5,
			icon = icon,
			isCircular = true,
			onActivated = function()
				setState(true)
			end,
			size = InputSize.Large,
			testId = "BuildChatPage.AgentSpecButton",
			variant = ButtonVariant.Utility
		})
	end

	children2.AgentSpec = agentSpec

	local createElement6 = React.createElement
	local v13 = {
		layoutOrder = 6,
		icon = IconName.ThreeDotsHorizontal,
		isDisabled = false,
		hasPublishedTurn = props.hasPublishedTurn,
		hasPublishedVersion = props.hasPublishedVersion,
		target = {
			universeId = props.target.universeId,
			placeId = props.target.placeId,
			sessionId = props.target.sessionId,
			isNewGameTarget = props.isNewGameTarget
		},
		store = props.buildOverflowMenuStore,
		onAction = props.onOverflowMenuAction,
		onOpenCreatorCreditPage = props.onOpenCreatorCreditPage,
		onOpenGetUsersPage = props.onOpenGetUsersPage,
		isUniversePublic = 0
	}
	local isUniversePublic

	if FFlagEnableBuildAdPromotion then
		isUniversePublic = props.isUniversePublic
	end

	v13.isUniversePublic = isUniversePublic
	children2.Overflow = createElement6(BuildOverflowMenuButton, v13)
	local children = {
		Header = createElement3(View, {
			LayoutOrder = 1,
			tag = "col align-x-center size-full-0 auto-y bg-surface-0"
		}, {
			HeaderBar = createElement4(
				View,
				{
					LayoutOrder = 1,
					tag = "composition-content-header row align-y-center gap-small size-full-0 auto-y padding-y-medium",
					testId = "BuildChatPage.HeaderBar"
				},
				children2
			),
			Divider = React.createElement(Divider, {
				LayoutOrder = 3,
				Visible = props.isChatScrollable,
				testId = "BuildChatPage.HeaderDivider"
			})
		}),
		Messages = React.createElement(ScrollView, {
			LayoutOrder = 2,
			scrollingFrameRef = scrollingFrameRef,
			onAbsoluteCanvasSizeChanged = props.onChatViewportChanged,
			onAbsoluteWindowSizeChanged = props.onChatViewportChanged,
			tag = { ["composition-layout-detail"] = true, ["fill size-full-0"] = true },
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, {
			MessageColumn = React.createElement(View, {
				layout = {
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, v4.Size.Size_800)
				},
				tag = {
					["composition-content-body"] = true,
					["size-full"] = props.isChatEmpty and not v,
					["size-full-0 auto-y padding-y-large"] = not props.isChatEmpty or v
				},
				testId = "BuildChatPage.MessageBody"
			}, v10)
		}),
		AgentSpecSheet = 0,
		Actions = 0,
		AdCampaignSheet = 0,
		AgentAdCampaignSheet = 0,
		AdCampaignCreatedToast = 0
	}
	local agentSpecSheet

	if enabled and state then
		agentSpecSheet = React.createElement(AgentSpecDebugSheet, {
			specVersion = props.agentSpecVersion,
			onSave = props.setAgentSpecVersion,
			onClose = function()
				setState(false)
			end
		})
	end

	children.AgentSpecSheet = agentSpecSheet

	children.Actions = React.createElement(View, {
		LayoutOrder = 3,
		tag = { ["composition-layout-detail"] = true, ["size-full-0 auto-y"] = true },
		testId = "BuildChatPage.ActionLayout"
	}, { ActionBody = element })
	local adCampaignSheet

	if FFlagBuildAdUpsell and props.isAdUpsellVisible then
		local createElement7 = React.createElement
		local universeId

		if FFlagBuildAdsManagerUniverseUrl then
			universeId = props.target.universeId
		end

		adCampaignSheet = createElement7(CreateAdCampaignSheetContainer, {
			universeId = universeId,
			isOpen = props.isAdCampaignSheetOpen,
			onClose = props.onAdCampaignSheetClose,
			onCreate = props.onAdCampaignSheetCreate,
			waitForCreateResult = true,
			useLocalRunDates = true,
			isCreatePending = props.isAdUpsellCreatePending,
			hasCreateError = props.hasAdCampaignCreateError,
			createErrorKind = props.adCampaignCreateErrorKind,
			campaignDurationDays = props.adCampaignDurationDays,
			estimatedPriceRobux = props.adCampaignEstimatedPriceRobux,
			campaignOffers = props.adCampaignOffers,
			runStartTimeMs = props.adCampaignRunStartTimeMs,
			runEndTimeMs = props.adCampaignRunEndTimeMs
		})
	end

	children.AdCampaignSheet = adCampaignSheet
	local agentAdCampaignSheet

	if FFlagBuildAgentAdCampaignCard then
		local createElement7 = React.createElement
		local universeId

		if FFlagBuildAdsManagerUniverseUrl then
			universeId = props.target.universeId
		end

		agentAdCampaignSheet = createElement7(CreateAdCampaignSheetContainer, {
			universeId = universeId,
			isOpen = props.isAgentAdCampaignSheetOpen,
			onClose = props.onAgentAdCampaignSheetClose,
			onCreate = props.onAgentAdCampaignSheetCreate,
			waitForCreateResult = true,
			useLocalRunDates = true,
			isCreatePending = props.isAgentAdCampaignCreatePending,
			hasCreateError = props.hasAgentAdCampaignCreateError,
			createErrorKind = props.agentAdCampaignCreateErrorKind,
			campaignOffers = props.agentAdCampaignOffers,
			attemptedOption = props.agentAdCampaignAttemptedOption,
			runStartTimeMs = props.agentAdCampaignRunStartTimeMs
		})
	end

	children.AgentAdCampaignSheet = agentAdCampaignSheet
	local adCampaignCreatedToast

	if FFlagBuildAdUpsell and props.isAdCampaignCreatedToastVisible and props.isAdUpsellVisible then
		local createElement7 = React.createElement
		local actionText

		if props.onOpenGetUsersPage ~= nil then
			actionText = v3.adCampaignCreatedView
		end

		adCampaignCreatedToast = createElement7(AdCampaignCreatedToast, {
			actionText = actionText,
			onActionActivated = props.onOpenGetUsersPage,
			onClose = props.onAdCampaignCreatedToastDismiss,
			testId = "AdCampaignCreatedToast",
			title = v3.adCampaignCreated
		})
	end

	children.AdCampaignCreatedToast = adCampaignCreatedToast
	return createElement2(View, v12, children)
end

return BuildChatPageView
