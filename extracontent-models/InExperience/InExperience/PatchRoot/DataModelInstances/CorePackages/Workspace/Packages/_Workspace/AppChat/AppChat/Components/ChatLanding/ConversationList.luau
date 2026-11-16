local IXPService = game:GetService("IXPService")

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local SocialExperiments = require(parent.SocialExperiments)
local AppChatPerfExperimentation = SocialExperiments.AppChatPerfExperimentation
local AppNavBar = require(parent.AppNavBar)
local VisibilityControl = AppNavBar.VisibilityControl
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local VirtualizedList = require(parent.VirtualizedList)
local BidirectionalFlatList = VirtualizedList.BidirectionalFlatList
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local CoreGui = ReactFocusNavigation.EngineInterface.CoreGui
local Cryo = require(parent.Cryo)
local ReactFocusNavigation2 = require(parent.ReactFocusNavigation)
local FocusNavigationService = ReactFocusNavigation2.FocusNavigationService
local AppCommonLib = require(parent.AppCommonLib)
local memoize = AppCommonLib.memoize
local React = require(parent.React)
local Roact = require(parent.Roact)
local Promise = require(parent.Promise)
local SharedFlags = require(parent.SharedFlags)
local AppCommonLib2 = require(parent.AppCommonLib)
local Signal = AppCommonLib2.Signal
local SocialCarousel = require(parent.SocialCarousel)
local SocialExperiments2 = require(parent.SocialExperiments)
local UIBlox = require(parent.UIBlox)
local withStyle = UIBlox.Style.withStyle

local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local createScrollIntervalTracker = require(AppChat.Telemetry.createScrollIntervalTracker)

local Constants = SocialCarousel.Constants
local Enums = SocialCarousel.Enums

local SquadQuickStartExperimentation = SocialExperiments2.SquadQuickStartExperimentation

local ChatLandingModalContainer = require(script.Parent.ChatLandingModal.ChatLandingModalContainer)
local ConversationEntry = require(script.Parent.ConversationEntry)
local ConversationRow = require(script.Parent.ConversationRow)
local ConversationGroupsEntryContainer = require(script.Parent.ConversationGroupsEntryContainer)
local PartyQuickStartContainer = require(script.Parent.PartyQuickStartContainer)
local defineFastInt = game:DefineFastInt("AppChatChatLandingInitialFetchLimit", 5)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagEnableScrollAwayContentScrollableFix = SharedFlags.FFlagEnableScrollAwayContentScrollableFix

local defineFastInt2 = game:DefineFastInt("AppChatChatLandingInitialFetchMinimumConversations", 30)

local FFlagAppChatRemoveConversationListDividerIxpEnabled = require(AppChat.Flags.FFlagAppChatRemoveConversationListDividerIxpEnabled)

local FStringAppChatRemoveConversationListDividerIxpLayer = require(AppChat.Flags.FStringAppChatRemoveConversationListDividerIxpLayer)
local FFlagAppChatTimestampInSubtitleIxpEnabled = require(AppChat.Flags.FFlagAppChatTimestampInSubtitleIxpEnabled)
local FStringAppChatTimestampInSubtitleIxpLayer = require(AppChat.Flags.FStringAppChatTimestampInSubtitleIxpLayer)

local defineFastInt3 = game:DefineFastInt("AppChatPerfChatLandingPaginationWindowSize", 2)

local defineFastInt4 = game:DefineFastInt("AppChatPerfChatLandingPaginationInitialRender", 8)

local defineFastInt5 = game:DefineFastInt("AppChatPerfChatLandingPaginationOnStartReachedUnits", 1)

local defineFastInt6 = game:DefineFastInt("AppChatPerfChatLandingPaginationOnEndReachedUnits", 10)

local SocialExperiments3 = require(parent.SocialExperiments)
local PartyPageCarouselExperimentation = SocialExperiments3.PartyPageCarouselExperimentation

local Logger = require(script.Parent.Logger)
local v = Logger:new(script.Name)

local SignalsMigrationConfig = require(AppChat.Flags.SignalsMigrationConfig)
local shouldUseFoundationConversationRow = SignalsMigrationConfig.shouldUseFoundationConversationRow
local FFlagAppChatConsoleFocusFixes = require(AppChat.Flags.FFlagAppChatConsoleFocusFixes)

local extended = Roact.PureComponent:extend("ConversationList")

extended.defaultProps = {
	focusIndex = 1,
	focusLock = {},
	itemList = {},
	loadNext = nil,
	loadPrevious = nil,
	onActivated = nil,
	navigateToQuickStartSquadInviteFriends = function() end,
	navigateToSquadLobby = function() end,
	isDebugEnabled = false,
	Size = UDim2.fromScale(1, 1),
	LayoutOrder = 1,
	onScrollUpdate = function() end,
	entryHeight = 64,
	shouldShowPhoneVerificationUpsell = false,
	shouldShowUnfilteredAccessFtux = false,
	shouldShowPartyUpsellFtux = false,
	dismissUnfilteredThreadsFtux = function() end,
	canvasTopPadding = FFlagAppIaScrollAway and 0 or nil,
	fireConversationImpressionEvent = function() end,
	isPartyQuickStartEnabled = false,
	fireConversationClickedEvent = function() end,
	canAccessParty = false
}

local function getIsSquadEnabledForRows(props): boolean -- 1 equivalent call inferred from this helper
	return props.canAccessParty == true
end

function extended:init()
	extended.ENTRY_HEIGHT = self.props.entryHeight

	if FFlagAppChatPerfTracking then
		self.scrollIntervalTracker = nil
	end

	self.scrollViewPositionChangedSignal = Signal.new()
	local unifiedLogging = {
		appPage = AppPage.Chat,
		impressionTag = 0,
		scrollViewPositionChangedSignal = 0,
		sortId = 0,
		sortIndex = 1
	}
	local impressionTag

	if self.props.isInExperience then
		impressionTag = Constants.ANALYTICS.SRC.PARTY_PAGE_IN_EXP
	else
		impressionTag = Constants.ANALYTICS.SRC.PARTY_PAGE_UA
	end

	unifiedLogging.impressionTag = impressionTag

	unifiedLogging.scrollViewPositionChangedSignal = self.scrollViewPositionChangedSignal
	self.unifiedLogging = unifiedLogging

	function self.onScrollUpdate(p)
		if FFlagAppChatPerfTracking and self.scrollIntervalTracker then
			self.scrollIntervalTracker.onScrollTick()
		end

		self.currentAnchor = math.floor(p.CanvasPosition.Y / 64)
		self.scrollViewPositionChangedSignal:fire()

		self.props.onScrollUpdate(p)
	end

	if FFlagAppIaScrollAway and FFlagEnableScrollAwayContentScrollableFix then
		self.lastContentHeight = 0
		function self.onViewportAbsoluteSizeChange(p)
			VisibilityControl.setContentScrollable(self.lastContentHeight > p.AbsoluteSize.Y)
		end
	end

	self.focusLock = self.props.focusLock

	if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
		function self.navigateToConversationFromSocialCarousel(p)
			self.props.navigateToConversationFromUserId(p.id)
		end
	end

	function self.identifier(p)
		if p then
			return p.id .. tostring(p.unixTime)
		end

		return nil
	end

	local v2 = memoize(function()
		return {
			{
				tileGroup = Enums.TileGroup.StartSquad,
				onActivated = self.props.navigateToQuickStartSquadInviteFriends
			},
			{
				tileGroup = Enums.TileGroup.FriendsList,
				onActivated = self.navigateToConversationFromSocialCarousel
			}
		}
	end)

	function self.isPartyQuickStartEnabled()
		return self.props.isPartyQuickStartEnabled
	end

	function self.renderItem(p, _)
		local item = p.item

		if item.isChatLandingModal then
			return Roact.createElement(ChatLandingModalContainer, {})
		end

		if item.isGroupLink then
			return Roact.createElement(ConversationGroupsEntryContainer, {
				entryHeight = self.ENTRY_HEIGHT
			})
		end

		if self.isPartyQuickStartEnabled() and item.isQuickStartLink then
			return Roact.createElement(PartyQuickStartContainer, { entryHeight = self.ENTRY_HEIGHT })
		end

		if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() and item.isSocialCarousel then
			local createElement = React.createElement
			local entry = SocialCarousel.Entry
			local v3 = {
				customTileList = v2(),
				roduxKey = "ChatAppReducer",
				hideCarouselHeader = true,
				source = 0,
				unifiedLogging = 0
			}
			local source

			if self.props.isInExperience then
				source = Constants.ANALYTICS.SRC.PARTY_PAGE_IN_EXP
			else
				source = Constants.ANALYTICS.SRC.PARTY_PAGE_UA
			end

			v3.source = source

			v3.unifiedLogging = self.unifiedLogging
			return createElement(entry, v3)
		else
			if
				FFlagAppIaScrollAway and item.isCanvasTopPadding
				or FFlagAppChatConsoleFocusFixes and item.isCanvasBottomPadding
			then
				return Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, item.height),
					BackgroundTransparency = 1
				})
			end

			if not shouldUseFoundationConversationRow then
				return Roact.createElement(ConversationEntry, {
					boldTitle = false,
					entryHeight = self.ENTRY_HEIGHT,
					conversation = item,
					onActivated = self.props.onActivated,
					onSquadJoinButtonActivated = self.props.navigateToSquadLobby,
					key = "ConversationEntry" .. tostring(item.id),
					fireImpressionEvent = self.props.fireConversationImpressionEvent,
					fireClickEvent = self.props.fireConversationClickedEvent
				}, self.props.isDebugEnabled and {
					debugCell = Roact.createElement("StringValue", { Value = tostring(item.id) })
				})
			end

			local createElement = React.createElement
			local v3 = {
				entryHeight = self.ENTRY_HEIGHT,
				conversationId = tostring(item.id),
				isSquadEnabled = getIsSquadEnabledForRows(self.props), -- inferred equivalent call
				isWideMode = self.props.isWideMode,
				onActivated = self.props.onActivated,
				onSquadJoinButtonActivated = self.props.navigateToSquadLobby,
				key = "ConversationEntry" .. tostring(item.id),
				fireImpressionEvent = self.props.fireConversationImpressionEvent,
				fireClickEvent = self.props.fireConversationClickedEvent,
				localUserId = self.props.localUserId,
				debugCellValue = 0
			}
			local debugCellValue

			if self.props.isDebugEnabled then
				debugCellValue = tostring(item.id)
			end

			v3.debugCellValue = debugCellValue
			return createElement(ConversationRow, v3)
		end
	end

	local ref

	if FFlagAppChatConsoleFocusFixes and self.props.listRef then
		ref = self.props.listRef
	else
		ref = Roact.createRef()
	end

	self.ref = ref
	self.viewRef = Roact.createRef()
	self.initialFetchesAttempted = 0
	self.focusNavigationService = FocusNavigationService.new(CoreGui)
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

	AppChatPerfExperimentation.logExposure()
	PartyPageCarouselExperimentation.logExposure()
	SquadQuickStartExperimentation.logExposure()

	if FFlagAppChatRemoveConversationListDividerIxpEnabled then
		IXPService:LogFlagLinkedUserLayerExposure(FStringAppChatRemoveConversationListDividerIxpLayer)
	end

	if FFlagAppChatTimestampInSubtitleIxpEnabled and game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
		IXPService:LogFlagLinkedUserLayerExposure(FStringAppChatTimestampInSubtitleIxpLayer)
	end
end

function extended:didMount()
	if FFlagAppChatPerfTracking and self.getScrollRef then
		local scrollRef = self.getScrollRef()

		if scrollRef ~= nil then
			self.scrollIntervalTracker = createScrollIntervalTracker(
				AppChatPerfTracker.Events.ScrollConversationList,
				scrollRef
			)
		end
	end

	local scrollRef = self.getScrollRef()

	if scrollRef ~= nil then
		scrollRef.Selectable = false
	end
end

function extended.willUnmount(p)
	if FFlagAppChatPerfTracking and p.scrollIntervalTracker then
		p.scrollIntervalTracker.cleanup()
	end

	if FFlagAppIaScrollAway and FFlagEnableScrollAwayContentScrollableFix then
		VisibilityControl.setContentScrollable(true)
	end

	p.focusNavigationService:teardown()
end

function extended:willUpdate(data, _)
	if data.filterText and data.filterText ~= "" and data.filterText ~= self.props.filterText then
		self.focusLock = data.filterText
	elseif
		data.itemList[1]
		and self.props.itemList[1]
		and data.itemList[1].id ~= self.props.itemList[1].id
		and self.currentAnchor == 1
	then
		self.focusLock = {}
	end

	if
		data.itemList
		and self.props.itemList ~= data.itemList
		and self.initialFetchesAttempted < defineFastInt
		and #data.itemList < defineFastInt2
	then
		self.initialFetchesAttempted += 1
		v:info(
			"Loading more conversations because the list (count: {} out of {}) is not enough (attempt {} out of {})",
			#data.itemList,
			defineFastInt2,
			self.initialFetchesAttempted,
			defineFastInt
		)

		self.props.loadNext()
	end

	if data.entryHeight ~= self.props.entryHeight then
		extended.ENTRY_HEIGHT = data.entryHeight
	end
end

function extended:render()
	local itemList = self.props.itemList

	local v2 = self.props.filterText == "" or self.props.filterText == nil
	local showGroupsLink = self.props.showGroupsLink

	if v2 and showGroupsLink then
		itemList = Cryo.List.join({
			{ id = "ConversationGroupsEntryContainer", isGroupLink = true }
		}, itemList)
	end

	if not PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() and self.isPartyQuickStartEnabled() then
		itemList = Cryo.List.join({
			{ id = "PartyQuickStartContainer", isQuickStartLink = true }
		}, itemList)
	end

	if v2 then
		if
			self.isPartyQuickStartEnabled()
			and PartyPageCarouselExperimentation.getPartyPageCarouselEnabled()
			and (self.props.isWideMode or not self.props.isInExperience)
		then
			itemList = Cryo.List.join({
				{ id = "SocialCarousel", isSocialCarousel = true }
			}, itemList)
		end

		itemList = Cryo.List.join({
			{ id = "UnfilteredThreadsFtux", isChatLandingModal = true }
		}, itemList)
	end

	if FFlagAppIaScrollAway and self.props.canvasTopPadding > 0 then
		itemList = Cryo.List.join({
			{
				id = "CanvasTopPadding",
				isCanvasTopPadding = true,
				height = self.props.canvasTopPadding
			}
		}, itemList)
	end

	if FFlagAppChatConsoleFocusFixes and (self.props.canvasBottomPadding or 0) > 0 then
		itemList = Cryo.List.join(itemList, {
			{
				id = "CanvasBottomPadding",
				isCanvasBottomPadding = true,
				height = self.props.canvasBottomPadding
			}
		})
	end

	local fn = FFlagAppIaScrollAway and function(_, p)
		local length, offset

		if self.props.canvasTopPadding > 0 then
			if p == 1 then
				length = self.props.canvasTopPadding
				offset = 0
			else
				length = self.ENTRY_HEIGHT
				offset = self.props.canvasTopPadding + self.ENTRY_HEIGHT * (p - 2)
			end
		else
			length = self.ENTRY_HEIGHT
			offset = self.ENTRY_HEIGHT * (p - 1)
		end

		return { length = length, offset = offset, index = p }
	end or nil

	local function renderScroller(p)
		local backgroundTransparency

		if self.props.pageBackgroundTransparency == nil then
			backgroundTransparency = p.Tokens.Color.None.Transparency
		else
			backgroundTransparency = self.props.pageBackgroundTransparency
		end

		local createElement = Roact.createElement
		local v3 = {
			BackgroundTransparency = 1,
			Size = self.props.Size,
			[Roact.Ref] = self.viewRef
		}
		local absoluteSize = Roact.Change.AbsoluteSize
		local v4

		if FFlagAppIaScrollAway and FFlagEnableScrollAwayContentScrollableFix then
			v4 = self.onViewportAbsoluteSizeChange
		end

		v3[absoluteSize] = v4

		local createElement2 = Roact.createElement
		local refsByRef = {}
		refsByRef.data = itemList
		refsByRef.renderItem = self.renderItem
		local getItemLayout

		if FFlagAppIaScrollAway then
			getItemLayout = fn
		else
			getItemLayout = function(_, p2)
				return {
					length = self.ENTRY_HEIGHT,
					offset = self.ENTRY_HEIGHT * (p2 - 1),
					index = p2
				}
			end
		end

		refsByRef.getItemLayout = getItemLayout

		refsByRef.style = {
			BackgroundColor3 = p.Theme.BackgroundDefault.Color,
			BackgroundTransparency = backgroundTransparency,
			ScrollBarThickness = 0,
			BorderSizePixel = 0
		}

		refsByRef.contentContainerStyle = {
			BackgroundColor3 = p.Theme.BackgroundDefault.Color,
			BackgroundTransparency = backgroundTransparency,
			BorderSizePixel = 0
		}

		refsByRef.windowSize = defineFastInt3
		refsByRef.initialNumToRender = defineFastInt4
		refsByRef.onScroll = self.onScrollUpdate
		function refsByRef.onContentSizeChange(_, lastContentHeight)
			local current = self.viewRef.current

			if current then
				v:debug(
					"onContentSizeChange - Window height: {} vs Content height: {}",
					current.AbsoluteSize.Y,
					lastContentHeight
				)

				if FFlagAppIaScrollAway and FFlagEnableScrollAwayContentScrollableFix then
					self.lastContentHeight = lastContentHeight
					self.onViewportAbsoluteSizeChange(current)
				end

				if lastContentHeight <= current.AbsoluteSize.Y then
					v:info("Not enough content to fill the view, loading more conversations")
					self.props.loadNext()
				end
			end
		end
		function refsByRef.onEndReached()
			v:debug("onEndReached - Loading more conversations")
			self.props.loadNext()
			return Promise.resolve()
		end

		function refsByRef.onStartReached()
			v:debug("onStartReached - Loading previous conversations")

			if self.props.loadPrevious then
				self.props.loadPrevious()
			end

			return Promise.resolve()
		end

		refsByRef.AutomaticCanvasSize = Enum.AutomaticSize.XY
		refsByRef.CanvasSize = UDim2.fromScale(0, 0)
		refsByRef.onEndReachedThreshold = self.ENTRY_HEIGHT * defineFastInt6
		refsByRef.onStartReachedThreshold = self.ENTRY_HEIGHT * defineFastInt5
		function refsByRef.compareItemData(p2, p3): boolean
			return p2.id == p3.id
		end

		refsByRef[Roact.Ref] = self.ref
		refsByRef.autoscrollToTopThreshold = 33
		refsByRef.enableAutoscrollToTop = true
		local scrollEnabled

		if FFlagAppChatConsoleFocusFixes then
			scrollEnabled = self.props.scrollEnabled
		end

		refsByRef.scrollEnabled = scrollEnabled
		return createElement("Frame", v3, {
			scroller = createElement2(BidirectionalFlatList, refsByRef)
		})
	end

	return withStyle(function(p)
		if #itemList ~= 0 then
			return renderScroller(p)
		end

		local createElement = Roact.createElement
		local v3 = {
			Size = self.props.Size,
			BackgroundColor3 = p.Theme.BackgroundDefault.Color,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			LayoutOrder = 0
		}
		local backgroundTransparency

		if self.props.pageBackgroundTransparency == nil then
			backgroundTransparency = p.Tokens.Color.None.Transparency
		else
			backgroundTransparency = self.props.pageBackgroundTransparency
		end

		v3.BackgroundTransparency = backgroundTransparency

		v3.LayoutOrder = self.props.LayoutOrder
		return createElement("Frame", v3)
	end)
end

return extended
