local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local bidirectionalFlatList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/VirtualizedList").BidirectionalFlatList
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")
local focusNavigationService = ReactFocusNavigation.FocusNavigationService
local coreGui = ReactFocusNavigation.EngineInterface.CoreGui

local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local FFlagAppChatScrollToLatest = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatScrollToLatest")
local createScrollIntervalTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/createScrollIntervalTracker")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")

local MessageModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/MessageModel")
local EnumMessageTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/EnumMessageTypes")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/MessageModel")
local getLastMessageWithFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/getLastMessageWithFilter")
local isScrolledAwayFromLatest = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ScrollToLatest/isScrolledAwayFromLatest")

local ChatMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatMessage")
local SystemMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/SystemMessage")
local SystemMessageContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/SystemMessageContainer")
local CustomMessageEntryContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/CustomMessageEntryContainer")

local getFFlagEnableSocialCards = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagEnableSocialCards
local FIntAppChatMessageInitialFetchMinMessages = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntAppChatMessageInitialFetchMinMessages")
local FIntAppChatInitialMessageFetchLimit = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntAppChatInitialMessageFetchLimit")
local FFlagAppChatGuardOsaScrollToIndex = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatGuardOsaScrollToIndex")
local FIntAppChatOsaAutoScrollDelayMs = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntAppChatOsaAutoScrollDelayMs")

local FFlagAppChatConversationLoadingSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConversationLoadingSkeleton")

local v5 = if FFlagAppChatConversationLoadingSkeleton then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ConversationMessageSkeletonList") else nil

local FFlagAppChatEnableAutotranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatEnableAutotranslation")

local FFlagAppChatAutotranslationRespectsExperienceChatSetting = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatAutotranslationRespectsExperienceChatSetting")

local defineFastInt = game:DefineFastInt("AppChatPerfChatConversationPaginationWindowSize", 2)

local defineFastInt2 = game:DefineFastInt("AppChatPerfChatConversationPaginationInitialRender", 10)

local defineFastInt3 = game:DefineFastInt("AppChatPerfChatConversationPaginationOnStartReached", 64)

local defineFastInt4 = game:DefineFastInt("AppChatPerfChatConversationPaginationOnEndReached", 100)

local function isIncomingChatMessage(p2)
	return p2.isIncoming and (p2.messageType == EnumMessageTypes.PlainText or p2.messageType == EnumMessageTypes.Link)
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
	openGameDetailsPage = function(p2, p3) end,
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

local function compareItemData(p2, p3)
	if p2 == nil or p3 == nil then
		return false
	end

	local v6

	if p2.stable_key == nil or p2.stable_key ~= p3.stable_key then
		v6 = not (p2.messageId == nil) and p2.messageId == p3.messageId
	else
		v6 = true
	end

	return v6
end

function extended:init()
	self.state = { width = 0, startIndex = 1, firstItem = self.props.itemList[1] }

	self.focusIndex = self.props.initialFocusIndex

	if FFlagAppChatPerfTracking then
		self._scrollIntervalTracker = nil
	end

	function self.isValidMessageAndSenderType(p2, p3): boolean
		if p3 == MessageModel.SenderTypes.System then
			return p2 == EnumMessageTypes.System
		end

		if p3 == MessageModel.SenderTypes.User then
			return p2 == EnumMessageTypes.PlainText or p2 == EnumMessageTypes.Link
		end

		return p2 == EnumMessageTypes.Custom
	end

	self.ref = self.props.messageListRef or Roact.createRef()
	local v6

	if FFlagAppChatAutotranslationRespectsExperienceChatSetting then
		local TextChatService = game:GetService("TextChatService")
		v6 = TextChatService.ChatTranslationEnabled
	else
		v6 = false
	end

	self.lastIncomingChatMessageId = nil

	if self.props.itemList then
		self.lastIncomingChatMessageId = getLastMessageWithFilter(self.props.itemList, isIncomingChatMessage)
	end

	function self.renderItem(props)
		if not self.isValidMessageAndSenderType(props.messageType, props.senderType) then
			return Roact.createElement(SystemMessage, {
				Text = self.props.invalidMessageTypeText
			})
		end

		local v7 = self.props.isDebugEnabled
			and Roact.createElement("StringValue", {
				Value = tostring(props.messageId)
			})

		if props.messageType == EnumMessageTypes.Custom then
			return Roact.createElement(CustomMessageEntryContainer, {
				openViewProfile = self.props.openViewProfile,
				customEntryType = props.customEntryType,
				conversationId = self.props.conversationId
			})
		end

		if props.messageType == EnumMessageTypes.System then
			local createElement = Roact.createElement
			local v10 = if getFFlagEnableSocialCards() then props.cards else nil
			local v9 = {
				cards = v10,
				text = props.content,
				parentWidth = self.state.width,
				sent = props.sent,
				showDateTime = props.showDateTime,
				messageId = props.messageId,
				senderTargetId = 0,
				debugElement = 0
			}
			local v11 = if getFFlagEnableSocialCards() then props.senderTargetId else nil
			v9.senderTargetId = v11

			v9.debugElement = v7
			return createElement(SystemMessageContainer, v9)
		else
			local additionalProps = props.additionalProps

			if additionalProps then
				additionalProps.onDetailsOpened = self.props.onDetailsOpened
			end

			local v8 = additionalProps or {}

			v8.openGameDetailsPage = self.props.openGameDetailsPage
			v8.openMomentsDeepLink = self.props.openMomentsDeepLink
			v8.shareLink = props.shareLink
			local contentToDisplay

			if FFlagAppChatEnableAutotranslation then
				if FFlagAppChatAutotranslationRespectsExperienceChatSetting then
					if v6 then
						contentToDisplay = props.contentToDisplay
					end
				else
					contentToDisplay = props.contentToDisplay
				end
			end

			return Roact.createElement(ChatMessage, {
				additionalProps = v8,
				content = props.content,
				debugElement = v7,
				failed = props.failed,
				filteredForReceivers = props.filteredForReceivers,
				isIncoming = props.isIncoming,
				isNewSender = props.isNewSender,
				isSending = props.isSending,
				isUnfiltered = props.moderationType == module10.ModerationTypes.TrustedComms,
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

	function self.updateWidth(p2)
		if p2.AbsoluteSize.X ~= self.state.width then
			self:setState({ width = p2.AbsoluteSize.X })
		end
	end

	function self.changeFocus(p2)
		self.isNearBottom = p2.anchorIndex <= self.props.autoScrollMaxIndex + 1

		self.focusIndex = self.isNearBottom and 1 or p2.anchorIndex + 1

		if p2.anchorIndex == 1 and not self.props.itemList[1].read then
			self.props.markAsRead()
		end
	end

	function self.identifier(p2)
		return p2.messageId .. "|" .. (p2.position or "")
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
	function self.setScrolledAwayFromLatest(wasScrolledAwayFromLatest)
		local onScrolledAwayFromLatestChanged = self.props.onScrolledAwayFromLatestChanged

		if
			onScrolledAwayFromLatestChanged ~= nil
			and wasScrolledAwayFromLatest ~= self.wasScrolledAwayFromLatest
		then
			self.wasScrolledAwayFromLatest = wasScrolledAwayFromLatest
			onScrolledAwayFromLatestChanged(wasScrolledAwayFromLatest)
		end
	end
	function self.reportScrolledAwayFromLatest(p2)
		self.setScrolledAwayFromLatest(isScrolledAwayFromLatest(self.calculateScrollOffset(p2), p2.AbsoluteWindowSize.Y))
	end

	self.scrolledAwayConnections = nil
	function self.disconnectScrolledAwayListener()
		if self.scrolledAwayConnections == nil then
			return
		end

		for k, scrolledAwayConnection in self.scrolledAwayConnections do
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
			local function report()
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

			for k, propertyName in { "CanvasPosition", "AbsoluteCanvasSize", "AbsoluteWindowSize" } do
				table.insert(connections, scrollRef:GetPropertyChangedSignal(propertyName):Connect(report))
			end

			if not flag then
				flag = true
				task.defer(function()
					flag = false

					if self.scrolledAwayConnections == connections then
						self.reportScrolledAwayFromLatest(scrollRef)
					end
				end)
			end
		end
	end

	function self.scrollToLatest()
		local listRef = self.ref.current and self.ref.current._listRef

		if listRef then
			listRef:scrollToOffset({ offset = 0, animated = false })
		end
	end

	function self.onScroll(p2)
		if FFlagAppChatPerfTracking then
			if self._scrollIntervalTracker == nil then
				local scrollRef = self.getScrollRef()

				if scrollRef ~= nil then
					self._scrollIntervalTracker = createScrollIntervalTracker(AppChatPerfTracker.Events.ScrollMessageList, scrollRef, {
						conversationId = self.props.conversationId
					})
				end
			end

			if self._scrollIntervalTracker then
				self._scrollIntervalTracker.onScrollTick()
			end
		end

		local scrollOffset = self.calculateScrollOffset(p2)

		if scrollOffset < 512 then
			self:setState(function(p3, p4)
				return { firstItem = p4.itemList[1] }
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
	self.focusNavigationService = focusNavigationService.new(coreGui)
end

function extended.getDerivedStateFromProps(p2, p3)
	if p3.firstItem == nil then
		return { startIndex = 1 }
	end

	local v6 = 1

	while v6 <= #p2.itemList do
		local item = p2.itemList[v6]
		local firstItem = p3.firstItem
		local v7

		if item == nil or firstItem == nil then
			v7 = false
		elseif item.stable_key == nil or item.stable_key ~= firstItem.stable_key then
			v7 = not (item.messageId == nil) and item.messageId == firstItem.messageId
		else
			v7 = true
		end

		if v7 then
			break
		end

		v6 += 1
	end

	if #p2.itemList < v6 then
		return { startIndex = 1 }
	end

	return { startIndex = v6 }
end

function extended:didUpdate(data, p2)
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

	if
		self.props.scrollToTopOnInitialOsaLoad
		and not data.scrollToTopOnInitialOsaLoad
		and #self.props.itemList > 0
	then
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
	local v6 = {}
	local v7 = self.state.startIndex

	if v7 ~= 1 then
		local scrollRef = self.getScrollRef()
		v7 = (scrollRef == nil and 0 or self.calculateScrollOffset(scrollRef)) < 128 and 1 or v7
	end

	if v7 == 1 then
		return self.props.itemList
	end

	local item = self.props.itemList[1]
	local firstItem = self.state.firstItem
	local v8

	if item == nil or firstItem == nil then
		v8 = false
	elseif item.stable_key == nil or item.stable_key ~= firstItem.stable_key then
		v8 = not (item.messageId == nil) and item.messageId == firstItem.messageId
	else
		v8 = true
	end

	if not v8 then
		table.move(self.props.itemList, v7, #self.props.itemList, 1, v6)

		return v6
	end

	return self.props.itemList
end

function extended:renderScrollingFrame()
	local renderedItemList = self:getRenderedItemList()

	local createElement = Roact.createElement
	local refsByRef = {}
	refsByRef.data = renderedItemList

	function refsByRef.renderItem(p2)
		return self.renderItem(p2.item)
	end

	refsByRef.inverted = true
	refsByRef.Size = self.props.Size
	refsByRef.style = {
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		Name = "MessageList"
	}

	refsByRef.contentContainerStyle = { BackgroundTransparency = 1 }

	function refsByRef.keyExtractor(p2, p3)
		return p2.stable_key or p2.messageId or p3
	end

	refsByRef.windowSize = defineFastInt
	local v7 = if self.props.scrollToTopOnInitialOsaLoad then #renderedItemList else defineFastInt2
	refsByRef.initialNumToRender = v7

	refsByRef.onScroll = self.onScroll
	local v8 = if FFlagAppChatGuardOsaScrollToIndex then self.onScrollToIndexFailed else nil
	refsByRef.onScrollToIndexFailed = v8
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
	function refsByRef.onContentSizeChange(p2, p3)
		self:setState({ width = p2 })
	end
	refsByRef.optimizeInvertedCanvasResize = true
	refsByRef.UNSTABLE_forceSiblingLayoutUpdate = true
	return createElement(bidirectionalFlatList, refsByRef)
end

function extended:renderEmptyMessageList()
	return Roact.createElement("Frame", {
		Size = self.props.Size,
		BackgroundTransparency = 1
	})
end

function extended:render()
	if FFlagAppChatConversationLoadingSkeleton and self.props.isInitialMessageLoading then
		return Roact.createElement(v5, { size = self.props.Size })
	end

	if #self.props.itemList == 0 then
		return (self:renderEmptyMessageList())
	end

	return (self:renderScrollingFrame())
end

return extended
