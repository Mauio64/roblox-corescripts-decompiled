local IXPService = game:GetService("IXPService")
local UserInputService = game:GetService("UserInputService")
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
local MessageReactionChip = require(script.Parent.MessageReactions.MessageReactionChip)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatEnableReactions = SharedFlags.FFlagAppChatEnableReactions

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

	local v4

	if FFlagAppChatEnableReactions then
		v4 = not useIsInExperience()
	else
		v4 = false
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

	local v5

	if FFlagAppChatConsoleFocusFixes then
		v5 = joined.viewProfileOnAvatarPressed
	end

	local onActivated = useCallback(fn, { senderUserId, openViewProfile, v5 })

	local v6 = useStyle()
	local shouldShowName = joined.shouldShowName
	local v7 = useChatPagePadding()

	local v8 = Foundation.Hooks.useTokens()

	local v9 = React.useMemo(function()
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
	local v10

	if FFlagAppChatMessageModelOnDemand then
		local v11 = React.useContext(ChatConversationTelemetryLayer.Context)
		v10 = React.useMemo(function()
			return createTelemetryEmitter(v11)
		end, { v11 })
	else
		v10 = useTelemetry(ChatConversationTelemetryLayer.Context)
	end

	local v11 = useTriggerFeedback()
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)
	local v12, v13

	if FFlagAppChatConsoleFocusFixes then
		v12, v13 = useDescendantSelected2()
	else
		v12 = nil
		v13 = nil
	end

	local v14

	if FFlagAppChatConsoleFocusFixes then
		local v15 = ReactFocusNavigation.useFocusGuiObject()

		v14 = React.useCallback(function()
			local current = ref2.current

			if current then
				v15(current)
			end
		end, { ref2, v15 })
	else
		v14 = nil
	end

	React.useEffect(function()
		local dismissedConnection = GlobalLongPressSignal.dismissed:connect(function()
			setState3(false)
		end)
		return function()
			dismissedConnection:disconnect()
		end
	end)

	local v15 = React.useMemo(function()
		local v15 = {
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

		v15.targetMessageSentAt = targetMessageSentAt
		v15.targetMessageLength = joined.content and #joined.content or nil
		v15.targetMessageVisibility = joined.visibility
		return v15
	end, {
		joined.conversationId,
		joined.senderUserId,
		joined.messageId,
		joined.sent,
		joined.content,
		joined.visibility
	})
	local v16

	if FFlagAppChatConsoleFocusFixes then
		v16 = React.useMemo(function()
			return not v3 and (state2 or v12)
		end, { state2, v3, v12 })
	else
		v16 = React.useMemo(function()
			return not v3 and state2
		end, { state2, v3 })
	end

	React.useEffect(function()
		if v16 and joined.isLastIncomingChatMessage then
			MessageFtuxTooltipDismissSignal.dismiss(MessageFtuxTooltipVariant.Replies)
		end
	end, { v16, joined.isLastIncomingChatMessage })
	local emitImpressionTelemetryEvent = React.useCallback(function()
		v10.emit(ChatConversationTelemetryEvents.ConversationMessageReplyIconImpression, v15)
	end, { v10, v15 })
	local v17 = useNavigation()
	local v18 = useGetConversationFromId(joined.conversationId)
	local v19

	if FFlagAppChatSignalsReplyStore then
		v19 = GetReplyingToStore(false)
	else
		v19 = nil
	end

	local v20 = nil
	local v21 = nil

	if
		FFlagAppChatMessageModelOnDemand
		and shouldReadMessageListFromSignalsStore
		and GetConversationMessageViewModelStore
	then
		v21 = GetConversationMessageViewModelStore(false).conversationMessageStore.messages[joined.messageId]
	elseif shouldReadMessageListFromSignalsStore and GetConversationMessageViewModelStore then
		local message = GetConversationMessageViewModelStore(false).conversationMessageStore.messages[joined.messageId]

		if message then
			v20 = MessageModel.fromChannelsApi(message, joined.conversationId)
		else
			v20 = nil
		end
	elseif v18 and v18.messages then
		v20 = v18.messages:Get(joined.messageId)
	end

	local v22

	if FFlagAppChatMessageModelOnDemand then
		v22 = React.useCallback(function()
			if v21 then
				return MessageModel.fromChannelsApi(v21, joined.conversationId)
			end

			return v20
		end, { v21, v20, joined.conversationId })
	else
		v22 = nil
	end

	local v23 = useReplyingToMessageDispatch()
	local v24 = useLocalUserId()

	local onSwipeThresholdReached = React.useCallback(function()
		if not v3 then
			v11(HapticFeedbackContext.Default, HapticFeedbackType.Press)
		end
	end, { v3, v11 })

	local useCallback2 = React.useCallback
	local function fn2()
		v10.emit(ChatConversationTelemetryEvents.ConversationMessageSwiped, v15)

		if not v3 then
			if FFlagAppChatSignalsReplyStore and v19 then
				v19.setReplyingTo(joined.messageId)
				return
			end

			local v25

			if FFlagAppChatMessageModelOnDemand then
				v25 = v22()
			else
				v25 = v20
			end

			v23(v25)
		end
	end

	local v25

	if FFlagAppChatSignalsReplyStore then
		v25 = v19
	end

	local messageId

	if FFlagAppChatSignalsReplyStore then
		messageId = joined.messageId
	end

	local v26

	if FFlagAppChatMessageModelOnDemand then
		v26 = v22
	end

	local v27 = useSwipeGesture({
		onSwipeThresholdReached = onSwipeThresholdReached,
		onSwipeComplete = useCallback2(fn2, { v23, v20, v10, v15, v3, v25, messageId, v26 }),
		direction = v9.direction
	})

	local v28 = React.useCallback(function()
		v17.navigate(EnumScreens.MessageContextMenu, {
			messageId = joined.messageId,
			conversationId = joined.conversationId,
			inputBoxRef = joined.inputBoxRef
		})
	end, { v17.navigate, joined.messageId, joined.conversationId, joined.inputBoxRef })

	local v29 = React.useCallback(function(p2, p3, p4: number)
		if p3 then
			ref3.current = Vector2.new(p3.Position.X, p3.Position.Y)
		end

		setTimeout(function()
			local v29

			if p3 then
				local current = ref3.current
				v29 = (Vector2.new(p3.Position.X, p3.Position.Y) - current).Magnitude
			else
				v29 = 0
			end

			if
				p3
				and (p3.UserInputState == Enum.UserInputState.Begin or p3.UserInputState == Enum.UserInputState.Change)
				and v29 < defineFastInt
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
				v10.emit(ChatConversationTelemetryEvents.ConversationMessageLongPressed, v15)

				if not v3 then
					setState3(true)

					if FFlagAppChatEnableMessageContextMenu then
						v28()
					end

					v29(React.Event.InputEnded, p3, ChatMessageContainerConstants.PEEK_VIEW_ANIMATION_MILLISEC)
				end
			end

			if p2 == React.Event.InputBegan and p3 then
				v10.emit(ChatConversationTelemetryEvents.ConversationMessagePressed, v15)

				if not (v3 or state3) then
					GlobalLongPressSignal.dismiss()
				end

				v29(React.Event.TouchLongPress, p3, ChatMessageContainerConstants.LONG_PRESS_DELAY_MILLISEC)
			end

			if p2 == React.Event.TouchTap then
				joined.closeKeyboard()
			end
		end

		if p2 == React.Event.Activated then
			GlobalLongPressSignal.dismiss()

			if p4 == OptionsEnum.MessageContextMenu then
				if ChatConversationTelemetryEvents.ConversationMessageOpenMenuIconClicked then
					v10.emit(ChatConversationTelemetryEvents.ConversationMessageOpenMenuIconClicked, v15)
				end

				v28()
			end

			if p4 == OptionsEnum.Reply then
				v10.emit(ChatConversationTelemetryEvents.ConversationMessageReplyIconClicked, v15)

				v11(HapticFeedbackContext.Default, HapticFeedbackType.Press)

				if FFlagAppChatSignalsReplyStore and v19 then
					v19.setReplyingTo(joined.messageId)
					return
				end

				local v30

				if FFlagAppChatMessageModelOnDemand then
					v30 = v22()
				else
					v30 = v20
				end

				v23(v30)
			end
		end
	end

	local isPending = joined.isPending
	local unitTestTouchEnabled = joined.unitTestTouchEnabled
	local mouseEnabled = UserInputService.MouseEnabled
	local touchEnabled = UserInputService.TouchEnabled
	local v30

	if FFlagAppChatSignalsReplyStore then
		v30 = v19
	end

	local v31

	if not FFlagAppChatSignalsReplyStore then
		v31 = v20
	end

	local v32

	if FFlagAppChatSignalsReplyStore then
		v32 = joined.messageId
	end

	local v40 = {
		isPending,
		unitTestTouchEnabled,
		mouseEnabled,
		touchEnabled,
		v29,
		setState2,
		setState3,
		setState,
		v10,
		v28,
		v23,
		v11,
		v3,
		v30,
		v31,
		v32,
		nil,
		nil,
		nil
	}
	local v45

	if FFlagAppChatMessageModelOnDemand and not FFlagAppChatSignalsReplyStore then
		v45 = v22
	end

	local v46

	if FFlagAppChatMessageModelOnDemand then
		v46 = v15
	end

	local v47

	if FFlagAppChatMessageModelOnDemand then
		v47 = joined.closeKeyboard
	end

	v40[17], v40[18], v40[19] = v45, v46, v47
	handleEvent = useCallback3(fn3, v40)

	local v48 = React.useCallback(function(p2, p3)
		if UserInputService.TouchEnabled and v27 then
			v27.onInputBegan(p2, p3)

			MessageFtuxTooltipDismissSignal.dismiss(MessageFtuxTooltipVariant.Replies)
		end

		v29(React.Event.InputBegan, p3, ChatMessageContainerConstants.INPUT_BEGAN_DELAY_MILLISEC)
	end, { v29, v27 })

	local v49 = React.useCallback(function(_)
		handleEvent(React.Event.InputEnded)
	end, { handleEvent })

	local v50 = React.useCallback(function(_)
		handleEvent(React.Event.MouseEnter)
	end, { handleEvent })

	local v51 = React.useCallback(function(_)
		handleEvent(React.Event.MouseLeave)
	end, { handleEvent })

	local v52 = React.useCallback(function(_)
		handleEvent(React.Event.TouchTap)
	end, { handleEvent })

	local v53 = React.useCallback(function(_)
		handleEvent(React.Event.MouseButton1Down)
	end, { handleEvent })

	local senderTargetId = joined.repliesTo and joined.repliesTo.senderTargetId

	local function getDisplayNameText(senderName: string, repliedToName: string)
		local senderIsLocalUser = v24 == joined.senderUserId
		local senderRepliedToSelf = joined.senderUserId == joined.repliesTo.senderTargetId
		local senderRepliedToLocalUser = v24 == joined.repliesTo.senderTargetId

		if not senderTargetId then
			return senderName
		end

		local conversationType = v18 and v18.conversationType

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

	local v54 = nil
	local v55 = nil

	if FFlagAppChatUseUserProfileHydration then
		v55 = useProfileNames(senderTargetIds)
	else
		v54 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = senderTargetIds,
			query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
		})
	end

	local v56, displayName2

	if FFlagAppChatUseUserProfileHydration then
		local combinedNameFromProfileNames = getCombinedNameFromProfileNames(v55, joined.senderUserId)
		local v58

		if senderTargetId then
			v58 = getCombinedNameFromProfileNames(v55, joined.repliesTo.senderTargetId)
		end

		if v55 == nil or v55.status == DataStatus.Ready then
			v56 = false
		else
			v56 = combinedNameFromProfileNames == nil or senderTargetId and v58 == nil
		end

		if not v56 then
			if senderTargetId then
				displayName2 = getDisplayNameText(
					combinedNameFromProfileNames or joined.unknownUserKey,
					v58 or joined.unknownUserKey
				)
			else
				displayName2 = combinedNameFromProfileNames or joined.unknownUserKey
			end
		end
	elseif v54.data then
		v56 = false
		displayName2 = UserProfiles.Selectors.getCombinedNameFromId(v54.data, joined.senderUserId)
			or joined.unknownUserKey

		if senderTargetId then
			displayName2 = getDisplayNameText(
				displayName2,
				UserProfiles.Selectors.getCombinedNameFromId(v54.data, joined.repliesTo.senderTargetId) or joined.unknownUserKey
			)
		end
	else
		v56 = true
	end

	local displayName = useLocalization(senderTargetId and { displayName = displayName2 } or {}).displayName
		or displayName2

	local v58 = React.useCallback(function()
		local vector2_3 = Vector2.new(
			math.max(1, joined.messageMaxWidth - ChatMessageContainerConstants.TAIL_WIDTH),
			1e999
		)
		local textSize = GetTextSize(
			displayName,
			v6.Font.BaseSize * v6.Font.Footer.RelativeSize,
			v8.Typography.CaptionSmall.Font,
			vector2_3,
			{ addTemporaryPadding = false }
		)

		return UDim2.new(0, textSize.X, 0, textSize.Y)
	end, {
		v6.Font.BaseSize * v6.Font.Footer.RelativeSize,
		v6.Font.Footer.Font,
		joined.messageMaxWidth - ChatMessageContainerConstants.TAIL_WIDTH,
		displayName,
		v8.Typography.CaptionSmall.Font
	})
	local v59

	if joined.showDateTime then
		v59 = 0
	else
		local v60

		if joined.isNewSender or senderTargetId then
			v60 = ChatMessageContainerConstants.CHAT_MESSAGE_MAX_SPACE
		else
			v60 = ChatMessageContainerConstants.CHAT_MESSAGE_MIN_SPACE
		end

		v59 = v60 + joined.messageTypePaddingOffset
	end

	local left = v7.left
	local v60 = left + v8.Size.Size_700
	local left2 = joined.isIncoming and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right

	local state4, setState4 = React.useState(false)
	local v61 = React.useCallback(function()
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
			style = v8.Color.System.Alert,
			LayoutOrder = joined.isIncoming and 0 or 3
		})
	end, { v8, v6, joined.isIncoming })

	if not (joined.failed or joined.moderated) then
		if v16 then
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

	if v27 and v27.swipeProgress then
		style = v27.swipeProgress:map(function(p2: number)
			local transparency = 1 - math.pow(p2, 3)
			return { Color3 = v8.Color.Content.Default.Color3, Transparency = transparency }
		end)
	else
		style = nil
	end

	local position

	if v27 and v27.swipeOffset then
		position = v27.swipeOffset:map(function(p2: number)
			if v9.direction ~= SwipeDirection.Right then
				p2 = -p2
			end

			return UDim2.new(0, p2, 0, 0)
		end)
	else
		position = nil
	end

	local position2

	if v27 and v27.swipeProgress then
		position2 = v27.swipeProgress:map(function(p2: number)
			return v9.messagePosition + UDim2.new(0, p2 * v9.iconOffset, 0, 0)
		end)
	else
		position2 = nil
	end

	local function renderMessage()
		local createElement = React.createElement
		local v69 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			Position = position,
			[React.Event.MouseEnter] = v50,
			[React.Event.MouseLeave] = v51
		}
		local v70 = {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v59),
				PaddingLeft = UDim.new(0, joined.thumbnail and left or v60),
				PaddingRight = UDim.new(0, v7.right - 0)
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

		v70.AvatarContainer = avatarContainer

		local createElement2 = React.createElement
		local v73 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, joined.isIncoming and -v60 or 0, 0, 0)
		}

		local createElement3 = React.createElement
		local v75 = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = left2,
			SortOrder = 0
		}
		local sortOrder

		if FFlagAppChatEnableReactions then
			sortOrder = Enum.SortOrder.LayoutOrder
		end

		v75.SortOrder = sortOrder
		local children = {
			Layout = createElement3("UIListLayout", v75),
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, joined.isIncoming and v8.Size.Size_200 or 0)
			}),
			DisplayNameContainer = 0,
			MessageWithIcons = 0,
			MessageReactionChip = 0
		}

		local displayNameContainer = shouldShowName

		if displayNameContainer then
			local createElement4 = React.createElement
			local v79 = {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(0, joined.messageMaxWidth - ChatMessageContainerConstants.TAIL_WIDTH, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 1
			}

			local createElement5 = React.createElement
			local v82 = {
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

			v82.PaddingRight = paddingRight
			local paddingBottom

			if senderTargetId then
				paddingBottom = UDim.new(0, ChatMessageContainerConstants.REPLIED_DISPLAY_NAME_BOTTOM_PADDING)
			else
				paddingBottom = UDim.new(0, ChatMessageContainerConstants.GROUPED_MESSAGE_DISPLAY_NAME_BOTTOM_PADDING)
			end

			v82.PaddingBottom = paddingBottom
			local v80 = {
				Padding = createElement5("UIPadding", v82),
				DisplayName = 0,
				ShimmerName = 0
			}
			local displayName3

			if not v56 then
				local createElement6 = React.createElement
				local v87 = {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					FontFace = normalizeFontFace(v8.Typography.CaptionSmall.Font),
					Size = v58(),
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

				v87.AnchorPoint = anchorPoint
				local position3

				if isIncoming then
					position3 = UDim2.fromScale(0, 0)
				else
					position3 = UDim2.fromScale(1, 0)
				end

				v87.Position = position3
				v87.Text = displayName
				v87.TextColor3 = v6.Theme.TextDefault.Color
				v87.TextSize = v6.Font.BaseSize * v6.Font.Footer.RelativeSize
				v87.TextTransparency = v6.Theme.TextDefault.Transparency
				local textXAlignment

				if isIncoming then
					textXAlignment = Enum.TextXAlignment.Left
				else
					textXAlignment = Enum.TextXAlignment.Right
				end

				v87.TextXAlignment = textXAlignment

				v87.TextYAlignment = Enum.TextYAlignment.Top
				displayName3 = createElement6("TextLabel", v87)
			end

			v80.DisplayName = displayName3
			local shimmerName

			if v56 then
				local createElement6 = React.createElement
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

				shimmerName = createElement6(Skeleton, {
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

			v80.ShimmerName = shimmerName
			displayNameContainer = createElement4("Frame", v79, v80)
		end

		children.DisplayNameContainer = displayNameContainer

		local createElement4 = React.createElement
		local v79 = {}
		v79.BackgroundTransparency = 1
		v79.BorderSizePixel = 0
		v79.LayoutOrder = 2
		v79.AutomaticSize = Enum.AutomaticSize.Y
		local size

		if FFlagAppChatConsoleFocusFixes then
			size = UDim2.new(1, 0, 0, 0)
		else
			size = UDim2.new(1, joined.isIncoming and -v60 or 0, 0, 0)
		end

		v79.Size = size
		local selectable

		if FFlagAppChatConsoleFocusFixes then
			selectable = not v3
		end

		v79.Selectable = selectable
		local ref4

		if FFlagAppChatConsoleFocusFixes then
			ref4 = v13
		end

		v79.ref = ref4
		local selectionGained = React.Event.SelectionGained
		local v83

		if FFlagAppChatConsoleFocusFixes then
			v83 = v14
		end

		v79[selectionGained] = v83
		local v84 = {
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
		local v85 = {
			LayoutOrder = joined.isIncoming and 1 or 2,
			[React.Event.InputBegan] = v48,
			[React.Event.InputEnded] = v49,
			[React.Event.TouchTap] = v52,
			[React.Event.MouseButton1Down] = v53
		}
		local v86 = { isPressed = state, Icons = icons, bubbleRef = nil, ref = nil }
		local bubbleRef

		if FFlagAppChatConsoleFocusFixes then
			bubbleRef = ref2
		end

		v86.bubbleRef = bubbleRef
		v86.ref = ref
		v84.Message = renderMessage2(v85, v86)
		local messageFtuxTooltip2

		if joined.isLastIncomingChatMessage and not v3 then
			messageFtuxTooltip2 = React.createElement(messageFtuxTooltip, {
				variant = MessageFtuxTooltipVariant.Replies,
				messageRef = ref,
				isReversed = joined.isIncoming
			})
		end

		v84.MessageFtuxTooltip = messageFtuxTooltip2
		children.MessageWithIcons = createElement4("Frame", v79, v84)
		local messageReactionChip

		if v4 then
			messageReactionChip = React.createElement(MessageReactionChip, {
				messageId = joined.messageId,
				isIncoming = joined.isIncoming,
				layoutOrder = 3
			})
		end

		children.MessageReactionChip = messageReactionChip
		v70.MessageWithDisplayName = createElement2("Frame", v73, children)
		local element = createElement("Frame", v69, v70)

		if v3 then
			return element
		end

		return React.createElement(
			Foundation.View,
			{ tag = "size-full-0 auto-y", ClipsDescendants = false, LayoutOrder = 2, ZIndex = 2 },
			{
				ReplyIconFilled = React.createElement(Foundation.Icon, {
					name = v9.iconName,
					size = Foundation.Enums.IconSize.Medium,
					variant = Foundation.Enums.IconVariant.Filled,
					AnchorPoint = v9.iconAnchorPoint,
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
	local v68 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		["AutomaticSize"] = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		Text = getFFlagDebugAppChat() and "" or nil
	}
	local activated = React.Event.Activated

	if not getFFlagDebugAppChat() then
		v61 = nil
	end

	v68[activated] = v61
	local v69 = {
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
		local v70 = {
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
			textColor = v8.Color.Content.Muted.Color3
		else
			textColor = joined.moderated and v6.Theme.Alert.Color or v6.Theme.UIDefault.Color
		end

		v70.TextColor3 = textColor
		local textTransparency

		if v3 then
			textTransparency = v8.Color.Content.Muted.Transparency
		else
			textTransparency = joined.moderated and v6.Theme.Alert.Transparency or v6.Theme.UIDefault.Transparency
		end

		v70.TextTransparency = textTransparency

		v70.TextXAlignment = joined.isIncoming and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right
		v70.TextSize = v8.Typography.CaptionSmall.FontSize

		v70.margin = {
			top = v8.Padding.Small,
			left = joined.isIncoming and v60 + ChatMessageContainerConstants.NOTICE_HORIZONTAL_PADDING or 0,
			right = joined.isIncoming and 0 or v7.right or 0,
			bottom = 0
		}

		v70.maxWidth = joined.parentWidth
		v70.width = UDim.new(1, joined.isIncoming and -v60 or 0)
		notice = createElement2(NoticeText, v70)
	end

	v69.Notice = notice

	v69.debug = joined.debugElement or nil
	return createElement(v2, v68, v69)
end

return ChatMessageContainer
