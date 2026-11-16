local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)
local withStyle = UIBlox.Style.withStyle
local AppCommonLib = require(parent.AppCommonLib)
local memoize = AppCommonLib.memoize
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local CoreGui = ReactFocusNavigation.EngineInterface.CoreGui
local FocusNavigationService = ReactFocusNavigation.FocusNavigationService
local FocusBehaviors = require(parent.FocusBehaviors)
local UserInputService = game:GetService("UserInputService")
local IXPService = game:GetService("IXPService")
local RoactNavigation = require(parent.RoactNavigation)

local MessageList = require(script.Parent.MessageList)
local SignalsMigrationConfig = require(AppChat.Flags.SignalsMigrationConfig)
local ReplyComposeBarContainer = require(script.Parent.ReplyComposeBarContainer)
local FFlagAppChatNewChatInputBar = require(AppChat.Flags.FFlagAppChatNewChatInputBar)
local v

if FFlagAppChatNewChatInputBar then
	v = require(script.Parent.ChatInputBar)
else
	v = require(script.Parent.ChatInputBarDeprecated)
end

local UserTypingIndicator = require(script.Parent.UserTypingIndicator)
local Logger = require(AppChat.Logger)
local v2 = Logger:new(script.Name)
local withChatPagePadding = require(AppChat.Contexts.ChatPagePadding.withChatPagePadding)
require(AppChat.Models.ConversationChannels)
local Http = require(parent.Http)
local StatusCodes = Http.StatusCodes
local Time = require(parent.Time)
local DateTime = Time.DateTime
local ChatConversationMoreMenu = require(script.Parent.ChatConversationMoreMenu)
local KeyboardOffsetEventHandler = require(script.Parent.KeyboardOffsetEventHandler)
local GlobalLongPressSignal = require(script.Parent.Utils.GlobalLongPressSignal)
local ScrollToLatestButton = require(script.Parent.ScrollToLatest.ScrollToLatestButton)
local FFlagAppChatConsoleFocusFixes = require(AppChat.Flags.FFlagAppChatConsoleFocusFixes)
local FFlagAppChatScrollToLatest = require(AppChat.Flags.FFlagAppChatScrollToLatest)

local GetReplyingToStore = require(AppChat.Stores.GetReplyingToStore)
local FFlagAppChatSignalsReplyStore = require(AppChat.Flags.FFlagAppChatSignalsReplyStore)

local SmartSuggestionsChipRowContainer = require(script.Parent.SmartSuggestions.SmartSuggestionsChipRowContainer)
local FFlagAppChatSmartSuggestions = require(AppChat.Flags.FFlagAppChatSmartSuggestions)

local ConversationExitType = require(AppChat.Analytics.Enums.ConversationExitType)
local SendMessageError = require(AppChat.Analytics.Enums.SendMessageError)
local withRoactChatAnalytics = require(AppChat.LegacyAnalytics.withRoactChatAnalytics)
local connectTelemetry = require(AppChat.Telemetry.connectTelemetry)
local ChatConversationTelemetryEvents = require(script.Parent.ChatConversationTelemetryEvents)
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local defineFastFlag = game:DefineFastFlag("AppChatNewChatInputBarIxpEnabled", false)
local defineFastString = game:DefineFastString("AppChatNewChatInputBarIxpLayer", "")
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatMessageTTIMilestones = require(AppChat.Flags.FFlagAppChatMessageTTIMilestones)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)

local ConversationTopModalContainer = require(script.Parent.ConversationTopModalContainer)
local ConversationBottomModalContainer = require(script.Parent.ConversationModal.ConversationBottomModalContainer)

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

	function self.onScrolledAwayFromLatestChanged(flag: boolean)
		local conversationId

		if flag then
			conversationId = self.props.conversationId
		else
			conversationId = nil
		end

		if self.isMounted == false then
			return
		end

		self:setState(function(p)
			if p.scrolledAwayFromLatestConversationId == conversationId then
				return nil
			end

			local scrolledAwayFromLatestConversationId

			if conversationId == nil then
				scrolledAwayFromLatestConversationId = Roact.None
			else
				scrolledAwayFromLatestConversationId = conversationId
			end

			return { scrolledAwayFromLatestConversationId = scrolledAwayFromLatestConversationId }
		end)
	end

	function self.onScrollToLatestActivated()
		local current = self.scrollToLatestRef.current

		if current then
			current()
		end

		local v3 = self.focusNavigationService.focusedGuiObject:getValue() ~= nil and self.inputBarRef:getValue()

		if v3 then
			self.focusNavigationService:focusGuiObject(v3)
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

	function self.onKeyboardOffsetChanged(p)
		if not self.isMounted then
			return
		end

		local keyboardOffset = not (self.inputBoxRef:getValue() and self.inputBoxRef:getValue():IsFocused()) and 0 or p

		if self.state.keyboardOffset ~= keyboardOffset then
			self:setState({ keyboardOffset = keyboardOffset })
		end
	end

	function self.clearKeyboardOffset()
		self:setState({ keyboardOffset = 0 })
	end

	self.loadNext = memoize(function(callback, p)
		return function()
			local v3 = callback(p)

			if v3 then
				v3:catch(function()
					self.showNetworkErrorToast()
				end)
			end
		end
	end)

	self.markAsRead = memoize(function(callback, p)
		return function()
			if self.props.readingMessagesIsEnabled then
				callback(p)
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

	self.onSendChat = memoize(function(callback, p, callback2, p2, p3, callback3, callback4, p4)
		return function(p5)
			if p3 and p3.source == "friends" then
				v2:info("Creating a conversation for friend conversation {} via onSendChat", p)

				local v3, v4 = callback3(p, p2):await()

				if v3 and v4 then
					v2:debug("Created conversation {} for friend conversation {} via onSendChat", v4.id, p)

					p = v4.id
					callback4(v4.id)
				else
					v2:error("Could not create conversation. Error: {}", (tostring(v4)))
					return
				end
			end

			v2:info("Sending message '{}' to conversationId {} via onSendChat", p5, p)

			if FFlagAppChatPerfTracking then
				if FFlagAppChatMessageTTIMilestones then
					AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageSendTTI, {
						conversationId = tostring(p)
					})
				else
					AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageSendToPendingRender, {
						conversationId = tostring(p)
					})

					AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageSendToFinalRender, {
						conversationId = tostring(p)
					})
				end
			end

			local v3 = nil

			if FFlagAppChatSignalsReplyStore and self.props.replyingToMessageId then
				v3 = { id = self.props.replyingToMessageId }
			elseif not FFlagAppChatSignalsReplyStore then
				v3 = self.props.replyingToMessage
			end

			local v4 = callback(p, p5, v3)

			if v4 then
				v4:andThen(function(p6)
					if p6 and p6.StatusCode == StatusCodes.CONFLICT then
						self.showNetworkErrorToast()
					elseif callback2 then
						callback2(p)
					end
				end)
			elseif callback2 then
				callback2(p)
			end

			self.closeReplying()

			local v5 = {
				messageSentResult = SendMessageError.OtherFailure,
				recipientIds = self.props.recipientIdsSerialized
			}

			if v4 then
				v4:andThen(function(p6)
					local id = nil

					local id2 = nil
					local sender_user_id = nil
					local dateTime = nil
					local targetMessageLength = nil

					local statusCode = p6 and p6.StatusCode
					local messageSentResult

					if p6 then
						if statusCode == StatusCodes.CONFLICT then
							messageSentResult = SendMessageError.Conflict
						elseif p6.responseBody then
							if p6.responseBody.messages and #p6.responseBody.messages ~= 0 then
								if p6.responseBody.messages[1].status then
									messageSentResult = p6.responseBody.messages[1].status
									id = p6.responseBody.messages[1].id

									if p6.responseBody.messages[1].replies_to then
										local replies_to = p6.responseBody.messages[1].replies_to

										id2 = replies_to.id
										sender_user_id = replies_to.sender_user_id

										dateTime = tostring(DateTime.fromIsoDate(replies_to.created_at).dateTime)

										if replies_to.content then
											targetMessageLength = #replies_to.content
										end
									end
								else
									messageSentResult = SendMessageError.NoMessageStatus
								end
							else
								messageSentResult = SendMessageError.NoMessages
							end
						else
							messageSentResult = SendMessageError.NoResponseBody
						end
					else
						messageSentResult = SendMessageError.NoResponse
					end

					p4.emit(ChatConversationTelemetryEvents.ConversationMessageSent, {
						messageSentResult = messageSentResult,
						messageId = id,
						recipientIds = self.props.recipientIdsSerialized,
						targetMessageId = id2,
						targetMessageSenderId = sender_user_id,
						targetMessageSentAt = dateTime,
						targetMessageLength = targetMessageLength
					})
				end):catch(function()
					p4.emit(ChatConversationTelemetryEvents.ConversationMessageSent, v5)
				end)
			else
				p4.emit(ChatConversationTelemetryEvents.ConversationMessageSent, v5)
			end
		end
	end)

	self.onSendBtnClicked = memoize(function(p)
		return function(sendBtnClickResult: string?)
			p.emit(ChatConversationTelemetryEvents.ConversationSendBtnClicked, {
				sendBtnClickResult = sendBtnClickResult
			})
		end
	end)

	function self.isMoreMenuEnabled()
		return self.props.moreMenuEnabled
	end

	self.reportInputBarReady = FFlagAppChatPerfTracking and function(p: number)
		if self.props.onChatInputBarReady and self.props.shouldShowChatInputBar and p > 0 then
			self.props.onChatInputBarReady()
		end
	end or nil

	function self.onHeightChanged(p)
		if FFlagAppChatPerfTracking then
			self.reportInputBarReady(p.AbsoluteSize.Y)
		end

		self:setState(function(p2, _)
			if p.AbsoluteSize.Y == p2.inputBarHeight then
				return {}
			end

			return { inputBarHeight = p.AbsoluteSize.Y }
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
		GlobalLongPressSignal.dismiss()
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

	function self.setBannerHeight(conversationBannerHeight)
		self:setState({ conversationBannerHeight = conversationBannerHeight })
	end

	function self.setBottomModalHeight(bottomModalHeight)
		self:setState({ bottomModalHeight = bottomModalHeight })
	end

	function self.onMessageListSizeChange(p)
		self:setState({ messageListHeight = p.AbsoluteSize.Y })
	end
	self.focusNavigationService = FocusNavigationService.new(CoreGui)
end

function extended:didMount()
	self.isMounted = true
	self.markAsRead(self.props.markConversationAsRead, self.props.conversationId)()
	local value = self.conversationViewRef:getValue()
	local value2 = self.inputBarRef:getValue()
	local focusNavigationService = self.focusNavigationService
	local v3

	if FFlagAppChatConsoleFocusFixes then
		v3 = FocusBehaviors.default(value2)
	else
		v3 = FocusBehaviors.mostRecentOrDefault(value2)
	end

	focusNavigationService:registerFocusBehavior(value, v3)

	if not self.props.wideMode and self.focusNavigationService.focusedGuiObject:getValue() ~= nil then
		self.focusNavigationService:focusGuiObject(value2)
	end

	if defineFastFlag and self.props.shouldShowChatInputBar then
		IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
	end
end

function extended.willUpdate(p, p2, _)
	if p2.chatIsVisible ~= p.props.chatIsVisible and not p2.chatIsVisible then
		p.closeKeyboard()
	end
end

function extended.didUpdate(object, data, p)
	if object.props.wideMode and object.props.navigation.getParam("navigatedWithFocus") then
		local value = object.inputBarRef:getValue()
		object.props.navigation.setParams({ navigatedWithFocus = false })
		object.focusNavigationService:focusGuiObject(value)
	end

	if FFlagAppChatConsoleFocusFixes and data.conversationId == object.props.conversationId then
		local v3

		if FFlagAppChatSignalsReplyStore then
			v3 = data.replyingToMessageId
		else
			v3 = data.replyingToMessage
		end

		local v4

		if FFlagAppChatSignalsReplyStore then
			v4 = object.props.replyingToMessageId
		else
			v4 = object.props.replyingToMessage
		end

		local v5 = v4 ~= nil
			and v4 ~= v3
			and object.focusNavigationService.focusedGuiObject:getValue() ~= nil
			and object.inputBarRef:getValue()

		if v5 then
			object.focusNavigationService:focusGuiObject(v5)
		end
	end

	if data.conversationId ~= object.props.conversationId then
		if FFlagAppChatPerfTracking then
			object.reportInputBarReady(object.state.inputBarHeight)
		end

		if object.inputBoxRef:getValue() then
			local value = object.inputBoxRef:getValue()
			value.Text = ""
			object.inputBoxRef:getValue():ReleaseFocus()
		end

		object.closeReplying()

		if FFlagAppChatScrollToLatest then
			local conversationId = data.conversationId
			object:setState(function(p2)
				if p2.scrolledAwayFromLatestConversationId == conversationId then
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

	local listRef = object.messageListRef and object.messageListRef.current and object.messageListRef.current._listRef
	local v3 = listRef and listRef._scrollRef and listRef._scrollRef.getNativeScrollRef()
	local v4 = object.state.messageListHeight - p.messageListHeight

	if listRef and v3 and p.messageListHeight ~= 0 and v4 ~= 0 then
		local scrollOffset = object.calculateScrollOffset(v3._nativeRef.current)

		if scrollOffset <= 0 then
			return
		end

		listRef:scrollToOffset({
			offset = scrollOffset + v4
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
	local v3

	if #props.props.usersTyping > 0 then
		v3 = props.props.displayNamesAvailable
	else
		v3 = false
	end

	local v4

	if props.props.conversation then
		v4 = props.props.conversation.source == "friends"
	else
		v4 = false
	end

	local v5 = "MessageList" .. tostring(props.props.conversationId)
	local onScrolledAwayFromLatestChanged

	if FFlagAppChatScrollToLatest then
		onScrolledAwayFromLatestChanged = props.onScrolledAwayFromLatestChanged
	else
		onScrolledAwayFromLatestChanged = nil
	end

	local scrollToLatestRef

	if FFlagAppChatScrollToLatest then
		scrollToLatestRef = props.scrollToLatestRef
	else
		scrollToLatestRef = nil
	end

	local messageListV

	if SignalsMigrationConfig.shouldUseViewRecyclerMessageList and props.props.conversationId ~= nil then
		local createElement = Roact.createElement
		local MessageListV2Container = require(AppChat.Components.MessageListV2.MessageListV2Container)
		local v6 = {
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
		local loadNext

		if not v4 then
			loadNext = props.loadNext(props.props.getOlderMessages, props.props.conversationId)
		end

		v6.loadNext = loadNext

		v6.markAsRead = props.markAsRead(props.props.markConversationAsRead, props.props.conversationId)
		v6.closeKeyboard = props.closeKeyboard
		v6.onDetailsOpened = props.closeKeyboard
		v6.inputBoxRef = props.inputBoxRef
		v6.openGameDetailsPage = props.props.openGameDetailsPage
		v6.openMomentsDeepLink = props.props.openMomentsDeepLink
		v6.openViewProfile = props.props.openViewProfile
		v6.viewProfileOnAvatarPressed = props.props.viewProfileOnAvatarPressed
		v6.wideMode = props.props.wideMode
		v6.isDebugEnabled = props.props.isDebugEnabled
		v6.readingMessagesIsEnabled = props.props.readingMessagesIsEnabled
		v6.isInitialMessageLoading = props.props.isInitialMessageLoading
		v6.openAtStart = props.props.openMessageListAtStart
		v6.invalidMessageTypeText = props.props.invalidMessageTypeText
		v6.messageDefaultNoticeText = props.props.messageDefaultNoticeText
		v6.messageModeratedNoticeText = props.props.messageModeratedNoticeText
		v6.messageHiddenNoticeText = props.props.messageHiddenNoticeText
		v6.unknownUserText = props.props.unknownUserText
		v6.onScrolledAwayFromLatestChanged = onScrolledAwayFromLatestChanged
		v6.scrollToLatestRef = scrollToLatestRef
		messageListV = createElement(MessageListV2Container, v6)
	else
		messageListV = nil
	end

	local scrollToLatestButton

	if
		FFlagAppChatScrollToLatest
		and props.props.conversationId ~= nil
		and props.state.scrolledAwayFromLatestConversationId == props.props.conversationId
	then
		scrollToLatestButton = Roact.createElement(ScrollToLatestButton, {
			conversationId = props.props.conversationId,
			messageListVersion = messageListV == nil and "legacy" or "viewRecycler",
			onActivated = props.onScrollToLatestActivated
		})
	else
		scrollToLatestButton = nil
	end

	return withRoactChatAnalytics(function(p)
		return withStyle(function(p2)
			return withChatPagePadding(function(p3)
				local udim

				if props.isMoreMenuEnabled() then
					udim = UDim.new(0, (math.max(p3.right - 6, 0)))

					if props.props.shouldDisableChatInputBar then
						udim = UDim.new(0, p3.right)
					end
				end

				local createElement = Roact.createElement
				local v6 = {
					AutoButtonColor = false,
					BackgroundColor3 = p2.Theme.BackgroundDefault.Color,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
					Text = "",
					Transparency = p2.Tokens.Color.None.Transparency,
					[Roact.Event.TouchTap] = props.onPointerInput,
					[Roact.Event.MouseButton1Down] = props.onPointerInput,
					[Roact.Ref] = props.conversationViewRef,
					Selectable = false
				}

				local children = {
					KeyboardOffsetEventHandler = Roact.createElement(KeyboardOffsetEventHandler, {
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
				local horizontalAlignment

				if not props.isMoreMenuEnabled() then
					horizontalAlignment = Enum.HorizontalAlignment.Right
				end

				children.Layout = createElement2("UIListLayout", {
					HorizontalAlignment = horizontalAlignment,
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

				local v7 = {}
				v7.MessageListV2 = messageListV
				local v8

				if messageListV == nil then
					local createElement4 = Roact.createElement
					local v9 = {
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
					local loadNext

					if not v4 then
						loadNext = props.loadNext(props.props.getOlderMessages, props.props.conversationId)
					end

					v9.loadNext = loadNext

					v9.localUserId = props.props.localUserId
					v9.markAsRead = props.markAsRead(props.props.markConversationAsRead, props.props.conversationId)

					v9.messageListRef = props.messageListRef
					v9.openViewProfile = props.props.openViewProfile
					v9.onDetailsOpened = props.closeKeyboard
					v9.closeKeyboard = props.closeKeyboard
					v9.inputBoxRef = props.inputBoxRef
					v9.wideMode = props.props.wideMode
					v9.viewProfileOnAvatarPressed = props.props.viewProfileOnAvatarPressed
					v9.readingMessagesIsEnabled = props.props.readingMessagesIsEnabled

					v9.invalidMessageTypeText = props.props.invalidMessageTypeText
					v9.messageDefaultNoticeText = props.props.messageDefaultNoticeText
					v9.messageModeratedNoticeText = props.props.messageModeratedNoticeText
					v9.messageHiddenNoticeText = props.props.messageHiddenNoticeText
					v9.unknownUserText = props.props.unknownUserText
					v9.openGameDetailsPage = props.props.openGameDetailsPage
					v9.openMomentsDeepLink = props.props.openMomentsDeepLink
					v9.scrollToTopOnInitialOsaLoad = props.props.scrollToTopOnInitialOsaLoad
					v9.isInitialMessageLoading = props.props.isInitialMessageLoading
					v9.onScrolledAwayFromLatestChanged = onScrolledAwayFromLatestChanged
					v9.scrollToLatestRef = scrollToLatestRef
					v8 = createElement4(MessageList, v9)
				else
					v8 = false
				end

				v7[v5] = v8

				v7.ScrollToLatestButton = scrollToLatestButton
				v7.UserTypingIndicator = v3 and Roact.createElement(UserTypingIndicator, {
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.new(0, 0, 1, 0),
					ZIndex = 2,
					height = 28,
					usersTyping = props.props.usersTyping,
					oneUserTyping = props.props.oneUserTyping,
					twoUsersTyping = props.props.twoUsersTyping,
					severalUsersTyping = props.props.severalUsersTyping
				})
				children.MessageListFrame = createElement3("Frame", onMessageListSizeChangesByAbsoluteSize, v7)

				local createElement4 = React.createElement
				local view = Foundation.View
				local bgsurface

				if FFlagAppChatSignalsReplyStore then
					bgsurface = props.props.replyingToMessageId ~= nil
				else
					bgsurface = props.props.replyingToMessage
				end

				local v9 = {
					LayoutOrder = 3,
					tag = {
						["col size-full-0 auto-y gap-medium padding-y-medium"] = true,
						["bg-surface-100"] = bgsurface
					},
					onAbsoluteSizeChanged = props.onHeightChanged,
					padding = { left = UDim.new(0, p3.left), right = udim }
				}
				local smartSuggestionsChipRow

				if FFlagAppChatSmartSuggestions then
					smartSuggestionsChipRow = React.createElement(SmartSuggestionsChipRowContainer, {
						LayoutOrder = 0,
						conversationId = props.props.conversationId,
						sendMessage = props.props.sendMessage,
						sendGameLinkChatMessage = props.props.sendGameLinkChatMessage
					})
				end

				local v10

				if FFlagAppChatSignalsReplyStore then
					v10 = props.props.replyingToMessageId
				else
					v10 = props.props.replyingToMessage
				end

				local replyComposeBar

				if v10 then
					local createElement5 = Roact.createElement
					local message

					if not FFlagAppChatSignalsReplyStore then
						message = props.props.replyingToMessage
					end

					replyComposeBar = createElement5(ReplyComposeBarContainer, {
						LayoutOrder = 1,
						message = message,
						close = props.closeReplying,
						inputBoxRef = props.inputBoxRef
					})
				end

				local divider

				if
					props.isMoreMenuEnabled()
					and not (props.props.shouldShowChatInputBar or props.props.shouldHideMoreMenuButton)
				then
					divider = React.createElement(Foundation.View, {
						LayoutOrder = 4,
						tag = "size-full-0 auto-y stroke-standard stroke-default"
					})
				end

				local actionInputContainer

				if props.isMoreMenuEnabled() then
					local createElement5 = React.createElement
					local view2 = Foundation.View
					local moreMenu

					if not props.props.shouldHideMoreMenuButton then
						moreMenu = Roact.createElement(ChatConversationMoreMenu, {
							conversation = props.props.conversation,
							conversationId = props.props.conversationId,
							navigateToSquadLobby = props.props.navigateToSquadLobby,
							layoutOrder = 1,
							showButtonText = not props.props.shouldShowChatInputBar,
							tooltipText = props.state.tooltipText
						})
					end

					local chatInputBar

					if props.props.shouldShowChatInputBar then
						chatInputBar = Roact.createElement(v, {
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
								p,
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
						})
					end

					actionInputContainer = createElement5(
						view2,
						{ LayoutOrder = 2, tag = "size-full-0 row gap-small auto-y align-y-center" },
						{ MoreMenu = moreMenu, ChatInputBar = chatInputBar }
					)
				end

				local chatInputBar

				if not (props.isMoreMenuEnabled() or not props.props.shouldShowChatInputBar) then
					chatInputBar = Roact.createElement(v, {
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
							p,
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
					})
				end

				children.ReplyAndInputContainer = createElement4(view, v9, {
					SmartSuggestionsChipRow = smartSuggestionsChipRow,
					ReplyComposeBar = replyComposeBar,
					Divider = divider,
					ActionInputContainer = actionInputContainer,
					ChatInputBar = chatInputBar
				})

				children.BottomModal = React.createElement(ConversationBottomModalContainer, {
					conversationId = props.props.conversationId,
					layoutOrder = 5,
					onHeightChanged = props.setBottomModalHeight,
					legacyBottomModalText = props.props.bottomModalText,
					shouldShowLegacyBottomModal = props.props.shouldShowLegacyBottomModal,
					shouldShowChatInputBar = props.props.shouldShowChatInputBar
				})
				return createElement("TextButton", v6, children)
			end)
		end)
	end)
end

return connectTelemetry(ChatConversationTelemetryLayer.Context)(RoactNavigation.withNavigation(extended))
