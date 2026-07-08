local IXPService = game:GetService("IXPService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local setTimeout = require(AppChatParent.LuauPolyfill).setTimeout
local React = require(AppChatParent.React)
local useStyle = require(AppChatParent.UIBlox).Core.Style.useStyle
local useNavigation = require(AppChatParent.Navigation).useNavigation
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local Options = require(AppChat.Components.ChatConversation.MessageInteraction.Options)
local OptionsEnum = require(AppChat.Components.ChatConversation.MessageInteraction.OptionsEnum)
local ChatMessageContainerConstants = require(script.Parent.ChatMessageContainerConstants)
local EnumScreens = require(AppChat.EnumScreens)
local Cryo = require(AppChatParent.Cryo)
local Foundation = require(AppChatParent.Foundation)
local Skeleton = Foundation.Skeleton
local useLocalUserId = require(AppChatParent.RobloxAppHooks).useLocalUserId
local Conversation = require(AppChat.Models.Conversation)

require(AppChat.Analytics.EventNames)

local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local Logger = require(script.Parent.Logger)
local NoticeText = require(script.Parent.NoticeText)
local SystemMessage = require(script.Parent.SystemMessage)
local UserProfiles = require(AppChatParent.UserProfiles)
local ChatConversationTelemetryEvents = require(AppChat.Components.ChatConversation.ChatConversationTelemetryEvents)
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local GlobalLongPressSignal = require(AppChat.Components.ChatConversation.Utils.GlobalLongPressSignal)
local MessageFtuxTooltip = require(script.Parent.MessageFtuxTooltip)
local MessageFtuxTooltip2 = MessageFtuxTooltip.MessageFtuxTooltip
local MessageFtuxTooltipVariant = MessageFtuxTooltip.MessageFtuxTooltipVariant
local MessageFtuxTooltipDismissSignal = MessageFtuxTooltip.MessageFtuxTooltipDismissSignal
local SwipeDirection = require(AppChat.Enums.SwipeDirection)
local getFFlagDebugAppChat = require(AppChat.Flags.getFFlagDebugAppChat)
local GetReplyingToStore = require(AppChat.Stores.GetReplyingToStore)
local useReplyingToMessageDispatch = require(AppChat.Components.ChatConversation.MessageInteraction.ReplyingContext.useReplyingToMessageDispatch)
local FFlagAppChatSignalsReplyStore = require(AppChat.Flags.FFlagAppChatSignalsReplyStore)
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local useTriggerFeedback = require(AppChatParent.InteractionFeedback).useTriggerFeedback
local HapticFeedbackContext = require(AppChat.Utils.HapticFeedback).HapticFeedbackContext
local HapticFeedbackType = require(AppChat.Utils.HapticFeedback).HapticFeedbackType
local useSwipeGesture = require(AppChat.Hooks.useSwipeGesture)
local UserTile = require(AppChatParent.UserTile).UserTile
local LayoutMode = require(AppChatParent.UserTile).LayoutMode
local UserPresence = require(AppChatParent.Foundation).Enums.UserPresence
local FFlagAppChatEnableMessageContextMenu = require(AppChat.Flags.FFlagAppChatEnableMessageContextMenu)
local v47 = game:DefineFastFlag("AppChatEnableRepliesUIIxpEnabled2", false)
local v48 = game:DefineFastString("AppChatEnableRepliesUIIxpLayer1", "Party.ConversationPage")
local v49 = game:DefineFastInt("AppChatMessageLongPressDistanceThreshold", 25)
local MessageModel = require(AppChat.Models.MessageModel)
local FFlagAppChatUseSwipeForReplies = require(AppChat.Flags.FFlagAppChatUseSwipeForReplies)
local v52 = game:DefineFastFlag("AppChatUseSymmetricSwipe", false)
local v53 = game:DefineFastInt("AppChatReplyIconSwipeOffset", 25)
local FFlagAppChatSignalsMessageStore = require(AppChat.Flags.FFlagAppChatSignalsMessageStore)
local v55 = if not FFlagAppChatSignalsMessageStore then nil else require(AppChat.Stores.GetConversationMessageViewModelStore)
local uDim2 = UDim2.new(0, 0, 0.5, 0)
local uDim2_2 = UDim2.new(1, 0, 0.5, 0)
local vector2 = Vector2.new(0, 0.5)
local vector2_2 = Vector2.new(1, 0.5)
local t1 = {
	failed = false,
	filteredForReceivers = false,
	isIncoming = false,
	isNewSender = false,
	parentWidth = 0,
	messageId = "",
	conversationId = "",
	messageType = nil,
	messageTypePaddingOffset = 0,
	moderated = false,
	messageMaxWidth = 0,
	inputBoxRef = nil,
	viewProfileOnAvatarPressed = true,
	messageDefaultNoticeText = "PLACEHOLDER Not everyone in this chat can see your message.",
	messageModeratedNoticeText = "PLACEHOLDER Your message was moderated and not sent.",
	messageHiddenNoticeText = "PLACEHOLDER This message is not available",
	unknownUserKey = "Feature.Chat.Label.UnknownUser",
	isPending = false,
	visibility = nil,
	unitTestTouchEnabled = false,
	Font = Enum.Font.Gotham,
	openViewProfile = function() -- line: 92
		-- upvalues: Logger (copy)
		Logger:warning("openViewProfile was not passed to ChatMessage")
	end,
	renderMessage = function() -- line: 95
		-- upvalues: Logger (copy)
		Logger:warning("renderMessage was not passed to ChatMessage")
	end,
	closeKeyboard = function() -- line: 98
	end
}
local v61 = not getFFlagDebugAppChat() and "Frame" or "TextButton"

function ChatMessageContainer(p1) -- line: 113
	-- upvalues: Cryo (copy), t1 (copy), MessageModel (copy), React (copy), useStyle (copy), useChatPagePadding (copy), Foundation (copy), FFlagAppChatUseSwipeForReplies (copy), v52 (copy), SwipeDirection (copy), uDim2 (copy), uDim2_2 (copy), v53 (copy), vector2 (copy), vector2_2 (copy), useTelemetry (copy), ChatConversationTelemetryLayer (copy), useTriggerFeedback (copy), GlobalLongPressSignal (copy), MessageFtuxTooltipDismissSignal (copy), MessageFtuxTooltipVariant (copy), ChatConversationTelemetryEvents (copy), useNavigation (copy), useGetConversationFromId (copy), FFlagAppChatSignalsReplyStore (copy), GetReplyingToStore (copy), FFlagAppChatSignalsMessageStore (copy), v55 (copy), useReplyingToMessageDispatch (copy), useLocalUserId (copy), HapticFeedbackContext (copy), HapticFeedbackType (copy), useSwipeGesture (copy), EnumScreens (copy), setTimeout (copy), v49 (copy), UserInputService (copy), FFlagAppChatEnableMessageContextMenu (copy), ChatMessageContainerConstants (copy), OptionsEnum (copy), Conversation (copy), UserProfiles (copy), useLocalization (copy), TextService (copy), getFFlagDebugAppChat (copy), Options (copy), UserTile (copy), LayoutMode (copy), UserPresence (copy), Skeleton (copy), MessageFtuxTooltip2 (copy), v47 (copy), IXPService (copy), v48 (copy), v61 (copy), SystemMessage (copy), NoticeText (copy)
	local v63 = Cryo.Dictionary.join(t1, p1)
	local v64 = not not v63.visibility and v63.visibility == MessageModel.VisibilityTypes.Hidden
	local v65 = React.useCallback(function() -- line: 118
		-- upvalues: v63 (copy)
		if v63.viewProfileOnAvatarPressed then
			v63.openViewProfile(v63.senderUserId)
		end
	end, { v63.senderUserId })
	local v66 = useStyle()
	local shouldShowName = v63.shouldShowName
	local v68 = useChatPagePadding()
	local v69 = Foundation.Hooks.useTokens()
	local u70 = nil
	local u71 = nil

	if FFlagAppChatUseSwipeForReplies then
		u71 = React.useMemo(function() -- line: 139
			-- upvalues: v52 (copy), v63 (copy), SwipeDirection (copy), Foundation (copy), uDim2 (copy), uDim2_2 (copy), v53 (copy), vector2 (copy), vector2_2 (copy)
			if v52 then
				return {
					direction = if not v63.isIncoming then SwipeDirection.Left else SwipeDirection.Right,
					iconName = if not v63.isIncoming then Foundation.Enums.IconName.ArrowThickToLeft else Foundation.Enums.IconName.ArrowThickToRight,
					messagePosition = if not v63.isIncoming then uDim2_2 else uDim2,
					iconOffset = if not v63.isIncoming then -v53 else v53,
					iconAnchorPoint = if not v63.isIncoming then vector2_2 else vector2
				}
			end

			return {
				direction = SwipeDirection.Right,
				iconName = Foundation.Enums.IconName.ArrowThickToRight,
				messagePosition = uDim2,
				iconOffset = v53,
				iconAnchorPoint = vector2
			}
		end, {})
	end

	local u72 = nil
	local v73 = React.useRef(nil)
	local v74 = React.useRef(Vector2.zero)
	local v75 = useTelemetry(ChatConversationTelemetryLayer.Context)
	local v76 = useTriggerFeedback()
	local v77, v78 = React.useState(false)
	local u79 = v77
	local v80, v81 = React.useState(false)
	local v82, v83 = React.useState(false)

	React.useEffect(function() -- line: 179
		-- upvalues: GlobalLongPressSignal (copy), v83 (copy)
		local v129 = GlobalLongPressSignal.dismissed:connect(function() -- line: 180
			-- upvalues: v83 (copy)
			v83(false)
		end)

		return function() -- line: 183
			-- upvalues: v129 (copy)
			v129:disconnect()
		end
	end)

	local v84 = React.useMemo(function() -- line: 189
		-- upvalues: v63 (copy)
		return {
			conversationId = v63.conversationId,
			targetMessageSenderId = v63.senderUserId,
			targetMessageId = v63.messageId,
			targetMessageSentAt = if not v63.sent then nil else v63.sent.dateTime,
			targetMessageLength = if not v63.content then nil else #v63.content,
			targetMessageVisibility = v63.visibility
		}
	end, {
		v63.conversationId,
		v63.senderUserId,
		v63.messageId,
		v63.sent,
		v63.content,
		v63.visibility
	})
	local u85 = React.useMemo(function() -- line: 209
		-- upvalues: v64 (copy), v80 (copy), FFlagAppChatUseSwipeForReplies (copy), v82 (copy)
		return not v64 and (v80 or not FFlagAppChatUseSwipeForReplies and v82)
	end, {
		v80,
		v82,
		v64
	})

	React.useEffect(function() -- line: 214
		-- upvalues: u85 (ref), v63 (copy), MessageFtuxTooltipDismissSignal (copy), MessageFtuxTooltipVariant (copy)
		if u85 and v63.isLastIncomingChatMessage then
			MessageFtuxTooltipDismissSignal.dismiss(MessageFtuxTooltipVariant.Replies)
		end
	end, {
		u85,
		v63.isLastIncomingChatMessage
	})

	local v86 = React.useCallback(function() -- line: 219
		-- upvalues: v75 (copy), ChatConversationTelemetryEvents (copy), v84 (copy)
		v75.emit(ChatConversationTelemetryEvents.ConversationMessageReplyIconImpression, v84)
	end, {
		v75,
		v84
	})
	local u87 = useNavigation()
	local u88 = useGetConversationFromId(v63.conversationId)
	local v89 = if not FFlagAppChatSignalsReplyStore then nil else GetReplyingToStore(false)
	local u90 = nil

	if FFlagAppChatSignalsMessageStore and v55 then
		local v91 = v55(false).conversationMessageStore.messages[v63.messageId]

		u90 = if not v91 then nil else MessageModel.fromChannelsApi(v91, v63.conversationId)
	elseif u88 and u88.messages then
		u90 = u88.messages:Get(v63.messageId)
	end

	local v92 = useReplyingToMessageDispatch()
	local u93 = useLocalUserId()

	if FFlagAppChatUseSwipeForReplies then
		local v94 = React.useCallback(function() -- line: 244
			-- upvalues: v64 (copy), v76 (copy), HapticFeedbackContext (copy), HapticFeedbackType (copy)
			if not v64 then
				v76(HapticFeedbackContext.Default, HapticFeedbackType.Press)
			end
		end, {})
		local v95 = React.useCallback(function() -- line: 251
			-- upvalues: ChatConversationTelemetryEvents (copy), v75 (copy), v84 (copy), v64 (copy), FFlagAppChatSignalsReplyStore (copy), v89 (copy), v63 (copy), v92 (copy), u90 (ref)
			if ChatConversationTelemetryEvents.ConversationMessageSwiped then
				v75.emit(ChatConversationTelemetryEvents.ConversationMessageSwiped, v84)
			end

			if not v64 then
				if FFlagAppChatSignalsReplyStore and v89 then
					v89.setReplyingTo(v63.messageId)

					return
				end

				v92(u90)
			end
		end, {
			v92,
			u90,
			v75,
			v84,
			v64,
			if not FFlagAppChatSignalsReplyStore then nil else v89,
			if not FFlagAppChatSignalsReplyStore then nil else v63.messageId
		})

		u70 = useSwipeGesture({
			onSwipeThresholdReached = v94,
			onSwipeComplete = v95,
			direction = u71.direction
		})
	end

	local v96 = React.useCallback(function() -- line: 281
		-- upvalues: u87 (ref), EnumScreens (copy), v63 (copy)
		u87.navigate(EnumScreens.MessageContextMenu, {
			messageId = v63.messageId,
			conversationId = v63.conversationId,
			inputBoxRef = v63.inputBoxRef
		})
	end, {
		u87.navigate,
		v63.messageId,
		v63.conversationId,
		v63.inputBoxRef
	})
	local v97 = React.useCallback(function(p2, p3, n1: number) -- line: 290
		-- upvalues: v74 (copy), setTimeout (copy), v49 (copy), u72 (ref)
		if p3 then
			v74.current = Vector2.new(p3.Position.X, p3.Position.Y)
		end

		setTimeout(function() -- line: 294
			-- upvalues: p3 (copy), v74 (copy), v49 (copy), u72 (ref), p2 (copy)
			local n2 = 0

			if p3 then
				local current = v74.current

				n2 = (Vector2.new(p3.Position.X, p3.Position.Y) - current).Magnitude
			end

			if p3 and ((p3.UserInputState == Enum.UserInputState.Begin or p3.UserInputState == Enum.UserInputState.Change) and n2 < v49) then
				u72(p2, p3)
			end
		end, n1)
	end, { u72 })

	u72 = React.useCallback(function(p4, p5, s1: string?) -- line: 317
		-- upvalues: v63 (copy), UserInputService (copy), React (copy), v81 (copy), v75 (copy), ChatConversationTelemetryEvents (copy), v84 (copy), v64 (copy), FFlagAppChatUseSwipeForReplies (copy), v76 (copy), HapticFeedbackContext (copy), HapticFeedbackType (copy), v83 (copy), FFlagAppChatEnableMessageContextMenu (copy), v96 (copy), v97 (copy), ChatMessageContainerConstants (copy), v82 (copy), GlobalLongPressSignal (copy), OptionsEnum (copy), FFlagAppChatSignalsReplyStore (copy), v89 (copy), v92 (copy), u90 (ref)
		if v63.isPending then
			return
		end

		if UserInputService.MouseEnabled then
			if p4 == React.Event.MouseEnter then
				v81(true)
			end

			if p4 == React.Event.MouseLeave then
				v81(false)
			end

			if p4 == React.Event.MouseButton1Down then
				v63.closeKeyboard()
			end
		end

		if UserInputService.GamepadEnabled or UserInputService.TouchEnabled or v63.unitTestTouchEnabled then
			if p4 == React.Event.TouchLongPress then
				v75.emit(ChatConversationTelemetryEvents.ConversationMessageLongPressed, v84)

				if not v64 then
					if not FFlagAppChatUseSwipeForReplies then
						v76(HapticFeedbackContext.Default, HapticFeedbackType.Release)
					end

					v83(true)

					if FFlagAppChatEnableMessageContextMenu then
						v96()
					end

					v97(React.Event.InputEnded, p5, ChatMessageContainerConstants.PEEK_VIEW_ANIMATION_MILLISEC)
				end
			end

			if p4 == React.Event.InputBegan and p5 then
				v75.emit(ChatConversationTelemetryEvents.ConversationMessagePressed, v84)

				if not v64 and not v82 then
					GlobalLongPressSignal.dismiss()
				end

				v97(React.Event.TouchLongPress, p5, ChatMessageContainerConstants.LONG_PRESS_DELAY_MILLISEC)
			end

			if p4 == React.Event.TouchTap then
				v63.closeKeyboard()
			end
		end

		if p4 == React.Event.Activated then
			GlobalLongPressSignal.dismiss()

			if s1 == OptionsEnum.MessageContextMenu then
				if ChatConversationTelemetryEvents.ConversationMessageOpenMenuIconClicked then
					v75.emit(ChatConversationTelemetryEvents.ConversationMessageOpenMenuIconClicked, v84)
				end

				v96()
			end

			if s1 == OptionsEnum.Reply then
				v75.emit(ChatConversationTelemetryEvents.ConversationMessageReplyIconClicked, v84)
				v76(HapticFeedbackContext.Default, HapticFeedbackType.Press)

				if FFlagAppChatSignalsReplyStore and v89 then
					v89.setReplyingTo(v63.messageId)

					return
				end

				v92(u90)
			end
		end
	end, {
		v63.isPending,
		v63.unitTestTouchEnabled,
		UserInputService.MouseEnabled,
		UserInputService.TouchEnabled,
		v97,
		v81,
		v83,
		v78,
		v75,
		v96,
		v92,
		v76,
		v64,
		if not FFlagAppChatSignalsReplyStore then nil else v89,
		if not FFlagAppChatSignalsReplyStore then nil else u90,
		if not FFlagAppChatSignalsReplyStore then nil else v63.messageId
	})

	local u98 = React.useCallback(function(p6, p7) -- line: 419
		-- upvalues: FFlagAppChatUseSwipeForReplies (copy), UserInputService (copy), u70 (ref), MessageFtuxTooltipDismissSignal (copy), MessageFtuxTooltipVariant (copy), v97 (copy), React (copy), ChatMessageContainerConstants (copy)
		if FFlagAppChatUseSwipeForReplies and (UserInputService.TouchEnabled and u70) then
			u70.onInputBegan(p6, p7)
			MessageFtuxTooltipDismissSignal.dismiss(MessageFtuxTooltipVariant.Replies)
		end

		v97(React.Event.InputBegan, p7, ChatMessageContainerConstants.INPUT_BEGAN_DELAY_MILLISEC)
	end, {
		v97,
		u70
	})
	local u99 = React.useCallback(function(_) -- line: 428
		-- upvalues: u72 (ref), React (copy)
		u72(React.Event.InputEnded)
	end, { u72 })
	local u100 = React.useCallback(function(_) -- line: 432
		-- upvalues: u72 (ref), React (copy)
		u72(React.Event.MouseEnter)
	end, { u72 })
	local u101 = React.useCallback(function(_) -- line: 436
		-- upvalues: u72 (ref), React (copy)
		u72(React.Event.MouseLeave)
	end, { u72 })
	local u102 = React.useCallback(function(_) -- line: 440
		-- upvalues: u72 (ref), React (copy)
		u72(React.Event.TouchTap)
	end, { u72 })
	local u103 = React.useCallback(function(_) -- line: 444
		-- upvalues: u72 (ref), React (copy)
		u72(React.Event.MouseButton1Down)
	end, { u72 })
	local v104 = v63.repliesTo and v63.repliesTo.senderTargetId

	local function getDisplayNameText(p13, p14) -- line: 450
		-- upvalues: u93 (ref), v63 (copy), v104 (copy), u88 (ref), Conversation (copy)
		local v145 = u93 == v63.senderUserId
		local v146 = v63.senderUserId == v63.repliesTo.senderTargetId
		local v147 = u93 == v63.repliesTo.senderTargetId

		if not v104 then
			return p13
		end

		if v145 and v146 then
			return "Feature.Chat.Label.YouRepliedToYou"
		end

		if u88.conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION then
			if v145 and not v146 then
				return "Feature.Chat.Label.OneToOne.YouRepliedToThem"
			end

			if not v145 and v147 then
				return "Feature.Chat.Label.OneToOne.ThemRepliedToYou"
			end

			if not v145 and v146 then
				return "Feature.Chat.Label.OneToOne.ThemRepliedToThem"
			end
		end

		if u88.conversationType == Conversation.Type.MULTI_USER_CONVERSATION then
			if v145 and not v146 then
				return {
					"Feature.Chat.Label.Group.YouRepliedToThem",
					DISPLAY_NAME = p14
				}
			end

			if not v145 and v147 then
				return {
					"Feature.Chat.Label.Group.ThemRepliedToYou",
					DISPLAY_NAME = p13
				}
			end

			if not v145 and v146 then
				return {
					"Feature.Chat.Label.Group.ThemRepliedToThem",
					DISPLAY_NAME = p13
				}
			end

			if not v145 and not v147 then
				return {
					"Feature.Chat.Label.Group.ThemRepliedToOther",
					DISPLAY_NAME_1 = p13,
					DISPLAY_NAME_2 = p14
				}
			end
		end

		return v63.unknownUserKey
	end

	local t2 = { v63.senderUserId }

	if v104 then
		table.insert(t2, v63.repliesTo.senderTargetId)
	end

	local v107 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = t2,
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})
	local u108, v110

	if v107.data then
		u108 = false

		local v109 = UserProfiles.Selectors.getCombinedNameFromId(v107.data, v63.senderUserId) or v63.unknownUserKey

		v110 = if not v104 then v109 else getDisplayNameText(v109, UserProfiles.Selectors.getCombinedNameFromId(v107.data, v63.repliesTo.senderTargetId) or v63.unknownUserKey)
	else
		u108 = true
		v110 = nil
	end

	local u111 = useLocalization((if not v104 then {} else {
		displayName = v110
	})).displayName or v110
	local v112 = React.useCallback(function() -- line: 542
		-- upvalues: v63 (copy), ChatMessageContainerConstants (copy), TextService (copy), u111 (ref), v66 (copy)
		local vector2_3 = Vector2.new(math.max(1, v63.messageMaxWidth - ChatMessageContainerConstants.TAIL_WIDTH), 1e999)
		local TextSize = TextService:GetTextSize(u111, v66.Font.BaseSize * v66.Font.Footer.RelativeSize, v66.Font.Footer.Font, vector2_3)

		return UDim2.new(0, TextSize.X, 0, TextSize.Y)
	end, {
		v66.Font.BaseSize * v66.Font.Footer.RelativeSize,
		v66.Font.Footer.Font,
		v63.messageMaxWidth - ChatMessageContainerConstants.TAIL_WIDTH,
		u111
	})
	local n3 = 0

	if not v63.showDateTime then
		n3 = ((if not v63.isNewSender and not v104 then ChatMessageContainerConstants.CHAT_MESSAGE_MIN_SPACE else ChatMessageContainerConstants.CHAT_MESSAGE_MAX_SPACE)) + v63.messageTypePaddingOffset
	end

	local left = v68.left
	local v115 = left + v69.Size.Size_700
	local v116 = v63.isIncoming and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right
	local v117, v118 = React.useState(false)
	local v119 = React.useCallback(function() -- line: 570
		-- upvalues: getFFlagDebugAppChat (copy), v118 (copy)
		if getFFlagDebugAppChat() then
			v118(function(p15) -- line: 572
				return not p15
			end)
		end
	end, { v118 })
	local v120 = v117 or (v63.moderated or (v63.filteredForReceivers or v64))
	local v121 = if not v117 then if not v64 then v63.moderated and v63.messageModeratedNoticeText or v63.messageDefaultNoticeText else v63.messageHiddenNoticeText else v63.messageId
	local v122 = React.useMemo(function() -- line: 584
		-- upvalues: React (copy), Foundation (copy), v69 (copy), v63 (copy)
		return React.createElement(Foundation.Icon, {
			name = Foundation.Enums.IconName.TriangleExclamation,
			size = Foundation.Enums.IconSize.Large,
			style = v69.Color.System.Alert,
			LayoutOrder = not v63.isIncoming and 3 or 0
		})
	end, {
		v69,
		v66,
		v63.isIncoming
	})
	local u123 = if not v63.failed and not v63.moderated then if not u85 then nil else React.createElement(Options, {
		LayoutOrder = not v63.isIncoming and 1 or 2,
		isIncoming = v63.isIncoming,
		handleEvent = u72,
		emitImpressionTelemetryEvent = v86
	}) else v122
	local isIncoming = v63.isIncoming
	local v125 = if not FFlagAppChatUseSwipeForReplies or (not u70 or not u70.swipeProgress) then nil else u70.swipeProgress:map(function(n4: number) -- line: 612
		-- upvalues: v69 (copy)
		local v151 = 1 - math.pow(n4, 3)

		return {
			Color3 = v69.Color.Content.Default.Color3,
			Transparency = v151
		}
	end)
	local v126 = if not FFlagAppChatUseSwipeForReplies or (not u70 or not u70.swipeOffset) then nil else u70.swipeOffset:map(function(n5: number) -- line: 625
		-- upvalues: u71 (ref), SwipeDirection (copy)
		local v153 = if u71.direction ~= SwipeDirection.Right then -n5 else n5

		return UDim2.new(0, v153, 0, 0)
	end)
	local v127 = if not FFlagAppChatUseSwipeForReplies or (not u70 or not u70.swipeProgress) then nil else u70.swipeProgress:map(function(n6: number) -- line: 635
		-- upvalues: u71 (ref)
		return u71.messagePosition + UDim2.new(0, n6 * u71.iconOffset, 0, 0)
	end)

	local function renderMessage() -- line: 641
		-- upvalues: React (copy), FFlagAppChatUseSwipeForReplies (copy), v126 (copy), u100 (ref), u101 (ref), n3 (ref), v63 (copy), left (copy), v115 (copy), v68 (copy), v116 (copy), Foundation (copy), UserTile (copy), LayoutMode (copy), UserPresence (copy), v65 (copy), v69 (copy), shouldShowName (copy), ChatMessageContainerConstants (copy), isIncoming (copy), v104 (copy), u108 (ref), v66 (copy), v112 (copy), u111 (ref), Skeleton (copy), u98 (ref), u99 (ref), u102 (ref), u103 (ref), u79 (ref), u123 (ref), v73 (copy), v64 (copy), MessageFtuxTooltip2 (copy), MessageFtuxTooltipVariant (copy), u71 (ref), v127 (copy), v125 (copy)
		local v155 = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			Position = if not FFlagAppChatUseSwipeForReplies then nil else v126,
			[React.Event.MouseEnter] = u100,
			[React.Event.MouseLeave] = u101
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, n3),
				PaddingLeft = UDim.new(0, v63.thumbnail and left or v115),
				PaddingRight = UDim.new(0, v68.right - 0)
			}),
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = v116
			}),
			AvatarContainer = if not v63.thumbnail then nil else React.createElement(Foundation.View, {
				LayoutOrder = 1,
				tag = {
					["col auto-x size-0-full"] = true,
					["align-y-top"] = false
				}
			}, {
				Avatar = React.createElement(Foundation.View, {
					tag = "size-700-700"
				}, {
					AvatarCircle = React.createElement(UserTile, {
						layoutOrder = 1,
						userId = v63.senderUserId,
						layoutMode = LayoutMode.compact,
						userPresenceType = UserPresence.None,
						onActivated = v65
					})
				})
			}),
			MessageWithDisplayName = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, v63.isIncoming and -v115 or 0, 0, 0)
			}, {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = v116
				}),
				Padding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v63.isIncoming and v69.Size.Size_200 or 0)
				}),
				DisplayNameContainer = shouldShowName and React.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					Size = UDim2.new(0, v63.messageMaxWidth - ChatMessageContainerConstants.TAIL_WIDTH, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					Padding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, ChatMessageContainerConstants.GROUPED_MESSAGE_DISPLAY_NAME_LEFT_PADDING),
						PaddingRight = if not isIncoming then UDim.new(0, ChatMessageContainerConstants.TAIL_WIDTH) else UDim.new(0, 0),
						PaddingBottom = if not v104 then UDim.new(0, ChatMessageContainerConstants.GROUPED_MESSAGE_DISPLAY_NAME_BOTTOM_PADDING) else UDim.new(0, ChatMessageContainerConstants.REPLIED_DISPLAY_NAME_BOTTOM_PADDING)
					}),
					DisplayName = if u108 then nil else React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Font = v66.Font.Footer.Font,
						Size = v112(),
						AnchorPoint = if not isIncoming then Vector2.new(1, 0) else Vector2.new(0, 0),
						Position = if not isIncoming then UDim2.fromScale(1, 0) else UDim2.fromScale(0, 0),
						Text = u111,
						TextColor3 = v66.Theme.TextDefault.Color,
						TextSize = v66.Font.BaseSize * v66.Font.Footer.RelativeSize,
						TextTransparency = v66.Theme.TextDefault.Transparency,
						TextXAlignment = if not isIncoming then Enum.TextXAlignment.Right else Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top
					}),
					ShimmerName = if not u108 then nil else React.createElement(Skeleton, {
						LayoutOrder = 2,
						AnchorPoint = if not isIncoming then Vector2.new(1, 0) else Vector2.new(0, 0),
						Position = if not isIncoming then UDim2.fromScale(1, 0) else UDim2.fromScale(0, 0),
						Size = UDim2.new(0, ChatMessageContainerConstants.SHIMMER_WIDTH, 0, ChatMessageContainerConstants.SHIMMER_HEIGHT)
					})
				}),
				MessageWithIcons = React.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 2,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, v63.isIncoming and -v115 or 0, 0, 0)
				}, {
					Layout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = v116,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 10),
						ItemLineAlignment = Enum.ItemLineAlignment.Center
					}),
					Message = v63.renderMessage({
						LayoutOrder = not v63.isIncoming and 2 or 1,
						[React.Event.InputBegan] = u98,
						[React.Event.InputEnded] = u99,
						[React.Event.TouchTap] = u102,
						[React.Event.MouseButton1Down] = u103
					}, {
						isPressed = u79,
						Icons = u123,
						ref = v73
					}),
					MessageFtuxTooltip = if not v63.isLastIncomingChatMessage or v64 then nil else React.createElement(MessageFtuxTooltip2, {
						variant = MessageFtuxTooltipVariant.Replies,
						messageRef = v73,
						isReversed = v63.isIncoming
					})
				})
			})
		})

		if FFlagAppChatUseSwipeForReplies and not v64 then
			return React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y",
				ClipsDescendants = false,
				LayoutOrder = 2,
				ZIndex = 2
			}, {
				ReplyIconFilled = React.createElement(Foundation.Icon, {
					ZIndex = 1,
					name = u71.iconName,
					size = Foundation.Enums.IconSize.Medium,
					variant = Foundation.Enums.IconVariant.Filled,
					AnchorPoint = u71.iconAnchorPoint,
					Position = v127,
					style = v125
				}),
				Content = v155
			})
		end

		return v155
	end

	React.useEffect(function() -- line: 799
		-- upvalues: v47 (copy), v63 (copy), IXPService (copy), v48 (copy)
		if v47 and v63.isLastIncomingChatMessage then
			IXPService:LogFlagLinkedUserLayerExposure(v48)
		end
	end, { v63.isLastIncomingChatMessage })

	return React.createElement(v61, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		Text = if not getFFlagDebugAppChat() then nil else "",
		[React.Event.Activated] = if not getFFlagDebugAppChat() then nil else v119
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = v116,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		DateTime = v63.showDateTime and React.createElement(SystemMessage, {
			LayoutOrder = 1,
			Text = v63.sent:GetLongRelativeTime(),
			maxWidth = ChatMessageContainerConstants.DATETIME_MAX_WIDTH
		}),
		MessageWithAvatar = renderMessage(),
		Notice = v120 and React.createElement(NoticeText, {
			LayoutOrder = 3,
			Font = v63.Font,
			HorizontalAlignment = v116,
			Text = v121,
			TextColor3 = if not v64 then v63.moderated and v66.Theme.Alert.Color or v66.Theme.UIDefault.Color else v69.Color.Content.Muted.Color3,
			TextTransparency = if not v64 then v63.moderated and v66.Theme.Alert.Transparency or v66.Theme.UIDefault.Transparency else v69.Color.Content.Muted.Transparency,
			TextXAlignment = v63.isIncoming and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right,
			TextSize = v69.Typography.CaptionSmall.FontSize,
			margin = {
				bottom = 0,
				top = v69.Padding.Small,
				left = v63.isIncoming and v115 + ChatMessageContainerConstants.NOTICE_HORIZONTAL_PADDING or 0,
				right = not v63.isIncoming and v68.right or 0
			},
			maxWidth = v63.parentWidth,
			width = UDim.new(1, v63.isIncoming and -v115 or 0)
		}),
		debug = v63.debugElement or nil
	})
end

return ChatMessageContainer
