local AppStorageService = game:GetService("AppStorageService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Foundation = require(AppChatParent.Foundation)
local React = require(AppChatParent.React)
local Roact = require(AppChatParent.Roact)
local withStyle = require(AppChatParent.UIBlox).Style.withStyle
local memoize = require(AppChatParent.AppCommonLib).memoize
local ReactFocusNavigation = require(AppChatParent.ReactFocusNavigation)
local CoreGui = ReactFocusNavigation.EngineInterface.CoreGui
local FocusNavigationService = ReactFocusNavigation.FocusNavigationService
local FocusBehaviors = require(AppChatParent.FocusBehaviors)
local UserInputService = game:GetService("UserInputService")
local IXPService = game:GetService("IXPService")
local RoactNavigation = require(AppChatParent.RoactNavigation)
local MessageList = require(script.Parent.MessageList)
local ReplyComposeBarContainer = require(script.Parent.ReplyComposeBarContainer)
local v18 = if not require(AppChat.Flags.FFlagAppChatNewChatInputBar) then require(script.Parent.ChatInputBarDeprecated) else require(script.Parent.ChatInputBar)
local UserTypingIndicator = require(script.Parent.UserTypingIndicator)
local v20 = require(AppChat.Logger):new(script.Name)
local withChatPagePadding = require(AppChat.Contexts.ChatPagePadding.withChatPagePadding)

require(AppChat.Models.ConversationChannels)

local StatusCodes = require(AppChatParent.Http).StatusCodes
local DateTime = require(AppChatParent.Time).DateTime
local LocalStorageKey = require(AppChatParent.LocalStorage).Enums.LocalStorageKey
local ChatConversationMoreMenu = require(script.Parent.ChatConversationMoreMenu)
local KeyboardOffsetEventHandler = require(script.Parent.KeyboardOffsetEventHandler)
local GlobalLongPressSignal = require(script.Parent.Utils.GlobalLongPressSignal)
local GetReplyingToStore = require(AppChat.Stores.GetReplyingToStore)
local FFlagAppChatSignalsReplyStore = require(AppChat.Flags.FFlagAppChatSignalsReplyStore)
local FFlagAppChatReplyComposeBarContainer = require(AppChat.Flags.FFlagAppChatReplyComposeBarContainer)
local ConversationExitType = require(AppChat.Analytics.Enums.ConversationExitType)
local SendMessageError = require(AppChat.Analytics.Enums.SendMessageError)
local withRoactChatAnalytics = require(AppChat.LegacyAnalytics.withRoactChatAnalytics)
local connectTelemetry = require(AppChat.Telemetry.connectTelemetry)
local ChatConversationTelemetryEvents = require(script.Parent.ChatConversationTelemetryEvents)
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local v37 = game:DefineFastFlag("AppChatNewChatInputBarIxpEnabled", false)
local v38 = game:DefineFastString("AppChatNewChatInputBarIxpLayer", "")
local FFlagAppChatEnableDoubleOptIn = require(AppChatParent.SharedFlags).FFlagAppChatEnableDoubleOptIn
local FFlagAppChatUseSwipeForReplies = require(AppChat.Flags.FFlagAppChatUseSwipeForReplies)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatMessageTTIMilestones = require(AppChat.Flags.FFlagAppChatMessageTTIMilestones)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local EngineFeature = game:GetEngineFeature("ScheduledSquadTooltipSeen")
local FFlagEnableScheduledSquads = require(AppChatParent.SharedFlags).FFlagEnableScheduledSquads
local ScheduledPartiesExperimentation = require(AppChatParent.SocialExperiments).ScheduledPartiesExperimentation
local v47 = if not FFlagAppChatEnableDoubleOptIn then require(script.Parent.ConversationTopModalContainerDeprecated) else require(script.Parent.ConversationTopModalContainer)
local ConversationBottomModalContainer = require(script.Parent.ConversationModal.ConversationBottomModalContainer)
local v49 = Roact.PureComponent:extend("ChatConversation")

v49.defaultProps = {
	topBarHeight = 0,
	conversationId = nil,
	conversationTitle = nil,
	itemList = {},
	inputBoxRef = nil,
	wideMode = false,
	getOlderMessages = function() -- line: 75
	end,
	isDebugEnabled = false,
	sendMessage = function() -- line: 77
	end,
	navigateToToast = function() -- line: 78
	end,
	markConversationAsRead = function() -- line: 79
	end,
	postTypingStatus = function() -- line: 80
	end,
	navigateBack = function() -- line: 81
	end,
	openViewProfile = function() -- line: 82
	end,
	updateConversationTitle = function() -- line: 83
	end,
	openGameDetailsPage = function() -- line: 84
	end,
	navigateToScreen = function() -- line: 85
	end,
	navigateToSquadLobby = function() -- line: 86
	end,
	onChatInputBarReady = function() -- line: 87
	end,
	viewProfileOnAvatarPressed = true,
	chatInputPlaceholder = "Say something",
	usersTyping = {},
	invalidMessageTypeText = "PLACEHOLDER This message could not be displayed",
	messageDefaultNoticeText = "PLACEHOLDER Not everyone in this chat can see your message.",
	messageModeratedNoticeText = "PLACEHOLDER Your message was moderated and not sent.",
	newText = not ScheduledPartiesExperimentation.getScheduledPartiesTooltipEnabled() and "" or "New",
	schedulePartyText = not ScheduledPartiesExperimentation.getScheduledPartiesTooltipEnabled() and "" or "Schedule Party",
	networkErrorText = "PLACEHOLDER There was a network error, please try again later",
	unknownUserText = "PLACEHOLDER unknown user",
	oneUserTyping = "PLACEHOLDER {DISPLAY_NAME} is typing...",
	twoUsersTyping = "PLACEHOLDER {DISPLAY_NAME_1} and {DISPLAY_NAME_2} are typing...",
	severalUsersTyping = "PLACEHOLDER Several users are typing...",
	bottomModalText = "PLACEHOLDER At this time, Chat is not available with this user.",
	readingMessagesIsEnabled = true,
	onConversationUnmount = function() -- line: 105
	end,
	chatIsVisible = true,
	moreMenuEnabled = false,
	keyboardOffset = nil,
	replyingToMessageId = nil,
	replyingToMessage = nil,
	replyingToMessageDispatch = function() -- line: 112
	end,
	shouldShowChatInputBar = true,
	shouldDisableChatInputBar = false,
	shouldShowLegacyBottomModal = false,
	telemetry = {
		emit = function() -- line: 117
		end
	},
	scrollToTopOnInitialOsaLoad = false,
	isInitialMessageLoading = false,
	displayNamesAvailable = true,
	shouldHideMoreMenuButton = false
}

function v49.init(p1) -- line: 125
	-- upvalues: EngineFeature (copy), FFlagEnableScheduledSquads (copy), AppStorageService (copy), LocalStorageKey (copy), ScheduledPartiesExperimentation (copy), Roact (copy), UserInputService (copy), memoize (copy), v20 (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), FFlagAppChatSignalsReplyStore (copy), StatusCodes (copy), SendMessageError (copy), ChatConversationTelemetryEvents (copy), DateTime (copy), FFlagAppChatReplyComposeBarContainer (copy), ConversationExitType (copy), FFlagAppChatUseSwipeForReplies (copy), GetReplyingToStore (copy), GlobalLongPressSignal (copy), FocusNavigationService (copy), CoreGui (copy)
	local v51 = nil

	if EngineFeature and (FFlagEnableScheduledSquads and not p1.props.shouldHideMoreMenuButton) then
		local ok, result = pcall(function() -- line: 129
			-- upvalues: AppStorageService (copy), LocalStorageKey (copy)
			return AppStorageService:GetItem(LocalStorageKey.ScheduledSquadTooltipSeen)
		end)

		if ok and result == "false" then
			if ScheduledPartiesExperimentation.getScheduledPartiesTooltipEnabled() then
				v51 = `{ p1.props.newText }: { p1.props.schedulePartyText }`
			end

			AppStorageService:SetItem(LocalStorageKey.ScheduledSquadTooltipSeen, "true")
			AppStorageService:Flush()
			ScheduledPartiesExperimentation.logExposure()
		end
	end

	p1.state = {
		inputBarHeight = 0,
		keyboardOffset = 0,
		replyComposeBarHeight = 0,
		conversationBannerHeight = 0,
		messageListHeight = 0,
		bottomModalHeight = 0,
		tooltipText = if not FFlagEnableScheduledSquads then nil else v51
	}
	p1.inputBoxRef = p1.props.inputBoxRef or Roact.createRef()
	p1.inputBarRef = Roact.createRef()
	p1.conversationViewRef = Roact.createRef()
	p1.messageListRef = Roact.createRef()

	function p1.getKeyboardOffset() -- line: 160
		-- upvalues: UserInputService (copy), p1 (copy)
		if UserInputService.OnScreenKeyboardVisible and (p1.inputBoxRef:getValue() and p1.inputBoxRef:getValue():IsFocused()) then
			if p1.props.keyboardOffset ~= nil then
				return p1.props.keyboardOffset
			end

			local v73 = p1.conversationViewRef:getValue()

			if v73 then
				return v73.AbsolutePosition.Y + v73.AbsoluteSize.Y - UserInputService.OnScreenKeyboardPosition.Y
			end
		end

		return 0
	end
	function p1.updateKeyboardOffset() -- line: 183
		-- upvalues: p1 (copy)
		if not p1.isMounted then
			return
		end

		local v74 = p1.getKeyboardOffset()

		if v74 ~= p1.state.keyboardOffset then
			p1:setState({
				keyboardOffset = v74
			})
		end
	end
	function p1.onKeyboardOffsetChanged(p2) -- line: 195
		-- upvalues: p1 (copy)
		if not p1.isMounted then
			return
		end

		if not p1.inputBoxRef:getValue() or not p1.inputBoxRef:getValue():IsFocused() then
			p2 = 0
		end

		if p2 ~= p1.state.keyboardOffset then
			p1:setState({
				keyboardOffset = p2
			})
		end
	end
	function p1.clearKeyboardOffset() -- line: 212
		-- upvalues: p1 (copy)
		p1:setState({
			keyboardOffset = 0
		})
	end

	p1.loadNext = memoize(function(p3, p4) -- line: 218
		-- upvalues: p1 (copy)
		return function() -- line: 219
			-- upvalues: p3 (copy), p4 (copy), p1 (copy)
			local v106 = p3(p4)

			if v106 then
				v106:catch(function() -- line: 222
					-- upvalues: p1 (copy)
					p1.showNetworkErrorToast()
				end)
			end
		end
	end)
	p1.markAsRead = memoize(function(p5, p6) -- line: 229
		-- upvalues: p1 (copy)
		return function() -- line: 230
			-- upvalues: p1 (copy), p5 (copy), p6 (copy)
			if p1.props.readingMessagesIsEnabled then
				p5(p6)
			end
		end
	end)

	function p1.showNetworkErrorToast() -- line: 237
		-- upvalues: p1 (copy)
		p1.props.navigateToToast({
			toastProps = {
				toastContent = {
					toastTitle = p1.props.networkErrorText
				}
			}
		})
	end

	p1.onSendChat = memoize(function(p7, p8, p9, p10, p11, p12, p13, p14) -- line: 248
		-- upvalues: v20 (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), FFlagAppChatSignalsReplyStore (copy), p1 (copy), StatusCodes (copy), SendMessageError (copy), ChatConversationTelemetryEvents (copy), DateTime (copy)
		return function(p15) -- line: 258
			-- upvalues: p11 (copy), v20 (copy), p8 (ref), p12 (copy), p10 (copy), p13 (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), FFlagAppChatSignalsReplyStore (copy), p1 (copy), p7 (copy), StatusCodes (copy), p9 (copy), SendMessageError (copy), p14 (copy), ChatConversationTelemetryEvents (copy), DateTime (copy)
			if p11 and p11.source == "friends" then
				v20:info("Creating a conversation for friend conversation {} via onSendChat", p8)

				local v108, v109 = p12(p8, p10):await()

				if not v108 or not v109 then
					v20:error("Could not create conversation. Error: {}", (tostring(v109)))

					return
				end

				v20:debug("Created conversation {} for friend conversation {} via onSendChat", v109.id, p8)
				p8 = v109.id
				p13(v109.id)
			end

			v20:info("Sending message '{}' to conversationId {} via onSendChat", p15, p8)

			if FFlagAppChatPerfTracking then
				if FFlagAppChatMessageTTIMilestones then
					AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageSendTTI, {
						conversationId = tostring(p8)
					})
				else
					AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageSendToPendingRender, {
						conversationId = tostring(p8)
					})
					AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageSendToFinalRender, {
						conversationId = tostring(p8)
					})
				end
			end

			local t1 = nil

			if FFlagAppChatSignalsReplyStore and p1.props.replyingToMessageId then
				t1 = {
					id = p1.props.replyingToMessageId
				}
			elseif not FFlagAppChatSignalsReplyStore then
				t1 = p1.props.replyingToMessage
			end

			local v111 = p7(p8, p15, t1)

			if v111 then
				v111:andThen(function(p16) -- line: 303
					-- upvalues: StatusCodes (copy), p1 (copy), p9 (copy), p8 (ref)
					if p16 and p16.StatusCode == StatusCodes.CONFLICT then
						p1.showNetworkErrorToast()

						return
					end

					if p9 then
						p9(p8)
					end
				end)
			elseif p9 then
				p9(p8)
			end

			p1.closeReplying()

			local t2 = {
				messageSentResult = SendMessageError.OtherFailure,
				recipientIds = p1.props.recipientIdsSerialized
			}

			if not v111 then
				p14.emit(ChatConversationTelemetryEvents.ConversationMessageSent, t2)

				return
			end

			v111:andThen(function(p17) -- line: 327
				-- upvalues: SendMessageError (copy), StatusCodes (copy), DateTime (copy), p14 (copy), ChatConversationTelemetryEvents (copy), p1 (copy)
				local id = nil
				local id2 = nil
				local sender_user_id = nil
				local str = nil
				local v125 = nil
				local v126 = p17 and p17.StatusCode
				local NoResponse

				if not p17 then
					NoResponse = SendMessageError.NoResponse
				elseif v126 == StatusCodes.CONFLICT then
					NoResponse = SendMessageError.Conflict
				elseif not p17.responseBody then
					NoResponse = SendMessageError.NoResponseBody
				elseif not p17.responseBody.messages or #p17.responseBody.messages == 0 then
					NoResponse = SendMessageError.NoMessages
				elseif not p17.responseBody.messages[1].status then
					NoResponse = SendMessageError.NoMessageStatus
				else
					NoResponse = p17.responseBody.messages[1].status
					id = p17.responseBody.messages[1].id

					if p17.responseBody.messages[1].replies_to then
						local replies_to = p17.responseBody.messages[1].replies_to

						id2 = replies_to.id
						sender_user_id = replies_to.sender_user_id
						str = tostring(DateTime.fromIsoDate(replies_to.created_at).dateTime)
						v125 = if not replies_to.content then nil else #replies_to.content
					end
				end

				p14.emit(ChatConversationTelemetryEvents.ConversationMessageSent, {
					messageSentResult = NoResponse,
					messageId = id,
					recipientIds = p1.props.recipientIdsSerialized,
					targetMessageId = id2,
					targetMessageSenderId = sender_user_id,
					targetMessageSentAt = str,
					targetMessageLength = v125
				})
			end):catch(function() -- line: 377
				-- upvalues: p14 (copy), ChatConversationTelemetryEvents (copy), t2 (copy)
				p14.emit(ChatConversationTelemetryEvents.ConversationMessageSent, t2)
			end)
		end
	end)
	p1.onSendBtnClicked = memoize(function(p18) -- line: 384
		-- upvalues: ChatConversationTelemetryEvents (copy)
		return function(s1: string?) -- line: 387
			-- upvalues: p18 (copy), ChatConversationTelemetryEvents (copy)
			p18.emit(ChatConversationTelemetryEvents.ConversationSendBtnClicked, {
				sendBtnClickResult = s1
			})
		end
	end)

	function p1.isMoreMenuEnabled() -- line: 394
		-- upvalues: p1 (copy)
		return p1.props.moreMenuEnabled
	end

	p1.reportInputBarReady = if not FFlagAppChatPerfTracking then nil else function(n1: number) -- line: 399
		-- upvalues: p1 (copy)
		if p1.props.onChatInputBarReady and (p1.props.shouldShowChatInputBar and n1 > 0) then
			p1.props.onChatInputBarReady()
		end
	end

	if p1.isMoreMenuEnabled() or FFlagAppChatReplyComposeBarContainer then
		function p1.onHeightChanged(p19) -- line: 407
			-- upvalues: FFlagAppChatPerfTracking (copy), p1 (copy)
			if FFlagAppChatPerfTracking then
				p1.reportInputBarReady(p19.AbsoluteSize.Y)
			end

			p1:setState(function(p20, _) -- line: 412
				-- upvalues: p19 (copy)
				if p19.AbsoluteSize.Y ~= p20.inputBarHeight then
					return {
						inputBarHeight = p19.AbsoluteSize.Y
					}
				end

				return {}
			end)
		end
	else
		function p1.onHeightChanged(p22) -- line: 421
			-- upvalues: FFlagAppChatPerfTracking (copy), p1 (copy)
			if FFlagAppChatPerfTracking then
				p1.reportInputBarReady(p22)
			end

			p1:setState(function(p23, _) -- line: 426
				-- upvalues: p22 (copy)
				if p22 ~= p23.inputBarHeight then
					return {
						inputBarHeight = p22
					}
				end

				return {}
			end)
		end
	end

	p1.lastTypingRequest = 0

	function p1.chatInputTextChanged() -- line: 437
		-- upvalues: p1 (copy)
		if p1.props.conversation and p1.props.conversation.source == "friends" then
			return
		end

		local timestamp = tick()

		if timestamp - p1.lastTypingRequest >= 3 then
			p1.lastTypingRequest = timestamp
			p1.props.postTypingStatus(p1.props.conversationId, true)
		end
	end

	p1.exitTypeForAnalytics = ConversationExitType.Default

	if not FFlagAppChatUseSwipeForReplies then
		function p1.onTouchSwipe(_, p26, p27) -- line: 453
			-- upvalues: p1 (copy), ConversationExitType (copy)
			if not p1.props.wideMode and (p26 == Enum.SwipeDirection.Right and p27 == 1) then
				p1.exitTypeForAnalytics = ConversationExitType.SwipedRight
				p1.props.navigateBack()
			end
		end
	end

	function p1.fireAnalyticsEventOnUnmount() -- line: 461
		-- upvalues: p1 (copy), ConversationExitType (copy)
		p1.props.onConversationUnmount(p1.exitTypeForAnalytics)
		p1.exitTypeForAnalytics = ConversationExitType.Default
	end
	function p1.closeKeyboard() -- line: 468
		-- upvalues: p1 (copy)
		if p1.inputBoxRef:getValue() then
			p1.inputBoxRef:getValue():ReleaseFocus()
		end
	end
	function p1.closeReplying() -- line: 474
		-- upvalues: FFlagAppChatSignalsReplyStore (copy), GetReplyingToStore (copy), p1 (copy)
		if FFlagAppChatSignalsReplyStore then
			GetReplyingToStore(false).clear()

			return
		end

		p1.props.replyingToMessageDispatch(nil)
	end
	function p1.onPointerInput() -- line: 481
		-- upvalues: GlobalLongPressSignal (copy), p1 (copy)
		GlobalLongPressSignal.dismiss()
		p1.closeKeyboard()
	end
	function p1.onSizeChange() -- line: 486
		-- upvalues: p1 (copy)
		p1.updateKeyboardOffset()
	end
	function p1.calculateScrollOffset(p28) -- line: 490
		local CanvasPositionY = p28.CanvasPosition.Y
		local AbsoluteCanvasSizeY = p28.AbsoluteCanvasSize.Y
		local AbsoluteWindowSizeY = p28.AbsoluteWindowSize.Y

		return AbsoluteCanvasSizeY - CanvasPositionY - AbsoluteWindowSizeY
	end
	function p1.setBannerHeight(p29) -- line: 497
		-- upvalues: p1 (copy)
		p1:setState({
			conversationBannerHeight = p29
		})
	end
	function p1.setBottomModalHeight(p30) -- line: 503
		-- upvalues: p1 (copy)
		p1:setState({
			bottomModalHeight = p30
		})
	end

	if not FFlagAppChatReplyComposeBarContainer then
		function p1.setReplyComposeBarHeight(p31) -- line: 510
			-- upvalues: p1 (copy)
			p1:setState({
				replyComposeBarHeight = p31
			})
		end
	end

	function p1.onMessageListSizeChange(p32) -- line: 517
		-- upvalues: p1 (copy)
		p1:setState({
			messageListHeight = p32.AbsoluteSize.Y
		})
	end

	p1.focusNavigationService = FocusNavigationService.new(CoreGui)
end
function v49.didMount(p33) -- line: 525
	-- upvalues: FocusBehaviors (copy), v37 (copy), IXPService (copy), v38 (copy)
	p33.isMounted = true
	p33.markAsRead(p33.props.markConversationAsRead, p33.props.conversationId)()

	local v55 = p33.conversationViewRef:getValue()
	local v56 = p33.inputBarRef:getValue()

	p33.focusNavigationService:registerFocusBehavior(v55, FocusBehaviors.mostRecentOrDefault(v56))

	if not p33.props.wideMode and p33.focusNavigationService.focusedGuiObject:getValue() ~= nil then
		p33.focusNavigationService:focusGuiObject(v56)
	end

	if v37 and p33.props.shouldShowChatInputBar then
		IXPService:LogFlagLinkedUserLayerExposure(v38)
	end
end
function v49.willUpdate(p34, p35, _) -- line: 541
	if p35.chatIsVisible ~= p34.props.chatIsVisible and not p35.chatIsVisible then
		p34.closeKeyboard()
	end
end
function v49.didUpdate(p37, p38, p39) -- line: 547
	-- upvalues: FFlagAppChatPerfTracking (copy)
	if p37.props.wideMode and p37.props.navigation.getParam("navigatedWithFocus") then
		local v63 = p37.inputBarRef:getValue()

		p37.props.navigation.setParams({
			navigatedWithFocus = false
		})
		p37.focusNavigationService:focusGuiObject(v63)
	end

	if p38.conversationId ~= p37.props.conversationId then
		if FFlagAppChatPerfTracking then
			p37.reportInputBarReady(p37.state.inputBarHeight)
		end

		if p37.inputBoxRef:getValue() then
			p37.inputBoxRef:getValue().Text = ""
			p37.inputBoxRef:getValue():ReleaseFocus()
		end

		p37.closeReplying()
		p37.markAsRead(p37.props.markConversationAsRead, p37.props.conversationId, false)()
	end

	if FFlagAppChatPerfTracking and p38.shouldShowChatInputBar ~= p37.props.shouldShowChatInputBar then
		p37.reportInputBarReady(p37.state.inputBarHeight)
	end

	local v64 = p37.messageListRef and (p37.messageListRef.current and p37.messageListRef.current._listRef)
	local v65 = v64 and (v64._scrollRef and v64._scrollRef.getNativeScrollRef())
	local v66 = p37.state.messageListHeight - p39.messageListHeight

	if v64 and v65 and p39.messageListHeight ~= 0 and v66 ~= 0 then
		local v67 = p37.calculateScrollOffset(v65._nativeRef.current)

		if v67 <= 0 then
			return
		end

		v64:scrollToOffset({
			offset = v67 + v66
		})
	end
end
function v49.willUnmount(p40) -- line: 605
	p40.fireAnalyticsEventOnUnmount()
	p40.closeReplying()
	p40.keyboardConnections = {}
	p40.isMounted = false
	p40.focusNavigationService:teardown()
end
function v49.render(p41) -- line: 613
	-- upvalues: withRoactChatAnalytics (copy), withStyle (copy), withChatPagePadding (copy), Roact (copy), FFlagAppChatUseSwipeForReplies (copy), KeyboardOffsetEventHandler (copy), v47 (copy), FFlagAppChatEnableDoubleOptIn (copy), FFlagAppChatReplyComposeBarContainer (copy), MessageList (copy), UserTypingIndicator (copy), React (copy), Foundation (copy), FFlagAppChatSignalsReplyStore (copy), ReplyComposeBarContainer (copy), ChatConversationMoreMenu (copy), FFlagEnableScheduledSquads (copy), v18 (copy), ConversationBottomModalContainer (copy)
	local v70 = #p41.props.usersTyping > 0 and p41.props.displayNamesAvailable
	local v71 = not not p41.props.conversation and p41.props.conversation.source == "friends"
	local v72 = "MessageList" .. tostring(p41.props.conversationId)

	return withRoactChatAnalytics(function(p42) -- line: 624
		-- upvalues: withStyle (copy), withChatPagePadding (copy), p41 (copy), Roact (copy), FFlagAppChatUseSwipeForReplies (copy), KeyboardOffsetEventHandler (copy), v47 (copy), FFlagAppChatEnableDoubleOptIn (copy), FFlagAppChatReplyComposeBarContainer (copy), v72 (copy), MessageList (copy), v71 (copy), v70 (copy), UserTypingIndicator (copy), React (copy), Foundation (copy), FFlagAppChatSignalsReplyStore (copy), ReplyComposeBarContainer (copy), ChatConversationMoreMenu (copy), FFlagEnableScheduledSquads (copy), v18 (copy), ConversationBottomModalContainer (copy)
		return withStyle(function(p43) -- line: 625
			-- upvalues: withChatPagePadding (copy), p41 (copy), Roact (copy), FFlagAppChatUseSwipeForReplies (copy), KeyboardOffsetEventHandler (copy), v47 (copy), FFlagAppChatEnableDoubleOptIn (copy), FFlagAppChatReplyComposeBarContainer (copy), v72 (copy), MessageList (copy), v71 (copy), v70 (copy), UserTypingIndicator (copy), React (copy), Foundation (copy), FFlagAppChatSignalsReplyStore (copy), ReplyComposeBarContainer (copy), ChatConversationMoreMenu (copy), FFlagEnableScheduledSquads (copy), v18 (copy), p42 (copy), ConversationBottomModalContainer (copy)
			return withChatPagePadding(function(p44) -- line: 626
				-- upvalues: p41 (copy), Roact (copy), p43 (copy), FFlagAppChatUseSwipeForReplies (copy), KeyboardOffsetEventHandler (copy), v47 (copy), FFlagAppChatEnableDoubleOptIn (copy), FFlagAppChatReplyComposeBarContainer (copy), v72 (copy), MessageList (copy), v71 (copy), v70 (copy), UserTypingIndicator (copy), React (copy), Foundation (copy), FFlagAppChatSignalsReplyStore (copy), ReplyComposeBarContainer (copy), ChatConversationMoreMenu (copy), FFlagEnableScheduledSquads (copy), v18 (copy), p42 (copy), ConversationBottomModalContainer (copy)
				local uDim = nil

				if p41.isMoreMenuEnabled() then
					uDim = UDim.new(0, (math.max(p44.right - 6, 0)))

					if p41.props.shouldDisableChatInputBar then
						uDim = UDim.new(0, p44.right)
					end
				end

				return Roact.createElement("TextButton", {
					AutoButtonColor = false,
					BackgroundColor3 = p43.Theme.BackgroundDefault.Color,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
					Text = "",
					Transparency = p43.Tokens.Color.None.Transparency,
					[Roact.Event.TouchSwipe] = if FFlagAppChatUseSwipeForReplies then nil else p41.onTouchSwipe,
					[Roact.Event.TouchTap] = p41.onPointerInput,
					[Roact.Event.MouseButton1Down] = p41.onPointerInput,
					[Roact.Ref] = p41.conversationViewRef,
					Selectable = false
				}, {
					KeyboardOffsetEventHandler = Roact.createElement(KeyboardOffsetEventHandler, {
						onKeyboardOffsetChanged = p41.onKeyboardOffsetChanged,
						parentViewRef = p41.conversationViewRef
					}),
					Layout = Roact.createElement("UIListLayout", {
						HorizontalAlignment = if not p41.isMoreMenuEnabled() then Enum.HorizontalAlignment.Right else nil,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					ConversationTopModal = Roact.createElement(v47, {
						layoutOrder = 1,
						conversationId = if not FFlagAppChatEnableDoubleOptIn then nil else p41.props.conversationId,
						conversation = if not FFlagAppChatEnableDoubleOptIn then p41.props.conversation else nil,
						navigateToScreen = if not FFlagAppChatEnableDoubleOptIn then p41.props.navigateToScreen else nil,
						setModalHeight = p41.setBannerHeight
					}),
					MessageListFrame = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 2,
						[Roact.Change.AbsoluteSize] = p41.onMessageListSizeChange,
						Size = UDim2.new(1, 0, 1, -p41.state.inputBarHeight - p41.state.keyboardOffset - (FFlagAppChatReplyComposeBarContainer and 0 or p41.state.replyComposeBarHeight) - p41.state.conversationBannerHeight - p41.state.bottomModalHeight)
					}, {
						[v72] = Roact.createElement(MessageList, {
							bottomMargin = 28,
							Size = UDim2.new(1, 0, 1, 0),
							conversationId = p41.props.conversationId,
							isDebugEnabled = p41.props.isDebugEnabled,
							itemList = p41.props.itemList,
							loadNext = if not v71 then p41.loadNext(p41.props.getOlderMessages, p41.props.conversationId) else nil,
							localUserId = p41.props.localUserId,
							markAsRead = p41.markAsRead(p41.props.markConversationAsRead, p41.props.conversationId),
							messageListRef = p41.messageListRef,
							openViewProfile = p41.props.openViewProfile,
							onDetailsOpened = p41.closeKeyboard,
							closeKeyboard = p41.closeKeyboard,
							inputBoxRef = p41.inputBoxRef,
							wideMode = p41.props.wideMode,
							viewProfileOnAvatarPressed = p41.props.viewProfileOnAvatarPressed,
							readingMessagesIsEnabled = p41.props.readingMessagesIsEnabled,
							invalidMessageTypeText = p41.props.invalidMessageTypeText,
							messageDefaultNoticeText = p41.props.messageDefaultNoticeText,
							messageModeratedNoticeText = p41.props.messageModeratedNoticeText,
							messageHiddenNoticeText = p41.props.messageHiddenNoticeText,
							unknownUserText = p41.props.unknownUserText,
							openGameDetailsPage = p41.props.openGameDetailsPage,
							scrollToTopOnInitialOsaLoad = p41.props.scrollToTopOnInitialOsaLoad,
							isInitialMessageLoading = p41.props.isInitialMessageLoading
						}),
						UserTypingIndicator = v70 and Roact.createElement(UserTypingIndicator, {
							ZIndex = 2,
							height = 28,
							AnchorPoint = Vector2.new(0, 1),
							Position = UDim2.new(0, 0, 1, 0),
							usersTyping = p41.props.usersTyping,
							oneUserTyping = p41.props.oneUserTyping,
							twoUsersTyping = p41.props.twoUsersTyping,
							severalUsersTyping = p41.props.severalUsersTyping
						})
					}),
					ReplyAndInputContainer = if not FFlagAppChatReplyComposeBarContainer then nil else React.createElement(Foundation.View, {
						LayoutOrder = 3,
						tag = {
							["col size-full-0 auto-y gap-medium padding-y-medium"] = true,
							["bg-surface-100"] = if not FFlagAppChatSignalsReplyStore then p41.props.replyingToMessage else p41.props.replyingToMessageId ~= nil
						},
						onAbsoluteSizeChanged = p41.onHeightChanged,
						padding = {
							left = UDim.new(0, p44.left),
							right = uDim
						}
					}, {
						ReplyComposeBar = if not if not FFlagAppChatSignalsReplyStore then p41.props.replyingToMessage else p41.props.replyingToMessageId then nil else Roact.createElement(ReplyComposeBarContainer, {
							LayoutOrder = 1,
							message = if FFlagAppChatSignalsReplyStore then nil else p41.props.replyingToMessage,
							close = p41.closeReplying,
							inputBoxRef = p41.inputBoxRef
						}),
						Divider = if not p41.isMoreMenuEnabled() or (p41.props.shouldShowChatInputBar or p41.props.shouldHideMoreMenuButton) then nil else React.createElement(Foundation.View, {
							LayoutOrder = 4,
							tag = "size-full-0 auto-y stroke-standard stroke-default"
						}),
						ActionInputContainer = if not p41.isMoreMenuEnabled() then nil else React.createElement(Foundation.View, {
							LayoutOrder = 2,
							tag = "size-full-0 row gap-small auto-y align-y-center"
						}, {
							MoreMenu = if p41.props.shouldHideMoreMenuButton then nil else Roact.createElement(ChatConversationMoreMenu, {
								layoutOrder = 1,
								conversation = p41.props.conversation,
								conversationId = p41.props.conversationId,
								navigateToSquadLobby = p41.props.navigateToSquadLobby,
								showButtonText = not p41.props.shouldShowChatInputBar,
								tooltipText = not FFlagEnableScheduledSquads and "" or p41.state.tooltipText
							}),
							ChatInputBar = if not p41.props.shouldShowChatInputBar then nil else Roact.createElement(v18, {
								LayoutOrder = 2,
								onFocusLost = p41.clearKeyboardOffset,
								conversationId = p41.props.conversationId,
								inputBoxRef = p41.inputBoxRef,
								inputBarRef = p41.inputBarRef,
								localUserId = p41.props.localUserId,
								messageListRef = p41.messageListRef,
								onSendChat = p41.onSendChat(p41.props.sendMessage, p41.props.conversationId, p41.props.markConversationAsRead, p42, p41.props.conversation, p41.props.createFriendConversation, p41.props.navigateToChatConversation, p41.props.telemetry),
								onSendBtnClicked = p41.onSendBtnClicked(p41.props.telemetry),
								onTextChanged = p41.chatInputTextChanged,
								placeholderText = p41.props.chatInputPlaceholder,
								isDisabled = p41.props.shouldDisableChatInputBar,
								inputBarDisabledText = p41.props.inputBarDisabledText,
								disabledEndTimestampDisplay = p41.props.inputBarDisabledEndTimestampDisplay,
								onDisabledInputBarActivated = p41.props.onDisabledInputBarActivated,
								moreMenuEnabled = p41.isMoreMenuEnabled()
							})
						}),
						ChatInputBar = if p41.isMoreMenuEnabled() or not p41.props.shouldShowChatInputBar then nil else Roact.createElement(v18, {
							LayoutOrder = 4,
							onFocusLost = p41.clearKeyboardOffset,
							conversationId = p41.props.conversationId,
							inputBoxRef = p41.inputBoxRef,
							inputBarRef = p41.inputBarRef,
							localUserId = p41.props.localUserId,
							messageListRef = p41.messageListRef,
							onSendChat = p41.onSendChat(p41.props.sendMessage, p41.props.conversationId, p41.props.markConversationAsRead, p42, p41.props.conversation, p41.props.createFriendConversation, p41.props.navigateToChatConversation, p41.props.telemetry),
							onSendBtnClicked = p41.onSendBtnClicked(p41.props.telemetry),
							onTextChanged = p41.chatInputTextChanged,
							placeholderText = p41.props.chatInputPlaceholder,
							isDisabled = p41.props.shouldDisableChatInputBar,
							inputBarDisabledText = p41.props.inputBarDisabledText,
							disabledEndTimestampDisplay = p41.props.inputBarDisabledEndTimestampDisplay,
							onDisabledInputBarActivated = p41.props.onDisabledInputBarActivated,
							moreMenuEnabled = p41.isMoreMenuEnabled()
						})
					}),
					ReplyComposeBar = if FFlagAppChatReplyComposeBarContainer or not if not FFlagAppChatSignalsReplyStore then p41.props.replyingToMessage else p41.props.replyingToMessageId then nil else Roact.createElement(ReplyComposeBarContainer, {
						LayoutOrder = 3,
						message = if FFlagAppChatSignalsReplyStore then nil else p41.props.replyingToMessage,
						close = p41.closeReplying,
						setReplyComposeBarHeight = p41.setReplyComposeBarHeight,
						inputBoxRef = p41.inputBoxRef
					}),
					Divider = if FFlagAppChatReplyComposeBarContainer or (not p41.isMoreMenuEnabled() or (p41.props.shouldShowChatInputBar or p41.props.shouldHideMoreMenuButton)) then nil else React.createElement(Foundation.View, {
						LayoutOrder = 4,
						tag = "size-full-0 auto-y stroke-standard stroke-default"
					}),
					ActionInputContainer = if FFlagAppChatReplyComposeBarContainer or not p41.isMoreMenuEnabled() then nil else React.createElement(Foundation.View, {
						tag = "size-full-0 row gap-small auto-y align-y-center padding-y-small",
						LayoutOrder = p41.props.shouldShowChatInputBar and 5 or 4,
						padding = {
							left = UDim.new(0, p44.left),
							right = uDim
						},
						onAbsoluteSizeChanged = p41.onHeightChanged
					}, {
						MoreMenu = if p41.props.shouldHideMoreMenuButton then nil else Roact.createElement(ChatConversationMoreMenu, {
							layoutOrder = 1,
							conversation = p41.props.conversation,
							conversationId = p41.props.conversationId,
							navigateToSquadLobby = p41.props.navigateToSquadLobby,
							showButtonText = not p41.props.shouldShowChatInputBar,
							tooltipText = not FFlagEnableScheduledSquads and "" or p41.state.tooltipText
						}),
						ChatInputBar = if not p41.props.shouldShowChatInputBar then nil else Roact.createElement(v18, {
							LayoutOrder = 2,
							onFocusLost = p41.clearKeyboardOffset,
							conversationId = p41.props.conversationId,
							inputBoxRef = p41.inputBoxRef,
							inputBarRef = p41.inputBarRef,
							localUserId = p41.props.localUserId,
							messageListRef = p41.messageListRef,
							onSendChat = p41.onSendChat(p41.props.sendMessage, p41.props.conversationId, p41.props.markConversationAsRead, p42, p41.props.conversation, p41.props.createFriendConversation, p41.props.navigateToChatConversation, p41.props.telemetry),
							onSendBtnClicked = p41.onSendBtnClicked(p41.props.telemetry),
							onTextChanged = p41.chatInputTextChanged,
							placeholderText = p41.props.chatInputPlaceholder,
							isDisabled = p41.props.shouldDisableChatInputBar,
							inputBarDisabledText = p41.props.inputBarDisabledText,
							disabledEndTimestampDisplay = p41.props.inputBarDisabledEndTimestampDisplay,
							onDisabledInputBarActivated = p41.props.onDisabledInputBarActivated,
							moreMenuEnabled = p41.props.moreMenuEnabled
						})
					}),
					ChatInputBar = if FFlagAppChatReplyComposeBarContainer or (p41.isMoreMenuEnabled() or not p41.props.shouldShowChatInputBar) then nil else Roact.createElement(v18, {
						LayoutOrder = 4,
						onFocusLost = p41.clearKeyboardOffset,
						conversationId = p41.props.conversationId,
						inputBoxRef = p41.inputBoxRef,
						inputBarRef = p41.inputBarRef,
						localUserId = p41.props.localUserId,
						messageListRef = p41.messageListRef,
						onHeightChanged = if not p41.isMoreMenuEnabled() then p41.onHeightChanged else nil,
						onSendChat = p41.onSendChat(p41.props.sendMessage, p41.props.conversationId, p41.props.markConversationAsRead, p42, p41.props.conversation, p41.props.createFriendConversation, p41.props.navigateToChatConversation, p41.props.telemetry),
						onSendBtnClicked = p41.onSendBtnClicked(p41.props.telemetry),
						onTextChanged = p41.chatInputTextChanged,
						placeholderText = p41.props.chatInputPlaceholder,
						isDisabled = p41.props.shouldDisableChatInputBar,
						inputBarDisabledText = p41.props.inputBarDisabledText,
						disabledEndTimestampDisplay = p41.props.inputBarDisabledEndTimestampDisplay,
						onDisabledInputBarActivated = p41.props.onDisabledInputBarActivated,
						moreMenuEnabled = p41.props.moreMenuEnabled
					}),
					BottomModal = React.createElement(ConversationBottomModalContainer, {
						layoutOrder = 5,
						conversationId = p41.props.conversationId,
						onHeightChanged = p41.setBottomModalHeight,
						legacyBottomModalText = p41.props.bottomModalText,
						shouldShowLegacyBottomModal = p41.props.shouldShowLegacyBottomModal,
						shouldShowChatInputBar = p41.props.shouldShowChatInputBar
					})
				})
			end)
		end)
	end)
end

return connectTelemetry(ChatConversationTelemetryLayer.Context)(RoactNavigation.withNavigation(v49))
