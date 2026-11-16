local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(BuildExperience.Components.ModelPicker.ModelPickerTypes)
local FFlagBuildExperienceModelPicker = require(BuildExperience.Flags.FFlagBuildExperienceModelPicker)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary

local Foundation = require(parent.Foundation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local React = require(parent.React)
require(parent.ReactFocusNavigation)
local ReactUtils = require(parent.ReactUtils)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local BuildEmptyState = require(BuildExperience.Components.BuildEmptyState.BuildEmptyState)
local BuildPillMenuPortal = require(BuildExperience.Components.BuildPillMenu.BuildPillMenuPortal)
local BuyMoreRobuxCard = require(BuildExperience.Components.Chat.BuyMoreRobuxCard)
require(script.Parent.useChatSheetFundingRecovery)
local BuildPillMenuPageHost = require(BuildExperience.Components.BuildPillMenu.BuildPillMenuPageHost)
local ChatActions = require(BuildExperience.Components.Chat.ChatActions)
local ChatCardEmphasisProvider = require(BuildExperience.Components.Chat.ChatCardEmphasis.ChatCardEmphasisProvider)
local ChatMessageList = require(BuildExperience.Components.Chat.ChatMessageList)
local ChatPermissionsContext = require(BuildExperience.Chat.ChatPermissionsContext)
local ChatScrollAnchorContext = require(BuildExperience.Chat.ChatScrollAnchorContext)
require(BuildExperience.Chat.chatTypes)
local chatConstants = require(BuildExperience.Chat.chatConstants)
local FFlagBuildExperienceAnswerForm = require(BuildExperience.Flags.FFlagBuildExperienceAnswerForm)
local AnswerFormContainer

if FFlagBuildExperienceAnswerForm then
	AnswerFormContainer = require(BuildExperience.Components.AnswerForm.AnswerFormContainer)
else
	AnswerFormContainer = nil
end

require(BuildExperience.Chat.useChatSessionCore)
local FFlagBuildExperienceMonetizationNativeUI = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationNativeUI)
local FFlagBuildExperienceChatCardEmphasis = require(BuildExperience.Flags.FFlagBuildExperienceChatCardEmphasis)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagBuildExperienceInGameShell = SharedFlags2.FFlagBuildExperienceInGameShell

local FFlagBuildExperienceChatAccordionScrollAnchor = require(BuildExperience.Flags.FFlagBuildExperienceChatAccordionScrollAnchor)

local FFlagBuildExperienceChatSheetReversedContent = require(BuildExperience.Flags.FFlagBuildExperienceChatSheetReversedContent)
local FFlagBuildExperienceChatImageAttachments = require(BuildExperience.Flags.FFlagBuildExperienceChatImageAttachments)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)
require(BuildExperience.useGamePermissions)

local SharedFlags3 = require(parent.SharedFlags)
local FFlagBuildExperienceChatResourceAttachments = SharedFlags3.FFlagBuildExperienceChatResourceAttachments
local Sheet = Foundation.Sheet
local useScrollPerformanceTracker = require(BuildExperience.Telemetry.useScrollPerformanceTracker)

local DialogSize = Foundation.Enums.DialogSize
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local View = Foundation.View
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useTokens = Foundation.Hooks.useTokens

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function ChatSheetContent(props)
	local ref = React.useRef(nil)
	local state, setState

	if FFlagBuildExperienceLibrary then
		state, setState = React.useState(nil)
	else
		setState = nil
		state = nil
	end

	useScrollPerformanceTracker("LuaApp_Build_Chat_Scroll", ref)

	local scrollingFrameRef = React.useCallback(function(current)
		ref.current = current

		if setState ~= nil then
			setState(current)
		end

		props.setScrollingFrame(current)
	end, { props.setScrollingFrame, setState })

	if FFlagBuildExperienceLibrary then
		React.useEffect(function()
			if props.onFramesChanged ~= nil then
				props.onFramesChanged(props.sheet, state)
			end
		end, { props.onFramesChanged, props.sheet, state })
	end

	return React.createElement(props.sheetComponent.Content, {
		isReversed = FFlagBuildExperienceChatSheetReversedContent and true or nil,
		scrollingFrameRef = scrollingFrameRef
	}, props.children)
end

local function ChatSheetView(props)
	local v = FFlagBuildExperienceAnswerForm and props.answerForm ~= nil
	local sheetComponent = props.sheetComponent or Sheet
	local v2 = useLocalization({
		composerPlaceholder = LocalizationStrings.CHAT_COMPOSER_PLACEHOLDER
	})

	local v3 = useTokens()
	local state, setState = React.useState(nil)

	if FFlagBuildExperienceMonetizationNativeUI then
		local onClose = props.onClose

		local eventHandlers = React.useMemo(function()
			return {
				[FocusNavigationEventNameEnum.NavigateBack] = {
					handler = InputHandlers.onRelease(function(object)
						onClose()
						object:cancel()
					end)
				}
			}
		end, { onClose })

		local v4 = useFocusRoot({
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
			eventMap = navigateBacks,
			eventHandlers = eventHandlers,
			isAutoFocusRoot = true,
			isFocusable = props.isOpen
		})

		setState = ReactUtils.useComposedRef(setState, v4)
	end

	local v4 = {
		messages = props.messages,
		clockBinding = props.clockBinding,
		localToolActions = props.localToolActions,
		emptyState = 0,
		isHistoryLoading = 0,
		onPlaytest = 0,
		isPlaytestLoading = 0
	}
	local emptyState

	if not v then
		emptyState = React.createElement(BuildEmptyState)
	end

	v4.emptyState = emptyState
	v4.isHistoryLoading = props.isHistoryLoading
	v4.onPlaytest = props.onPlaytest
	v4.isPlaytestLoading = props.isPlaytestLoading
	local chatMessageList = ChatMessageList(v4)
	local creatorCreditRecovery

	if FFlagBuildExperienceModelPicker then
		creatorCreditRecovery = props.creatorCreditRecovery
	end

	local fundingRecovery

	if not (creatorCreditRecovery == nil or not creatorCreditRecovery.card.showBuyMoreRobuxCard) then
		local card = creatorCreditRecovery.card
		fundingRecovery = React.createElement(BuyMoreRobuxCard, {
			LayoutOrder = 1,
			title = card.buyMoreRobuxCardTitle,
			description = card.buyMoreRobuxCardDescription,
			primaryActionText = card.buyMoreRobuxCardPrimaryActionText,
			onPrimaryAction = card.onBuyMoreRobuxCardPrimaryAction,
			secondaryActionText = card.buyMoreRobuxCardSecondaryActionText,
			onSecondaryAction = card.onBuyMoreRobuxCardSecondaryAction
		})
	end

	if v then
		chatMessageList.AnswerForm = React.createElement(AnswerFormContainer, {
			LayoutOrder = (#props.messages + 2) * chatConstants.MESSAGE_LAYOUT_ORDER_STRIDE,
			state = props.answerForm,
			actions = props.localToolActions,
			onSubmitText = props.onSubmitAnswerText,
			onStop = props.onStop,
			errorText = props.composerErrorText,
			isReadOnly = props.isChatReadOnly
		})
	end

	local v5 = FFlagBuildExperienceChatAccordionScrollAnchor and {
		ScrollAnchor = React.createElement(
			ChatScrollAnchorContext.Provider,
			{ value = props.anchorScrollToInstance },
			chatMessageList
		)
	} or chatMessageList

	local v6 = FFlagBuildCheckGamePermissions and {
		Permissions = React.createElement(ChatPermissionsContext.Provider, {
			value = props.chatPermissions
		}, v5)
	} or v5

	local element = React.createElement(View, {
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, v3.Size.Size_800)
		},
		padding = FFlagBuildExperienceLibrary and props.reservesHandleSpace == true and {
			top = UDim.new(0, v3.Size.Size_600)
		} or nil,
		tag = {
			["size-full"] = #props.messages == 0 and not v,
			["size-full-0 auto-y"] = #props.messages > 0 or v
		},
		testId = "ChatSheet.MessageList"
	}, v6)

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = fundingRecovery ~= nil and 2 or nil,
		modelPicker = 0,
		composerText = 0,
		composerErrorText = 0,
		onComposerChanged = 0,
		images = 0,
		onImagesChanged = 0,
		onRetryImage = 0,
		isSendBlocked = 0,
		tracksExternalText = 0,
		resourceAttachments = 0,
		onRemoveResourceAttachment = 0,
		onActivateResourceAttachment = 0,
		placeholder = 0,
		textBoxRef = 0,
		isAssistantResponding = 0,
		canStopAssistantResponse = 0,
		canSendWhileResponding = 0,
		allowsTypingWhileResponding = 0,
		isReadOnly = 0,
		onSend = 0,
		onStop = 0
	}
	local modelPicker

	if FFlagBuildExperienceModelPicker then
		modelPicker = props.modelPicker
	end

	v7.modelPicker = modelPicker
	v7.composerText = props.composerText
	v7.composerErrorText = props.composerErrorText
	v7.onComposerChanged = props.onComposerChanged
	local images

	if FFlagBuildExperienceChatImageAttachments then
		images = props.composerImages
	end

	v7.images = images
	local onImagesChanged

	if FFlagBuildExperienceChatImageAttachments then
		onImagesChanged = props.onComposerImagesChanged
	end

	v7.onImagesChanged = onImagesChanged
	local onRetryImage

	if FFlagBuildExperienceChatImageAttachments then
		onRetryImage = props.onRetryComposerImage
	end

	v7.onRetryImage = onRetryImage
	v7.isSendBlocked = props.isComposerSendBlocked
	v7.tracksExternalText = props.tracksExternalComposerText
	local resourceAttachments

	if FFlagBuildExperienceChatResourceAttachments then
		resourceAttachments = props.composerResourceAttachments
	end

	v7.resourceAttachments = resourceAttachments
	local onRemoveResourceAttachment

	if FFlagBuildExperienceChatResourceAttachments then
		onRemoveResourceAttachment = props.onRemoveComposerResourceAttachment
	end

	v7.onRemoveResourceAttachment = onRemoveResourceAttachment

	v7.onActivateResourceAttachment = props.onActivateComposerResourceAttachment
	v7.placeholder = v2.composerPlaceholder
	v7.textBoxRef = props.textBoxRef
	v7.isAssistantResponding = props.isAssistantResponding
	v7.canStopAssistantResponse = props.canStopAssistantResponse
	v7.canSendWhileResponding = props.canSendWhileResponding
	v7.allowsTypingWhileResponding = props.allowsComposerTypingWhileResponding
	v7.isReadOnly = props.isChatReadOnly
	v7.onSend = props.onSend
	v7.onStop = props.onStop
	local v8 = createElement(ChatActions, v7)

	local createElement2 = React.createElement
	local root = sheetComponent.Root
	local v9 = {
		ref = setState,
		isOpen = props.isOpen,
		snapPoints = props.snapPoints,
		defaultSnapPointIndex = props.defaultSnapPointIndex,
		onSnapPointChanged = props.onSnapPointChanged,
		size = DialogSize.Large,
		onClose = props.onClose
	}
	local v10 = {
		Content = React.createElement(
			ChatSheetContent,
			{
				setScrollingFrame = props.scrollingFrameRef,
				sheetComponent = sheetComponent,
				sheet = state,
				onFramesChanged = props.onFramesChanged
			},
			{ MessageList = element }
		),
		Actions = 0,
		CreatorCreditPage = 0,
		TopBarPillMenu = 0
	}
	local actions2

	if not v then
		local createElement3 = React.createElement
		local actions = sheetComponent.Actions

		if fundingRecovery ~= nil then
			v8 = React.createElement(View, { tag = "col gap-medium size-full-0 auto-y" }, {
				FundingRecovery = fundingRecovery,
				Composer = v8
			})
		end

		actions2 = createElement3(actions, nil, { Footer = v8 })
	end

	v10.Actions = actions2
	local creatorCreditPage

	if not (creatorCreditRecovery == nil or creatorCreditRecovery.page == nil) then
		creatorCreditPage = React.createElement(BuildPillMenuPageHost, creatorCreditRecovery.page)
	end

	v10.CreatorCreditPage = creatorCreditPage
	local topBarPillMenu

	if not (FFlagBuildExperienceInGameShell or props.topBarPillMenuTarget == nil) then
		topBarPillMenu = React.createElement(BuildPillMenuPortal, {
			sheet = state,
			target = props.topBarPillMenuTarget,
			onOpenChat = props.onOpenChat,
			testId = "build-pill-menu"
		})
	end

	v10.TopBarPillMenu = topBarPillMenu
	local element2 = createElement2(root, v9, v10)

	if FFlagBuildExperienceChatCardEmphasis then
		return React.createElement(ChatCardEmphasisProvider, nil, element2)
	end

	return element2
end

return ChatSheetView
