local IXPService = game:GetService("IXPService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")

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
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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
local ChatConversationTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatConversationTelemetryLayer")
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

local defineFastFlag = game:DefineFastFlag("AppChatEnableRepliesUIIxpEnabled2", false)

local defineFastString = game:DefineFastString("AppChatEnableRepliesUIIxpLayer1", "Party.ConversationPage")
local defineFastInt = game:DefineFastInt("AppChatMessageLongPressDistanceThreshold", 25)
local MessageModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/MessageModel")
local defineFastFlag2 = game:DefineFastFlag("AppChatUseSymmetricSwipe", false)
local defineFastInt2 = game:DefineFastInt("AppChatReplyIconSwipeOffset", 25)
local shouldReadMessageListFromSignalsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/SignalsMigrationConfig").shouldReadMessageListFromSignalsStore
	or FFlagAppChatSignalsReplyStore

local v5 = if shouldReadMessageListFromSignalsStore then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageViewModelStore") else nil

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
function LUAUFORGE_MODULE_GLOBALS_hnc_ChatMessageContainer(p2)
	local joined = Cryo.Dictionary.join(v6, p2)

	local v8 = if joined.visibility then joined.visibility == MessageModel.VisibilityTypes.Hidden else false

	local useCallback = React.useCallback
	local function fn()
		if joined.viewProfileOnAvatarPressed then
			joined.openViewProfile(joined.senderUserId)
		end
	end
	local senderUserId = joined.senderUserId

	local openViewProfile = if FFlagAppChatConsoleFocusFixes then joined.openViewProfile else nil
	local v10 = if FFlagAppChatConsoleFocusFixes then joined.viewProfileOnAvatarPressed else nil
	local v11 = useCallback(fn, { senderUserId, openViewProfile, v10 })

	local v12 = useStyle()
	local shouldShowName = joined.shouldShowName
	local v13 = useChatPagePadding()

	local v14 = Foundation.Hooks.useTokens()

	local v15 = React.useMemo(function()
		if not defineFastFlag2 then
			return {
				direction = SwipeDirection.Right,
				iconName = Foundation.Enums.IconName.ArrowThickToRight,
				messagePosition = udim,
				iconOffset = defineFastInt2,
				iconAnchorPoint = vector2
			}
		end

		local v17 = if joined.isIncoming then SwipeDirection.Right else SwipeDirection.Left
		local v18 = if joined.isIncoming then Foundation.Enums.IconName.ArrowThickToRight else Foundation.Enums.IconName.ArrowThickToLeft
		local v19 = if joined.isIncoming then udim else udim2
		local v20 = if joined.isIncoming then defineFastInt2 else -defineFastInt2
		local v21 = if joined.isIncoming then vector2 else vector2_2
		return {
			direction = v17,
			iconName = v18,
			messagePosition = v19,
			iconOffset = v20,
			iconAnchorPoint = v21
		}
	end, { joined.isIncoming })

	local v16 = nil
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(Vector2.zero)
	local v17

	if FFlagAppChatMessageModelOnDemand then
		local v18 = React.useContext(ChatConversationTelemetryLayer.Context)
		v17 = React.useMemo(function()
			return createTelemetryEmitter(v18)
		end, { v18 })
	else
		v17 = useTelemetry(ChatConversationTelemetryLayer.Context)
	end

	local v18 = useTriggerFeedback()
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)
	local v20, v21

	if FFlagAppChatConsoleFocusFixes then
		v20, v21 = useDescendantSelected()
	else
		v20 = nil
		v21 = nil
	end

	local v22

	if FFlagAppChatConsoleFocusFixes then
		local v23 = ReactFocusNavigation.useFocusGuiObject()

		v22 = React.useCallback(function()
			local current = ref2.current

			if current then
				v23(current)
			end
		end, { ref2, v23 })
	else
		v22 = nil
	end

	React.useEffect(function()
		local dismissedConnection = MessageFtuxTooltipDismissSignal.dismissed:connect(function()
			setState3(false)
		end)
		return function()
			dismissedConnection:disconnect()
		end
	end)

	local v23 = React.useMemo(function()
		local v24 = {
			conversationId = joined.conversationId,
			targetMessageSenderId = joined.senderUserId,
			targetMessageId = joined.messageId,
			targetMessageSentAt = 0,
			targetMessageLength = 0,
			targetMessageVisibility = 0
		}
		local v25 = if joined.sent then joined.sent.dateTime else nil
		v24.targetMessageSentAt = v25
		v24.targetMessageLength = joined.content and #joined.content or nil
		v24.targetMessageVisibility = joined.visibility
		return v24
	end, {
		joined.conversationId,
		joined.senderUserId,
		joined.messageId,
		joined.sent,
		joined.content,
		joined.visibility
	})
	local v24

	if FFlagAppChatConsoleFocusFixes then
		v24 = React.useMemo(function()
			return not v8 and (state2 or v20)
		end, { state2, v8, v20 })
	else
		v24 = React.useMemo(function()
			return not v8 and state2
		end, { state2, v8 })
	end

	React.useEffect(function()
		if v24 and joined.isLastIncomingChatMessage then
			messageFtuxTooltipDismissSignal.dismiss(messageFtuxTooltipVariant.Replies)
		end
	end, { v24, joined.isLastIncomingChatMessage })
	local v25 = React.useCallback(function()
		v17.emit(ChatConversationTelemetryEvents.ConversationMessageReplyIconImpression, v23)
	end, { v17, v23 })
	local v26 = useNavigation()
	local v27 = useGetConversationFromId(joined.conversationId)

	local v28 = if FFlagAppChatSignalsReplyStore then GetReplyingToStore(false) else nil
	local v29 = nil
	local v30 = nil

	if FFlagAppChatMessageModelOnDemand and shouldReadMessageListFromSignalsStore and v5 then
		v30 = v5(false).conversationMessageStore.messages[joined.messageId]
	elseif shouldReadMessageListFromSignalsStore and v5 then
		local message = v5(false).conversationMessageStore.messages[joined.messageId]

		v29 = if message then MessageModel.fromChannelsApi(message, joined.conversationId) else nil
	elseif v27 and v27.messages then
		v29 = v27.messages:Get(joined.messageId)
	end

	local v31

	if FFlagAppChatMessageModelOnDemand then
		v31 = React.useCallback(function()
			if v30 then
				return MessageModel.fromChannelsApi(v30, joined.conversationId)
			end

			return v29
		end, { v30, v29, joined.conversationId })
	else
		v31 = nil
	end

	local v32 = useReplyingToMessageDispatch()
	local v33 = useLocalUserId()

	local v34 = React.useCallback(function()
		if not v8 then
			v18(hapticFeedbackContext.Default, hapticFeedbackType.Press)
		end
	end, { v8, v18 })

	local useCallback2 = React.useCallback
	local function fn2()
		v17.emit(ChatConversationTelemetryEvents.ConversationMessageSwiped, v23)

		if not v8 then
			if FFlagAppChatSignalsReplyStore and v28 then
				v28.setReplyingTo(joined.messageId)
				return
			end

			local v36 = if FFlagAppChatMessageModelOnDemand then v31() else v29
			v32(v36)
		end
	end

	local v38 = if FFlagAppChatSignalsReplyStore then v28 else nil
	local messageId = if FFlagAppChatSignalsReplyStore then joined.messageId else nil
	local v41 = useSwipeGesture({
		onSwipeThresholdReached = v34,
		onSwipeComplete = useCallback2(fn2, {
			v32,
			v29,
			v17,
			v23,
			v8,
			v38,
			messageId,
			if FFlagAppChatMessageModelOnDemand then v31 else nil
		}),
		direction = v15.direction
	})

	local v42 = React.useCallback(function()
		v26.navigate(EnumScreens.MessageContextMenu, {
			messageId = joined.messageId,
			conversationId = joined.conversationId,
			inputBoxRef = joined.inputBoxRef
		})
	end, { v26.navigate, joined.messageId, joined.conversationId, joined.inputBoxRef })

	local v43 = React.useCallback(function(p3, p4, p5)
		if p4 then
			ref3.current = Vector2.new(p4.Position.X, p4.Position.Y)
		end

		setTimeout(function()
			local v44

			if p4 then
				local current = ref3.current
				v44 = (Vector2.new(p4.Position.X, p4.Position.Y) - current).Magnitude
			else
				v44 = 0
			end

			if
				p4
				and (p4.UserInputState == Enum.UserInputState.Begin or p4.UserInputState == Enum.UserInputState.Change)
				and v44 < defineFastInt
			then
				v16(p3, p4)
			end
		end, p5)
	end, { v16 })

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
				v17.emit(ChatConversationTelemetryEvents.ConversationMessageLongPressed, v23)

				if not v8 then
					setState3(true)

					if FFlagAppChatEnableMessageContextMenu then
						v42()
					end

					v43(React.Event.InputEnded, p4, ChatMessageContainerConstants.PEEK_VIEW_ANIMATION_MILLISEC)
				end
			end

			if p3 == React.Event.InputBegan and p4 then
				v17.emit(ChatConversationTelemetryEvents.ConversationMessagePressed, v23)

				if not (v8 or state3) then
					MessageFtuxTooltipDismissSignal.dismiss()
				end

				v43(React.Event.TouchLongPress, p4, ChatMessageContainerConstants.LONG_PRESS_DELAY_MILLISEC)
			end

			if p3 == React.Event.TouchTap then
				joined.closeKeyboard()
			end
		end

		if p3 == React.Event.Activated then
			MessageFtuxTooltipDismissSignal.dismiss()

			if p5 == OptionsEnum.MessageContextMenu then
				if ChatConversationTelemetryEvents.ConversationMessageOpenMenuIconClicked then
					v17.emit(ChatConversationTelemetryEvents.ConversationMessageOpenMenuIconClicked, v23)
				end

				v42()
			end

			if p5 == OptionsEnum.Reply then
				v17.emit(ChatConversationTelemetryEvents.ConversationMessageReplyIconClicked, v23)

				v18(hapticFeedbackContext.Default, hapticFeedbackType.Press)

				if FFlagAppChatSignalsReplyStore and v28 then
					v28.setReplyingTo(joined.messageId)
					return
				end

				local v45 = if FFlagAppChatMessageModelOnDemand then v31() else v29
				v32(v45)
			end
		end
	end

	local isPending = joined.isPending
	local unitTestTouchEnabled = joined.unitTestTouchEnabled
	local mouseEnabled = UserInputService.MouseEnabled
	local touchEnabled = UserInputService.TouchEnabled
	local v46 = if FFlagAppChatSignalsReplyStore then v28 else nil
	local v47 = if not FFlagAppChatSignalsReplyStore then v29 else nil
	local v48 = if FFlagAppChatSignalsReplyStore then joined.messageId else nil
	local v44 = {
		isPending,
		unitTestTouchEnabled,
		mouseEnabled,
		touchEnabled,
		v43,
		setState2,
		setState3,
		setState,
		v17,
		v42,
		v32,
		v18,
		v8,
		v46,
		v47,
		v48,
		nil,
		nil,
		nil
	}
	local v49 = if FFlagAppChatMessageModelOnDemand and not FFlagAppChatSignalsReplyStore then v31 else nil
	local v50 = if FFlagAppChatMessageModelOnDemand then v23 else nil
	local v51 = if FFlagAppChatMessageModelOnDemand then joined.closeKeyboard else nil
	v44[17], v44[18], v44[19] = v49, v50, v51
	v16 = useCallback3(fn3, v44)

	local v52 = React.useCallback(function(p3, p4)
		if UserInputService.TouchEnabled and v41 then
			v41.onInputBegan(p3, p4)

			messageFtuxTooltipDismissSignal.dismiss(messageFtuxTooltipVariant.Replies)
		end

		v43(React.Event.InputBegan, p4, ChatMessageContainerConstants.INPUT_BEGAN_DELAY_MILLISEC)
	end, { v43, v41 })

	local v53 = React.useCallback(function(p3)
		v16(React.Event.InputEnded)
	end, { v16 })

	local v54 = React.useCallback(function(p3)
		v16(React.Event.MouseEnter)
	end, { v16 })

	local v55 = React.useCallback(function(p3)
		v16(React.Event.MouseLeave)
	end, { v16 })

	local v56 = React.useCallback(function(p3)
		v16(React.Event.TouchTap)
	end, { v16 })

	local v57 = React.useCallback(function(p3)
		v16(React.Event.MouseButton1Down)
	end, { v16 })

	local senderTargetId = joined.repliesTo and joined.repliesTo.senderTargetId

	local function getDisplayNameText(p3, p4)
		local v58 = v33 == joined.senderUserId
		local v59 = joined.senderUserId == joined.repliesTo.senderTargetId
		local v60 = v33 == joined.repliesTo.senderTargetId

		if not senderTargetId then
			return p3
		end

		local conversationType = v27 and v27.conversationType

		if
			conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION
			or conversationType == Conversation.Type.MULTI_USER_CONVERSATION
		then
			return getReplyLabelDescriptor({
				senderIsLocalUser = v58,
				senderRepliedToSelf = v59,
				senderRepliedToLocalUser = v60,
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

	local v58 = nil
	local v59 = nil

	if FFlagAppChatUseUserProfileHydration then
		v59 = useProfileNames(senderTargetIds)
	else
		v58 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = senderTargetIds,
			query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
		})
	end

	local v60, v61

	if FFlagAppChatUseUserProfileHydration then
		local v62 = getCombinedNameFromProfileNames(v59, joined.senderUserId)

		local v63 = if senderTargetId then getCombinedNameFromProfileNames(v59, joined.repliesTo.senderTargetId) else nil

		if v59 == nil or v59.status == dataStatus.Ready then
			v60 = false
		else
			v60 = v62 == nil or senderTargetId and v63 == nil
		end

		if not v60 then
			if senderTargetId then
				v61 = getDisplayNameText(v62 or joined.unknownUserKey, v63 or joined.unknownUserKey)
			else
				v61 = v62 or joined.unknownUserKey
			end
		end
	elseif v58.data then
		v60 = false
		v61 = UserProfiles.Selectors.getCombinedNameFromId(v58.data, joined.senderUserId)
			or joined.unknownUserKey

		if senderTargetId then
			v61 = getDisplayNameText(
				v61,
				UserProfiles.Selectors.getCombinedNameFromId(v58.data, joined.repliesTo.senderTargetId) or joined.unknownUserKey
			)
		end
	else
		v60 = true
	end

	local displayName = useLocalization(senderTargetId and { displayName = v61 } or {}).displayName or v61

	local useCallback4 = React.useCallback
	local function fn4()
		local vector2_3 = Vector2.new(math.max(1, joined.messageMaxWidth - ChatMessageContainerConstants.TAIL_WIDTH), 1e999)
		local v62

		if foundationFontFaceMigration then
			v62 = getTextSize(
				displayName,
				v12.Font.BaseSize * v12.Font.Footer.RelativeSize,
				v14.Typography.CaptionSmall.Font,
				vector2_3,
				{ addTemporaryPadding = false }
			)
		else
			v62 = TextService:GetTextSize(
				displayName,
				v12.Font.BaseSize * v12.Font.Footer.RelativeSize,
				v12.Font.Footer.Font,
				vector2_3
			)
		end

		return UDim2.new(0, v62.X, 0, v62.Y)
	end

	local v63 = v12.Font.BaseSize * v12.Font.Footer.RelativeSize
	local font = v12.Font.Footer.Font
	local v64 = joined.messageMaxWidth - ChatMessageContainerConstants.TAIL_WIDTH

	local v66 = if foundationFontFaceMigration then v14.Typography.CaptionSmall.Font else nil
	local v67 = useCallback4(fn4, { v63, font, v64, displayName, v66 })
	local v68

	if joined.showDateTime then
		v68 = 0
	else
		v68 = (if joined.isNewSender or senderTargetId then ChatMessageContainerConstants.CHAT_MESSAGE_MAX_SPACE else ChatMessageContainerConstants.CHAT_MESSAGE_MIN_SPACE) + joined.messageTypePaddingOffset
	end

	local left = v13.left
	local v69 = left + v14.Size.Size_700
	local left2 = joined.isIncoming and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right

	local state4, setState4 = React.useState(false)
	local v70 = React.useCallback(function()
		if getFFlagDebugAppChat() then
			setState4(function(p3): boolean
				return not p3
			end)
		end
	end, { setState4 })

	local v71 = state4 or joined.moderated or joined.filteredForReceivers or v8
	local v72

	if state4 then
		v72 = joined.messageId
	elseif v8 then
		v72 = joined.messageHiddenNoticeText
	else
		v72 = joined.moderated and joined.messageModeratedNoticeText or joined.messageDefaultNoticeText
	end

	local v73 = React.useMemo(function()
		return React.createElement(Foundation.Icon, {
			name = Foundation.Enums.IconName.TriangleExclamation,
			size = Foundation.Enums.IconSize.Large,
			style = v14.Color.System.Alert,
			LayoutOrder = joined.isIncoming and 0 or 3
		})
	end, { v14, v12, joined.isIncoming })

	if not (joined.failed or joined.moderated) then
		if v24 then
			v73 = React.createElement(Options, {
				LayoutOrder = joined.isIncoming and 2 or 1,
				isIncoming = joined.isIncoming,
				handleEvent = v16,
				emitImpressionTelemetryEvent = v25
			})
		else
			v73 = nil
		end
	end

	local isIncoming = joined.isIncoming
	local v74

	if v41 and v41.swipeProgress then
		v74 = v41.swipeProgress:map(function(p3)
			local v75 = 1 - math.pow(p3, 3)
			return { Color3 = v14.Color.Content.Default.Color3, Transparency = v75 }
		end)
	else
		v74 = nil
	end

	local v75

	if v41 and v41.swipeOffset then
		v75 = v41.swipeOffset:map(function(p3)
			if v15.direction ~= SwipeDirection.Right then
				p3 = -p3
			end

			return UDim2.new(0, p3, 0, 0)
		end)
	else
		v75 = nil
	end

	local v76

	if v41 and v41.swipeProgress then
		v76 = v41.swipeProgress:map(function(p3)
			return v15.messagePosition + UDim2.new(0, p3 * v15.iconOffset, 0, 0)
		end)
	else
		v76 = nil
	end

	local function renderMessage()
		local createElement = React.createElement
		local v78 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			Position = v75,
			[React.Event.MouseEnter] = v54,
			[React.Event.MouseLeave] = v55
		}
		local v79 = {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v68),
				PaddingLeft = UDim.new(0, joined.thumbnail and left or v69),
				PaddingRight = UDim.new(0, v13.right - 0)
			}),
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = left2
			}),
			AvatarContainer = 0,
			MessageWithDisplayName = 0
		}

		local v80 = if joined.thumbnail then React.createElement(Foundation.View, {
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
					onActivated = v11
				})
			})
		}) else nil
		v79.AvatarContainer = v80

		local createElement2 = React.createElement
		local v82 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, joined.isIncoming and -v69 or 0, 0, 0)
		}
		local v83 = {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = left2
			}),
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, joined.isIncoming and v14.Size.Size_200 or 0)
			}),
			DisplayNameContainer = 0,
			MessageWithIcons = 0
		}

		local v84 = shouldShowName

		if v84 then
			local createElement3 = React.createElement
			local v86 = {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(0, joined.messageMaxWidth - ChatMessageContainerConstants.TAIL_WIDTH, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 1
			}

			local createElement4 = React.createElement
			local v89 = {
				PaddingLeft = UDim.new(0, ChatMessageContainerConstants.GROUPED_MESSAGE_DISPLAY_NAME_LEFT_PADDING),
				PaddingRight = 0,
				PaddingBottom = 0
			}

			local v90 = if isIncoming then UDim.new(0, 0) else UDim.new(0, ChatMessageContainerConstants.TAIL_WIDTH)
			v89.PaddingRight = v90

			local v91 = if senderTargetId then UDim.new(0, ChatMessageContainerConstants.REPLIED_DISPLAY_NAME_BOTTOM_PADDING) else UDim.new(
				0,
				ChatMessageContainerConstants.GROUPED_MESSAGE_DISPLAY_NAME_BOTTOM_PADDING
			)
			v89.PaddingBottom = v91
			local v87 = {
				Padding = createElement4("UIPadding", v89),
				DisplayName = 0,
				ShimmerName = 0
			}
			local v92

			if not v60 then
				local createElement5 = React.createElement

				local v95 = if not foundationFontFaceMigration then v12.Font.Footer.Font else nil

				local v96 = if foundationFontFaceMigration then normalizeFontFace(v14.Typography.CaptionSmall.Font) else nil
				local v94 = {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Font = v95,
					FontFace = v96,
					Size = v67(),
					AnchorPoint = 0,
					Position = 0,
					Text = 0,
					TextColor3 = 0,
					TextSize = 0,
					TextTransparency = 0,
					TextXAlignment = 0,
					TextYAlignment = 0
				}
				local v97 = if isIncoming then Vector2.new(0, 0) else Vector2.new(1, 0)
				v94.AnchorPoint = v97
				local v98 = if isIncoming then UDim2.fromScale(0, 0) else UDim2.fromScale(1, 0)
				v94.Position = v98
				v94.Text = displayName
				v94.TextColor3 = v12.Theme.TextDefault.Color
				v94.TextSize = v12.Font.BaseSize * v12.Font.Footer.RelativeSize
				v94.TextTransparency = v12.Theme.TextDefault.Transparency

				local v99 = if isIncoming then Enum.TextXAlignment.Left else Enum.TextXAlignment.Right
				v94.TextXAlignment = v99

				v94.TextYAlignment = Enum.TextYAlignment.Top
				v92 = createElement5("TextLabel", v94)
			end

			v87.DisplayName = v92
			local v93

			if v60 then
				local createElement5 = React.createElement
				local v96 = if isIncoming then Vector2.new(0, 0) else Vector2.new(1, 0)
				local v97 = if isIncoming then UDim2.fromScale(0, 0) else UDim2.fromScale(1, 0)
				v93 = createElement5(skeleton, {
					AnchorPoint = v96,
					Position = v97,
					Size = UDim2.new(0, ChatMessageContainerConstants.SHIMMER_WIDTH, 0, ChatMessageContainerConstants.SHIMMER_HEIGHT),
					LayoutOrder = 2
				})
			end

			v87.ShimmerName = v93
			v84 = createElement3("Frame", v86, v87)
		end

		v83.DisplayNameContainer = v84

		local createElement3 = React.createElement
		local v86 = {}
		v86.BackgroundTransparency = 1
		v86.BorderSizePixel = 0
		v86.LayoutOrder = 2
		v86.AutomaticSize = Enum.AutomaticSize.Y

		local v87 = if FFlagAppChatConsoleFocusFixes then UDim2.new(1, 0, 0, 0) else UDim2.new(1, joined.isIncoming and -v69 or 0, 0, 0)
		v86.Size = v87

		v86.Selectable = if FFlagAppChatConsoleFocusFixes then not v8 else nil
		v86.ref = if FFlagAppChatConsoleFocusFixes then v21 else nil
		local selectionGained = React.Event.SelectionGained
		v86[selectionGained] = if FFlagAppChatConsoleFocusFixes then v22 else nil
		local v91 = {
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
				[React.Event.InputBegan] = v52,
				[React.Event.InputEnded] = v53,
				[React.Event.TouchTap] = v56,
				[React.Event.MouseButton1Down] = v57
			}, {
				isPressed = state,
				Icons = v73,
				bubbleRef = if FFlagAppChatConsoleFocusFixes then ref2 else nil,
				ref = ref
			}),
			MessageFtuxTooltip = 0
		}

		local v95 = if joined.isLastIncomingChatMessage and not v8 then React.createElement(messageFtuxTooltip, {
			variant = messageFtuxTooltipVariant.Replies,
			messageRef = ref,
			isReversed = joined.isIncoming
		}) else nil
		v91.MessageFtuxTooltip = v95
		v83.MessageWithIcons = createElement3("Frame", v86, v91)
		v79.MessageWithDisplayName = createElement2("Frame", v82, v83)
		local element = createElement("Frame", v78, v79)

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
					name = v15.iconName,
					size = Foundation.Enums.IconSize.Medium,
					variant = Foundation.Enums.IconVariant.Filled,
					AnchorPoint = v15.iconAnchorPoint,
					Position = v76,
					style = v74,
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
	local v78 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		["AutomaticSize"] = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		Text = getFFlagDebugAppChat() and "" or nil
	}
	local activated = React.Event.Activated

	if not getFFlagDebugAppChat() then
		v70 = nil
	end

	v78[activated] = v70
	local v79 = {
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

	if v71 then
		local createElement2 = React.createElement
		local v81 = {
			Font = joined.Font,
			HorizontalAlignment = left2,
			LayoutOrder = 3,
			Text = v72,
			TextColor3 = 0,
			TextTransparency = 0,
			TextXAlignment = 0,
			TextSize = 0,
			margin = 0,
			maxWidth = 0,
			width = 0
		}

		local v82 = if v8 then v14.Color.Content.Muted.Color3 else joined.moderated and v12.Theme.Alert.Color or v12.Theme.UIDefault.Color
		v81.TextColor3 = v82

		local v83 = if v8 then v14.Color.Content.Muted.Transparency else joined.moderated and v12.Theme.Alert.Transparency or v12.Theme.UIDefault.Transparency
		v81.TextTransparency = v83

		v81.TextXAlignment = joined.isIncoming and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right
		v81.TextSize = v14.Typography.CaptionSmall.FontSize

		v81.margin = {
			top = v14.Padding.Small,
			left = joined.isIncoming and v69 + ChatMessageContainerConstants.NOTICE_HORIZONTAL_PADDING or 0,
			right = joined.isIncoming and 0 or v13.right or 0,
			bottom = 0
		}

		v81.maxWidth = joined.parentWidth
		v81.width = UDim.new(1, joined.isIncoming and -v69 or 0)
		v71 = createElement2(NoticeText, v81)
	end

	v79.Notice = v71

	v79.debug = joined.debugElement or nil
	return createElement(v7, v78, v79)
end

return LUAUFORGE_MODULE_GLOBALS_hnc_ChatMessageContainer
