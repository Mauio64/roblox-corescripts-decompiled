require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/ModelPickerTypes")
local FFlagBuildExperienceModelPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPicker")

local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local FFlagBuildAdUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdUpsell")
local FFlagBuildAdUpsellPinned = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdUpsellPinned")
local FFlagBuildAdsManagerUniverseUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdsManagerUniverseUrl")
local FFlagBuildAgentAdCampaignCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignCard")

local chatConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatConstants")
local ChatPermissionsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/ChatPermissionsContext")
local ChatScrollAnchorContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/ChatScrollAnchorContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")

local ChatCardEmphasisPositionProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/ChatCardEmphasisPositionProvider")
local FFlagBuildExperienceChatCardEmphasis = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatCardEmphasis")
local BuildEmptyState = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildEmptyState/BuildEmptyState")
local enabled = CreatorAgentChat.experimentOverride.isEnabled()

local v5 = if enabled then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/AgentSpecDebug/AgentSpecDebugSheet") else nil

local BuildOverflowMenuButton = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/BuildOverflowMenuButton")
local PlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PlayButton/PlayButton")
local BuyMoreRobuxCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/BuyMoreRobuxCard")
local ChatActions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatActions")
local ChatMessageList = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatMessageList")
local FFlagBuildExperienceAnswerForm = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceAnswerForm")

local v6 = if FFlagBuildExperienceAnswerForm then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/AnswerForm/AnswerFormContainer") else nil

local PushNotificationsUpsellCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/PushNotificationsUpsellCard")

local v7 = if FFlagBuildAdUpsell then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/AdUpsellMilestone/AdUpsellMilestoneContainer") else nil

local v8 = if FFlagBuildAdUpsell then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/CreateAdCampaignSheet/CreateAdCampaignSheetContainer") else nil

local v9 = if FFlagBuildAdUpsell then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/AdCampaignCreatedToast") else nil

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildOverflowMenuStore")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildOverflowMenuStore/createBuildOverflowMenuStore")
local fFlagBuildExperienceLibrary = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceLibrary
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useChatSessionCore")
local FFlagEnableBuildAdPromotion = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagEnableBuildAdPromotion")

local FFlagBuildExperienceChatAccordionScrollAnchor = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatAccordionScrollAnchor")
local FFlagBuildExperienceChatImageAttachments = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatImageAttachments")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/useGamePermissions")

local fFlagBuildExperienceChatResourceAttachments = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceChatResourceAttachments
local useScrollPerformanceTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/useScrollPerformanceTracker")

local divider = Foundation.Divider
local iconButton = Foundation.IconButton
local scrollView = Foundation.ScrollView
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local iconVariant = Foundation.Enums.IconVariant
local inputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens

local function groupAdUpsellCardsByAnchorIndex(adUpsellCards)
	local result = {}

	for k, item in adUpsellCards do
		if item.anchorIndex == nil then
			continue
		end

		local v10 = result[item.anchorIndex] or {}
		table.insert(v10, item)
		result[item.anchorIndex] = v10
	end

	return result
end

local function renderAdUpsells(props, p2, ref, adUpsellCongrats)
	local clone = table.clone(p2)

	if FFlagBuildAdUpsell and FFlagBuildAdUpsellPinned and props.adUpsellCongratsAnchorIndex ~= nil then
		clone.AdUpsellCongrats = React.createElement(text, {
			LayoutOrder = props.adUpsellCongratsAnchorIndex * chatConstants.MESSAGE_LAYOUT_ORDER_STRIDE + 1,
			Text = adUpsellCongrats,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis",
			testId = "AdUpsellCongrats"
		})
	end

	if FFlagBuildAdUpsell and not FFlagBuildAdUpsellPinned then
		local v10 = groupAdUpsellCardsByAnchorIndex(props.adUpsellCards)

		for k, v11 in v10 do
			local ids = {}
			local children = {}

			for k2, v12 in v11 do
				table.insert(ids, v12.id)
				local id = v12.id
				local createElement = React.createElement
				local v14 = {
					anchorId = v12.id,
					order = v12.order,
					isImpressed = v12.isImpressed,
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

				local v15 = if FFlagBuildAgentAdCampaignCard then props.adUpsellFreePromotionsRemaining else nil
				v14.freePromotionsRemaining = v15

				v14.isCreatePending = props.isAdUpsellCreatePending
				v14.isCreateDisabled = props.isAdUpsellCreateDisabled
				v14.isPageVisible = props.isAdUpsellVisible
				v14.onCreate = props.onAdUpsellCreate
				v14.onDismiss = props.onAdUpsellDismiss
				v14.onImpression = props.onAdUpsellImpression
				v14.scrollingFrameRef = ref
				children[id] = createElement(v7, v14)

				if FFlagBuildExperienceChatCardEmphasis then
					children[v12.id] = React.createElement(ChatCardEmphasisPositionProvider, {
						messageOrder = k * chatConstants.MESSAGE_LAYOUT_ORDER_STRIDE + 1,
						segmentOrder = v12.order
					}, children[v12.id])
				end
			end

			clone[`AdUpsellGroup:{table.concat(ids, "|")}`] = React.createElement(view, {
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

	for k, adUpsellCard in props.adUpsellCards do
		local id = adUpsellCard.id
		local createElement = React.createElement
		local v11 = {
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

		local v12 = if FFlagBuildAgentAdCampaignCard then props.adUpsellFreePromotionsRemaining else nil
		v11.freePromotionsRemaining = v12

		v11.isCreatePending = props.isAdUpsellCreatePending
		v11.isCreateDisabled = props.isAdUpsellCreateDisabled
		v11.isPageVisible = props.isAdUpsellVisible
		v11.onCreate = props.onAdUpsellCreate
		v11.onDismiss = props.onAdUpsellDismiss
		v11.onImpression = props.onAdUpsellImpression
		children[id] = createElement(v7, v11)
	end

	return clone, children
end

local function BuildChatPageView(props)
	local v10 = FFlagBuildExperienceAnswerForm and props.answerForm ~= nil
	local state, setState

	if enabled then
		state, setState = React.useState(false)
	else
		state = false
		setState = nil
	end

	local v12 = {
		composerPlaceholder = LocalizationStrings.CHAT_COMPOSER_PLACEHOLDER,
		adUpsellCongrats = 0,
		adCampaignCreated = 0,
		adCampaignCreatedView = 0
	}
	local v13

	if FFlagBuildAdUpsell then
		if props.adUpsellFreePromotionsRemaining == 1 then
			v13 = LocalizationStrings.AD_UPSELL_CONGRATS_SINGULAR
		else
			v13 = {
				LocalizationStrings.AD_UPSELL_CONGRATS,
				promotionCount = props.adUpsellFreePromotionsRemaining
			}
		end
	end

	v12.adUpsellCongrats = v13

	local v14 = if FFlagBuildAdUpsell then LocalizationStrings.ADS_STATS_CREATE_SUCCESS else nil
	v12.adCampaignCreated = v14
	local v15 = if FFlagBuildAdUpsell then LocalizationStrings.AD_CAMPAIGN_CARD_VIEW else nil
	v12.adCampaignCreatedView = v15
	local v16 = useLocalization(v12)

	local v17 = useTokens()
	local ref = React.useRef(nil)
	useScrollPerformanceTracker("LuaApp_Build_Chat_Scroll", ref)

	local v18 = React.useCallback(function(current)
		ref.current = current
		props.scrollingFrameRef(current)
	end, { props.scrollingFrameRef })

	local v20 = {
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
	local v21 = if not v10 then React.createElement(BuildEmptyState) else nil
	v20.emptyState = v21
	v20.isHistoryLoading = props.isHistoryLoading
	v20.onPlaytest = props.onPlaytest
	v20.onPublish = props.onPublish
	v20.isPlaytestLoading = props.isPlaytestLoading

	local v22 = if FFlagBuildAgentAdCampaignCard then props.onAgentAdCampaignOfferSelected else nil
	v20.onAgentAdCampaignOfferSelected = v22

	local v23 = if FFlagBuildAgentAdCampaignCard then props.getAgentAdCampaignCardState else nil
	v20.getAgentAdCampaignCardState = v23

	local v24 = if FFlagBuildAgentAdCampaignCard then props.onAgentAdCampaignActive else nil
	v20.onAgentAdCampaignActive = v24
	local v25 = ChatMessageList(v20)
	local v26 = false

	for k, message in props.messages do
		if message.kind == "user_message" then
			v26 = true
			break
		end
	end

	local MESSAGE_LAYOUT_ORDER_STRIDE = chatConstants.MESSAGE_LAYOUT_ORDER_STRIDE

	if props.showPushNotificationsUpsell and v26 and props.isAssistantResponding then
		v25.PushNotificationsUpsell = React.createElement(PushNotificationsUpsellCard, {
			LayoutOrder = (#props.messages + 1) * MESSAGE_LAYOUT_ORDER_STRIDE,
			isRequestPending = props.isPushNotificationsRequestPending,
			shouldOpenSettings = props.shouldOpenPushNotificationsSettings,
			onNotifyMe = props.onNotifyMe,
			onOpenSettings = props.onOpenPushNotificationsSettings,
			onNotNow = props.onNotNow
		})
	end

	local v28, v29 = renderAdUpsells(props, v25, ref, v16.adUpsellCongrats)

	if v10 then
		v28.AnswerForm = React.createElement(v6, {
			LayoutOrder = (#props.messages + 2) * chatConstants.MESSAGE_LAYOUT_ORDER_STRIDE,
			state = props.answerForm,
			actions = props.localToolActions,
			onSubmitText = props.onSubmitAnswerText,
			onStop = props.onStop,
			errorText = props.composerErrorText,
			isReadOnly = props.isChatReadOnly
		})
	end

	local v30 = FFlagBuildExperienceChatAccordionScrollAnchor and {
		ScrollAnchor = React.createElement(
			ChatScrollAnchorContext.Provider,
			{ value = props.anchorScrollToInstance },
			v28
		)
	} or v28

	local v31 = FFlagBuildCheckGamePermissions and {
		Permissions = React.createElement(ChatPermissionsContext.Provider, {
			value = props.chatPermissions
		}, v30)
	} or v30

	local createElement = React.createElement
	local v33 = {
		tag = {
			["composition-content-body size-full-0 auto-y"] = true,
			["col gap-medium"] = props.showBuyMoreRobuxCard or FFlagBuildAdUpsellPinned and #props.adUpsellCards > 0
		},
		testId = "BuildChatPage.ActionBody"
	}

	local v35 = if props.showBuyMoreRobuxCard then React.createElement(BuyMoreRobuxCard, {
		LayoutOrder = 1,
		title = props.buyMoreRobuxCardTitle,
		description = props.buyMoreRobuxCardDescription,
		primaryActionText = props.buyMoreRobuxCardPrimaryActionText,
		onPrimaryAction = props.onBuyMoreRobuxCardPrimaryAction,
		secondaryActionText = props.buyMoreRobuxCardSecondaryActionText,
		onSecondaryAction = props.onBuyMoreRobuxCardSecondaryAction
	}) else nil

	local v36 = if FFlagBuildAdUpsell and FFlagBuildAdUpsellPinned and #props.adUpsellCards > 0 then React.createElement(view, {
		LayoutOrder = props.showBuyMoreRobuxCard and 2 or 1,
		tag = "col gap-medium size-full-0 auto-y",
		testId = "BuildChatPage.AdUpsells"
	}, v29) else nil
	local v37

	if not v10 then
		local createElement2 = React.createElement
		local v40 = if props.showBuyMoreRobuxCard then FFlagBuildAdUpsellPinned and #props.adUpsellCards > 0 and 3 or 2 else FFlagBuildAdUpsellPinned and #props.adUpsellCards > 0 and 2 or nil

		local v41 = if FFlagBuildExperienceModelPicker then props.modelPicker else nil
		local v39 = {
			LayoutOrder = v40,
			modelPicker = v41,
			composerText = props.composerText,
			composerErrorText = props.composerErrorText,
			onComposerChanged = props.onComposerChanged,
			promptChips = props.promptChips,
			isPromptChipsLoading = props.isPromptChipsLoading,
			onPromptChipActivated = props.onPromptChipActivated,
			onPromptChipExhausted = props.onPromptChipExhausted,
			images = 0,
			onImagesChanged = 0,
			onRetryImage = 0,
			isSendBlocked = 0,
			resourceAttachments = 0,
			onRemoveResourceAttachment = 0,
			placeholder = 0,
			textBoxRef = 0,
			isAssistantResponding = 0,
			canStopAssistantResponse = 0,
			canSendWhileResponding = 0,
			isReadOnly = 0,
			onSend = 0,
			onStop = 0
		}
		local v42 = if FFlagBuildExperienceChatImageAttachments then props.composerImages else nil
		v39.images = v42

		local v43 = if FFlagBuildExperienceChatImageAttachments then props.onComposerImagesChanged else nil
		v39.onImagesChanged = v43

		local v44 = if FFlagBuildExperienceChatImageAttachments then props.onRetryComposerImage else nil
		v39.onRetryImage = v44
		v39.isSendBlocked = props.isComposerSendBlocked

		local v45 = if fFlagBuildExperienceChatResourceAttachments then props.composerResourceAttachments else nil
		v39.resourceAttachments = v45

		local v46 = if fFlagBuildExperienceChatResourceAttachments then props.onRemoveComposerResourceAttachment else nil
		v39.onRemoveResourceAttachment = v46

		v39.placeholder = v16.composerPlaceholder
		v39.textBoxRef = props.textBoxRef
		v39.isAssistantResponding = props.isAssistantResponding
		v39.canStopAssistantResponse = props.canStopAssistantResponse
		v39.canSendWhileResponding = props.canSendWhileResponding
		v39.isReadOnly = props.isChatReadOnly
		v39.onSend = props.onSend
		v39.onStop = props.onStop
		v37 = createElement2(ChatActions, v39)
	end

	local element = createElement(view, v33, {
		BuyMoreRobux = v35,
		AdUpsells = v36,
		Footer = v37
	})

	local createElement2 = React.createElement
	local v39 = {
		onAbsolutePositionChanged = props.onPageMetricsChanged,
		onAbsoluteSizeChanged = props.onPageMetricsChanged,
		tag = "col align-x-center size-full bg-surface-0",
		padding = {
			bottom = UDim.new(0, props.paddingBottom)
		}
	}

	local createElement3 = React.createElement

	local createElement4 = React.createElement

	local v44 = if fFlagBuildExperienceLibrary then React.createElement(iconButton, {
		LayoutOrder = 5,
		icon = iconName.SquaresGridPlus,
		isCircular = true,
		isDisabled = props.isLibraryDisabled,
		onActivated = props.onOpenLibrary,
		size = inputSize.Large,
		testId = "BuildChatPage.LibraryButton",
		variant = buttonVariant.Utility
	}) else nil
	local children3 = {
		Library = v44,
		Back = React.createElement(iconButton, {
			LayoutOrder = 1,
			icon = iconName.ChevronLargeLeft,
			isCircular = true,
			onActivated = props.onClose,
			size = inputSize.Large,
			testId = "BuildChatPage.BackButton"
		}),
		Title = 0,
		Play = 0,
		AgentSpec = 0,
		Overflow = 0
	}

	local createElement5 = React.createElement

	local v47 = if props.isNewGameTarget then chatConstants.BUILD_CHAT_PAGE_TITLE else props.target.experienceName
	children3.Title = createElement5(text, {
		LayoutOrder = 2,
		Text = v47,
		tag = "fill text-heading-small text-align-x-left text-truncate-split content-emphasis"
	})

	children3.Play = React.createElement(PlayButton, {
		LayoutOrder = 3,
		activeIcon = iconName.PlaySmall,
		inActiveIcon = iconName.PlaySmall,
		isActive = true,
		isDisabled = props.isNewGameTarget and not props.hasPublishedTurn,
		isUnavailable = props.isPlaytestDisabled,
		onActivated = props.onPlayActivated,
		variant = buttonVariant.Utility
	})
	local v48

	if enabled and (not FFlagBuildExperienceModelPicker or props.modelPicker == nil) then
		local createElement6 = React.createElement

		local v51 = { name = iconName.LabBeaker, variant = 0 }
		local v52 = if props.agentSpecVersion == nil then iconVariant.Regular else iconVariant.Filled
		v51.variant = v52
		v48 = createElement6(iconButton, {
			LayoutOrder = 5,
			icon = v51,
			isCircular = true,
			onActivated = function()
				setState(true)
			end,
			size = inputSize.Large,
			testId = "BuildChatPage.AgentSpecButton",
			variant = buttonVariant.Utility
		})
	end

	children3.AgentSpec = v48

	local createElement6 = React.createElement
	local v50 = {
		layoutOrder = 6,
		icon = iconName.ThreeDotsHorizontal,
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
	local v51 = if FFlagEnableBuildAdPromotion then props.isUniversePublic else nil
	v50.isUniversePublic = v51
	children3.Overflow = createElement6(BuildOverflowMenuButton, v50)
	local children = {
		Header = createElement3(
			view,
			{
				LayoutOrder = 1,
				tag = "col align-x-center size-full-0 auto-y bg-surface-0"
			},
			{
				HeaderBar = createElement4(
					view,
					{
						LayoutOrder = 1,
						tag = "composition-content-header row align-y-center gap-small size-full-0 auto-y padding-y-medium",
						testId = "BuildChatPage.HeaderBar"
					},
					children3
				),
				Divider = React.createElement(divider, {
					LayoutOrder = 3,
					Visible = props.isChatScrollable,
					testId = "BuildChatPage.HeaderDivider"
				})
			}
		),
		Messages = React.createElement(scrollView, {
			LayoutOrder = 2,
			scrollingFrameRef = v18,
			onAbsoluteCanvasSizeChanged = props.onChatViewportChanged,
			onAbsoluteWindowSizeChanged = props.onChatViewportChanged,
			tag = { ["composition-layout-detail"] = true, ["fill size-full-0"] = true },
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, {
			MessageColumn = React.createElement(view, {
				layout = {
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, v17.Size.Size_800)
				},
				tag = {
					["composition-content-body"] = true,
					["size-full"] = props.isChatEmpty and not v10,
					["size-full-0 auto-y padding-y-large"] = not props.isChatEmpty or v10
				},
				testId = "BuildChatPage.MessageBody"
			}, v31)
		}),
		AgentSpecSheet = 0,
		Actions = 0,
		AdCampaignSheet = 0,
		AgentAdCampaignSheet = 0,
		AdCampaignCreatedToast = 0
	}
	local v52

	if enabled and state then
		v52 = React.createElement(v5, {
			specVersion = props.agentSpecVersion,
			onSave = props.setAgentSpecVersion,
			onClose = function()
				setState(false)
			end
		})
	end

	children.AgentSpecSheet = v52

	children.Actions = React.createElement(view, {
		LayoutOrder = 3,
		tag = { ["composition-layout-detail"] = true, ["size-full-0 auto-y"] = true },
		testId = "BuildChatPage.ActionLayout"
	}, { ActionBody = element })
	local v53

	if FFlagBuildAdUpsell and props.isAdUpsellVisible then
		local createElement7 = React.createElement
		local v56 = if FFlagBuildAdsManagerUniverseUrl then props.target.universeId else nil
		v53 = createElement7(v8, {
			universeId = v56,
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

	children.AdCampaignSheet = v53
	local v54

	if FFlagBuildAgentAdCampaignCard then
		local createElement7 = React.createElement
		local v57 = if FFlagBuildAdsManagerUniverseUrl then props.target.universeId else nil
		v54 = createElement7(v8, {
			universeId = v57,
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

	children.AgentAdCampaignSheet = v54
	local v55

	if FFlagBuildAdUpsell and props.isAdCampaignCreatedToastVisible and props.isAdUpsellVisible then
		local createElement7 = React.createElement
		local v58 = if props.onOpenGetUsersPage ~= nil then v16.adCampaignCreatedView else nil
		v55 = createElement7(v9, {
			actionText = v58,
			onActionActivated = props.onOpenGetUsersPage,
			onClose = props.onAdCampaignCreatedToastDismiss,
			testId = "AdCampaignCreatedToast",
			title = v16.adCampaignCreated
		})
	end

	children.AdCampaignCreatedToast = v55
	return createElement2(view, v39, children)
end

return BuildChatPageView
