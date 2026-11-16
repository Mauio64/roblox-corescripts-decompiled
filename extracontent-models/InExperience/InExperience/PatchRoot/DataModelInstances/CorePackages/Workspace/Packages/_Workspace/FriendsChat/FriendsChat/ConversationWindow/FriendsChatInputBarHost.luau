local UserInputService = game:GetService("UserInputService")

local FriendsChat = script:FindFirstAncestor("FriendsChat")
local parent = FriendsChat.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local InputType = require(parent.InputType)
local InputTypeConstants = InputType.InputTypeConstants

local ChatInputBoxDisabled = require(parent.AppChat.ChatInputBoxDisabled)
require(parent.AppChat.ConversationChannels)
local MessageCharacterLimit = require(parent.AppChat.MessageCharacterLimit)
local ChatConversationTelemetryLayer = require(parent.AppChat.ChatConversationTelemetryLayer)
local useChatTimeoutDetailsFromHydration = require(parent.AppChat.useChatTimeoutDetailsFromHydration)
local useTelemetry = require(parent.AppChat.useTelemetry)
local InterventionShared = require(parent.InterventionShared)
local chatInputBoxDisabledPressedSignal = InterventionShared.Signals.chatInputBoxDisabledPressedSignal
local interventionTreatmentShownSignal = InterventionShared.Signals.interventionTreatmentShownSignal
local Constants = InterventionShared.Utils.Constants

local FFlagFriendsChatEnforceInputCharacterLimit = require(FriendsChat.Flags.FFlagFriendsChatEnforceInputCharacterLimit)
local FFlagFriendsChatMessageComposer = require(FriendsChat.Flags.FFlagFriendsChatMessageComposer)
local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatReactiveFeatureRestrictions = SharedFlags.FFlagAppChatReactiveFeatureRestrictions
local SharedFlags2 = require(parent.SharedFlags)
local FFlagExpChatComposerFigmaParity = SharedFlags2.FFlagExpChatComposerFigmaParity
local SharedFlags3 = require(parent.SharedFlags)
local FFlagAppChatUniversalFeatureRestriction = SharedFlags3.FFlagAppChatUniversalFeatureRestriction
local SharedFlags4 = require(parent.SharedFlags)
local FFlagExpChatTabShortcutNav = SharedFlags4.FFlagExpChatTabShortcutNav

local ExpChatConversationListAdapter = require(script.Parent.Parent.ConversationList.ExpChatConversationListAdapter)
local GetFriendsChatNavigationStore = require(FriendsChat.Stores.GetFriendsChatNavigationStore)
local useConsumeFocusInputBarRequest = require(script.Parent.useConsumeFocusInputBarRequest)
local useFocusConversationInput = require(script.Parent.useFocusConversationInput)
local useFocusBackButtonOnUp = require(script.Parent.useFocusBackButtonOnUp)
local SharedFlags5 = require(parent.SharedFlags)
local FFlagFriendsChatConversationListFocusNav = SharedFlags5.FFlagFriendsChatConversationListFocusNav
local getConversationInputPlaceholder = require(script.Parent.getConversationInputPlaceholder)
local resolveFade = require(script.Parent.Parent.Utils.resolveFade)
local useInExperienceLocalization = ChatUIPrimitives.Hooks.useInExperienceLocalization
local LayoutConstants = require(FriendsChat.LayoutConstants)
local sendFriendsChatMessage = require(script.Parent.sendFriendsChatMessage)
local useFriendsChatComposerViewModel = require(script.Parent.useFriendsChatComposerViewModel)

local ChatInputBarView = ChatUIPrimitives.ChatInputBarView
local MessageComposer = require(parent.ChatUIPrimitives.MessageComposer)
local useChatInputBarSettings = require(parent.ExpChatIntegration.useChatInputBarSettings)
local useChatInputBarOnFocus = require(parent.ExpChatIntegration.useChatInputBarOnFocus)
local useChatWindowSettings = require(parent.ExpChatIntegration.useChatWindowSettings)
local useInterpolatedClientSettings = require(parent.ExpChatIntegration.useInterpolatedClientSettings)

local autocomplete = { commands = nil, emojis = true }

local function FriendsChatInputBarHost(props)
	local v = Foundation.Hooks.useTokens()
	local conversationId = props.conversationId
	local friendPlaceholder = ExpChatConversationListAdapter.isFriendPlaceholder(conversationId)
	local hasRealConversation

	if conversationId == nil or conversationId == "" then
		hasRealConversation = false
	else
		hasRealConversation = not friendPlaceholder
	end

	local conversationId2

	if hasRealConversation then
		conversationId2 = conversationId
	end

	local v2 = useChatTimeoutDetailsFromHydration({
		conversationId = conversationId2,
		conversationModerationType = props.conversationModerationType
	})

	local v3 = SignalsReact.useSignalState(v2)
	local isTimedOut = v3.isTimedOut

	local v4 = useChatWindowSettings()

	local v5 = React.useMemo(function()
		return {
			BackgroundColor3 = v4.ChatWindowBackgroundColor3,
			BackgroundTransparency = v4.ChatWindowBackgroundTransparency
		}
	end, { v4 })

	local canLocalUserChat = not isTimedOut

	local v6 = useChatInputBarSettings()

	local textSize = React.useMemo(function()
		if props.isSpatialUIEnabled and v6 and v6.SpatialPanelTextSize then
			return v6.SpatialPanelTextSize
		end

		return if v6 then v6.TextSize else nil
	end, { v6, props.isSpatialUIEnabled })

	local v7 = useInExperienceLocalization()

	local v8 = ChatUIPrimitives.Hooks.useLastInputGroup()
	local isTouch = v8 == InputTypeConstants.Touch
	local isGamepad = v8 == InputTypeConstants.Gamepad
	local v9

	if v6 and v6.KeyboardKeyCode then
		v9 = v6.KeyboardKeyCode
	else
		v9 = Enum.KeyCode.Slash
	end

	local placeholderText = React.useMemo(function()
		return getConversationInputPlaceholder({ isGamepad = isGamepad, isTouch = isTouch }, v9, v7, UserInputService)
	end, { isGamepad, isTouch, v9, v7 })

	local disabledChatPlaceholderText = v7("CoreScripts.TextChat.InputBar.Hint.PrivacySettingsDisabled")
	local v10 = useLocalization({ timeoutDisabled = "Feature.Chat.Label.ChatDisabled" })

	local v11 = useTelemetry(ChatConversationTelemetryLayer.Context)
	local ref = React.useRef(v11.emit)
	ref.current = v11.emit

	local v12 = useInterpolatedClientSettings(props.chatWindowSettings or v5)

	local v13 = useChatInputBarOnFocus()
	local friendsChatNavigationStore = GetFriendsChatNavigationStore(false)

	local onFocusGained = React.useCallback(function()
		if not FFlagFriendsChatConversationListFocusNav then
			friendsChatNavigationStore.setInputBarFocused(true)
		end

		v13.onFocusGained()
	end, { v13.onFocusGained, friendsChatNavigationStore })
	local onFocusLost = React.useCallback(function()
		if not FFlagFriendsChatConversationListFocusNav then
			friendsChatNavigationStore.setInputBarFocused(false)
		end

		v13.onFocusLost()
	end, { v13.onFocusLost, friendsChatNavigationStore })
	local ref2

	if FFlagFriendsChatMessageComposer then
		ref2 = React.useRef(nil)
	end

	local v14 = useFocusConversationInput(props.rootRef, canLocalUserChat, ref2)
	local ref3 = v14.ref
	useConsumeFocusInputBarRequest(v14.focus)

	if FFlagExpChatTabShortcutNav then
		ChatUIPrimitives.Hooks.useInputBarTabNavigation(ref3)
	end

	if FFlagFriendsChatConversationListFocusNav then
		useFocusBackButtonOnUp(ref3, props.backButtonRef)
	end

	local selectionImageObject

	if FFlagFriendsChatConversationListFocusNav then
		selectionImageObject = Foundation.Hooks.useCursor(Foundation.Enums.CursorType.RoundedRect)
	end

	local onShown = React.useCallback(function()
		local current = ref3.current

		if current then
			current:ReleaseFocus()
		end
	end, {})

	React.useEffect(function()
		return function()
			onFocusLost()
		end
	end, { onFocusLost })

	React.useEffect(function()
		local connection = interventionTreatmentShownSignal:connect(function(p)
			local current = (p == Constants.TreatmentType.PartyChatNudgeDialog or p == Constants.TreatmentType.PartyChatTimeoutDialog)
				and ref3.current

			if current then
				current:ReleaseFocus()
			end
		end)
		return function()
			connection:disconnect()
		end
	end, {})

	local onSend = React.useCallback(function(value: string)
		if isTimedOut then
			return
		end

		local text = typeof(value) ~= "string" and "" or value

		if text == "" then
			return
		end

		sendFriendsChatMessage({
			text = text,
			conversationId = conversationId,
			isFriendPlaceholder = friendPlaceholder,
			hasRealConversation = hasRealConversation,
			emit = function(p, p2)
				ref.current(p, p2)
			end,
			onFriendPlaceholderConversationCreated = props.onFriendPlaceholderConversationCreated
		})
	end, {
		conversationId,
		hasRealConversation,
		friendPlaceholder,
		isTimedOut,
		props.onFriendPlaceholderConversationCreated
	})

	local onActivated = React.useCallback(function()
		if not FFlagAppChatUniversalFeatureRestriction then
			chatInputBoxDisabledPressedSignal:fire({
				endTimestamp = v3.timeoutEndTimestamp,
				decisionEventId = v3.decisionEventId,
				duration = v3.duration
			})

			return
		end

		local AbuseVector = require(parent.UniversalFeatureRestrictions.AbuseVector)
		local showFeatureRestriction = require(parent.UniversalFeatureRestrictions.showFeatureRestriction)
		local v15 = {
			onShown = onShown,
			onAppeal = function() end
		}

		if FFlagAppChatReactiveFeatureRestrictions then
			local partyChatTimeoutReceivedSignal = InterventionShared.Signals.partyChatTimeoutReceivedSignal
			function v15.onAcknowledgementSuccess()
				partyChatTimeoutReceivedSignal:fire(nil)
			end
		end

		showFeatureRestriction(AbuseVector.PartyChat, v15)
	end, { onShown, v3.timeoutEndTimestamp, v3.decisionEventId, v3.duration })
	local contentSize

	if FFlagFriendsChatMessageComposer then
		contentSize = v.Typography.BodyMedium.FontSize
	else
		contentSize = textSize or v.Typography.CaptionMedium.FontSize
	end

	local v15 = math.max(v.Typography.CaptionMedium.LineHeight, contentSize)
	local v16

	if isTimedOut then
		v16 = React.createElement(Foundation.View, {
			tag = "auto-y",
			Size = UDim2.fromScale(1, 0),
			padding = {
				top = UDim.new(0, contentSize / 2),
				bottom = UDim.new(0, contentSize / 2),
				left = UDim.new(0, v.Padding.Large),
				right = UDim.new(0, v.Padding.XSmall)
			}
		}, {
			TimeoutContent = React.createElement("CanvasGroup", {
				BackgroundTransparency = 1,
				GroupTransparency = props.transparencyValue or 0,
				Size = UDim2.new(1, 0, 0, v15),
				ZIndex = 5
			}, {
				DisabledInput = React.createElement(ChatInputBoxDisabled, {
					bodyText = v10.timeoutDisabled,
					contentSize = contentSize,
					endTimestamp = v3.timeoutEndTimestamp,
					font = Enum.Font.BuilderSans,
					onActivated = onActivated,
					contentVerticalAlignment = Enum.VerticalAlignment.Center,
					navigationTargetRef = ref2
				})
			})
		})
	end

	local inputBar

	if FFlagFriendsChatMessageComposer then
		local v17 = {
			canLocalUserChat = canLocalUserChat,
			timeoutOverlay = v16,
			onSend = onSend,
			onFocusGained = onFocusGained,
			onFocusLost = onFocusLost,
			placeholderText = placeholderText,
			maximumCharacterLimit = nil,
			textBoxRef = nil,
			navigationTargetRef = nil,
			transparency = 0
		}
		local maximumCharacterLimit

		if FFlagFriendsChatEnforceInputCharacterLimit then
			maximumCharacterLimit = MessageCharacterLimit
		end

		v17.maximumCharacterLimit = maximumCharacterLimit
		v17.textBoxRef = ref3
		v17.navigationTargetRef = ref2
		v17.transparency = props.transparencyValue
		local v18 = useFriendsChatComposerViewModel(v17)

		inputBar = React.createElement(MessageComposer, v18)
	end

	local createElement = React.createElement
	local v17 = {
		Name = "friendsChatInput",
		LayoutOrder = props.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = v12.BackgroundColor3 or v4.ChatWindowBackgroundColor3,
		BackgroundTransparency = resolveFade(v12.BackgroundTransparency, props.transparencyValue),
		Active = true,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Size = UDim2.fromScale(1, 0),
		[React.Event.MouseEnter] = props.onHovered,
		[React.Event.MouseLeave] = props.onUnhovered,
		ref = props.rootRef
	}
	local v18 = {
		bottomCorner = React.createElement("UICorner", {
			BottomLeftRadius = UDim.new(0, LayoutConstants.PanelBottomCornerRadius),
			BottomRightRadius = UDim.new(0, LayoutConstants.PanelBottomCornerRadius),
			TopLeftRadius = UDim.new(0, 0),
			TopRightRadius = UDim.new(0, 0)
		}),
		padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, LayoutConstants.InputBarTopPadding),
			PaddingBottom = UDim.new(0, LayoutConstants.InputBarBottomPadding + LayoutConstants.PanelBottomCornerRadius),
			PaddingLeft = UDim.new(0, LayoutConstants.InputBarSidePadding),
			PaddingRight = UDim.new(0, LayoutConstants.InputBarSidePadding)
		}),
		inputBar = 0
	}

	if not FFlagFriendsChatMessageComposer then
		local createElement2 = React.createElement
		local v19 = {
			onSend = onSend,
			canLocalUserChat = canLocalUserChat or false,
			composerLayout = FFlagExpChatComposerFigmaParity,
			disabledOverlay = v16,
			textSize = textSize,
			textBoxRef = ref3,
			selectionImageObject = selectionImageObject,
			placeholderText = placeholderText,
			disabledChatPlaceholderText = disabledChatPlaceholderText,
			showSideChip = false,
			autocomplete = autocomplete,
			transparencyValue = props.transparencyValue,
			onFocusGained = onFocusGained,
			onFocusLost = onFocusLost,
			maximumCharacterLimit = 0
		}
		local maximumCharacterLimit

		if FFlagFriendsChatEnforceInputCharacterLimit then
			maximumCharacterLimit = MessageCharacterLimit
		end

		v19.maximumCharacterLimit = maximumCharacterLimit
		inputBar = createElement2(ChatInputBarView, v19)
	end

	v18.inputBar = inputBar
	return createElement("Frame", v17, v18)
end

return FriendsChatInputBarHost
