local IXPService = game:GetService("IXPService")
local UserInputService = game:GetService("UserInputService")

local setTimeout = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuauPolyfill").setTimeout
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")
local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Core.Style.useStyle
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigation
local useGetConversationFromId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetConversationFromId")
local Options = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageInteraction/Options")
local OptionsEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageInteraction/OptionsEnum")
local ChatMessageContainerConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatMessageContainerConstants")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local skeleton = Foundation.Skeleton
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Style").GetTextSize

local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks").useLocalUserId
local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")
local getReplyLabelDescriptor = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getReplyLabelDescriptor")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/EventNames")

local useChatPagePadding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/useChatPagePadding")

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Logger")
local NoticeText = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/NoticeText")
local SystemMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/SystemMessage")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserProfiles")
local dataStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration").DataStatus
local useProfileNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useProfileNames")
local getCombinedNameFromProfileNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Users/getCombinedNameFromProfileNames")
local FFlagAppChatUseUserProfileHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseUserProfileHydration")
local ChatConversationTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatConversationTelemetryEvents")
local ChatDetailsTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatDetailsTelemetryLayer")
local MessageFtuxTooltipDismissSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageFtuxTooltip/MessageFtuxTooltipDismissSignal")
local module23 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageFtuxTooltip")
local messageFtuxTooltip = module23.MessageFtuxTooltip
local messageFtuxTooltipVariant = module23.MessageFtuxTooltipVariant
local messageFtuxTooltipDismissSignal = module23.MessageFtuxTooltipDismissSignal
local SwipeDirection = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Enums/SwipeDirection")

local getFFlagDebugAppChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFFlagDebugAppChat")
local GetReplyingToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetReplyingToStore")

local useReplyingToMessageDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageInteraction/ReplyingContext/useReplyingToMessageDispatch")
local FFlagAppChatSignalsReplyStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatSignalsReplyStore")
local FFlagAppChatMessageModelOnDemand = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMessageModelOnDemand")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")
local createTelemetryEmitter = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/createTelemetryEmitter")
local useTriggerFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InteractionFeedback").useTriggerFeedback
local hapticFeedbackContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/HapticFeedback").HapticFeedbackContext
local hapticFeedbackType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/HapticFeedback").HapticFeedbackType
local useSwipeGesture = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useSwipeGesture")

local userTile = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserTile").UserTile
local layoutMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserTile").LayoutMode
local userPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation").Enums.UserPresence

local FFlagAppChatEnableMessageContextMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatEnableMessageContextMenu")
local FFlagAppChatConsoleFocusFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConsoleFocusFixes")
local FFlagAppChatAlignAvatarToMessageGroupBottom = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatAlignAvatarToMessageGroupBottom")
local useDescendantSelected = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Hooks/useDescendantSelected").useDescendantSelected
local module36 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageReactions/MessageReactionChip")
local useIsInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsInExperience")
local fFlagAppChatEnableReactions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatEnableReactions

local defineFastFlag = game:DefineFastFlag("AppChatEnableRepliesUIIxpEnabled2", false)

local defineFastString = game:DefineFastString("AppChatEnableRepliesUIIxpLayer1", "Party.ConversationPage")
local defineFastInt = game:DefineFastInt("AppChatMessageLongPressDistanceThreshold", 25)
local MessageModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/MessageModel")
local defineFastFlag2 = game:DefineFastFlag("AppChatUseSymmetricSwipe", false)
local defineFastInt2 = game:DefineFastInt("AppChatReplyIconSwipeOffset", 25)
local shouldReadMessageListFromSignalsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/SignalsMigrationConfig").shouldReadMessageListFromSignalsStore
	or FFlagAppChatSignalsReplyStore
local v5

if shouldReadMessageListFromSignalsStore then
	v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageViewModelStore")
else
	v5 = nil
end

local udim = UDim2.new(0, 0, 0.5, 0)
local udim2 = UDim2.new(1, 0, 0.5, 0)
local vector2 = Vector2.new(0, 0.5)
local vector2_2 = Vector2.new(1, 0.5)

local v6 = {
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

local v7 = getFFlagDebugAppChat() and "TextButton" or "Frame"
function LUAUFORGE_MODULE_GLOBALS_hxN_ChatMessageContainer(p2)
	local joined = Cryo.Dictionary.join(v6, p2)

	local v8 = if joined.visibility then joined.visibility == MessageModel.VisibilityTypes.Hidden else false

	local v9 = if fFlagAppChatEnableReactions then not useIsInExperience() else false

	local useCallback = React.useCallback
	local function fn()
		if joined.viewProfileOnAvatarPressed then
			joined.openViewProfile(joined.senderUserId)
		end
	end
	local senderUserId = joined.senderUserId

	local openViewProfile = if FFlagAppChatConsoleFocusFixes then joined.openViewProfile else nil
	local v11 = if FFlagAppChatConsoleFocusFixes then joined.viewProfileOnAvatarPressed else nil
	local v12 = useCallback(fn, { senderUserId, openViewProfile, v11 })

	local v13 = useStyle()
	local shouldShowName = joined.shouldShowName
	local v14 = useChatPagePadding()

	local v15 = Foundation.Hooks.useTokens()

	local v16 = React.useMemo(function()
		if not defineFastFlag2 then
			return {
				direction = SwipeDirection.Right,
				iconName = Foundation.Enums.IconName.ArrowThickToRight,
				messagePosition = udim,
				iconOffset = defineFastInt2,
				iconAnchorPoint = vector2
			}
		end

		local v18 = if joined.isIncoming then SwipeDirection.Right else SwipeDirection.Left
		local v19 = if joined.isIncoming then Foundation.Enums.IconName.ArrowThickToRight else Foundation.Enums.IconName.ArrowThickToLeft
		local v20 = if joined.isIncoming then udim else udim2
		local v21 = if joined.isIncoming then defineFastInt2 else -defineFastInt2
		local v22 = if joined.isIncoming then vector2 else vector2_2
		return {
			direction = v18,
			iconName = v19,
			messagePosition = v20,
			iconOffset = v21,
			iconAnchorPoint = v22
		}
	end, { joined.isIncoming })

	local v17 = nil
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(Vector2.zero)
	local v18

	if FFlagAppChatMessageModelOnDemand then
		local v19 = React.useContext(ChatDetailsTelemetryLayer.Context)
		v18 = React.useMemo(function()
			return createTelemetryEmitter(v19)
		end, { v19 })
	else
		v18 = useTelemetry(ChatDetailsTelemetryLayer.Context)
	end

	local v19 = useTriggerFeedback()
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)
	local v21, v22

	if FFlagAppChatConsoleFocusFixes then
		v21, v22 = useDescendantSelected()
	else
		v21 = nil
		v22 = nil
	end

	local v23

	if FFlagAppChatConsoleFocusFixes then
		local v24 = ReactFocusNavigation.useFocusGuiObject()

		v23 = React.useCallback(function()
			local current = ref2.current

			if current then
				v24(current)
			end
		end, { ref2, v24 })
	else
		v23 = nil
	end

	React.useEffect(function()
		local dismissedConnection = MessageFtuxTooltipDismissSignal.dismissed:connect(function()
			setState3(false)
		end)
		return function()
			dismissedConnection:disconnect()
		end
	end)

	local v24 = React.useMemo(function()
		local v25 = {
			conversationId = joined.conversationId,
			targetMessageSenderId = joined.senderUserId,
			targetMessageId = joined.messageId,
			targetMessageSentAt = 0,
			targetMessageLength = 0,
			targetMessageVisibility = 0
		}
		local v26 = if joined.sent then joined.sent.dateTime else nil
		v25.targetMessageSentAt = v26
		v25.targetMessageLength = joined.content and #joined.content or nil
		v25.targetMessageVisibility = joined.visibility
		return v25
	end, {
		joined.conversationId,
		joined.senderUserId,
		joined.messageId,
		joined.sent,
		joined.content,
		joined.visibility
	})
	local v25

	if FFlagAppChatConsoleFocusFixes then
		v25 = React.useMemo(function()
			return not v8 and (state2 or v21)
		end, { state2, v8, v21 })
	else
		v25 = React.useMemo(function()
			return not v8 and state2
		end, { state2, v8 })
	end

	React.useEffect(function()
		if v25 and joined.isLastIncomingChatMessage then
			messageFtuxTooltipDismissSignal.dismiss(messageFtuxTooltipVariant.Replies)
		end
	end, { v25, joined.isLastIncomingChatMessage })
	local v26 = React.useCallback(function()
		v18.emit(ChatConversationTelemetryEvents.ConversationMessageReplyIconImpression, v24)
	end, { v18, v24 })
	local v27 = useNavigation()
	local v28 = useGetConversationFromId(joined.conversationId)

	local v29 = if FFlagAppChatSignalsReplyStore then GetReplyingToStore(false) else nil
	local v30 = nil
	local v31 = nil

	if FFlagAppChatMessageModelOnDemand and shouldReadMessageListFromSignalsStore and v5 then
		v31 = v5(false).conversationMessageStore.messages[joined.messageId]
	elseif shouldReadMessageListFromSignalsStore and v5 then
		local message = v5(false).conversationMessageStore.messages[joined.messageId]

		v30 = if message then MessageModel.fromChannelsApi(message, joined.conversationId) else nil
	elseif v28 and v28.messages then
		v30 = v28.messages:Get(joined.messageId)
	end

	local v32

	if FFlagAppChatMessageModelOnDemand then
		v32 = React.useCallback(function()
			if v31 then
				return MessageModel.fromChannelsApi(v31, joined.conversationId)
			end

			return v30
		end, { v31, v30, joined.conversationId })
	else
		v32 = nil
	end

	local v33 = useReplyingToMessageDispatch()
	local v34 = useLocalUserId()

	local v35 = React.useCallback(function()
		if not v8 then
			v19(hapticFeedbackContext.Default, hapticFeedbackType.Press)
		end
	end, { v8, v19 })

	local useCallback2 = React.useCallback
	local function fn2()
		v18.emit(ChatConversationTelemetryEvents.ConversationMessageSwiped, v24)

		if not v8 then
			if FFlagAppChatSignalsReplyStore and v29 then
				v29.setReplyingTo(joined.messageId)
				return
			end

			local v37 = if FFlagAppChatMessageModelOnDemand then v32() else v30
			v33(v37)
		end
	end

	local v39 = if FFlagAppChatSignalsReplyStore then v29 else nil
	local messageId = if FFlagAppChatSignalsReplyStore then joined.messageId else nil
	local v42 = useSwipeGesture({
		onSwipeThresholdReached = v35,
		onSwipeComplete = useCallback2(fn2, {
			v33,
			v30,
			v18,
			v24,
			v8,
			v39,
			messageId,
			if FFlagAppChatMessageModelOnDemand then v32 else nil
		}),
		direction = v16.direction
	})

	local v43 = React.useCallback(function()
		v27.navigate(EnumScreens.MessageContextMenu, {
			messageId = joined.messageId,
			conversationId = joined.conversationId,
			inputBoxRef = joined.inputBoxRef
		})
	end, { v27.navigate, joined.messageId, joined.conversationId, joined.inputBoxRef })

	local v44 = React.useCallback(function(p3, p4, p5)
		if p4 then
			ref3.current = Vector2.new(p4.Position.X, p4.Position.Y)
		end

		setTimeout(function()
			local v45

			if p4 then
				local current = ref3.current
				v45 = (Vector2.new(p4.Position.X, p4.Position.Y) - current).Magnitude
			else
				v45 = 0
			end

			if
				p4
				and (p4.UserInputState == Enum.UserInputState.Begin or p4.UserInputState == Enum.UserInputState.Change)
				and v45 < defineFastInt
			then
				v17(p3, p4)
			end
		end, p5)
	end, { v17 })

	local useCallback3 = React.useCallback
	local function fn3(p3, p4, p5)
		if joined.isPending then
			return
		end

		if UserInputService.MouseEnabled then
			if p3 == React.Event.MouseEnter then
				setState2(true)
			end

			if p3 == React.Event.MouseLeave then
				setState2(false)
			end

			if p3 == React.Event.MouseButton1Down then
				joined.closeKeyboard()
			end
		end

		if
			UserInputService.GamepadEnabled
			or UserInputService.TouchEnabled
			or joined.unitTestTouchEnabled
		then
			if p3 == React.Event.TouchLongPress then
				v18.emit(ChatConversationTelemetryEvents.ConversationMessageLongPressed, v24)

				if not v8 then
					setState3(true)

					if FFlagAppChatEnableMessageContextMenu then
						v43()
					end

					v44(React.Event.InputEnded, p4, ChatMessageContainerConstants.PEEK_VIEW_ANIMATION_MILLISEC)
				end
			end

			if p3 == React.Event.InputBegan and p4 then
				v18.emit(ChatConversationTelemetryEvents.ConversationMessagePressed, v24)

				if not (v8 or state3) then
					MessageFtuxTooltipDismissSignal.dismiss()
				end

				v44(React.Event.TouchLongPress, p4, ChatMessageContainerConstants.LONG_PRESS_DELAY_MILLISEC)
			end

			if p3 == React.Event.TouchTap then
				joined.closeKeyboard()
			end
		end

		if p3 == React.Event.Activated then
			MessageFtuxTooltipDismissSignal.dismiss()

			if p5 == OptionsEnum.MessageContextMenu then
				if ChatConversationTelemetryEvents.ConversationMessageOpenMenuIconClicked then
					v18.emit(ChatConversationTelemetryEvents.ConversationMessageOpenMenuIconClicked, v24)
				end

				v43()
			end

			if p5 == OptionsEnum.Reply then
				v18.emit(ChatConversationTelemetryEvents.ConversationMessageReplyIconClicked, v24)

				v19(hapticFeedbackContext.Default, hapticFeedbackType.Press)

				if FFlagAppChatSignalsReplyStore and v29 then
					v29.setReplyingTo(joined.messageId)
					return
				end

				local v46 = if FFlagAppChatMessageModelOnDemand then v32() else v30
				v33(v46)
			end
		end
	end

	local isPending = joined.isPending
	local unitTestTouchEnabled = joined.unitTestTouchEnabled
	local mouseEnabled = UserInputService.MouseEnabled
	local touchEnabled = UserInputService.TouchEnabled
	local v47 = if FFlagAppChatSignalsReplyStore then v29 else nil
	local v48 = if not FFlagAppChatSignalsReplyStore then v30 else nil
	local v49 = if FFlagAppChatSignalsReplyStore then joined.messageId else nil
	local v45 = {
		isPending,
		unitTestTouchEnabled,
		mouseEnabled,
		touchEnabled,
		v44,
		setState2,
		setState3,
		setState,
		v18,
		v43,
		v33,
		v19,
		v8,
		v47,
		v48,
		v49,
		nil,
		nil,
		nil
	}
	local v50 = if FFlagAppChatMessageModelOnDemand and not FFlagAppChatSignalsReplyStore then v32 else nil
	local v51 = if FFlagAppChatMessageModelOnDemand then v24 else nil
	local v52 = if FFlagAppChatMessageModelOnDemand then joined.closeKeyboard else nil
	v45[17], v45[18], v45[19] = v50, v51, v52
	v17 = useCallback3(fn3, v45)

	local v53 = React.useCallback(function(p3, p4)
		if UserInputService.TouchEnabled and v42 then
			v42.onInputBegan(p3, p4)

			messageFtuxTooltipDismissSignal.dismiss(messageFtuxTooltipVariant.Replies)
		end

		v44(React.Event.InputBegan, p4, ChatMessageContainerConstants.INPUT_BEGAN_DELAY_MILLISEC)
	end, { v44, v42 })

	local v54 = React.useCallback(function(p3)
		v17(React.Event.InputEnded)
	end, { v17 })

	local v55 = React.useCallback(function(p3)
		v17(React.Event.MouseEnter)
	end, { v17 })

	local v56 = React.useCallback(function(p3)
		v17(React.Event.MouseLeave)
	end, { v17 })

	local v57 = React.useCallback(function(p3)
		v17(React.Event.TouchTap)
	end, { v17 })

	local v58 = React.useCallback(function(p3)
		v17(React.Event.MouseButton1Down)
	end, { v17 })

	local senderTargetId = joined.repliesTo and joined.repliesTo.senderTargetId

	local function getDisplayNameText(p3, p4)
		local v59 = v34 == joined.senderUserId
		local v60 = joined.senderUserId == joined.repliesTo.senderTargetId
		local v61 = v34 == joined.repliesTo.senderTargetId

		if not senderTargetId then
			return p3
		end

		local conversationType = v28 and v28.conversationType

		if
			conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION
			or conversationType == Conversation.Type.MULTI_USER_CONVERSATION
		then
			return getReplyLabelDescriptor({
				senderIsLocalUser = v59,
				senderRepliedToSelf = v60,
				senderRepliedToLocalUser = v61,
				isGroup = conversationType == Conversation.Type.MULTI_USER_CONVERSATION,
				senderName = p3,
				repliedToName = p4
			})
		end

		return joined.unknownUserKey
	end

	local senderTargetIds = { joined.senderUserId }

	if senderTargetId then
		table.insert(senderTargetIds, joined.repliesTo.senderTargetId)
	end

	local v59 = nil
	local v60 = nil

	if FFlagAppChatUseUserProfileHydration then
		v60 = useProfileNames(senderTargetIds)
	else
		v59 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = senderTargetIds,
			query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
		})
	end

	local v61, v62

	if FFlagAppChatUseUserProfileHydration then
		local v63 = getCombinedNameFromProfileNames(v60, joined.senderUserId)

		local v64 = if senderTargetId then getCombinedNameFromProfileNames(v60, joined.repliesTo.senderTargetId) else nil

		if v60 == nil or v60.status == dataStatus.Ready then
			v61 = false
		else
			v61 = v63 == nil or senderTargetId and v64 == nil
		end

		if not v61 then
			if senderTargetId then
				v62 = getDisplayNameText(v63 or joined.unknownUserKey, v64 or joined.unknownUserKey)
			else
				v62 = v63 or joined.unknownUserKey
			end
		end
	elseif v59.data then
		v61 = false
		v62 = UserProfiles.Selectors.getCombinedNameFromId(v59.data, joined.senderUserId)
			or joined.unknownUserKey

		if senderTargetId then
			v62 = getDisplayNameText(
				v62,
				UserProfiles.Selectors.getCombinedNameFromId(v59.data, joined.repliesTo.senderTargetId) or joined.unknownUserKey
			)
		end
	else
		v61 = true
	end

	local displayName = useLocalization(senderTargetId and { displayName = v62 } or {}).displayName or v62

	local v63 = React.useCallback(function()
		local vector2_3 = Vector2.new(math.max(1, joined.messageMaxWidth - ChatMessageContainerConstants.TAIL_WIDTH), 1e999)
		local textSize = getTextSize(
			displayName,
			v13.Font.BaseSize * v13.Font.Footer.RelativeSize,
			v15.Typography.CaptionSmall.Font,
			vector2_3,
			{ addTemporaryPadding = false }
		)

		return UDim2.new(0, textSize.X, 0, textSize.Y)
	end, {
		v13.Font.BaseSize * v13.Font.Footer.RelativeSize,
		v13.Font.Footer.Font,
		joined.messageMaxWidth - ChatMessageContainerConstants.TAIL_WIDTH,
		displayName,
		v15.Typography.CaptionSmall.Font
	})
	local v64

	if joined.showDateTime then
		v64 = 0
	else
		v64 = (if joined.isNewSender or senderTargetId then ChatMessageContainerConstants.CHAT_MESSAGE_MAX_SPACE else ChatMessageContainerConstants.CHAT_MESSAGE_MIN_SPACE) + joined.messageTypePaddingOffset
	end

	local left = v14.left
	local v65 = left + v15.Size.Size_700
	local left2 = joined.isIncoming and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right

	local state4, setState4 = React.useState(false)
	local v66 = React.useCallback(function()
		if getFFlagDebugAppChat() then
			setState4(function(p3): boolean
				return not p3
			end)
		end
	end, { setState4 })

	local v67 = state4 or joined.moderated or joined.filteredForReceivers or v8
	local v68

	if state4 then
		v68 = joined.messageId
	elseif v8 then
		v68 = joined.messageHiddenNoticeText
	else
		v68 = joined.moderated and joined.messageModeratedNoticeText or joined.messageDefaultNoticeText
	end

	local v69 = React.useMemo(function()
		return React.createElement(Foundation.Icon, {
			name = Foundation.Enums.IconName.TriangleExclamation,
			size = Foundation.Enums.IconSize.Large,
			style = v15.Color.System.Alert,
			LayoutOrder = joined.isIncoming and 0 or 3
		})
	end, { v15, v13, joined.isIncoming })

	if not (joined.failed or joined.moderated) then
		if v25 then
			v69 = React.createElement(Options, {
				LayoutOrder = joined.isIncoming and 2 or 1,
				isIncoming = joined.isIncoming,
				handleEvent = v17,
				emitImpressionTelemetryEvent = v26
			})
		else
			v69 = nil
		end
	end

	local isIncoming = joined.isIncoming
	local v70

	if v42 and v42.swipeProgress then
		v70 = v42.swipeProgress:map(function(p3)
			local v71 = 1 - math.pow(p3, 3)
			return { Color3 = v15.Color.Content.Default.Color3, Transparency = v71 }
		end)
	else
		v70 = nil
	end

	local v71

	if v42 and v42.swipeOffset then
		v71 = v42.swipeOffset:map(function(p3)
			if v16.direction ~= SwipeDirection.Right then
				p3 = -p3
			end

			return UDim2.new(0, p3, 0, 0)
		end)
	else
		v71 = nil
	end

	local v72

	if v42 and v42.swipeProgress then
		v72 = v42.swipeProgress:map(function(p3)
			return v16.messagePosition + UDim2.new(0, p3 * v16.iconOffset, 0, 0)
		end)
	else
		v72 = nil
	end

	local function renderMessage()
		local createElement = React.createElement
		local v74 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			Position = v71,
			[React.Event.MouseEnter] = v55,
			[React.Event.MouseLeave] = v56
		}
		local v75 = {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v64),
				PaddingLeft = UDim.new(0, joined.thumbnail and left or v65),
				PaddingRight = UDim.new(0, v14.right - 0)
			}),
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = left2
			}),
			AvatarContainer = 0,
			MessageWithDisplayName = 0
		}

		local v76 = if joined.thumbnail then React.createElement(Foundation.View, {
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
					layoutMode = layoutMode.compact,
					userPresenceType = userPresence.None,
					layoutOrder = 1,
					onActivated = v12
				})
			})
		}) else nil
		v75.AvatarContainer = v76

		local createElement2 = React.createElement
		local v78 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, joined.isIncoming and -v65 or 0, 0, 0)
		}

		local createElement3 = React.createElement
		local v80 = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = left2,
			SortOrder = 0
		}

		local v81 = if fFlagAppChatEnableReactions then Enum.SortOrder.LayoutOrder else nil
		v80.SortOrder = v81
		local children = {
			Layout = createElement3("UIListLayout", v80),
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, joined.isIncoming and v15.Size.Size_200 or 0)
			}),
			DisplayNameContainer = 0,
			MessageWithIcons = 0,
			MessageReactionChip = 0
		}

		local v82 = shouldShowName

		if v82 then
			local createElement4 = React.createElement
			local v84 = {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(0, joined.messageMaxWidth - ChatMessageContainerConstants.TAIL_WIDTH, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 1
			}

			local createElement5 = React.createElement
			local v87 = {
				PaddingLeft = UDim.new(0, ChatMessageContainerConstants.GROUPED_MESSAGE_DISPLAY_NAME_LEFT_PADDING),
				PaddingRight = 0,
				PaddingBottom = 0
			}

			local v88 = if isIncoming then UDim.new(0, 0) else UDim.new(0, ChatMessageContainerConstants.TAIL_WIDTH)
			v87.PaddingRight = v88

			local v89 = if senderTargetId then UDim.new(0, ChatMessageContainerConstants.REPLIED_DISPLAY_NAME_BOTTOM_PADDING) else UDim.new(
				0,
				ChatMessageContainerConstants.GROUPED_MESSAGE_DISPLAY_NAME_BOTTOM_PADDING
			)
			v87.PaddingBottom = v89
			local v85 = {
				Padding = createElement5("UIPadding", v87),
				DisplayName = 0,
				ShimmerName = 0
			}
			local v90

			if not v61 then
				local createElement6 = React.createElement
				local v92 = {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					FontFace = normalizeFontFace(v15.Typography.CaptionSmall.Font),
					Size = v63(),
					AnchorPoint = 0,
					Position = 0,
					Text = 0,
					TextColor3 = 0,
					TextSize = 0,
					TextTransparency = 0,
					TextXAlignment = 0,
					TextYAlignment = 0
				}
				local v93 = if isIncoming then Vector2.new(0, 0) else Vector2.new(1, 0)
				v92.AnchorPoint = v93
				local v94 = if isIncoming then UDim2.fromScale(0, 0) else UDim2.fromScale(1, 0)
				v92.Position = v94
				v92.Text = displayName
				v92.TextColor3 = v13.Theme.TextDefault.Color
				v92.TextSize = v13.Font.BaseSize * v13.Font.Footer.RelativeSize
				v92.TextTransparency = v13.Theme.TextDefault.Transparency

				local v95 = if isIncoming then Enum.TextXAlignment.Left else Enum.TextXAlignment.Right
				v92.TextXAlignment = v95

				v92.TextYAlignment = Enum.TextYAlignment.Top
				v90 = createElement6("TextLabel", v92)
			end

			v85.DisplayName = v90
			local v91

			if v61 then
				local createElement6 = React.createElement
				local v94 = if isIncoming then Vector2.new(0, 0) else Vector2.new(1, 0)
				local v95 = if isIncoming then UDim2.fromScale(0, 0) else UDim2.fromScale(1, 0)
				v91 = createElement6(skeleton, {
					AnchorPoint = v94,
					Position = v95,
					Size = UDim2.new(0, ChatMessageContainerConstants.SHIMMER_WIDTH, 0, ChatMessageContainerConstants.SHIMMER_HEIGHT),
					LayoutOrder = 2
				})
			end

			v85.ShimmerName = v91
			v82 = createElement4("Frame", v84, v85)
		end

		children.DisplayNameContainer = v82

		local createElement4 = React.createElement
		local v84 = {}
		v84.BackgroundTransparency = 1
		v84.BorderSizePixel = 0
		v84.LayoutOrder = 2
		v84.AutomaticSize = Enum.AutomaticSize.Y

		local v85 = if FFlagAppChatConsoleFocusFixes then UDim2.new(1, 0, 0, 0) else UDim2.new(1, joined.isIncoming and -v65 or 0, 0, 0)
		v84.Size = v85

		v84.Selectable = if FFlagAppChatConsoleFocusFixes then not v8 else nil
		v84.ref = if FFlagAppChatConsoleFocusFixes then v22 else nil
		local selectionGained = React.Event.SelectionGained
		v84[selectionGained] = if FFlagAppChatConsoleFocusFixes then v23 else nil
		local v89 = {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = left2,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 10),
				ItemLineAlignment = Enum.ItemLineAlignment.Center
			}),
			Message = joined.renderMessage({
				LayoutOrder = joined.isIncoming and 1 or 2,
				[React.Event.InputBegan] = v53,
				[React.Event.InputEnded] = v54,
				[React.Event.TouchTap] = v57,
				[React.Event.MouseButton1Down] = v58
			}, {
				isPressed = state,
				Icons = v69,
				bubbleRef = if FFlagAppChatConsoleFocusFixes then ref2 else nil,
				ref = ref
			}),
			MessageFtuxTooltip = 0
		}

		local v93 = if joined.isLastIncomingChatMessage and not v8 then React.createElement(messageFtuxTooltip, {
			variant = messageFtuxTooltipVariant.Replies,
			messageRef = ref,
			isReversed = joined.isIncoming
		}) else nil
		v89.MessageFtuxTooltip = v93
		children.MessageWithIcons = createElement4("Frame", v84, v89)

		local v94 = if v9 then React.createElement(module36, {
			messageId = joined.messageId,
			isIncoming = joined.isIncoming,
			layoutOrder = 3
		}) else nil
		children.MessageReactionChip = v94
		v75.MessageWithDisplayName = createElement2("Frame", v78, children)
		local element = createElement("Frame", v74, v75)

		if v8 then
			return element
		end

		return React.createElement(
			Foundation.View,
			{
				tag = "size-full-0 auto-y",
				ClipsDescendants = false,
				LayoutOrder = 2,
				ZIndex = 2
			},
			{
				ReplyIconFilled = React.createElement(Foundation.Icon, {
					name = v16.iconName,
					size = Foundation.Enums.IconSize.Medium,
					variant = Foundation.Enums.IconVariant.Filled,
					AnchorPoint = v16.iconAnchorPoint,
					Position = v72,
					style = v70,
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
	local v74 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		["AutomaticSize"] = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		Text = getFFlagDebugAppChat() and "" or nil
	}
	local activated = React.Event.Activated

	if not getFFlagDebugAppChat() then
		v66 = nil
	end

	v74[activated] = v66
	local v75 = {
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

	if v67 then
		local createElement2 = React.createElement
		local v77 = {
			Font = joined.Font,
			HorizontalAlignment = left2,
			LayoutOrder = 3,
			Text = v68,
			TextColor3 = 0,
			TextTransparency = 0,
			TextXAlignment = 0,
			TextSize = 0,
			margin = 0,
			maxWidth = 0,
			width = 0
		}

		local v78 = if v8 then v15.Color.Content.Muted.Color3 else joined.moderated and v13.Theme.Alert.Color or v13.Theme.UIDefault.Color
		v77.TextColor3 = v78

		local v79 = if v8 then v15.Color.Content.Muted.Transparency else joined.moderated and v13.Theme.Alert.Transparency or v13.Theme.UIDefault.Transparency
		v77.TextTransparency = v79

		v77.TextXAlignment = joined.isIncoming and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right
		v77.TextSize = v15.Typography.CaptionSmall.FontSize

		v77.margin = {
			top = v15.Padding.Small,
			left = joined.isIncoming and v65 + ChatMessageContainerConstants.NOTICE_HORIZONTAL_PADDING or 0,
			right = joined.isIncoming and 0 or v14.right or 0,
			bottom = 0
		}

		v77.maxWidth = joined.parentWidth
		v77.width = UDim.new(1, joined.isIncoming and -v65 or 0)
		v67 = createElement2(NoticeText, v77)
	end

	v75.Notice = v67

	v75.debug = joined.debugElement or nil
	return createElement(v7, v74, v75)
end

return LUAUFORGE_MODULE_GLOBALS_hxN_ChatMessageContainer
