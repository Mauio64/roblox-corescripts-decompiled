local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Roact = require(parent.Roact)
local VirtualizedList = require(parent.VirtualizedList)
local BidirectionalFlatList = VirtualizedList.BidirectionalFlatList
local Promise = require(parent.Promise)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationService = ReactFocusNavigation.FocusNavigationService
local CoreGui = ReactFocusNavigation.EngineInterface.CoreGui

local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatScrollToLatest = require(AppChat.Flags.FFlagAppChatScrollToLatest)
local createScrollIntervalTracker = require(AppChat.Telemetry.createScrollIntervalTracker)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)

local MessageModel = require(AppChat.Models.MessageModel)
local EnumMessageTypes = require(AppChat.Components.ChatConversation.EnumMessageTypes)
local MessageModel2 = require(AppChat.Models.MessageModel)
local getLastMessageWithFilter = require(script.Parent.Utils.getLastMessageWithFilter)
local isScrolledAwayFromLatest = require(script.Parent.ScrollToLatest.isScrolledAwayFromLatest)

local ChatMessage = require(script.Parent.ChatMessage)
local SystemMessage = require(script.Parent.SystemMessage)
local SystemMessageContainer = require(script.Parent.SystemMessageContainer)
local CustomMessageEntryContainer = require(script.Parent.CustomMessageEntryContainer)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableSocialCards = SharedFlags.GetFFlagEnableSocialCards
local FIntAppChatMessageInitialFetchMinMessages = require(AppChat.Flags.FIntAppChatMessageInitialFetchMinMessages)
local FIntAppChatInitialMessageFetchLimit = require(AppChat.Flags.FIntAppChatInitialMessageFetchLimit)
local FFlagAppChatGuardOsaScrollToIndex = require(AppChat.Flags.FFlagAppChatGuardOsaScrollToIndex)
local FIntAppChatOsaAutoScrollDelayMs = require(AppChat.Flags.FIntAppChatOsaAutoScrollDelayMs)

local FFlagAppChatConversationLoadingSkeleton = require(AppChat.Flags.FFlagAppChatConversationLoadingSkeleton)
local ConversationMessageSkeletonList

if FFlagAppChatConversationLoadingSkeleton then
	ConversationMessageSkeletonList = require(script.Parent.ConversationMessageSkeletonList)
else
	ConversationMessageSkeletonList = nil
end

local FFlagAppChatEnableAutotranslation = require(AppChat.Flags.FFlagAppChatEnableAutotranslation)

local FFlagAppChatAutotranslationRespectsExperienceChatSetting = require(AppChat.Flags.FFlagAppChatAutotranslationRespectsExperienceChatSetting)

local defineFastInt = game:DefineFastInt("AppChatPerfChatConversationPaginationWindowSize", 2)

local defineFastInt2 = game:DefineFastInt("AppChatPerfChatConversationPaginationInitialRender", 10)

local defineFastInt3 = game:DefineFastInt("AppChatPerfChatConversationPaginationOnStartReached", 64)

local defineFastInt4 = game:DefineFastInt("AppChatPerfChatConversationPaginationOnEndReached", 100)

local function isIncomingChatMessage(p)
	return p.isIncoming and (p.messageType == EnumMessageTypes.PlainText or p.messageType == EnumMessageTypes.Link)
end

local extended = Roact.PureComponent:extend("MessageList")
extended.defaultProps = {
	Size = UDim2.new(1, 0, 1, 0),
	autoScrollMaxIndex = 3,
	bottomMargin = 10,
	conversationId = nil,
	initialFocusIndex = 1,
	isDebugEnabled = false,
	itemList = {},
	loadNext = function() end,
	markAsRead = function() end,
	messageListRef = nil,
	onDetailsOpened = function() end,
	openGameDetailsPage = function(_, _) end,
	openViewProfile = nil,
	wideMode = false,
	viewProfileOnAvatarPressed = true,
	closeKeyboard = function() end,
	inputBoxRef = nil,
	invalidMessageTypeText = "PLACEHOLDER This message could not be displayed",
	messageDefaultNoticeText = "PLACEHOLDER Not everyone in this chat can see your message.",
	messageModeratedNoticeText = "PLACEHOLDER Your message was moderated and not sent.",
	unknownUserText = "PLACEHOLDER unknown user",
	scrollToTopOnInitialOsaLoad = false
}

local function compareItemData(p, firstItem): boolean -- 2 equivalent calls inferred from this helper
	if p == nil or firstItem == nil then
		return false
	end

	if p.stable_key == nil or p.stable_key ~= firstItem.stable_key then
		if p.messageId == nil then
			return false
		end

		return p.messageId == firstItem.messageId
	end

	return true
end

function extended:init()
	self.state = { width = 0, startIndex = 1, firstItem = self.props.itemList[1] }

	self.focusIndex = self.props.initialFocusIndex

	if FFlagAppChatPerfTracking then
		self._scrollIntervalTracker = nil
	end

	function self.isValidMessageAndSenderType(p, p2): boolean
		if p2 == MessageModel.SenderTypes.System then
			return p == EnumMessageTypes.System
		end

		if p2 == MessageModel.SenderTypes.User then
			return p == EnumMessageTypes.PlainText or p == EnumMessageTypes.Link
		end

		return p == EnumMessageTypes.Custom
	end

	self.ref = self.props.messageListRef or Roact.createRef()
	local v

	if FFlagAppChatAutotranslationRespectsExperienceChatSetting then
		local TextChatService = game:GetService("TextChatService")
		v = TextChatService.ChatTranslationEnabled
	else
		v = false
	end

	self.lastIncomingChatMessageId = nil

	if self.props.itemList then
		self.lastIncomingChatMessageId = getLastMessageWithFilter(self.props.itemList, isIncomingChatMessage)
	end

	function self.renderItem(props)
		if not self.isValidMessageAndSenderType(props.messageType, props.senderType) then
			return Roact.createElement(SystemMessage, { Text = self.props.invalidMessageTypeText })
		end

		local debugElement = self.props.isDebugEnabled
			and Roact.createElement("StringValue", { Value = tostring(props.messageId) })

		if props.messageType == EnumMessageTypes.Custom then
			return Roact.createElement(CustomMessageEntryContainer, {
				openViewProfile = self.props.openViewProfile,
				customEntryType = props.customEntryType,
				conversationId = self.props.conversationId
			})
		end

		if props.messageType == EnumMessageTypes.System then
			local createElement = Roact.createElement
			local cards

			if GetFFlagEnableSocialCards() then
				cards = props.cards
			end

			local v2 = {
				cards = cards,
				text = props.content,
				parentWidth = self.state.width,
				sent = props.sent,
				showDateTime = props.showDateTime,
				messageId = props.messageId,
				senderTargetId = 0,
				conversationId = 0,
				debugElement = 0
			}
			local senderTargetId

			if GetFFlagEnableSocialCards() then
				senderTargetId = props.senderTargetId
			end

			v2.senderTargetId = senderTargetId
			v2.conversationId = self.props.conversationId

			v2.debugElement = debugElement
			return createElement(SystemMessageContainer, v2)
		else
			local additionalProps = props.additionalProps

			if additionalProps then
				additionalProps.onDetailsOpened = self.props.onDetailsOpened
			end

			additionalProps = additionalProps or {}

			additionalProps.openGameDetailsPage = self.props.openGameDetailsPage
			additionalProps.openMomentsDeepLink = self.props.openMomentsDeepLink
			additionalProps.shareLink = props.shareLink
			local contentToDisplay

			if FFlagAppChatEnableAutotranslation then
				if FFlagAppChatAutotranslationRespectsExperienceChatSetting then
					if v then
						contentToDisplay = props.contentToDisplay
					end
				else
					contentToDisplay = props.contentToDisplay
				end
			end

			return Roact.createElement(ChatMessage, {
				additionalProps = additionalProps,
				content = props.content,
				debugElement = debugElement,
				failed = props.failed,
				filteredForReceivers = props.filteredForReceivers,
				isIncoming = props.isIncoming,
				isNewSender = props.isNewSender,
				isSending = props.isSending,
				isUnfiltered = props.moderationType == MessageModel2.ModerationTypes.TrustedComms,
				isLastMessageInMessageGroup = props.isLastMessageInMessageGroup,
				isLastIncomingChatMessage = props.messageId == self.lastIncomingChatMessageId,
				messageDefaultNoticeText = self.props.messageDefaultNoticeText,
				conversationId = self.props.conversationId,
				messageId = props.messageId,
				messageModeratedNoticeText = self.props.messageModeratedNoticeText,
				messageHiddenNoticeText = self.props.messageHiddenNoticeText,
				messageType = props.messageType,
				moderated = props.moderated,
				openViewProfile = self.props.openViewProfile,
				parentWidth = self.state.width,
				readingMessagesIsEnabled = true,
				senderUserId = props.senderTargetId,
				sent = props.sent,
				showDateTime = props.showDateTime,
				showDisplayName = props.showDisplayName,
				shouldShowName = props.sender.shouldShowName,
				thumbnail = props.sender.thumbnail,
				wideMode = self.props.wideMode,
				unknownUserText = self.props.unknownUserText,
				viewProfileOnAvatarPressed = self.props.viewProfileOnAvatarPressed,
				closeKeyboard = self.props.closeKeyboard,
				inputBoxRef = self.props.inputBoxRef,
				repliesTo = props.repliesTo,
				visibility = props.visibility,
				translatedText = contentToDisplay
			})
		end
	end

	function self.updateWidth(p)
		if p.AbsoluteSize.X ~= self.state.width then
			self:setState({ width = p.AbsoluteSize.X })
		end
	end

	function self.changeFocus(p)
		self.isNearBottom = p.anchorIndex <= self.props.autoScrollMaxIndex + 1

		self.focusIndex = self.isNearBottom and 1 or p.anchorIndex + 1

		if p.anchorIndex == 1 and not self.props.itemList[1].read then
			self.props.markAsRead()
		end
	end

	function self.identifier(p)
		return p.messageId .. "|" .. (p.position or "")
	end

	function self.getScrollRef()
		if self.ref.current == nil then
			return nil
		end

		local nativeScrollRef = self.ref.current._listRef._scrollRef.getNativeScrollRef()

		if nativeScrollRef == nil then
			return nil
		end

		return nativeScrollRef._nativeRef.current
	end

	function self.calculateScrollOffset(data)
		local y = data.CanvasPosition.Y
		local y2 = data.AbsoluteCanvasSize.Y
		local y3 = data.AbsoluteWindowSize.Y
		return y2 - y - y3
	end

	self.wasScrolledAwayFromLatest = false
	function self.setScrolledAwayFromLatest(wasScrolledAwayFromLatest: boolean)
		local onScrolledAwayFromLatestChanged = self.props.onScrolledAwayFromLatestChanged

		if onScrolledAwayFromLatestChanged ~= nil and wasScrolledAwayFromLatest ~= self.wasScrolledAwayFromLatest then
			self.wasScrolledAwayFromLatest = wasScrolledAwayFromLatest
			onScrolledAwayFromLatestChanged(wasScrolledAwayFromLatest)
		end
	end
	function self.reportScrolledAwayFromLatest(p)
		self.setScrolledAwayFromLatest(isScrolledAwayFromLatest(self.calculateScrollOffset(p), p.AbsoluteWindowSize.Y))
	end

	self.scrolledAwayConnections = nil
	function self.disconnectScrolledAwayListener()
		if self.scrolledAwayConnections == nil then
			return
		end

		for _, scrolledAwayConnection in self.scrolledAwayConnections do
			scrolledAwayConnection:Disconnect()
		end

		self.scrolledAwayConnections = nil
	end
	function self.connectScrolledAwayListener()
		if self.props.onScrolledAwayFromLatestChanged == nil then
			return
		end

		local scrollRef = self.getScrollRef()

		if scrollRef == nil then
			self.disconnectScrolledAwayListener()
			self.setScrolledAwayFromLatest(false)
		else
			if self.scrolledAwayConnections ~= nil then
				return
			end

			local connections = {}
			self.scrolledAwayConnections = connections

			local flag = false
			local function report() -- 1 equivalent call inferred from this helper
				if flag then
					return
				end

				flag = true
				task.defer(function()
					flag = false

					if self.scrolledAwayConnections == connections then
						self.reportScrolledAwayFromLatest(scrollRef)
					end
				end)
			end

			for _, propertyName in { "CanvasPosition", "AbsoluteCanvasSize", "AbsoluteWindowSize" } do
				table.insert(connections, scrollRef:GetPropertyChangedSignal(propertyName):Connect(report))
			end

			report() -- inferred equivalent call
		end
	end

	function self.scrollToLatest()
		local listRef = self.ref.current and self.ref.current._listRef

		if listRef then
			listRef:scrollToOffset({ offset = 0, animated = false })
		end
	end

	function self.onScroll(p)
		if FFlagAppChatPerfTracking then
			if self._scrollIntervalTracker == nil then
				local scrollRef = self.getScrollRef()

				if scrollRef ~= nil then
					self._scrollIntervalTracker = createScrollIntervalTracker(
						AppChatPerfTracker.Events.ScrollMessageList,
						scrollRef,
						{ conversationId = self.props.conversationId }
					)
				end
			end

			if self._scrollIntervalTracker then
				self._scrollIntervalTracker.onScrollTick()
			end
		end

		local scrollOffset = self.calculateScrollOffset(p)

		if scrollOffset < 512 then
			self:setState(function(_, p2)
				return { firstItem = p2.itemList[1] }
			end)
		end

		if scrollOffset < 64 then
			self.props.markAsRead()
		end

		self.isNearBottom = scrollOffset < 64

		if FFlagAppChatScrollToLatest then
			self.connectScrolledAwayListener()
		end
	end

	function self.onScrollToIndexFailed()
		local current = self.ref.current

		if current ~= nil then
			current:scrollToEnd({ animated = false })
		end
	end

	self.initialFetchesAttempted = 0
	self.focusNavigationService = FocusNavigationService.new(CoreGui)
end

function extended.getDerivedStateFromProps(p, p2)
	if p2.firstItem == nil then
		return { startIndex = 1 }
	end

	local startIndex = 1

	while startIndex <= #p.itemList do
		if compareItemData(p.itemList[startIndex], p2.firstItem) then -- inferred equivalent call
			break
		end

		startIndex += 1
	end

	if #p.itemList < startIndex then
		return { startIndex = 1 }
	end

	return { startIndex = startIndex }
end

function extended:didUpdate(data, _)
	if FFlagAppChatPerfTracking and #self.props.itemList > #data.itemList then
		AppChatPerfTracker.finish(AppChatPerfTracker.Events.PaginationMessageList, {
			conversationId = self.props.conversationId
		})
	end

	if self.props.itemList and #self.props.itemList == 0 and data.itemList and #data.itemList > 0 then
		self.initialFetchesAttempted = 0
	end

	if
		self.props.itemList
		and self.props.itemList ~= data.itemList
		and self.initialFetchesAttempted < FIntAppChatInitialMessageFetchLimit
		and #self.props.itemList < FIntAppChatMessageInitialFetchMinMessages
		and self.props.loadNext
	then
		self.initialFetchesAttempted += 1
		self.props.loadNext()
	end

	if data.conversationId ~= self.props.conversationId then
		self.isNearBottom = true
	end

	local scrollRef = self.getScrollRef()

	if (scrollRef == nil and 0 or self.calculateScrollOffset(scrollRef)) < 64 then
		self.isNearBottom = true

		if #self.props.itemList > 0 then
			self.props.markAsRead()
		end
	end

	if
		data.readingMessagesIsEnabled ~= self.props.readingMessagesIsEnabled
		and self.props.readingMessagesIsEnabled
		and self.isNearBottom
	then
		self.props.markAsRead()
	end

	if self.props.scrollToTopOnInitialOsaLoad and not data.scrollToTopOnInitialOsaLoad and #self.props.itemList > 0 then
		local current = self.ref and self.ref.current

		if current and current.scrollToEnd then
			task.delay(FIntAppChatOsaAutoScrollDelayMs / 1000, function()
				if not FFlagAppChatGuardOsaScrollToIndex then
					current:scrollToIndex({
						index = #self.props.itemList,
						animated = false
					})
					return
				end

				local current2 = self.ref.current
				local count = #self:getRenderedItemList()

				if current2 ~= nil and count > 0 then
					current2:scrollToIndex({ index = count, animated = false })
				end
			end)
		end
	end

	if self.props.itemList and not self.lastIncomingChatMessageId then
		self.lastIncomingChatMessageId = getLastMessageWithFilter(self.props.itemList, isIncomingChatMessage)
	end

	if FFlagAppChatScrollToLatest then
		self.connectScrolledAwayListener()
	end
end

function extended:didMount()
	if #self.props.itemList < FIntAppChatMessageInitialFetchMinMessages and self.props.loadNext then
		self.props.loadNext()
	end

	self.isNearBottom = true
	local scrollRef = self.getScrollRef()

	if scrollRef ~= nil then
		scrollRef.Selectable = false
	end

	if FFlagAppChatScrollToLatest then
		if self.props.scrollToLatestRef then
			self.props.scrollToLatestRef.current = self.scrollToLatest
		end

		self.connectScrolledAwayListener()
	end
end

function extended:willUnmount()
	if FFlagAppChatPerfTracking and self._scrollIntervalTracker then
		self._scrollIntervalTracker.cleanup()
	end

	if FFlagAppChatScrollToLatest then
		local scrollToLatestRef = self.props.scrollToLatestRef

		if scrollToLatestRef and scrollToLatestRef.current == self.scrollToLatest then
			scrollToLatestRef.current = nil
		end

		self.disconnectScrolledAwayListener()
	end

	self.focusNavigationService:teardown()
end

function extended:getRenderedItemList()
	local v = {}
	local v2 = self.state.startIndex

	if v2 ~= 1 then
		local scrollRef = self.getScrollRef()
		v2 = (scrollRef == nil and 0 or self.calculateScrollOffset(scrollRef)) < 128 and 1 or v2
	end

	if v2 ~= 1 and not compareItemData(self.props.itemList[1], self.state.firstItem) then -- inferred equivalent call
		table.move(self.props.itemList, v2, #self.props.itemList, 1, v)

		return v
	end

	return self.props.itemList
end

function extended:renderScrollingFrame()
	local renderedItemList = self:getRenderedItemList()

	local createElement = Roact.createElement
	local refsByRef = {}
	refsByRef.data = renderedItemList

	function refsByRef.renderItem(p)
		return self.renderItem(p.item)
	end

	refsByRef.inverted = true
	refsByRef.Size = self.props.Size
	refsByRef.style = { BackgroundTransparency = 1, ScrollBarThickness = 0, Name = "MessageList" }

	refsByRef.contentContainerStyle = { BackgroundTransparency = 1 }

	function refsByRef.keyExtractor(p, p2)
		return p.stable_key or p.messageId or p2
	end

	refsByRef.windowSize = defineFastInt
	local initialNumToRender

	if self.props.scrollToTopOnInitialOsaLoad then
		initialNumToRender = #renderedItemList
	else
		initialNumToRender = defineFastInt2
	end

	refsByRef.initialNumToRender = initialNumToRender

	refsByRef.onScroll = self.onScroll
	local onScrollToIndexFailed

	if FFlagAppChatGuardOsaScrollToIndex then
		onScrollToIndexFailed = self.onScrollToIndexFailed
	end

	refsByRef.onScrollToIndexFailed = onScrollToIndexFailed
	function refsByRef.onEndReached()
		if FFlagAppChatPerfTracking then
			AppChatPerfTracker.start(AppChatPerfTracker.Events.PaginationMessageList, {
				conversationId = self.props.conversationId
			})
		end

		self.props.loadNext()
		return Promise.resolve()
	end

	refsByRef.onEndReachedThreshold = defineFastInt4
	refsByRef.onStartReachedThreshold = defineFastInt3
	refsByRef.compareItemData = compareItemData
	refsByRef.scrollEventThrottle = self.props.scrollEventThrottle or 75
	refsByRef[Roact.Ref] = self.ref
	refsByRef.autoscrollToTopThreshold = 33
	refsByRef.enableAutoscrollToTop = true

	function refsByRef.ListHeaderComponent()
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 10)
		})
	end

	refsByRef.showDefaultLoadingIndicators = false
	function refsByRef.onContentSizeChange(width: number, _: number)
		self:setState({ width = width })
	end
	refsByRef.optimizeInvertedCanvasResize = true
	refsByRef.UNSTABLE_forceSiblingLayoutUpdate = true
	return createElement(BidirectionalFlatList, refsByRef)
end

function extended:renderEmptyMessageList()
	return Roact.createElement("Frame", { Size = self.props.Size, BackgroundTransparency = 1 })
end

function extended:render()
	if FFlagAppChatConversationLoadingSkeleton and self.props.isInitialMessageLoading then
		return Roact.createElement(ConversationMessageSkeletonList, { size = self.props.Size })
	end

	if #self.props.itemList == 0 then
		return (self:renderEmptyMessageList())
	end

	return (self:renderScrollingFrame())
end

return extended
