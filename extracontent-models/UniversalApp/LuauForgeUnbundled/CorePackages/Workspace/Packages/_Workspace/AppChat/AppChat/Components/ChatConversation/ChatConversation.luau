local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local withStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Style.withStyle
local memoize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").memoize
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")
local coreGui = ReactFocusNavigation.EngineInterface.CoreGui
local focusNavigationService = ReactFocusNavigation.FocusNavigationService
local FocusBehaviors = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusBehaviors")
local UserInputService = game:GetService("UserInputService")
local IXPService = game:GetService("IXPService")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")

local MessageList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageList")
local SignalsMigrationConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/SignalsMigrationConfig")
local ReplyComposeBarContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ReplyComposeBarContainer")
local v5 = if require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatNewChatInputBar") then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatInputBar") else require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatInputBarDeprecated")
local UserTypingIndicator = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/UserTypingIndicator")
local v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("ChatConversation")
local withChatPagePadding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/withChatPagePadding")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local statusCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Http").StatusCodes
local dateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Time").DateTime
local ChatConversationMoreMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatConversationMoreMenu")
local module13 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/KeyboardOffsetEventHandler")
local MessageFtuxTooltipDismissSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageFtuxTooltip/MessageFtuxTooltipDismissSignal")
local ScrollToLatestButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ScrollToLatest/ScrollToLatestButton")
local FFlagAppChatConsoleFocusFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConsoleFocusFixes")
local FFlagAppChatScrollToLatest = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatScrollToLatest")

local GetReplyingToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetReplyingToStore")
local FFlagAppChatSignalsReplyStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatSignalsReplyStore")

local SmartSuggestionsChipRowContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/SmartSuggestions/SmartSuggestionsChipRowContainer")
local FFlagAppChatSmartSuggestions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatSmartSuggestions")

local ConversationExitType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/Enums/ConversationExitType")
local SendMessageError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/Enums/SendMessageError")
local withRoactChatAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LegacyAnalytics/withRoactChatAnalytics")
local connectTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/connectTelemetry")
local ChatConversationTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatConversationTelemetryEvents")
local ChatConversationTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatConversationTelemetryLayer")
local defineFastFlag = game:DefineFastFlag("AppChatNewChatInputBarIxpEnabled", false)
local defineFastString = game:DefineFastString("AppChatNewChatInputBarIxpLayer", "")
local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local FFlagAppChatMessageTTIMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMessageTTIMilestones")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")

local ConversationTopModalContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ConversationTopModalContainer")
local ConversationBottomModalContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ConversationModal/ConversationBottomModalContainer")

local extended = Roact.PureComponent:extend("ChatConversation")
extended.defaultProps = {
	topBarHeight = 0,
	conversationId = nil,
	conversationTitle = nil,
	itemList = {},
	inputBoxRef = nil,
	wideMode = false,
	getOlderMessages = function() end,
	isDebugEnabled = false,
	sendMessage = function() end,
	navigateToToast = function() end,
	markConversationAsRead = function() end,
	postTypingStatus = function() end,
	navigateBack = function() end,
	openViewProfile = function() end,
	updateConversationTitle = function() end,
	openGameDetailsPage = function() end,
	navigateToSquadLobby = function() end,
	onChatInputBarReady = function() end,
	viewProfileOnAvatarPressed = true,
	chatInputPlaceholder = "Say something",
	usersTyping = {},
	invalidMessageTypeText = "PLACEHOLDER This message could not be displayed",
	messageDefaultNoticeText = "PLACEHOLDER Not everyone in this chat can see your message.",
	messageModeratedNoticeText = "PLACEHOLDER Your message was moderated and not sent.",
	newText = "New",
	networkErrorText = "PLACEHOLDER There was a network error, please try again later",
	unknownUserText = "PLACEHOLDER unknown user",
	oneUserTyping = "PLACEHOLDER {DISPLAY_NAME} is typing...",
	twoUsersTyping = "PLACEHOLDER {DISPLAY_NAME_1} and {DISPLAY_NAME_2} are typing...",
	severalUsersTyping = "PLACEHOLDER Several users are typing...",
	bottomModalText = "PLACEHOLDER At this time, Chat is not available with this user.",
	readingMessagesIsEnabled = true,
	onConversationUnmount = function() end,
	chatIsVisible = true,
	moreMenuEnabled = false,
	keyboardOffset = nil,
	replyingToMessageId = nil,
	replyingToMessage = nil,
	replyingToMessageDispatch = function() end,
	shouldShowChatInputBar = true,
	shouldDisableChatInputBar = false,
	shouldShowLegacyBottomModal = false,
	telemetry = {
		emit = function() end
	},
	scrollToTopOnInitialOsaLoad = false,
	isInitialMessageLoading = false,
	displayNamesAvailable = true,
	shouldHideMoreMenuButton = false
}

function extended:init()
	self.state = {
		inputBarHeight = 0,
		keyboardOffset = 0,
		conversationBannerHeight = 0,
		messageListHeight = 0,
		bottomModalHeight = 0,
		tooltipText = "",
		scrolledAwayFromLatestConversationId = nil
	}

	self.inputBoxRef = self.props.inputBoxRef or Roact.createRef()
	self.inputBarRef = Roact.createRef()
	self.conversationViewRef = Roact.createRef()
	self.messageListRef = Roact.createRef()

	self.scrollToLatestRef = { current = nil }

	function self.onScrolledAwayFromLatestChanged(p2)
		local conversationId = if p2 then self.props.conversationId else nil

		if self.isMounted == false then
			return
		end

		self:setState(function(p3)
			if p3.scrolledAwayFromLatestConversationId == conversationId then
				return nil
			end

			local v8 = if conversationId == nil then Roact.None else conversationId
			return { scrolledAwayFromLatestConversationId = v8 }
		end)
	end

	function self.onScrollToLatestActivated()
		local current = self.scrollToLatestRef.current

		if current then
			current()
		end

		local v7 = self.focusNavigationService.focusedGuiObject:getValue() ~= nil
			and self.inputBarRef:getValue()

		if v7 then
			self.focusNavigationService:focusGuiObject(v7)
		end
	end

	function self.getKeyboardOffset()
		if
			UserInputService.OnScreenKeyboardVisible
			and self.inputBoxRef:getValue()
			and self.inputBoxRef:getValue():IsFocused()
		then
			if self.props.keyboardOffset ~= nil then
				return self.props.keyboardOffset
			end

			local value = self.conversationViewRef:getValue()

			if value then
				return value.AbsolutePosition.Y + value.AbsoluteSize.Y - UserInputService.OnScreenKeyboardPosition.Y
			end
		end

		return 0
	end

	function self.updateKeyboardOffset()
		if not self.isMounted then
			return
		end

		local keyboardOffset = self.getKeyboardOffset()

		if self.state.keyboardOffset ~= keyboardOffset then
			self:setState({ keyboardOffset = keyboardOffset })
		end
	end

	function self.onKeyboardOffsetChanged(p2)
		if not self.isMounted then
			return
		end

		local v7 = not (self.inputBoxRef:getValue() and self.inputBoxRef:getValue():IsFocused()) and 0 or p2

		if self.state.keyboardOffset ~= v7 then
			self:setState({ keyboardOffset = v7 })
		end
	end

	function self.clearKeyboardOffset()
		self:setState({ keyboardOffset = 0 })
	end

	self.loadNext = memoize(function(callback, p2)
		return function()
			local v7 = callback(p2)

			if v7 then
				v7:catch(function()
					self.showNetworkErrorToast()
				end)
			end
		end
	end)

	self.markAsRead = memoize(function(callback, p2)
		return function()
			if self.props.readingMessagesIsEnabled then
				callback(p2)
			end
		end
	end)

	function self.showNetworkErrorToast()
		self.props.navigateToToast({
			toastProps = {
				toastContent = { toastTitle = self.props.networkErrorText }
			}
		})
	end

	self.onSendChat = memoize(function(callback, p2, callback2, p3, p4, callback3, callback4, p5)
		return function(p6)
			if p4 and p4.source == "friends" then
				v6:info("Creating a conversation for friend conversation {} via onSendChat", p2)

				local v7, v8 = callback3(p2, p3):await()

				if v7 and v8 then
					v6:debug("Created conversation {} for friend conversation {} via onSendChat", v8.id, p2)

					p2 = v8.id
					callback4(v8.id)
				else
					v6:error("Could not create conversation. Error: {}", (tostring(v8)))
					return
				end
			end

			v6:info("Sending message '{}' to conversationId {} via onSendChat", p6, p2)

			if FFlagAppChatPerfTracking then
				if FFlagAppChatMessageTTIMilestones then
					AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageSendTTI, {
						conversationId = tostring(p2)
					})
				else
					AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageSendToPendingRender, {
						conversationId = tostring(p2)
					})

					AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageSendToFinalRender, {
						conversationId = tostring(p2)
					})
				end
			end

			local v7 = nil

			if FFlagAppChatSignalsReplyStore and self.props.replyingToMessageId then
				v7 = { id = self.props.replyingToMessageId }
			elseif not FFlagAppChatSignalsReplyStore then
				v7 = self.props.replyingToMessage
			end

			local v8 = callback(p2, p6, v7)

			if v8 then
				v8:andThen(function(p7)
					if p7 and p7.StatusCode == statusCodes.CONFLICT then
						self.showNetworkErrorToast()
					elseif callback2 then
						callback2(p2)
					end
				end)
			elseif callback2 then
				callback2(p2)
			end

			self.closeReplying()

			local v9 = {
				messageSentResult = SendMessageError.OtherFailure,
				recipientIds = self.props.recipientIdsSerialized
			}

			if v8 then
				v8:andThen(function(p7)
					local id = nil

					local id2 = nil
					local sender_user_id = nil
					local dateTime2 = nil
					local v10 = nil

					local statusCode = p7 and p7.StatusCode
					local v11

					if p7 then
						if statusCode == statusCodes.CONFLICT then
							v11 = SendMessageError.Conflict
						elseif p7.responseBody then
							if p7.responseBody.messages and #p7.responseBody.messages ~= 0 then
								if p7.responseBody.messages[1].status then
									v11 = p7.responseBody.messages[1].status
									id = p7.responseBody.messages[1].id

									if p7.responseBody.messages[1].replies_to then
										local replies_to = p7.responseBody.messages[1].replies_to

										id2 = replies_to.id
										sender_user_id = replies_to.sender_user_id

										dateTime2 = tostring(dateTime.fromIsoDate(replies_to.created_at).dateTime)

										if replies_to.content then
											v10 = #replies_to.content
										end
									end
								else
									v11 = SendMessageError.NoMessageStatus
								end
							else
								v11 = SendMessageError.NoMessages
							end
						else
							v11 = SendMessageError.NoResponseBody
						end
					else
						v11 = SendMessageError.NoResponse
					end

					p5.emit(ChatConversationTelemetryEvents.ConversationMessageSent, {
						messageSentResult = v11,
						messageId = id,
						recipientIds = self.props.recipientIdsSerialized,
						targetMessageId = id2,
						targetMessageSenderId = sender_user_id,
						targetMessageSentAt = dateTime2,
						targetMessageLength = v10
					})
				end):catch(function()
					p5.emit(ChatConversationTelemetryEvents.ConversationMessageSent, v9)
				end)
			else
				p5.emit(ChatConversationTelemetryEvents.ConversationMessageSent, v9)
			end
		end
	end)

	self.onSendBtnClicked = memoize(function(p2)
		return function(p3)
			p2.emit(ChatConversationTelemetryEvents.ConversationSendBtnClicked, { sendBtnClickResult = p3 })
		end
	end)

	function self.isMoreMenuEnabled()
		return self.props.moreMenuEnabled
	end

	self.reportInputBarReady = FFlagAppChatPerfTracking and function(p2)
		if self.props.onChatInputBarReady and self.props.shouldShowChatInputBar and p2 > 0 then
			self.props.onChatInputBarReady()
		end
	end or nil

	function self.onHeightChanged(p2)
		if FFlagAppChatPerfTracking then
			self.reportInputBarReady(p2.AbsoluteSize.Y)
		end

		self:setState(function(p3, p4)
			if p2.AbsoluteSize.Y == p3.inputBarHeight then
				return {}
			end

			return { inputBarHeight = p2.AbsoluteSize.Y }
		end)
	end

	self.lastTypingRequest = 0
	function self.chatInputTextChanged()
		if self.props.conversation and self.props.conversation.source == "friends" then
			return
		end

		local now = tick()

		if now - self.lastTypingRequest >= 3 then
			self.lastTypingRequest = now
			self.props.postTypingStatus(self.props.conversationId, true)
		end
	end

	self.exitTypeForAnalytics = ConversationExitType.Default

	function self.fireAnalyticsEventOnUnmount()
		self.props.onConversationUnmount(self.exitTypeForAnalytics)

		self.exitTypeForAnalytics = ConversationExitType.Default
	end

	function self.closeKeyboard()
		if self.inputBoxRef:getValue() then
			self.inputBoxRef:getValue():ReleaseFocus()
		end
	end

	function self.closeReplying()
		if FFlagAppChatSignalsReplyStore then
			GetReplyingToStore(false).clear()
		else
			self.props.replyingToMessageDispatch(nil)
		end
	end
	function self.onPointerInput()
		MessageFtuxTooltipDismissSignal.dismiss()
		self.closeKeyboard()
	end

	function self.onSizeChange()
		self.updateKeyboardOffset()
	end

	function self.calculateScrollOffset(data)
		local y = data.CanvasPosition.Y
		local y2 = data.AbsoluteCanvasSize.Y
		local y3 = data.AbsoluteWindowSize.Y
		return y2 - y - y3
	end

	function self.setBannerHeight(p2)
		self:setState({ conversationBannerHeight = p2 })
	end

	function self.setBottomModalHeight(p2)
		self:setState({ bottomModalHeight = p2 })
	end

	function self.onMessageListSizeChange(p2)
		self:setState({ messageListHeight = p2.AbsoluteSize.Y })
	end
	self.focusNavigationService = focusNavigationService.new(coreGui)
end

function extended:didMount()
	self.isMounted = true
	self.markAsRead(self.props.markConversationAsRead, self.props.conversationId)()
	local value = self.conversationViewRef:getValue()
	local value2 = self.inputBarRef:getValue()
	local focusNavigationService2 = self.focusNavigationService

	local v7 = if FFlagAppChatConsoleFocusFixes then FocusBehaviors.default(value2) else FocusBehaviors.mostRecentOrDefault(value2)
	focusNavigationService2:registerFocusBehavior(value, v7)

	if not self.props.wideMode and self.focusNavigationService.focusedGuiObject:getValue() ~= nil then
		self.focusNavigationService:focusGuiObject(value2)
	end

	if defineFastFlag and self.props.shouldShowChatInputBar then
		IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
	end
end

function extended.willUpdate(p2, p3, p4)
	if p3.chatIsVisible ~= p2.props.chatIsVisible and not p3.chatIsVisible then
		p2.closeKeyboard()
	end
end

function extended.didUpdate(object, data, p2)
	if object.props.wideMode and object.props.navigation.getParam("navigatedWithFocus") then
		local value = object.inputBarRef:getValue()
		object.props.navigation.setParams({ navigatedWithFocus = false })
		object.focusNavigationService:focusGuiObject(value)
	end

	if FFlagAppChatConsoleFocusFixes and data.conversationId == object.props.conversationId then
		local v7 = if FFlagAppChatSignalsReplyStore then data.replyingToMessageId else data.replyingToMessage

		local v8 = if FFlagAppChatSignalsReplyStore then object.props.replyingToMessageId else object.props.replyingToMessage

		local v9 = v8 ~= nil
			and v8 ~= v7
			and object.focusNavigationService.focusedGuiObject:getValue() ~= nil
			and object.inputBarRef:getValue()

		if v9 then
			object.focusNavigationService:focusGuiObject(v9)
		end
	end

	if data.conversationId ~= object.props.conversationId then
		if FFlagAppChatPerfTracking then
			object.reportInputBarReady(object.state.inputBarHeight)
		end

		if object.inputBoxRef:getValue() then
			local value_2 = object.inputBoxRef:getValue()
			value_2.Text = ""
			object.inputBoxRef:getValue():ReleaseFocus()
		end

		object.closeReplying()

		if FFlagAppChatScrollToLatest then
			local conversationId = data.conversationId
			object:setState(function(p3)
				if p3.scrolledAwayFromLatestConversationId == conversationId then
					return { scrolledAwayFromLatestConversationId = Roact.None }
				end

				return nil
			end)
		end

		object.markAsRead(object.props.markConversationAsRead, object.props.conversationId, false)()
	end

	if FFlagAppChatPerfTracking and data.shouldShowChatInputBar ~= object.props.shouldShowChatInputBar then
		object.reportInputBarReady(object.state.inputBarHeight)
	end

	local listRef = object.messageListRef
		and object.messageListRef.current
		and object.messageListRef.current._listRef
	local v7 = listRef and listRef._scrollRef and listRef._scrollRef.getNativeScrollRef()
	local v8 = object.state.messageListHeight - p2.messageListHeight

	if listRef and v7 and p2.messageListHeight ~= 0 and v8 ~= 0 then
		local scrollOffset = object.calculateScrollOffset(v7._nativeRef.current)

		if scrollOffset <= 0 then
			return
		end

		listRef:scrollToOffset({
			offset = scrollOffset + v8
		})
	end
end

function extended:willUnmount()
	self.fireAnalyticsEventOnUnmount()
	self.closeReplying()
	self.keyboardConnections = {}
	self.isMounted = false
	self.focusNavigationService:teardown()
end

function extended.render(props)
	local v7 = #props.props.usersTyping > 0 and props.props.displayNamesAvailable
	local v8 = if props.props.conversation then props.props.conversation.source == "friends" else false

	local v9 = "MessageList" .. tostring(props.props.conversationId)

	local onScrolledAwayFromLatestChanged = if FFlagAppChatScrollToLatest then props.onScrolledAwayFromLatestChanged else nil

	local scrollToLatestRef = if FFlagAppChatScrollToLatest then props.scrollToLatestRef else nil
	local v10

	if SignalsMigrationConfig.shouldUseViewRecyclerMessageList and props.props.conversationId ~= nil then
		local createElement = Roact.createElement
		local MessageListV2Container = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/MessageListV2/MessageListV2Container")
		local v11 = {
			conversationId = props.props.conversationId,
			itemList = props.props.itemList,
			loadNext = 0,
			markAsRead = 0,
			closeKeyboard = 0,
			onDetailsOpened = 0,
			inputBoxRef = 0,
			openGameDetailsPage = 0,
			openMomentsDeepLink = 0,
			openViewProfile = 0,
			viewProfileOnAvatarPressed = 0,
			wideMode = 0,
			isDebugEnabled = 0,
			readingMessagesIsEnabled = 0,
			isInitialMessageLoading = 0,
			openAtStart = 0,
			invalidMessageTypeText = 0,
			messageDefaultNoticeText = 0,
			messageModeratedNoticeText = 0,
			messageHiddenNoticeText = 0,
			unknownUserText = 0,
			onScrolledAwayFromLatestChanged = 0,
			scrollToLatestRef = 0
		}

		local v12 = if not v8 then props.loadNext(props.props.getOlderMessages, props.props.conversationId) else nil
		v11.loadNext = v12

		v11.markAsRead = props.markAsRead(props.props.markConversationAsRead, props.props.conversationId)
		v11.closeKeyboard = props.closeKeyboard
		v11.onDetailsOpened = props.closeKeyboard
		v11.inputBoxRef = props.inputBoxRef
		v11.openGameDetailsPage = props.props.openGameDetailsPage
		v11.openMomentsDeepLink = props.props.openMomentsDeepLink
		v11.openViewProfile = props.props.openViewProfile
		v11.viewProfileOnAvatarPressed = props.props.viewProfileOnAvatarPressed
		v11.wideMode = props.props.wideMode
		v11.isDebugEnabled = props.props.isDebugEnabled
		v11.readingMessagesIsEnabled = props.props.readingMessagesIsEnabled
		v11.isInitialMessageLoading = props.props.isInitialMessageLoading
		v11.openAtStart = props.props.openMessageListAtStart
		v11.invalidMessageTypeText = props.props.invalidMessageTypeText
		v11.messageDefaultNoticeText = props.props.messageDefaultNoticeText
		v11.messageModeratedNoticeText = props.props.messageModeratedNoticeText
		v11.messageHiddenNoticeText = props.props.messageHiddenNoticeText
		v11.unknownUserText = props.props.unknownUserText
		v11.onScrolledAwayFromLatestChanged = onScrolledAwayFromLatestChanged
		v11.scrollToLatestRef = scrollToLatestRef
		v10 = createElement(MessageListV2Container, v11)
	else
		v10 = nil
	end

	local v11

	if
		FFlagAppChatScrollToLatest
		and props.props.conversationId ~= nil
		and props.state.scrolledAwayFromLatestConversationId == props.props.conversationId
	then
		v11 = Roact.createElement(ScrollToLatestButton, {
			conversationId = props.props.conversationId,
			messageListVersion = v10 == nil and "legacy" or "viewRecycler",
			onActivated = props.onScrollToLatestActivated
		})
	else
		v11 = nil
	end

	return withRoactChatAnalytics(function(p2)
		return withStyle(function(p3)
			return withChatPagePadding(function(p4)
				local udim

				if props.isMoreMenuEnabled() then
					udim = UDim.new(0, (math.max(p4.right - 6, 0)))

					if props.props.shouldDisableChatInputBar then
						udim = UDim.new(0, p4.right)
					end
				end

				local createElement = Roact.createElement
				local v13 = {
					AutoButtonColor = false,
					BackgroundColor3 = p3.Theme.BackgroundDefault.Color,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
					Text = "",
					Transparency = p3.Tokens.Color.None.Transparency,
					[Roact.Event.TouchTap] = props.onPointerInput,
					[Roact.Event.MouseButton1Down] = props.onPointerInput,
					[Roact.Ref] = props.conversationViewRef,
					Selectable = false
				}

				local children = {
					KeyboardOffsetEventHandler = Roact.createElement(module13, {
						onKeyboardOffsetChanged = props.onKeyboardOffsetChanged,
						parentViewRef = props.conversationViewRef
					}),
					Layout = 0,
					ConversationTopModal = 0,
					MessageListFrame = 0,
					ReplyAndInputContainer = 0,
					BottomModal = 0
				}

				local createElement2 = Roact.createElement
				local v16 = if not props.isMoreMenuEnabled() then Enum.HorizontalAlignment.Right else nil
				children.Layout = createElement2("UIListLayout", {
					HorizontalAlignment = v16,
					SortOrder = Enum.SortOrder.LayoutOrder
				})

				children.ConversationTopModal = Roact.createElement(ConversationTopModalContainer, {
					conversationId = props.props.conversationId,
					setModalHeight = props.setBannerHeight,
					layoutOrder = 1
				})

				local createElement3 = Roact.createElement
				local onMessageListSizeChangesByAbsoluteSize = {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 2,
					[Roact.Change.AbsoluteSize] = props.onMessageListSizeChange,
					Size = UDim2.new(
						1,
						0,
						1,
						-props.state.inputBarHeight - props.state.keyboardOffset - props.state.conversationBannerHeight - props.state.bottomModalHeight
					)
				}

				local v18 = {}
				v18.MessageListV2 = v10
				local v20

				if v10 == nil then
					local createElement4 = Roact.createElement
					local v22 = {
						Size = UDim2.new(1, 0, 1, 0),
						bottomMargin = 28,
						conversationId = props.props.conversationId,
						isDebugEnabled = props.props.isDebugEnabled,
						itemList = props.props.itemList,
						loadNext = 0,
						localUserId = 0,
						markAsRead = 0,
						messageListRef = 0,
						openViewProfile = 0,
						onDetailsOpened = 0,
						closeKeyboard = 0,
						inputBoxRef = 0,
						wideMode = 0,
						viewProfileOnAvatarPressed = 0,
						readingMessagesIsEnabled = 0,
						invalidMessageTypeText = 0,
						messageDefaultNoticeText = 0,
						messageModeratedNoticeText = 0,
						messageHiddenNoticeText = 0,
						unknownUserText = 0,
						openGameDetailsPage = 0,
						openMomentsDeepLink = 0,
						scrollToTopOnInitialOsaLoad = 0,
						isInitialMessageLoading = 0,
						onScrolledAwayFromLatestChanged = 0,
						scrollToLatestRef = 0
					}

					local v23 = if not v8 then props.loadNext(
						props.props.getOlderMessages,
						props.props.conversationId
					) else nil
					v22.loadNext = v23

					v22.localUserId = props.props.localUserId
					v22.markAsRead = props.markAsRead(
						props.props.markConversationAsRead,
						props.props.conversationId
					)

					v22.messageListRef = props.messageListRef
					v22.openViewProfile = props.props.openViewProfile
					v22.onDetailsOpened = props.closeKeyboard
					v22.closeKeyboard = props.closeKeyboard
					v22.inputBoxRef = props.inputBoxRef
					v22.wideMode = props.props.wideMode
					v22.viewProfileOnAvatarPressed = props.props.viewProfileOnAvatarPressed
					v22.readingMessagesIsEnabled = props.props.readingMessagesIsEnabled

					v22.invalidMessageTypeText = props.props.invalidMessageTypeText
					v22.messageDefaultNoticeText = props.props.messageDefaultNoticeText
					v22.messageModeratedNoticeText = props.props.messageModeratedNoticeText
					v22.messageHiddenNoticeText = props.props.messageHiddenNoticeText
					v22.unknownUserText = props.props.unknownUserText
					v22.openGameDetailsPage = props.props.openGameDetailsPage
					v22.openMomentsDeepLink = props.props.openMomentsDeepLink
					v22.scrollToTopOnInitialOsaLoad = props.props.scrollToTopOnInitialOsaLoad
					v22.isInitialMessageLoading = props.props.isInitialMessageLoading
					v22.onScrolledAwayFromLatestChanged = onScrolledAwayFromLatestChanged
					v22.scrollToLatestRef = scrollToLatestRef
					v20 = createElement4(MessageList, v22)
				else
					v20 = false
				end

				v18[v9] = v20

				v18.ScrollToLatestButton = v11
				v18.UserTypingIndicator = v7 and Roact.createElement(UserTypingIndicator, {
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.new(0, 0, 1, 0),
					ZIndex = 2,
					height = 28,
					usersTyping = props.props.usersTyping,
					oneUserTyping = props.props.oneUserTyping,
					twoUsersTyping = props.props.twoUsersTyping,
					severalUsersTyping = props.props.severalUsersTyping
				})
				children.MessageListFrame = createElement3(
					"Frame",
					onMessageListSizeChangesByAbsoluteSize,
					v18
				)

				local createElement4 = React.createElement
				local view = Foundation.View

				local v23 = if FFlagAppChatSignalsReplyStore then props.props.replyingToMessageId ~= nil else props.props.replyingToMessage
				local v21 = {
					LayoutOrder = 3,
					tag = {
						["col size-full-0 auto-y gap-medium padding-y-medium"] = true,
						["bg-surface-100"] = v23
					},
					onAbsoluteSizeChanged = props.onHeightChanged,
					padding = { left = UDim.new(0, p4.left), right = udim }
				}

				local v25 = if FFlagAppChatSmartSuggestions then React.createElement(SmartSuggestionsChipRowContainer, {
					LayoutOrder = 0,
					conversationId = props.props.conversationId,
					sendMessage = props.props.sendMessage,
					sendGameLinkChatMessage = props.props.sendGameLinkChatMessage
				}) else nil

				local v26 = if FFlagAppChatSignalsReplyStore then props.props.replyingToMessageId else props.props.replyingToMessage
				local v27

				if v26 then
					local createElement5 = Roact.createElement

					local v30 = if not FFlagAppChatSignalsReplyStore then props.props.replyingToMessage else nil
					v27 = createElement5(ReplyComposeBarContainer, {
						LayoutOrder = 1,
						message = v30,
						close = props.closeReplying,
						inputBoxRef = props.inputBoxRef
					})
				end

				local v28 = if props.isMoreMenuEnabled() and not (props.props.shouldShowChatInputBar or props.props.shouldHideMoreMenuButton) then React.createElement(Foundation.View, {
					LayoutOrder = 4,
					tag = "size-full-0 auto-y stroke-standard stroke-default"
				}) else nil
				local v29

				if props.isMoreMenuEnabled() then
					local createElement5 = React.createElement
					local view2 = Foundation.View

					local v32 = if not props.props.shouldHideMoreMenuButton then Roact.createElement(ChatConversationMoreMenu, {
						conversation = props.props.conversation,
						conversationId = props.props.conversationId,
						navigateToSquadLobby = props.props.navigateToSquadLobby,
						layoutOrder = 1,
						showButtonText = not props.props.shouldShowChatInputBar,
						tooltipText = props.state.tooltipText
					}) else nil

					local v33 = if props.props.shouldShowChatInputBar then Roact.createElement(v5, {
						LayoutOrder = 2,
						onFocusLost = props.clearKeyboardOffset,
						conversationId = props.props.conversationId,
						inputBoxRef = props.inputBoxRef,
						inputBarRef = props.inputBarRef,
						localUserId = props.props.localUserId,
						messageListRef = props.messageListRef,
						onSendChat = props.onSendChat(
							props.props.sendMessage,
							props.props.conversationId,
							props.props.markConversationAsRead,
							p2,
							props.props.conversation,
							props.props.createFriendConversation,
							props.props.navigateToChatConversation,
							props.props.telemetry
						),
						onSendBtnClicked = props.onSendBtnClicked(props.props.telemetry),
						onTextChanged = props.chatInputTextChanged,
						placeholderText = props.props.chatInputPlaceholder,
						isDisabled = props.props.shouldDisableChatInputBar,
						inputBarDisabledText = props.props.inputBarDisabledText,
						disabledEndTimestampDisplay = props.props.inputBarDisabledEndTimestampDisplay,
						onDisabledInputBarActivated = props.props.onDisabledInputBarActivated,
						moreMenuEnabled = props.isMoreMenuEnabled()
					}) else nil
					v29 = createElement5(
						view2,
						{
							LayoutOrder = 2,
							tag = "size-full-0 row gap-small auto-y align-y-center"
						},
						{ MoreMenu = v32, ChatInputBar = v33 }
					)
				end

				local v30 = if not (props.isMoreMenuEnabled() or not props.props.shouldShowChatInputBar) then Roact.createElement(v5, {
					LayoutOrder = 4,
					onFocusLost = props.clearKeyboardOffset,
					conversationId = props.props.conversationId,
					inputBoxRef = props.inputBoxRef,
					inputBarRef = props.inputBarRef,
					localUserId = props.props.localUserId,
					messageListRef = props.messageListRef,
					onSendChat = props.onSendChat(
						props.props.sendMessage,
						props.props.conversationId,
						props.props.markConversationAsRead,
						p2,
						props.props.conversation,
						props.props.createFriendConversation,
						props.props.navigateToChatConversation,
						props.props.telemetry
					),
					onSendBtnClicked = props.onSendBtnClicked(props.props.telemetry),
					onTextChanged = props.chatInputTextChanged,
					placeholderText = props.props.chatInputPlaceholder,
					isDisabled = props.props.shouldDisableChatInputBar,
					inputBarDisabledText = props.props.inputBarDisabledText,
					disabledEndTimestampDisplay = props.props.inputBarDisabledEndTimestampDisplay,
					onDisabledInputBarActivated = props.props.onDisabledInputBarActivated,
					moreMenuEnabled = props.isMoreMenuEnabled()
				}) else nil
				children.ReplyAndInputContainer = createElement4(view, v21, {
					SmartSuggestionsChipRow = v25,
					ReplyComposeBar = v27,
					Divider = v28,
					ActionInputContainer = v29,
					ChatInputBar = v30
				})

				children.BottomModal = React.createElement(ConversationBottomModalContainer, {
					conversationId = props.props.conversationId,
					layoutOrder = 5,
					onHeightChanged = props.setBottomModalHeight,
					legacyBottomModalText = props.props.bottomModalText,
					shouldShowLegacyBottomModal = props.props.shouldShowLegacyBottomModal,
					shouldShowChatInputBar = props.props.shouldShowChatInputBar
				})
				return createElement("TextButton", v13, children)
			end)
		end)
	end)
end

return connectTelemetry(ChatConversationTelemetryLayer.Context)(RoactNavigation.withNavigation(extended))
