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
local getReplyLabelDescriptor = require(AppChat.Utils.getReplyLabelDescriptor)

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
local v48 = game:DefineFastFlag("AppChatEnableRepliesUIIxpEnabled2", false)
local v49 = game:DefineFastString("AppChatEnableRepliesUIIxpLayer1", "Party.ConversationPage")
local v50 = game:DefineFastInt("AppChatMessageLongPressDistanceThreshold", 25)
local MessageModel = require(AppChat.Models.MessageModel)
local FFlagAppChatUseSwipeForReplies = require(AppChat.Flags.FFlagAppChatUseSwipeForReplies)
local v53 = game:DefineFastFlag("AppChatUseSymmetricSwipe", false)
local v54 = game:DefineFastInt("AppChatReplyIconSwipeOffset", 25)
local FFlagAppChatSignalsMessageStore = require(AppChat.Flags.FFlagAppChatSignalsMessageStore)
local v56 = if not FFlagAppChatSignalsMessageStore then nil else require(AppChat.Stores.GetConversationMessageViewModelStore)
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
	openViewProfile = function() -- line: 93
		-- upvalues: Logger (copy)
		Logger:warning("openViewProfile was not passed to ChatMessage")
	end,
	renderMessage = function() -- line: 96
		-- upvalues: Logger (copy)
		Logger:warning("renderMessage was not passed to ChatMessage")
	end,
	closeKeyboard = function() -- line: 99
	end
}
local v62 = not getFFlagDebugAppChat() and "Frame" or "TextButton"

function ChatMessageContainer(p1) -- line: 114
	-- upvalues: Cryo (copy), t1 (copy), MessageModel (copy), React (copy), useStyle (copy), useChatPagePadding (copy), Foundation (copy), FFlagAppChatUseSwipeForReplies (copy), v53 (copy), SwipeDirection (copy), uDim2 (copy), uDim2_2 (copy), v54 (copy), vector2 (copy), vector2_2 (copy), useTelemetry (copy), ChatConversationTelemetryLayer (copy), useTriggerFeedback (copy), GlobalLongPressSignal (copy), MessageFtuxTooltipDismissSignal (copy), MessageFtuxTooltipVariant (copy), ChatConversationTelemetryEvents (copy), useNavigation (copy), useGetConversationFromId (copy), FFlagAppChatSignalsReplyStore (copy), GetReplyingToStore (copy), FFlagAppChatSignalsMessageStore (copy), v56 (copy), useReplyingToMessageDispatch (copy), useLocalUserId (copy), HapticFeedbackContext (copy), HapticFeedbackType (copy), useSwipeGesture (copy), EnumScreens (copy), setTimeout (copy), v50 (copy), UserInputService (copy), FFlagAppChatEnableMessageContextMenu (copy), ChatMessageContainerConstants (copy), OptionsEnum (copy), Conversation (copy), getReplyLabelDescriptor (copy), UserProfiles (copy), useLocalization (copy), TextService (copy), getFFlagDebugAppChat (copy), Options (copy), UserTile (copy), LayoutMode (copy), UserPresence (copy), Skeleton (copy), MessageFtuxTooltip2 (copy), v48 (copy), IXPService (copy), v49 (copy), v62 (copy), SystemMessage (copy), NoticeText (copy)
	local v64 = Cryo.Dictionary.join(t1, p1)
	local v65 = not not v64.visibility and v64.visibility == MessageModel.VisibilityTypes.Hidden
	local v66 = React.useCallback(function() -- line: 119
		-- upvalues: v64 (copy)
		if v64.viewProfileOnAvatarPressed then
			v64.openViewProfile(v64.senderUserId)
		end
	end, { v64.senderUserId })
	local v67 = useStyle()
	local shouldShowName = v64.shouldShowName
	local v69 = useChatPagePadding()
	local v70 = Foundation.Hooks.useTokens()
	local u71 = nil
	local u72 = nil

	if FFlagAppChatUseSwipeForReplies then
		u72 = React.useMemo(function() -- line: 140
			-- upvalues: v53 (copy), v64 (copy), SwipeDirection (copy), Foundation (copy), uDim2 (copy), uDim2_2 (copy), v54 (copy), vector2 (copy), vector2_2 (copy)
			if v53 then
				return {
					direction = if not v64.isIncoming then SwipeDirection.Left else SwipeDirection.Right,
					iconName = if not v64.isIncoming then Foundation.Enums.IconName.ArrowThickToLeft else Foundation.Enums.IconName.ArrowThickToRight,
					messagePosition = if not v64.isIncoming then uDim2_2 else uDim2,
					iconOffset = if not v64.isIncoming then -v54 else v54,
					iconAnchorPoint = if not v64.isIncoming then vector2_2 else vector2
				}
			end

			return {
				direction = SwipeDirection.Right,
				iconName = Foundation.Enums.IconName.ArrowThickToRight,
				messagePosition = uDim2,
				iconOffset = v54,
				iconAnchorPoint = vector2
			}
		end, {})
	end

	local u73 = nil
	local v74 = React.useRef(nil)
	local v75 = React.useRef(Vector2.zero)
	local v76 = useTelemetry(ChatConversationTelemetryLayer.Context)
	local v77 = useTriggerFeedback()
	local v78, v79 = React.useState(false)
	local u80 = v78
	local v81, v82 = React.useState(false)
	local v83, v84 = React.useState(false)

	React.useEffect(function() -- line: 180
		-- upvalues: GlobalLongPressSignal (copy), v84 (copy)
		local v130 = GlobalLongPressSignal.dismissed:connect(function() -- line: 181
			-- upvalues: v84 (copy)
			v84(false)
		end)

		return function() -- line: 184
			-- upvalues: v130 (copy)
			v130:disconnect()
		end
	end)

	local v85 = React.useMemo(function() -- line: 190
		-- upvalues: v64 (copy)
		return {
			conversationId = v64.conversationId,
			targetMessageSenderId = v64.senderUserId,
			targetMessageId = v64.messageId,
			targetMessageSentAt = if not v64.sent then nil else v64.sent.dateTime,
			targetMessageLength = if not v64.content then nil else #v64.content,
			targetMessageVisibility = v64.visibility
		}
	end, {
		v64.conversationId,
		v64.senderUserId,
		v64.messageId,
		v64.sent,
		v64.content,
		v64.visibility
	})
	local u86 = React.useMemo(function() -- line: 210
		-- upvalues: v65 (copy), v81 (copy), FFlagAppChatUseSwipeForReplies (copy), v83 (copy)
		return not v65 and (v81 or not FFlagAppChatUseSwipeForReplies and v83)
	end, {
		v81,
		v83,
		v65
	})

	React.useEffect(function() -- line: 215
		-- upvalues: u86 (ref), v64 (copy), MessageFtuxTooltipDismissSignal (copy), MessageFtuxTooltipVariant (copy)
		if u86 and v64.isLastIncomingChatMessage then
			MessageFtuxTooltipDismissSignal.dismiss(MessageFtuxTooltipVariant.Replies)
		end
	end, {
		u86,
		v64.isLastIncomingChatMessage
	})

	local v87 = React.useCallback(function() -- line: 220
		-- upvalues: v76 (copy), ChatConversationTelemetryEvents (copy), v85 (copy)
		v76.emit(ChatConversationTelemetryEvents.ConversationMessageReplyIconImpression, v85)
	end, {
		v76,
		v85
	})
	local u88 = useNavigation()
	local u89 = useGetConversationFromId(v64.conversationId)
	local v90 = if not FFlagAppChatSignalsReplyStore then nil else GetReplyingToStore(false)
	local u91 = nil

	if FFlagAppChatSignalsMessageStore and v56 then
		local v92 = v56(false).conversationMessageStore.messages[v64.messageId]

		u91 = if not v92 then nil else MessageModel.fromChannelsApi(v92, v64.conversationId)
	elseif u89 and u89.messages then
		u91 = u89.messages:Get(v64.messageId)
	end

	local v93 = useReplyingToMessageDispatch()
	local u94 = useLocalUserId()

	if FFlagAppChatUseSwipeForReplies then
		local v95 = React.useCallback(function() -- line: 245
			-- upvalues: v65 (copy), v77 (copy), HapticFeedbackContext (copy), HapticFeedbackType (copy)
			if not v65 then
				v77(HapticFeedbackContext.Default, HapticFeedbackType.Press)
			end
		end, {})
		local v96 = React.useCallback(function() -- line: 252
			-- upvalues: ChatConversationTelemetryEvents (copy), v76 (copy), v85 (copy), v65 (copy), FFlagAppChatSignalsReplyStore (copy), v90 (copy), v64 (copy), v93 (copy), u91 (ref)
			if ChatConversationTelemetryEvents.ConversationMessageSwiped then
				v76.emit(ChatConversationTelemetryEvents.ConversationMessageSwiped, v85)
			end

			if not v65 then
				if FFlagAppChatSignalsReplyStore and v90 then
					v90.setReplyingTo(v64.messageId)

					return
				end

				v93(u91)
			end
		end, {
			v93,
			u91,
			v76,
			v85,
			v65,
			if not FFlagAppChatSignalsReplyStore then nil else v90,
			if not FFlagAppChatSignalsReplyStore then nil else v64.messageId
		})

		u71 = useSwipeGesture({
			onSwipeThresholdReached = v95,
			onSwipeComplete = v96,
			direction = u72.direction
		})
	end

	local v97 = React.useCallback(function() -- line: 282
		-- upvalues: u88 (ref), EnumScreens (copy), v64 (copy)
		u88.navigate(EnumScreens.MessageContextMenu, {
			messageId = v64.messageId,
			conversationId = v64.conversationId,
			inputBoxRef = v64.inputBoxRef
		})
	end, {
		u88.navigate,
		v64.messageId,
		v64.conversationId,
		v64.inputBoxRef
	})
	local v98 = React.useCallback(function(p2, p3, n1: number) -- line: 291
		-- upvalues: v75 (copy), setTimeout (copy), v50 (copy), u73 (ref)
		if p3 then
			v75.current = Vector2.new(p3.Position.X, p3.Position.Y)
		end

		setTimeout(function() -- line: 295
			-- upvalues: p3 (copy), v75 (copy), v50 (copy), u73 (ref), p2 (copy)
			local n2 = 0

			if p3 then
				local current = v75.current

				n2 = (Vector2.new(p3.Position.X, p3.Position.Y) - current).Magnitude
			end

			if p3 and ((p3.UserInputState == Enum.UserInputState.Begin or p3.UserInputState == Enum.UserInputState.Change) and n2 < v50) then
				u73(p2, p3)
			end
		end, n1)
	end, { u73 })

	u73 = React.useCallback(function(p4, p5, s1: string?) -- line: 318
		-- upvalues: v64 (copy), UserInputService (copy), React (copy), v82 (copy), v76 (copy), ChatConversationTelemetryEvents (copy), v85 (copy), v65 (copy), FFlagAppChatUseSwipeForReplies (copy), v77 (copy), HapticFeedbackContext (copy), HapticFeedbackType (copy), v84 (copy), FFlagAppChatEnableMessageContextMenu (copy), v97 (copy), v98 (copy), ChatMessageContainerConstants (copy), v83 (copy), GlobalLongPressSignal (copy), OptionsEnum (copy), FFlagAppChatSignalsReplyStore (copy), v90 (copy), v93 (copy), u91 (ref)
		if v64.isPending then
			return
		end

		if UserInputService.MouseEnabled then
			if p4 == React.Event.MouseEnter then
				v82(true)
			end

			if p4 == React.Event.MouseLeave then
				v82(false)
			end

			if p4 == React.Event.MouseButton1Down then
				v64.closeKeyboard()
			end
		end

		if UserInputService.GamepadEnabled or UserInputService.TouchEnabled or v64.unitTestTouchEnabled then
			if p4 == React.Event.TouchLongPress then
				v76.emit(ChatConversationTelemetryEvents.ConversationMessageLongPressed, v85)

				if not v65 then
					if not FFlagAppChatUseSwipeForReplies then
						v77(HapticFeedbackContext.Default, HapticFeedbackType.Release)
					end

					v84(true)

					if FFlagAppChatEnableMessageContextMenu then
						v97()
					end

					v98(React.Event.InputEnded, p5, ChatMessageContainerConstants.PEEK_VIEW_ANIMATION_MILLISEC)
				end
			end

			if p4 == React.Event.InputBegan and p5 then
				v76.emit(ChatConversationTelemetryEvents.ConversationMessagePressed, v85)

				if not v65 and not v83 then
					GlobalLongPressSignal.dismiss()
				end

				v98(React.Event.TouchLongPress, p5, ChatMessageContainerConstants.LONG_PRESS_DELAY_MILLISEC)
			end

			if p4 == React.Event.TouchTap then
				v64.closeKeyboard()
			end
		end

		if p4 == React.Event.Activated then
			GlobalLongPressSignal.dismiss()

			if s1 == OptionsEnum.MessageContextMenu then
				if ChatConversationTelemetryEvents.ConversationMessageOpenMenuIconClicked then
					v76.emit(ChatConversationTelemetryEvents.ConversationMessageOpenMenuIconClicked, v85)
				end

				v97()
			end

			if s1 == OptionsEnum.Reply then
				v76.emit(ChatConversationTelemetryEvents.ConversationMessageReplyIconClicked, v85)
				v77(HapticFeedbackContext.Default, HapticFeedbackType.Press)

				if FFlagAppChatSignalsReplyStore and v90 then
					v90.setReplyingTo(v64.messageId)

					return
				end

				v93(u91)
			end
		end
	end, {
		v64.isPending,
		v64.unitTestTouchEnabled,
		UserInputService.MouseEnabled,
		UserInputService.TouchEnabled,
		v98,
		v82,
		v84,
		v79,
		v76,
		v97,
		v93,
		v77,
		v65,
		if not FFlagAppChatSignalsReplyStore then nil else v90,
		if not FFlagAppChatSignalsReplyStore then nil else u91,
		if not FFlagAppChatSignalsReplyStore then nil else v64.messageId
	})

	local u99 = React.useCallback(function(p6, p7) -- line: 420
		-- upvalues: FFlagAppChatUseSwipeForReplies (copy), UserInputService (copy), u71 (ref), MessageFtuxTooltipDismissSignal (copy), MessageFtuxTooltipVariant (copy), v98 (copy), React (copy), ChatMessageContainerConstants (copy)
		if FFlagAppChatUseSwipeForReplies and (UserInputService.TouchEnabled and u71) then
			u71.onInputBegan(p6, p7)
			MessageFtuxTooltipDismissSignal.dismiss(MessageFtuxTooltipVariant.Replies)
		end

		v98(React.Event.InputBegan, p7, ChatMessageContainerConstants.INPUT_BEGAN_DELAY_MILLISEC)
	end, {
		v98,
		u71
	})
	local u100 = React.useCallback(function(_) -- line: 429
		-- upvalues: u73 (ref), React (copy)
		u73(React.Event.InputEnded)
	end, { u73 })
	local u101 = React.useCallback(function(_) -- line: 433
		-- upvalues: u73 (ref), React (copy)
		u73(React.Event.MouseEnter)
	end, { u73 })
	local u102 = React.useCallback(function(_) -- line: 437
		-- upvalues: u73 (ref), React (copy)
		u73(React.Event.MouseLeave)
	end, { u73 })
	local u103 = React.useCallback(function(_) -- line: 441
		-- upvalues: u73 (ref), React (copy)
		u73(React.Event.TouchTap)
	end, { u73 })
	local u104 = React.useCallback(function(_) -- line: 445
		-- upvalues: u73 (ref), React (copy)
		u73(React.Event.MouseButton1Down)
	end, { u73 })
	local v105 = v64.repliesTo and v64.repliesTo.senderTargetId

	local function getDisplayNameText(s2: string, s3: string) -- line: 451
		-- upvalues: u94 (ref), v64 (copy), v105 (copy), u89 (ref), Conversation (copy), getReplyLabelDescriptor (copy)
		local v146 = u94 == v64.senderUserId
		local v147 = v64.senderUserId == v64.repliesTo.senderTargetId
		local v148 = u94 == v64.repliesTo.senderTargetId

		if not v105 then
			return s2
		end

		local v149 = u89 and u89.conversationType

		if v149 == Conversation.Type.ONE_TO_ONE_CONVERSATION or v149 == Conversation.Type.MULTI_USER_CONVERSATION then
			return getReplyLabelDescriptor({
				senderIsLocalUser = v146,
				senderRepliedToSelf = v147,
				senderRepliedToLocalUser = v148,
				isGroup = v149 == Conversation.Type.MULTI_USER_CONVERSATION,
				senderName = s2,
				repliedToName = s3
			})
		end

		return v64.unknownUserKey
	end

	local t2 = { v64.senderUserId }

	if v105 then
		table.insert(t2, v64.repliesTo.senderTargetId)
	end

	local v108 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = t2,
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})
	local u109, v111

	if v108.data then
		u109 = false

		local v110 = UserProfiles.Selectors.getCombinedNameFromId(v108.data, v64.senderUserId) or v64.unknownUserKey

		v111 = if not v105 then v110 else getDisplayNameText(v110, UserProfiles.Selectors.getCombinedNameFromId(v108.data, v64.repliesTo.senderTargetId) or v64.unknownUserKey)
	else
		u109 = true
		v111 = nil
	end

	local u112 = useLocalization((if not v105 then {} else {
		displayName = v111
	})).displayName or v111
	local v113 = React.useCallback(function() -- line: 518
		-- upvalues: v64 (copy), ChatMessageContainerConstants (copy), TextService (copy), u112 (ref), v67 (copy)
		local vector2_3 = Vector2.new(math.max(1, v64.messageMaxWidth - ChatMessageContainerConstants.TAIL_WIDTH), 1e999)
		local TextSize = TextService:GetTextSize(u112, v67.Font.BaseSize * v67.Font.Footer.RelativeSize, v67.Font.Footer.Font, vector2_3)

		return UDim2.new(0, TextSize.X, 0, TextSize.Y)
	end, {
		v67.Font.BaseSize * v67.Font.Footer.RelativeSize,
		v67.Font.Footer.Font,
		v64.messageMaxWidth - ChatMessageContainerConstants.TAIL_WIDTH,
		u112
	})
	local n3 = 0

	if not v64.showDateTime then
		n3 = ((if not v64.isNewSender and not v105 then ChatMessageContainerConstants.CHAT_MESSAGE_MIN_SPACE else ChatMessageContainerConstants.CHAT_MESSAGE_MAX_SPACE)) + v64.messageTypePaddingOffset
	end

	local left = v69.left
	local v116 = left + v70.Size.Size_700
	local v117 = v64.isIncoming and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right
	local v118, v119 = React.useState(false)
	local v120 = React.useCallback(function() -- line: 546
		-- upvalues: getFFlagDebugAppChat (copy), v119 (copy)
		if getFFlagDebugAppChat() then
			v119(function(p13) -- line: 548
				return not p13
			end)
		end
	end, { v119 })
	local v121 = v118 or (v64.moderated or (v64.filteredForReceivers or v65))
	local v122 = if not v118 then if not v65 then v64.moderated and v64.messageModeratedNoticeText or v64.messageDefaultNoticeText else v64.messageHiddenNoticeText else v64.messageId
	local v123 = React.useMemo(function() -- line: 560
		-- upvalues: React (copy), Foundation (copy), v70 (copy), v64 (copy)
		return React.createElement(Foundation.Icon, {
			name = Foundation.Enums.IconName.TriangleExclamation,
			size = Foundation.Enums.IconSize.Large,
			style = v70.Color.System.Alert,
			LayoutOrder = not v64.isIncoming and 3 or 0
		})
	end, {
		v70,
		v67,
		v64.isIncoming
	})
	local u124 = if not v64.failed and not v64.moderated then if not u86 then nil else React.createElement(Options, {
		LayoutOrder = not v64.isIncoming and 1 or 2,
		isIncoming = v64.isIncoming,
		handleEvent = u73,
		emitImpressionTelemetryEvent = v87
	}) else v123
	local isIncoming = v64.isIncoming
	local v126 = if not FFlagAppChatUseSwipeForReplies or (not u71 or not u71.swipeProgress) then nil else u71.swipeProgress:map(function(n4: number) -- line: 588
		-- upvalues: v70 (copy)
		local v153 = 1 - math.pow(n4, 3)

		return {
			Color3 = v70.Color.Content.Default.Color3,
			Transparency = v153
		}
	end)
	local v127 = if not FFlagAppChatUseSwipeForReplies or (not u71 or not u71.swipeOffset) then nil else u71.swipeOffset:map(function(n5: number) -- line: 601
		-- upvalues: u72 (ref), SwipeDirection (copy)
		local v155 = if u72.direction ~= SwipeDirection.Right then -n5 else n5

		return UDim2.new(0, v155, 0, 0)
	end)
	local v128 = if not FFlagAppChatUseSwipeForReplies or (not u71 or not u71.swipeProgress) then nil else u71.swipeProgress:map(function(n6: number) -- line: 611
		-- upvalues: u72 (ref)
		return u72.messagePosition + UDim2.new(0, n6 * u72.iconOffset, 0, 0)
	end)

	local function renderMessage() -- line: 617
		-- upvalues: React (copy), FFlagAppChatUseSwipeForReplies (copy), v127 (copy), u101 (ref), u102 (ref), n3 (ref), v64 (copy), left (copy), v116 (copy), v69 (copy), v117 (copy), Foundation (copy), UserTile (copy), LayoutMode (copy), UserPresence (copy), v66 (copy), v70 (copy), shouldShowName (copy), ChatMessageContainerConstants (copy), isIncoming (copy), v105 (copy), u109 (ref), v67 (copy), v113 (copy), u112 (ref), Skeleton (copy), u99 (ref), u100 (ref), u103 (ref), u104 (ref), u80 (ref), u124 (ref), v74 (copy), v65 (copy), MessageFtuxTooltip2 (copy), MessageFtuxTooltipVariant (copy), u72 (ref), v128 (copy), v126 (copy)
		local v157 = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			Position = if not FFlagAppChatUseSwipeForReplies then nil else v127,
			[React.Event.MouseEnter] = u101,
			[React.Event.MouseLeave] = u102
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, n3),
				PaddingLeft = UDim.new(0, v64.thumbnail and left or v116),
				PaddingRight = UDim.new(0, v69.right - 0)
			}),
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = v117
			}),
			AvatarContainer = if not v64.thumbnail then nil else React.createElement(Foundation.View, {
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
						userId = v64.senderUserId,
						layoutMode = LayoutMode.compact,
						userPresenceType = UserPresence.None,
						onActivated = v66
					})
				})
			}),
			MessageWithDisplayName = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, v64.isIncoming and -v116 or 0, 0, 0)
			}, {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = v117
				}),
				Padding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v64.isIncoming and v70.Size.Size_200 or 0)
				}),
				DisplayNameContainer = shouldShowName and React.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					Size = UDim2.new(0, v64.messageMaxWidth - ChatMessageContainerConstants.TAIL_WIDTH, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					Padding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, ChatMessageContainerConstants.GROUPED_MESSAGE_DISPLAY_NAME_LEFT_PADDING),
						PaddingRight = if not isIncoming then UDim.new(0, ChatMessageContainerConstants.TAIL_WIDTH) else UDim.new(0, 0),
						PaddingBottom = if not v105 then UDim.new(0, ChatMessageContainerConstants.GROUPED_MESSAGE_DISPLAY_NAME_BOTTOM_PADDING) else UDim.new(0, ChatMessageContainerConstants.REPLIED_DISPLAY_NAME_BOTTOM_PADDING)
					}),
					DisplayName = if u109 then nil else React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Font = v67.Font.Footer.Font,
						Size = v113(),
						AnchorPoint = if not isIncoming then Vector2.new(1, 0) else Vector2.new(0, 0),
						Position = if not isIncoming then UDim2.fromScale(1, 0) else UDim2.fromScale(0, 0),
						Text = u112,
						TextColor3 = v67.Theme.TextDefault.Color,
						TextSize = v67.Font.BaseSize * v67.Font.Footer.RelativeSize,
						TextTransparency = v67.Theme.TextDefault.Transparency,
						TextXAlignment = if not isIncoming then Enum.TextXAlignment.Right else Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top
					}),
					ShimmerName = if not u109 then nil else React.createElement(Skeleton, {
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
					Size = UDim2.new(1, v64.isIncoming and -v116 or 0, 0, 0)
				}, {
					Layout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = v117,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 10),
						ItemLineAlignment = Enum.ItemLineAlignment.Center
					}),
					Message = v64.renderMessage({
						LayoutOrder = not v64.isIncoming and 2 or 1,
						[React.Event.InputBegan] = u99,
						[React.Event.InputEnded] = u100,
						[React.Event.TouchTap] = u103,
						[React.Event.MouseButton1Down] = u104
					}, {
						isPressed = u80,
						Icons = u124,
						ref = v74
					}),
					MessageFtuxTooltip = if not v64.isLastIncomingChatMessage or v65 then nil else React.createElement(MessageFtuxTooltip2, {
						variant = MessageFtuxTooltipVariant.Replies,
						messageRef = v74,
						isReversed = v64.isIncoming
					})
				})
			})
		})

		if FFlagAppChatUseSwipeForReplies and not v65 then
			return React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y",
				ClipsDescendants = false,
				LayoutOrder = 2,
				ZIndex = 2
			}, {
				ReplyIconFilled = React.createElement(Foundation.Icon, {
					ZIndex = 1,
					name = u72.iconName,
					size = Foundation.Enums.IconSize.Medium,
					variant = Foundation.Enums.IconVariant.Filled,
					AnchorPoint = u72.iconAnchorPoint,
					Position = v128,
					style = v126
				}),
				Content = v157
			})
		end

		return v157
	end

	React.useEffect(function() -- line: 775
		-- upvalues: v48 (copy), v64 (copy), IXPService (copy), v49 (copy)
		if v48 and v64.isLastIncomingChatMessage then
			IXPService:LogFlagLinkedUserLayerExposure(v49)
		end
	end, { v64.isLastIncomingChatMessage })

	return React.createElement(v62, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		Text = if not getFFlagDebugAppChat() then nil else "",
		[React.Event.Activated] = if not getFFlagDebugAppChat() then nil else v120
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = v117,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		DateTime = v64.showDateTime and React.createElement(SystemMessage, {
			LayoutOrder = 1,
			Text = v64.sent:GetLongRelativeTime(),
			maxWidth = ChatMessageContainerConstants.DATETIME_MAX_WIDTH
		}),
		MessageWithAvatar = renderMessage(),
		Notice = v121 and React.createElement(NoticeText, {
			LayoutOrder = 3,
			Font = v64.Font,
			HorizontalAlignment = v117,
			Text = v122,
			TextColor3 = if not v65 then v64.moderated and v67.Theme.Alert.Color or v67.Theme.UIDefault.Color else v70.Color.Content.Muted.Color3,
			TextTransparency = if not v65 then v64.moderated and v67.Theme.Alert.Transparency or v67.Theme.UIDefault.Transparency else v70.Color.Content.Muted.Transparency,
			TextXAlignment = v64.isIncoming and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right,
			TextSize = v70.Typography.CaptionSmall.FontSize,
			margin = {
				bottom = 0,
				top = v70.Padding.Small,
				left = v64.isIncoming and v116 + ChatMessageContainerConstants.NOTICE_HORIZONTAL_PADDING or 0,
				right = not v64.isIncoming and v69.right or 0
			},
			maxWidth = v64.parentWidth,
			width = UDim.new(1, v64.isIncoming and -v116 or 0)
		}),
		debug = v64.debugElement or nil
	})
end

return ChatMessageContainer
