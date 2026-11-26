require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/ModelPickerTypes")
local FFlagBuildExperienceModelPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPicker")
local fFlagBuildExperienceLibrary = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceLibrary

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/InputHandlers")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ReactFocusNavigation")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ReactUtils")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local BuildEmptyState = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildEmptyState/BuildEmptyState")
local BuildPillMenuPortal = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/BuildPillMenuPortal")
local BuyMoreRobuxCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/BuyMoreRobuxCard")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/useChatSheetFundingRecovery")
local BuildPillMenuPageHost = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/BuildPillMenuPageHost")
local ChatActions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatActions")
local ChatCardEmphasisProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/ChatCardEmphasisProvider")
local ChatMessageList = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatMessageList")
local ChatPermissionsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/ChatPermissionsContext")
local ChatScrollAnchorContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/ChatScrollAnchorContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local chatConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatConstants")
local FFlagBuildExperienceAnswerForm = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceAnswerForm")

local v5 = if FFlagBuildExperienceAnswerForm then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/AnswerForm/AnswerFormContainer") else nil

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useChatSessionCore")
local FFlagBuildExperienceMonetizationNativeUI = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationNativeUI")
local FFlagBuildExperienceChatCardEmphasis = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatCardEmphasis")
local fFlagBuildExperienceInGameShell = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceInGameShell

local FFlagBuildExperienceChatAccordionScrollAnchor = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatAccordionScrollAnchor")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/useGamePermissions")
local sheet = Foundation.Sheet
local useScrollPerformanceTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/useScrollPerformanceTracker")

local dialogSize = Foundation.Enums.DialogSize
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local view = Foundation.View
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useTokens = Foundation.Hooks.useTokens

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function ChatSheetContent(props)
	local ref = React.useRef(nil)
	local state, setState

	if fFlagBuildExperienceLibrary then
		state, setState = React.useState(nil)
	else
		setState = nil
		state = nil
	end

	useScrollPerformanceTracker("LuaApp_Build_Chat_Scroll", ref)

	local v6 = React.useCallback(function(current)
		ref.current = current

		if setState ~= nil then
			setState(current)
		end

		props.setScrollingFrame(current)
	end, { props.setScrollingFrame, setState })

	if fFlagBuildExperienceLibrary then
		React.useEffect(function()
			if props.onFramesChanged ~= nil then
				props.onFramesChanged(props.sheet, state)
			end
		end, { props.onFramesChanged, props.sheet, state })
	end

	return React.createElement(
		props.sheetComponent.Content,
		{ isReversed = true, scrollingFrameRef = v6 },
		props.children
	)
end

local function ChatSheetView(props)
	local v6 = FFlagBuildExperienceAnswerForm and props.answerForm ~= nil
	local sheetComponent = props.sheetComponent or sheet
	local v7 = useLocalization({
		composerPlaceholder = LocalizationStrings.CHAT_COMPOSER_PLACEHOLDER
	})

	local v8 = useTokens()
	local state, setState = React.useState(nil)

	if FFlagBuildExperienceMonetizationNativeUI then
		local onClose = props.onClose

		local v9 = React.useMemo(function()
			return {
				[focusNavigationEventNameEnum.NavigateBack] = {
					handler = InputHandlers.onRelease(function(object)
						onClose()
						object:cancel()
					end)
				}
			}
		end, { onClose })

		local v10 = useFocusRoot({
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
			eventMap = navigateBacks,
			eventHandlers = v9,
			isAutoFocusRoot = true,
			isFocusable = props.isOpen
		})

		setState = ReactUtils.useComposedRef(setState, v10)
	end

	local v10 = {
		messages = props.messages,
		clockBinding = props.clockBinding,
		localToolActions = props.localToolActions,
		emptyState = 0,
		isHistoryLoading = 0,
		onPlaytest = 0,
		isPlaytestLoading = 0
	}
	local v11 = if not v6 then React.createElement(BuildEmptyState) else nil
	v10.emptyState = v11
	v10.isHistoryLoading = props.isHistoryLoading
	v10.onPlaytest = props.onPlaytest
	v10.isPlaytestLoading = props.isPlaytestLoading
	local v12 = ChatMessageList(v10)

	local creatorCreditRecovery = if FFlagBuildExperienceModelPicker then props.creatorCreditRecovery else nil
	local v13

	if not (creatorCreditRecovery == nil or not creatorCreditRecovery.card.showBuyMoreRobuxCard) then
		local card = creatorCreditRecovery.card
		v13 = React.createElement(BuyMoreRobuxCard, {
			LayoutOrder = 1,
			title = card.buyMoreRobuxCardTitle,
			description = card.buyMoreRobuxCardDescription,
			primaryActionText = card.buyMoreRobuxCardPrimaryActionText,
			onPrimaryAction = card.onBuyMoreRobuxCardPrimaryAction,
			secondaryActionText = card.buyMoreRobuxCardSecondaryActionText,
			onSecondaryAction = card.onBuyMoreRobuxCardSecondaryAction
		})
	end

	if v6 then
		v12.AnswerForm = React.createElement(v5, {
			LayoutOrder = (#props.messages + 2) * chatConstants.MESSAGE_LAYOUT_ORDER_STRIDE,
			state = props.answerForm,
			actions = props.localToolActions,
			onSubmitText = props.onSubmitAnswerText,
			onStop = props.onStop,
			errorText = props.composerErrorText,
			isReadOnly = props.isChatReadOnly
		})
	end

	local v14 = FFlagBuildExperienceChatAccordionScrollAnchor and {
		ScrollAnchor = React.createElement(
			ChatScrollAnchorContext.Provider,
			{ value = props.anchorScrollToInstance },
			v12
		)
	} or v12

	local v15 = FFlagBuildCheckGamePermissions and {
		Permissions = React.createElement(ChatPermissionsContext.Provider, {
			value = props.chatPermissions
		}, v14)
	} or v14

	local element = React.createElement(view, {
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, v8.Size.Size_800)
		},
		padding = fFlagBuildExperienceLibrary and props.reservesHandleSpace == true and {
			top = UDim.new(0, v8.Size.Size_600)
		} or nil,
		tag = {
			["size-full"] = #props.messages == 0 and not v6,
			["size-full-0 auto-y"] = #props.messages > 0 or v6
		},
		testId = "ChatSheet.MessageList"
	}, v15)

	local createElement2 = React.createElement
	local v21 = {
		LayoutOrder = v13 ~= nil and 2 or nil,
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

	local v22 = if FFlagBuildExperienceModelPicker then props.modelPicker else nil
	v21.modelPicker = v22
	v21.composerText = props.composerText
	v21.composerErrorText = props.composerErrorText
	v21.onComposerChanged = props.onComposerChanged
	v21.images = props.composerImages
	v21.onImagesChanged = props.onComposerImagesChanged
	v21.onRetryImage = props.onRetryComposerImage
	v21.isSendBlocked = props.isComposerSendBlocked
	v21.tracksExternalText = props.tracksExternalComposerText
	v21.resourceAttachments = props.composerResourceAttachments
	v21.onRemoveResourceAttachment = props.onRemoveComposerResourceAttachment
	v21.onActivateResourceAttachment = props.onActivateComposerResourceAttachment
	v21.placeholder = v7.composerPlaceholder
	v21.textBoxRef = props.textBoxRef
	v21.isAssistantResponding = props.isAssistantResponding
	v21.canStopAssistantResponse = props.canStopAssistantResponse
	v21.canSendWhileResponding = props.canSendWhileResponding
	v21.allowsTypingWhileResponding = props.allowsComposerTypingWhileResponding
	v21.isReadOnly = props.isChatReadOnly
	v21.onSend = props.onSend
	v21.onStop = props.onStop
	local v23 = createElement2(ChatActions, v21)

	local createElement3 = React.createElement
	local root = sheetComponent.Root
	local v24 = {
		ref = setState,
		isOpen = props.isOpen,
		snapPoints = props.snapPoints,
		defaultSnapPointIndex = props.defaultSnapPointIndex,
		onSnapPointChanged = props.onSnapPointChanged,
		size = dialogSize.Large,
		onClose = props.onClose
	}
	local v25 = {
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
	local v26

	if not v6 then
		local createElement4 = React.createElement
		local actions = sheetComponent.Actions

		if v13 ~= nil then
			v23 = React.createElement(view, {
				tag = "col gap-medium size-full-0 auto-y"
			}, {
				FundingRecovery = v13,
				Composer = v23
			})
		end

		v26 = createElement4(actions, nil, { Footer = v23 })
	end

	v25.Actions = v26

	local v27 = if creatorCreditRecovery ~= nil and creatorCreditRecovery.page ~= nil then React.createElement(BuildPillMenuPageHost, creatorCreditRecovery.page) else nil
	v25.CreatorCreditPage = v27

	local v28 = if not fFlagBuildExperienceInGameShell and props.topBarPillMenuTarget ~= nil then React.createElement(BuildPillMenuPortal, {
		sheet = state,
		target = props.topBarPillMenuTarget,
		onOpenChat = props.onOpenChat,
		testId = "build-pill-menu"
	}) else nil
	v25.TopBarPillMenu = v28
	local element2 = createElement3(root, v24, v25)

	if FFlagBuildExperienceChatCardEmphasis then
		return React.createElement(ChatCardEmphasisProvider, nil, element2)
	end

	return element2
end

return ChatSheetView
