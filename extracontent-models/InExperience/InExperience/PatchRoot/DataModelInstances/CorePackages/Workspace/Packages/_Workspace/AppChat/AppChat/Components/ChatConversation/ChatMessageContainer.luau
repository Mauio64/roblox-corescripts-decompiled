local IXPService = game:GetService("IXPService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local setTimeout = LuauPolyfill.setTimeout
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local Options = require(AppChat.Components.ChatConversation.MessageInteraction.Options)
local OptionsEnum = require(AppChat.Components.ChatConversation.MessageInteraction.OptionsEnum)
local ChatMessageContainerConstants = require(script.Parent.ChatMessageContainerConstants)
local EnumScreens = require(AppChat.EnumScreens)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local Skeleton = Foundation.Skeleton
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local Conversation = require(AppChat.Models.Conversation)
local getReplyLabelDescriptor = require(AppChat.Utils.getReplyLabelDescriptor)
require(AppChat.Analytics.EventNames)

local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)

local Logger = require(script.Parent.Logger)
local NoticeText = require(script.Parent.NoticeText)
local SystemMessage = require(script.Parent.SystemMessage)
local UserProfiles = require(parent.UserProfiles)
local DataHydration = require(parent.DataHydration)
local DataStatus = DataHydration.DataStatus
local useProfileNames = require(AppChat.Hooks.useProfileNames)
local getCombinedNameFromProfileNames = require(AppChat.Users.getCombinedNameFromProfileNames)
local FFlagAppChatUseUserProfileHydration = require(AppChat.Flags.FFlagAppChatUseUserProfileHydration)
local ChatConversationTelemetryEvents = require(AppChat.Components.ChatConversation.ChatConversationTelemetryEvents)
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local GlobalLongPressSignal = require(AppChat.Components.ChatConversation.Utils.GlobalLongPressSignal)
local MessageFtuxTooltip = require(script.Parent.MessageFtuxTooltip)
local messageFtuxTooltip = MessageFtuxTooltip.MessageFtuxTooltip
local MessageFtuxTooltipVariant = MessageFtuxTooltip.MessageFtuxTooltipVariant
local MessageFtuxTooltipDismissSignal = MessageFtuxTooltip.MessageFtuxTooltipDismissSignal
local SwipeDirection = require(AppChat.Enums.SwipeDirection)

local getFFlagDebugAppChat = require(AppChat.Flags.getFFlagDebugAppChat)
local GetReplyingToStore = require(AppChat.Stores.GetReplyingToStore)

local useReplyingToMessageDispatch = require(AppChat.Components.ChatConversation.MessageInteraction.ReplyingContext.useReplyingToMessageDispatch)
local FFlagAppChatSignalsReplyStore = require(AppChat.Flags.FFlagAppChatSignalsReplyStore)
local FFlagAppChatMessageModelOnDemand = require(AppChat.Flags.FFlagAppChatMessageModelOnDemand)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local createTelemetryEmitter = require(AppChat.Telemetry.createTelemetryEmitter)
local InteractionFeedback = require(parent.InteractionFeedback)
local useTriggerFeedback = InteractionFeedback.useTriggerFeedback
local HapticFeedback = require(AppChat.Utils.HapticFeedback)
local HapticFeedbackContext = HapticFeedback.HapticFeedbackContext
local HapticFeedback2 = require(AppChat.Utils.HapticFeedback)
local HapticFeedbackType = HapticFeedback2.HapticFeedbackType
local useSwipeGesture = require(AppChat.Hooks.useSwipeGesture)

local UserTile = require(parent.UserTile)
local userTile = UserTile.UserTile
local UserTile2 = require(parent.UserTile)
local LayoutMode = UserTile2.LayoutMode
local Foundation2 = require(parent.Foundation)
local UserPresence = Foundation2.Enums.UserPresence

local FFlagAppChatEnableMessageContextMenu = require(AppChat.Flags.FFlagAppChatEnableMessageContextMenu)
local FFlagAppChatConsoleFocusFixes = require(AppChat.Flags.FFlagAppChatConsoleFocusFixes)
local FFlagAppChatAlignAvatarToMessageGroupBottom = require(AppChat.Flags.FFlagAppChatAlignAvatarToMessageGroupBottom)
local useDescendantSelected = require(script.Parent.Hooks.useDescendantSelected)
local useDescendantSelected2 = useDescendantSelected.useDescendantSelected

local defineFastFlag = game:DefineFastFlag("AppChatEnableRepliesUIIxpEnabled2", false)

local defineFastString = game:DefineFastString("AppChatEnableRepliesUIIxpLayer1", "Party.ConversationPage")
local defineFastInt = game:DefineFastInt("AppChatMessageLongPressDistanceThreshold", 25)
local MessageModel = require(AppChat.Models.MessageModel)
local defineFastFlag2 = game:DefineFastFlag("AppChatUseSymmetricSwipe", false)
local defineFastInt2 = game:DefineFastInt("AppChatReplyIconSwipeOffset", 25)
local SignalsMigrationConfig = require(AppChat.Flags.SignalsMigrationConfig)
local shouldReadMessageListFromSignalsStore = SignalsMigrationConfig.shouldReadMessageListFromSignalsStore
	or FFlagAppChatSignalsReplyStore
local GetConversationMessageViewModelStore

if shouldReadMessageListFromSignalsStore then
	GetConversationMessageViewModelStore = require(AppChat.Stores.GetConversationMessageViewModelStore)
else
	GetConversationMessageViewModelStore = nil
end

local udim = UDim2.new(0, 0, 0.5, 0)
local udim2 = UDim2.new(1, 0, 0.5, 0)
local vector2 = Vector2.new(0, 0.5)
local vector2_2 = Vector2.new(1, 0.5)

local v = {
	failed = false,
	filteredForReceivers = false,
	Font = Enum.Font.Gotham,
	isIncoming = false,
	isNewSender = false,
	parentWidth = 0,
	messageId = "",
	conversationId = "",
	messageType = nil,
	messageTypePaddingOffset = 0,
	moderated = false,
	messageMaxWidth = 0,
	openViewProfile = function()
		Logger:warning("openViewProfile was not passed to ChatMessage")
	end,
	renderMessage = function()
		Logger:warning("renderMessage was not passed to ChatMessage")
	end,
	closeKeyboard = function() end,
	inputBoxRef = nil,
	viewProfileOnAvatarPressed = true,
	messageDefaultNoticeText = "PLACEHOLDER Not everyone in this chat can see your message.",
	messageModeratedNoticeText = "PLACEHOLDER Your message was moderated and not sent.",
	messageHiddenNoticeText = "PLACEHOLDER This message is not available",
	unknownUserKey = "Feature.Chat.Label.UnknownUser",
	isPending = false,
	visibility = nil,
	unitTestTouchEnabled = false
}

local v2 = getFFlagDebugAppChat() and "TextButton" or "Frame"
function ChatMessageContainer(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v3

	if joined.visibility then
		v3 = joined.visibility == MessageModel.VisibilityTypes.Hidden
	else
		v3 = false
	end

	local useCallback = React.useCallback
	local function fn()
		if joined.viewProfileOnAvatarPressed then
			joined.openViewProfile(joined.senderUserId)
		end
	end
	local senderUserId = joined.senderUserId
	local openViewProfile

	if FFlagAppChatConsoleFocusFixes then
		openViewProfile = joined.openViewProfile
	end

	local v4

	if FFlagAppChatConsoleFocusFixes then
		v4 = joined.viewProfileOnAvatarPressed
	end

	local onActivated = useCallback(fn, { senderUserId, openViewProfile, v4 })

	local v5 = useStyle()
	local shouldShowName = joined.shouldShowName
	local v6 = useChatPagePadding()

	local v7 = Foundation.Hooks.useTokens()

	local v8 = React.useMemo(function()
		if not defineFastFlag2 then
			return {
				direction = SwipeDirection.Right,
				iconName = Foundation.Enums.IconName.ArrowThickToRight,
				messagePosition = udim,
				iconOffset = defineFastInt2,
				iconAnchorPoint = vector2
			}
		end

		local direction

		if joined.isIncoming then
			direction = SwipeDirection.Right
		else
			direction = SwipeDirection.Left
		end

		local iconName

		if joined.isIncoming then
			iconName = Foundation.Enums.IconName.ArrowThickToRight
		else
			iconName = Foundation.Enums.IconName.ArrowThickToLeft
		end

		local messagePosition

		if joined.isIncoming then
			messagePosition = udim
		else
			messagePosition = udim2
		end

		local iconOffset

		if joined.isIncoming then
			iconOffset = defineFastInt2
		else
			iconOffset = -defineFastInt2
		end

		local iconAnchorPoint

		if joined.isIncoming then
			iconAnchorPoint = vector2
		else
			iconAnchorPoint = vector2_2
		end

		return {
			direction = direction,
			iconName = iconName,
			messagePosition = messagePosition,
			iconOffset = iconOffset,
			iconAnchorPoint = iconAnchorPoint
		}
	end, { joined.isIncoming })

	local handleEvent = nil
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(Vector2.zero)
	local v9

	if FFlagAppChatMessageModelOnDemand then
		local v10 = React.useContext(ChatConversationTelemetryLayer.Context)
		v9 = React.useMemo(function()
			return createTelemetryEmitter(v10)
		end, { v10 })
	else
		v9 = useTelemetry(ChatConversationTelemetryLayer.Context)
	end

	local v10 = useTriggerFeedback()
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)
	local v11, v12

	if FFlagAppChatConsoleFocusFixes then
		v11, v12 = useDescendantSelected2()
	else
		v11 = nil
		v12 = nil
	end

	local v13

	if FFlagAppChatConsoleFocusFixes then
		local v14 = ReactFocusNavigation.useFocusGuiObject()

		v13 = React.useCallback(function()
			local current = ref2.current

			if current then
				v14(current)
			end
		end, { ref2, v14 })
	else
		v13 = nil
	end

	React.useEffect(function()
		local dismissedConnection = GlobalLongPressSignal.dismissed:connect(function()
			setState3(false)
		end)
		return function()
			dismissedConnection:disconnect()
		end
	end)

	local v14 = React.useMemo(function()
		local v14 = {
			conversationId = joined.conversationId,
			targetMessageSenderId = joined.senderUserId,
			targetMessageId = joined.messageId,
			targetMessageSentAt = 0,
			targetMessageLength = 0,
			targetMessageVisibility = 0
		}
		local targetMessageSentAt

		if joined.sent then
			targetMessageSentAt = joined.sent.dateTime
		end

		v14.targetMessageSentAt = targetMessageSentAt
		v14.targetMessageLength = joined.content and #joined.content or nil
		v14.targetMessageVisibility = joined.visibility
		return v14
	end, {
		joined.conversationId,
		joined.senderUserId,
		joined.messageId,
		joined.sent,
		joined.content,
		joined.visibility
	})
	local v15

	if FFlagAppChatConsoleFocusFixes then
		v15 = React.useMemo(function()
			return not v3 and (state2 or v11)
		end, { state2, v3, v11 })
	else
		v15 = React.useMemo(function()
			return not v3 and state2
		end, { state2, v3 })
	end

	React.useEffect(function()
		if v15 and joined.isLastIncomingChatMessage then
			MessageFtuxTooltipDismissSignal.dismiss(MessageFtuxTooltipVariant.Replies)
		end
	end, { v15, joined.isLastIncomingChatMessage })
	local emitImpressionTelemetryEvent = React.useCallback(function()
		v9.emit(ChatConversationTelemetryEvents.ConversationMessageReplyIconImpression, v14)
	end, { v9, v14 })
	local v16 = useNavigation()
	local v17 = useGetConversationFromId(joined.conversationId)
	local v18

	if FFlagAppChatSignalsReplyStore then
		v18 = GetReplyingToStore(false)
	else
		v18 = nil
	end

	local v19 = nil
	local v20 = nil

	if
		FFlagAppChatMessageModelOnDemand
		and shouldReadMessageListFromSignalsStore
		and GetConversationMessageViewModelStore
	then
		v20 = GetConversationMessageViewModelStore(false).conversationMessageStore.messages[joined.messageId]
	elseif shouldReadMessageListFromSignalsStore and GetConversationMessageViewModelStore then
		local message = GetConversationMessageViewModelStore(false).conversationMessageStore.messages[joined.messageId]

		if message then
			v19 = MessageModel.fromChannelsApi(message, joined.conversationId)
		else
			v19 = nil
		end
	elseif v17 and v17.messages then
		v19 = v17.messages:Get(joined.messageId)
	end

	local v21

	if FFlagAppChatMessageModelOnDemand then
		v21 = React.useCallback(function()
			if v20 then
				return MessageModel.fromChannelsApi(v20, joined.conversationId)
			end

			return v19
		end, { v20, v19, joined.conversationId })
	else
		v21 = nil
	end

	local v22 = useReplyingToMessageDispatch()
	local v23 = useLocalUserId()

	local onSwipeThresholdReached = React.useCallback(function()
		if not v3 then
			v10(HapticFeedbackContext.Default, HapticFeedbackType.Press)
		end
	end, { v3, v10 })

	local useCallback2 = React.useCallback
	local function fn2()
		v9.emit(ChatConversationTelemetryEvents.ConversationMessageSwiped, v14)

		if not v3 then
			if FFlagAppChatSignalsReplyStore and v18 then
				v18.setReplyingTo(joined.messageId)
				return
			end

			local v24

			if FFlagAppChatMessageModelOnDemand then
				v24 = v21()
			else
				v24 = v19
			end

			v22(v24)
		end
	end

	local v24

	if FFlagAppChatSignalsReplyStore then
		v24 = v18
	end

	local messageId

	if FFlagAppChatSignalsReplyStore then
		messageId = joined.messageId
	end

	local v25

	if FFlagAppChatMessageModelOnDemand then
		v25 = v21
	end

	local v26 = useSwipeGesture({
		onSwipeThresholdReached = onSwipeThresholdReached,
		onSwipeComplete = useCallback2(fn2, { v22, v19, v9, v14, v3, v24, messageId, v25 }),
		direction = v8.direction
	})

	local v27 = React.useCallback(function()
		v16.navigate(EnumScreens.MessageContextMenu, {
			messageId = joined.messageId,
			conversationId = joined.conversationId,
			inputBoxRef = joined.inputBoxRef
		})
	end, { v16.navigate, joined.messageId, joined.conversationId, joined.inputBoxRef })

	local v28 = React.useCallback(function(p2, p3, p4: number)
		if p3 then
			ref3.current = Vector2.new(p3.Position.X, p3.Position.Y)
		end

		setTimeout(function()
			local v28

			if p3 then
				local current = ref3.current
				v28 = (Vector2.new(p3.Position.X, p3.Position.Y) - current).Magnitude
			else
				v28 = 0
			end

			if
				p3
				and (p3.UserInputState == Enum.UserInputState.Begin or p3.UserInputState == Enum.UserInputState.Change)
				and v28 < defineFastInt
			then
				handleEvent(p2, p3)
			end
		end, p4)
	end, { handleEvent })

	local useCallback3 = React.useCallback
	local function fn3(p2, p3, p4: string?)
		if joined.isPending then
			return
		end

		if UserInputService.MouseEnabled then
			if p2 == React.Event.MouseEnter then
				setState2(true)
			end

			if p2 == React.Event.MouseLeave then
				setState2(false)
			end

			if p2 == React.Event.MouseButton1Down then
				joined.closeKeyboard()
			end
		end

		if UserInputService.GamepadEnabled or UserInputService.TouchEnabled or joined.unitTestTouchEnabled then
			if p2 == React.Event.TouchLongPress then
				v9.emit(ChatConversationTelemetryEvents.ConversationMessageLongPressed, v14)

				if not v3 then
					setState3(true)

					if FFlagAppChatEnableMessageContextMenu then
						v27()
					end

					v28(React.Event.InputEnded, p3, ChatMessageContainerConstants.PEEK_VIEW_ANIMATION_MILLISEC)
				end
			end

			if p2 == React.Event.InputBegan and p3 then
				v9.emit(ChatConversationTelemetryEvents.ConversationMessagePressed, v14)

				if not (v3 or state3) then
					GlobalLongPressSignal.dismiss()
				end

				v28(React.Event.TouchLongPress, p3, ChatMessageContainerConstants.LONG_PRESS_DELAY_MILLISEC)
			end

			if p2 == React.Event.TouchTap then
				joined.closeKeyboard()
			end
		end

		if p2 == React.Event.Activated then
			GlobalLongPressSignal.dismiss()

			if p4 == OptionsEnum.MessageContextMenu then
				if ChatConversationTelemetryEvents.ConversationMessageOpenMenuIconClicked then
					v9.emit(ChatConversationTelemetryEvents.ConversationMessageOpenMenuIconClicked, v14)
				end

				v27()
			end

			if p4 == OptionsEnum.Reply then
				v9.emit(ChatConversationTelemetryEvents.ConversationMessageReplyIconClicked, v14)

				v10(HapticFeedbackContext.Default, HapticFeedbackType.Press)

				if FFlagAppChatSignalsReplyStore and v18 then
					v18.setReplyingTo(joined.messageId)
					return
				end

				local v29

				if FFlagAppChatMessageModelOnDemand then
					v29 = v21()
				else
					v29 = v19
				end

				v22(v29)
			end
		end
	end

	local isPending = joined.isPending
	local unitTestTouchEnabled = joined.unitTestTouchEnabled
	local mouseEnabled = UserInputService.MouseEnabled
	local touchEnabled = UserInputService.TouchEnabled
	local v29

	if FFlagAppChatSignalsReplyStore then
		v29 = v18
	end

	local v30

	if not FFlagAppChatSignalsReplyStore then
		v30 = v19
	end

	local v31

	if FFlagAppChatSignalsReplyStore then
		v31 = joined.messageId
	end

	local v32 = {
		isPending,
		unitTestTouchEnabled,
		mouseEnabled,
		touchEnabled,
		v28,
		setState2,
		setState3,
		setState,
		v9,
		v27,
		v22,
		v10,
		v3,
		v29,
		v30,
		v31,
		nil,
		nil,
		nil
	}
	local v40

	if FFlagAppChatMessageModelOnDemand and not FFlagAppChatSignalsReplyStore then
		v40 = v21
	end

	local v41

	if FFlagAppChatMessageModelOnDemand then
		v41 = v14
	end

	local v42

	if FFlagAppChatMessageModelOnDemand then
		v42 = joined.closeKeyboard
	end

	v32[17], v32[18], v32[19] = v40, v41, v42
	handleEvent = useCallback3(fn3, v32)

	local v43 = React.useCallback(function(p2, p3)
		if UserInputService.TouchEnabled and v26 then
			v26.onInputBegan(p2, p3)

			MessageFtuxTooltipDismissSignal.dismiss(MessageFtuxTooltipVariant.Replies)
		end

		v28(React.Event.InputBegan, p3, ChatMessageContainerConstants.INPUT_BEGAN_DELAY_MILLISEC)
	end, { v28, v26 })

	local v44 = React.useCallback(function(_)
		handleEvent(React.Event.InputEnded)
	end, { handleEvent })

	local v45 = React.useCallback(function(_)
		handleEvent(React.Event.MouseEnter)
	end, { handleEvent })

	local v46 = React.useCallback(function(_)
		handleEvent(React.Event.MouseLeave)
	end, { handleEvent })

	local v47 = React.useCallback(function(_)
		handleEvent(React.Event.TouchTap)
	end, { handleEvent })

	local v48 = React.useCallback(function(_)
		handleEvent(React.Event.MouseButton1Down)
	end, { handleEvent })

	local senderTargetId = joined.repliesTo and joined.repliesTo.senderTargetId

	local function getDisplayNameText(senderName: string, repliedToName: string)
		local senderIsLocalUser = v23 == joined.senderUserId
		local senderRepliedToSelf = joined.senderUserId == joined.repliesTo.senderTargetId
		local senderRepliedToLocalUser = v23 == joined.repliesTo.senderTargetId

		if not senderTargetId then
			return senderName
		end

		local conversationType = v17 and v17.conversationType

		if
			conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION
			or conversationType == Conversation.Type.MULTI_USER_CONVERSATION
		then
			return getReplyLabelDescriptor({
				senderIsLocalUser = senderIsLocalUser,
				senderRepliedToSelf = senderRepliedToSelf,
				senderRepliedToLocalUser = senderRepliedToLocalUser,
				isGroup = conversationType == Conversation.Type.MULTI_USER_CONVERSATION,
				senderName = senderName,
				repliedToName = repliedToName
			})
		end

		return joined.unknownUserKey
	end

	local senderTargetIds = { joined.senderUserId }

	if senderTargetId then
		table.insert(senderTargetIds, joined.repliesTo.senderTargetId)
	end

	local v49 = nil
	local v50 = nil

	if FFlagAppChatUseUserProfileHydration then
		v50 = useProfileNames(senderTargetIds)
	else
		v49 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = senderTargetIds,
			query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
		})
	end

	local v51, displayName2

	if FFlagAppChatUseUserProfileHydration then
		local combinedNameFromProfileNames = getCombinedNameFromProfileNames(v50, joined.senderUserId)
		local v53

		if senderTargetId then
			v53 = getCombinedNameFromProfileNames(v50, joined.repliesTo.senderTargetId)
		end

		if v50 == nil or v50.status == DataStatus.Ready then
			v51 = false
		else
			v51 = combinedNameFromProfileNames == nil or senderTargetId and v53 == nil
		end

		if not v51 then
			if senderTargetId then
				displayName2 = getDisplayNameText(
					combinedNameFromProfileNames or joined.unknownUserKey,
					v53 or joined.unknownUserKey
				)
			else
				displayName2 = combinedNameFromProfileNames or joined.unknownUserKey
			end
		end
	elseif v49.data then
		v51 = false
		displayName2 = UserProfiles.Selectors.getCombinedNameFromId(v49.data, joined.senderUserId)
			or joined.unknownUserKey

		if senderTargetId then
			displayName2 = getDisplayNameText(
				displayName2,
				UserProfiles.Selectors.getCombinedNameFromId(v49.data, joined.repliesTo.senderTargetId) or joined.unknownUserKey
			)
		end
	else
		v51 = true
	end

	local displayName = useLocalization(senderTargetId and { displayName = displayName2 } or {}).displayName
		or displayName2

	local useCallback4 = React.useCallback
	local function fn4()
		local vector2_3 = Vector2.new(
			math.max(1, joined.messageMaxWidth - ChatMessageContainerConstants.TAIL_WIDTH),
			1e999
		)
		local v53

		if FoundationFontFaceMigration then
			v53 = GetTextSize(
				displayName,
				v5.Font.BaseSize * v5.Font.Footer.RelativeSize,
				v7.Typography.CaptionSmall.Font,
				vector2_3,
				{ addTemporaryPadding = false }
			)
		else
			v53 = TextService:GetTextSize(
				displayName,
				v5.Font.BaseSize * v5.Font.Footer.RelativeSize,
				v5.Font.Footer.Font,
				vector2_3
			)
		end

		return UDim2.new(0, v53.X, 0, v53.Y)
	end

	local v54 = v5.Font.BaseSize * v5.Font.Footer.RelativeSize
	local font = v5.Font.Footer.Font
	local v55 = joined.messageMaxWidth - ChatMessageContainerConstants.TAIL_WIDTH
	local v56

	if FoundationFontFaceMigration then
		v56 = v7.Typography.CaptionSmall.Font
	end

	local v57 = useCallback4(fn4, { v54, font, v55, displayName, v56 })
	local v58

	if joined.showDateTime then
		v58 = 0
	else
		local v59

		if joined.isNewSender or senderTargetId then
			v59 = ChatMessageContainerConstants.CHAT_MESSAGE_MAX_SPACE
		else
			v59 = ChatMessageContainerConstants.CHAT_MESSAGE_MIN_SPACE
		end

		v58 = v59 + joined.messageTypePaddingOffset
	end

	local left = v6.left
	local v59 = left + v7.Size.Size_700
	local left2 = joined.isIncoming and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right

	local state4, setState4 = React.useState(false)
	local v60 = React.useCallback(function()
		if getFFlagDebugAppChat() then
			setState4(function(p2): boolean
				return not p2
			end)
		end
	end, { setState4 })

	local notice = state4 or joined.moderated or joined.filteredForReceivers or v3
	local text

	if state4 then
		text = joined.messageId
	elseif v3 then
		text = joined.messageHiddenNoticeText
	else
		text = joined.moderated and joined.messageModeratedNoticeText or joined.messageDefaultNoticeText
	end

	local icons = React.useMemo(function()
		return React.createElement(Foundation.Icon, {
			name = Foundation.Enums.IconName.TriangleExclamation,
			size = Foundation.Enums.IconSize.Large,
			style = v7.Color.System.Alert,
			LayoutOrder = joined.isIncoming and 0 or 3
		})
	end, { v7, v5, joined.isIncoming })

	if not (joined.failed or joined.moderated) then
		if v15 then
			icons = React.createElement(Options, {
				LayoutOrder = joined.isIncoming and 2 or 1,
				isIncoming = joined.isIncoming,
				handleEvent = handleEvent,
				emitImpressionTelemetryEvent = emitImpressionTelemetryEvent
			})
		else
			icons = nil
		end
	end

	local isIncoming = joined.isIncoming
	local style

	if v26 and v26.swipeProgress then
		style = v26.swipeProgress:map(function(p2: number)
			local transparency = 1 - math.pow(p2, 3)
			return { Color3 = v7.Color.Content.Default.Color3, Transparency = transparency }
		end)
	else
		style = nil
	end

	local position

	if v26 and v26.swipeOffset then
		position = v26.swipeOffset:map(function(p2: number)
			if v8.direction ~= SwipeDirection.Right then
				p2 = -p2
			end

			return UDim2.new(0, p2, 0, 0)
		end)
	else
		position = nil
	end

	local position2

	if v26 and v26.swipeProgress then
		position2 = v26.swipeProgress:map(function(p2: number)
			return v8.messagePosition + UDim2.new(0, p2 * v8.iconOffset, 0, 0)
		end)
	else
		position2 = nil
	end

	local function renderMessage()
		local createElement = React.createElement
		local v68 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			Position = position,
			[React.Event.MouseEnter] = v45,
			[React.Event.MouseLeave] = v46
		}
		local v69 = {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v58),
				PaddingLeft = UDim.new(0, joined.thumbnail and left or v59),
				PaddingRight = UDim.new(0, v6.right - 0)
			}),
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = left2
			}),
			AvatarContainer = 0,
			MessageWithDisplayName = 0
		}
		local avatarContainer

		if joined.thumbnail then
			avatarContainer = React.createElement(Foundation.View, {
				tag = {
					["col auto-x size-0-full"] = true,
					["align-y-top"] = false,
					["align-y-bottom"] = FFlagAppChatAlignAvatarToMessageGroupBottom
				},
				LayoutOrder = 1
			}, {
				Avatar = React.createElement(Foundation.View, { tag = "size-700-700" }, {
					AvatarCircle = React.createElement(userTile, {
						userId = joined.senderUserId,
						layoutMode = LayoutMode.compact,
						userPresenceType = UserPresence.None,
						layoutOrder = 1,
						onActivated = onActivated
					})
				})
			})
		end

		v69.AvatarContainer = avatarContainer

		local createElement2 = React.createElement
		local v72 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, joined.isIncoming and -v59 or 0, 0, 0)
		}
		local v73 = {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = left2
			}),
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, joined.isIncoming and v7.Size.Size_200 or 0)
			}),
			DisplayNameContainer = 0,
			MessageWithIcons = 0
		}

		local displayNameContainer = shouldShowName

		if displayNameContainer then
			local createElement3 = React.createElement
			local v76 = {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(0, joined.messageMaxWidth - ChatMessageContainerConstants.TAIL_WIDTH, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 1
			}

			local createElement4 = React.createElement
			local v79 = {
				PaddingLeft = UDim.new(0, ChatMessageContainerConstants.GROUPED_MESSAGE_DISPLAY_NAME_LEFT_PADDING),
				PaddingRight = 0,
				PaddingBottom = 0
			}
			local paddingRight

			if isIncoming then
				paddingRight = UDim.new(0, 0)
			else
				paddingRight = UDim.new(0, ChatMessageContainerConstants.TAIL_WIDTH)
			end

			v79.PaddingRight = paddingRight
			local paddingBottom

			if senderTargetId then
				paddingBottom = UDim.new(0, ChatMessageContainerConstants.REPLIED_DISPLAY_NAME_BOTTOM_PADDING)
			else
				paddingBottom = UDim.new(0, ChatMessageContainerConstants.GROUPED_MESSAGE_DISPLAY_NAME_BOTTOM_PADDING)
			end

			v79.PaddingBottom = paddingBottom
			local v77 = {
				Padding = createElement4("UIPadding", v79),
				DisplayName = 0,
				ShimmerName = 0
			}
			local displayName3

			if not v51 then
				local createElement5 = React.createElement
				local font2

				if not FoundationFontFaceMigration then
					font2 = v5.Font.Footer.Font
				end

				local fontFace

				if FoundationFontFaceMigration then
					fontFace = normalizeFontFace(v7.Typography.CaptionSmall.Font)
				end

				local v84 = {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Font = font2,
					FontFace = fontFace,
					Size = v57(),
					AnchorPoint = 0,
					Position = 0,
					Text = 0,
					TextColor3 = 0,
					TextSize = 0,
					TextTransparency = 0,
					TextXAlignment = 0,
					TextYAlignment = 0
				}
				local anchorPoint

				if isIncoming then
					anchorPoint = Vector2.new(0, 0)
				else
					anchorPoint = Vector2.new(1, 0)
				end

				v84.AnchorPoint = anchorPoint
				local position3

				if isIncoming then
					position3 = UDim2.fromScale(0, 0)
				else
					position3 = UDim2.fromScale(1, 0)
				end

				v84.Position = position3
				v84.Text = displayName
				v84.TextColor3 = v5.Theme.TextDefault.Color
				v84.TextSize = v5.Font.BaseSize * v5.Font.Footer.RelativeSize
				v84.TextTransparency = v5.Theme.TextDefault.Transparency
				local textXAlignment

				if isIncoming then
					textXAlignment = Enum.TextXAlignment.Left
				else
					textXAlignment = Enum.TextXAlignment.Right
				end

				v84.TextXAlignment = textXAlignment

				v84.TextYAlignment = Enum.TextYAlignment.Top
				displayName3 = createElement5("TextLabel", v84)
			end

			v77.DisplayName = displayName3
			local shimmerName

			if v51 then
				local createElement5 = React.createElement
				local anchorPoint

				if isIncoming then
					anchorPoint = Vector2.new(0, 0)
				else
					anchorPoint = Vector2.new(1, 0)
				end

				local position3

				if isIncoming then
					position3 = UDim2.fromScale(0, 0)
				else
					position3 = UDim2.fromScale(1, 0)
				end

				shimmerName = createElement5(Skeleton, {
					AnchorPoint = anchorPoint,
					Position = position3,
					Size = UDim2.new(
						0,
						ChatMessageContainerConstants.SHIMMER_WIDTH,
						0,
						ChatMessageContainerConstants.SHIMMER_HEIGHT
					),
					LayoutOrder = 2
				})
			end

			v77.ShimmerName = shimmerName
			displayNameContainer = createElement3("Frame", v76, v77)
		end

		v73.DisplayNameContainer = displayNameContainer

		local createElement3 = React.createElement
		local v76 = {}
		v76.BackgroundTransparency = 1
		v76.BorderSizePixel = 0
		v76.LayoutOrder = 2
		v76.AutomaticSize = Enum.AutomaticSize.Y
		local size

		if FFlagAppChatConsoleFocusFixes then
			size = UDim2.new(1, 0, 0, 0)
		else
			size = UDim2.new(1, joined.isIncoming and -v59 or 0, 0, 0)
		end

		v76.Size = size
		local selectable

		if FFlagAppChatConsoleFocusFixes then
			selectable = not v3
		end

		v76.Selectable = selectable
		local ref4

		if FFlagAppChatConsoleFocusFixes then
			ref4 = v12
		end

		v76.ref = ref4
		local selectionGained = React.Event.SelectionGained
		local v80

		if FFlagAppChatConsoleFocusFixes then
			v80 = v13
		end

		v76[selectionGained] = v80
		local v81 = {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = left2,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 10),
				ItemLineAlignment = Enum.ItemLineAlignment.Center
			}),
			Message = 0,
			MessageFtuxTooltip = 0
		}

		local renderMessage2 = joined.renderMessage
		local v82 = {
			LayoutOrder = joined.isIncoming and 1 or 2,
			[React.Event.InputBegan] = v43,
			[React.Event.InputEnded] = v44,
			[React.Event.TouchTap] = v47,
			[React.Event.MouseButton1Down] = v48
		}
		local v83 = { isPressed = state, Icons = icons, bubbleRef = nil, ref = nil }
		local bubbleRef

		if FFlagAppChatConsoleFocusFixes then
			bubbleRef = ref2
		end

		v83.bubbleRef = bubbleRef
		v83.ref = ref
		v81.Message = renderMessage2(v82, v83)
		local messageFtuxTooltip2

		if joined.isLastIncomingChatMessage and not v3 then
			messageFtuxTooltip2 = React.createElement(messageFtuxTooltip, {
				variant = MessageFtuxTooltipVariant.Replies,
				messageRef = ref,
				isReversed = joined.isIncoming
			})
		end

		v81.MessageFtuxTooltip = messageFtuxTooltip2
		v73.MessageWithIcons = createElement3("Frame", v76, v81)
		v69.MessageWithDisplayName = createElement2("Frame", v72, v73)
		local element = createElement("Frame", v68, v69)

		if v3 then
			return element
		end

		return React.createElement(
			Foundation.View,
			{ tag = "size-full-0 auto-y", ClipsDescendants = false, LayoutOrder = 2, ZIndex = 2 },
			{
				ReplyIconFilled = React.createElement(Foundation.Icon, {
					name = v8.iconName,
					size = Foundation.Enums.IconSize.Medium,
					variant = Foundation.Enums.IconVariant.Filled,
					AnchorPoint = v8.iconAnchorPoint,
					Position = position2,
					style = style,
					ZIndex = 1
				}),
				Content = element
			}
		)
	end

	React.useEffect(function()
		if defineFastFlag and joined.isLastIncomingChatMessage then
			IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
		end
	end, { joined.isLastIncomingChatMessage })
	local createElement = React.createElement
	local v67 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		["AutomaticSize"] = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		Text = getFFlagDebugAppChat() and "" or nil
	}
	local activated = React.Event.Activated

	if not getFFlagDebugAppChat() then
		v60 = nil
	end

	v67[activated] = v60
	local v68 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = left2,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		DateTime = joined.showDateTime and React.createElement(SystemMessage, {
			LayoutOrder = 1,
			Text = joined.sent:GetLongRelativeTime(),
			maxWidth = ChatMessageContainerConstants.DATETIME_MAX_WIDTH
		}),
		MessageWithAvatar = renderMessage(),
		Notice = 0,
		debug = 0
	}

	if notice then
		local createElement2 = React.createElement
		local v69 = {
			Font = joined.Font,
			HorizontalAlignment = left2,
			LayoutOrder = 3,
			Text = text,
			TextColor3 = 0,
			TextTransparency = 0,
			TextXAlignment = 0,
			TextSize = 0,
			margin = 0,
			maxWidth = 0,
			width = 0
		}
		local textColor

		if v3 then
			textColor = v7.Color.Content.Muted.Color3
		else
			textColor = joined.moderated and v5.Theme.Alert.Color or v5.Theme.UIDefault.Color
		end

		v69.TextColor3 = textColor
		local textTransparency

		if v3 then
			textTransparency = v7.Color.Content.Muted.Transparency
		else
			textTransparency = joined.moderated and v5.Theme.Alert.Transparency or v5.Theme.UIDefault.Transparency
		end

		v69.TextTransparency = textTransparency

		v69.TextXAlignment = joined.isIncoming and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right
		v69.TextSize = v7.Typography.CaptionSmall.FontSize

		v69.margin = {
			top = v7.Padding.Small,
			left = joined.isIncoming and v59 + ChatMessageContainerConstants.NOTICE_HORIZONTAL_PADDING or 0,
			right = joined.isIncoming and 0 or v6.right or 0,
			bottom = 0
		}

		v69.maxWidth = joined.parentWidth
		v69.width = UDim.new(1, joined.isIncoming and -v59 or 0)
		notice = createElement2(NoticeText, v69)
	end

	v68.Notice = notice

	v68.debug = joined.debugElement or nil
	return createElement(v2, v67, v68)
end

return ChatMessageContainer
