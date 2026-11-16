local IXPService = game:GetService("IXPService")

local appChatPerfExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments").AppChatPerfExperimentation
local visibilityControl = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppNavBar").VisibilityControl
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppEnums").AppPage
local bidirectionalFlatList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/VirtualizedList").BidirectionalFlatList
local coreGui = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation").EngineInterface.CoreGui
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local focusNavigationService = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation").FocusNavigationService
local memoize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").memoize
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").Signal
local SocialCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCarousel")
local SocialExperiments = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments")
local withStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Style.withStyle

local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")
local createScrollIntervalTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/createScrollIntervalTracker")

local constants = SocialCarousel.Constants
local enums = SocialCarousel.Enums

local squadQuickStartExperimentation = SocialExperiments.SquadQuickStartExperimentation

local ChatLandingModalContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLandingModal/ChatLandingModalContainer")
local ConversationEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationEntry")
local ConversationRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationRow")
local ConversationGroupsEntryContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationGroupsEntryContainer")
local PartyQuickStartContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/PartyQuickStartContainer")
local defineFastInt = game:DefineFastInt("AppChatChatLandingInitialFetchLimit", 5)
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagEnableScrollAwayContentScrollableFix = SharedFlags.FFlagEnableScrollAwayContentScrollableFix

local defineFastInt2 = game:DefineFastInt("AppChatChatLandingInitialFetchMinimumConversations", 30)

local FFlagAppChatRemoveConversationListDividerIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatRemoveConversationListDividerIxpEnabled")

local FStringAppChatRemoveConversationListDividerIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FStringAppChatRemoveConversationListDividerIxpLayer")
local FFlagAppChatTimestampInSubtitleIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatTimestampInSubtitleIxpEnabled")
local FStringAppChatTimestampInSubtitleIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FStringAppChatTimestampInSubtitleIxpLayer")

local defineFastInt3 = game:DefineFastInt("AppChatPerfChatLandingPaginationWindowSize", 2)

local defineFastInt4 = game:DefineFastInt("AppChatPerfChatLandingPaginationInitialRender", 8)

local defineFastInt5 = game:DefineFastInt("AppChatPerfChatLandingPaginationOnStartReachedUnits", 1)

local defineFastInt6 = game:DefineFastInt("AppChatPerfChatLandingPaginationOnEndReachedUnits", 10)

local partyPageCarouselExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments").PartyPageCarouselExperimentation

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/Logger"):new("ConversationList")

local shouldUseFoundationConversationRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/SignalsMigrationConfig").shouldUseFoundationConversationRow
local FFlagAppChatConsoleFocusFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConsoleFocusFixes")

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
	canvasTopPadding = fFlagAppIaScrollAway and 0 or nil,
	fireConversationImpressionEvent = function() end,
	isPartyQuickStartEnabled = false,
	fireConversationClickedEvent = function() end,
	canAccessParty = false
}

local function getIsSquadEnabledForRows(p2): boolean
	return p2.canAccessParty == true
end

function extended:init()
	extended.ENTRY_HEIGHT = self.props.entryHeight

	if FFlagAppChatPerfTracking then
		self.scrollIntervalTracker = nil
	end

	self.scrollViewPositionChangedSignal = signal.new()
	local v6 = {
		appPage = appPage.Chat,
		impressionTag = 0,
		scrollViewPositionChangedSignal = 0,
		sortId = 0,
		sortIndex = 1
	}
	local v7 = if self.props.isInExperience then constants.ANALYTICS.SRC.PARTY_PAGE_IN_EXP else constants.ANALYTICS.SRC.PARTY_PAGE_UA
	v6.impressionTag = v7

	v6.scrollViewPositionChangedSignal = self.scrollViewPositionChangedSignal
	self.unifiedLogging = v6

	function self.onScrollUpdate(p2)
		if FFlagAppChatPerfTracking and self.scrollIntervalTracker then
			self.scrollIntervalTracker.onScrollTick()
		end

		self.currentAnchor = math.floor(p2.CanvasPosition.Y / 64)
		self.scrollViewPositionChangedSignal:fire()

		self.props.onScrollUpdate(p2)
	end

	if fFlagAppIaScrollAway and fFlagEnableScrollAwayContentScrollableFix then
		self.lastContentHeight = 0
		function self.onViewportAbsoluteSizeChange(p2)
			visibilityControl.setContentScrollable(self.lastContentHeight > p2.AbsoluteSize.Y)
		end
	end

	self.focusLock = self.props.focusLock

	if partyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
		function self.navigateToConversationFromSocialCarousel(p2)
			self.props.navigateToConversationFromUserId(p2.id)
		end
	end

	function self.identifier(p2)
		if p2 then
			return p2.id .. tostring(p2.unixTime)
		end

		return nil
	end

	local v8 = memoize(function()
		return {
			{
				tileGroup = enums.TileGroup.StartSquad,
				onActivated = self.props.navigateToQuickStartSquadInviteFriends
			},
			{
				tileGroup = enums.TileGroup.FriendsList,
				onActivated = self.navigateToConversationFromSocialCarousel
			}
		}
	end)

	function self.isPartyQuickStartEnabled()
		return self.props.isPartyQuickStartEnabled
	end

	function self.renderItem(p2, p3)
		local item = p2.item

		if item.isChatLandingModal then
			return Roact.createElement(ChatLandingModalContainer, {})
		end

		if item.isGroupLink then
			return Roact.createElement(ConversationGroupsEntryContainer, { entryHeight = self.ENTRY_HEIGHT })
		end

		if self.isPartyQuickStartEnabled() and item.isQuickStartLink then
			return Roact.createElement(PartyQuickStartContainer, { entryHeight = self.ENTRY_HEIGHT })
		end

		if partyPageCarouselExperimentation.getPartyPageCarouselEnabled() and item.isSocialCarousel then
			local createElement = React.createElement
			local entry = SocialCarousel.Entry
			local v9 = {
				customTileList = v8(),
				roduxKey = "ChatAppReducer",
				hideCarouselHeader = true,
				source = 0,
				unifiedLogging = 0
			}

			local v10 = if self.props.isInExperience then constants.ANALYTICS.SRC.PARTY_PAGE_IN_EXP else constants.ANALYTICS.SRC.PARTY_PAGE_UA
			v9.source = v10

			v9.unifiedLogging = self.unifiedLogging
			return createElement(entry, v9)
		else
			if
				fFlagAppIaScrollAway and item.isCanvasTopPadding
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
					debugCell = Roact.createElement("StringValue", {
						Value = tostring(item.id)
					})
				})
			end

			local createElement = React.createElement
			local v10 = {
				entryHeight = self.ENTRY_HEIGHT,
				conversationId = tostring(item.id),
				isSquadEnabled = self.props.canAccessParty == true,
				isWideMode = self.props.isWideMode,
				onActivated = self.props.onActivated,
				onSquadJoinButtonActivated = self.props.navigateToSquadLobby,
				key = "ConversationEntry" .. tostring(item.id),
				fireImpressionEvent = self.props.fireConversationImpressionEvent,
				fireClickEvent = self.props.fireConversationClickedEvent,
				localUserId = self.props.localUserId,
				debugCellValue = 0
			}
			local v11 = if self.props.isDebugEnabled then tostring(item.id) else nil
			v10.debugCellValue = v11
			return createElement(ConversationRow, v10)
		end
	end

	local v9 = if FFlagAppChatConsoleFocusFixes and self.props.listRef then self.props.listRef else Roact.createRef()
	self.ref = v9
	self.viewRef = Roact.createRef()
	self.initialFetchesAttempted = 0
	self.focusNavigationService = focusNavigationService.new(coreGui)
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

	appChatPerfExperimentation.logExposure()
	partyPageCarouselExperimentation.logExposure()
	squadQuickStartExperimentation.logExposure()

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
			self.scrollIntervalTracker = createScrollIntervalTracker(AppChatPerfTracker.Events.ScrollConversationList, scrollRef)
		end
	end

	local scrollRef = self.getScrollRef()

	if scrollRef ~= nil then
		scrollRef.Selectable = false
	end
end

function extended.willUnmount(p2)
	if FFlagAppChatPerfTracking and p2.scrollIntervalTracker then
		p2.scrollIntervalTracker.cleanup()
	end

	if fFlagAppIaScrollAway and fFlagEnableScrollAwayContentScrollableFix then
		visibilityControl.setContentScrollable(true)
	end

	p2.focusNavigationService:teardown()
end

function extended:willUpdate(data, p2)
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
		v5:info(
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

	local v6 = self.props.filterText == "" or self.props.filterText == nil
	local showGroupsLink = self.props.showGroupsLink

	if v6 and showGroupsLink then
		itemList = Cryo.List.join({
			{ id = "ConversationGroupsEntryContainer", isGroupLink = true }
		}, itemList)
	end

	if
		not partyPageCarouselExperimentation.getPartyPageCarouselEnabled()
		and self.isPartyQuickStartEnabled()
	then
		itemList = Cryo.List.join({
			{ id = "PartyQuickStartContainer", isQuickStartLink = true }
		}, itemList)
	end

	if v6 then
		if
			self.isPartyQuickStartEnabled()
			and partyPageCarouselExperimentation.getPartyPageCarouselEnabled()
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

	if fFlagAppIaScrollAway and self.props.canvasTopPadding > 0 then
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

	local fn = fFlagAppIaScrollAway and function(p2, p3)
		local v7, v8

		if self.props.canvasTopPadding > 0 then
			if p3 == 1 then
				v7 = self.props.canvasTopPadding
				v8 = 0
			else
				v7 = self.ENTRY_HEIGHT
				v8 = self.props.canvasTopPadding + self.ENTRY_HEIGHT * (p3 - 2)
			end
		else
			v7 = self.ENTRY_HEIGHT
			v8 = self.ENTRY_HEIGHT * (p3 - 1)
		end

		return { length = v7, offset = v8, index = p3 }
	end or nil

	local function renderScroller(p2)
		local v7

		if self.props.pageBackgroundTransparency == nil then
			v7 = p2.Tokens.Color.None.Transparency
		else
			v7 = self.props.pageBackgroundTransparency
		end

		local createElement = Roact.createElement
		local v9 = {
			BackgroundTransparency = 1,
			Size = self.props.Size,
			[Roact.Ref] = self.viewRef
		}
		local absoluteSize = Roact.Change.AbsoluteSize
		local v10 = if fFlagAppIaScrollAway and fFlagEnableScrollAwayContentScrollableFix then self.onViewportAbsoluteSizeChange else nil
		v9[absoluteSize] = v10

		local createElement2 = Roact.createElement
		local refsByRef = {}
		refsByRef.data = itemList
		refsByRef.renderItem = self.renderItem
		local v13

		if fFlagAppIaScrollAway then
			v13 = fn
		else
			v13 = function(p3, p4)
				return {
					length = self.ENTRY_HEIGHT,
					offset = self.ENTRY_HEIGHT * (p4 - 1),
					index = p4
				}
			end
		end

		refsByRef.getItemLayout = v13

		refsByRef.style = {
			BackgroundColor3 = p2.Theme.BackgroundDefault.Color,
			BackgroundTransparency = v7,
			ScrollBarThickness = 0,
			BorderSizePixel = 0
		}

		refsByRef.contentContainerStyle = {
			BackgroundColor3 = p2.Theme.BackgroundDefault.Color,
			BackgroundTransparency = v7,
			BorderSizePixel = 0
		}

		refsByRef.windowSize = defineFastInt3
		refsByRef.initialNumToRender = defineFastInt4
		refsByRef.onScroll = self.onScrollUpdate
		function refsByRef.onContentSizeChange(p3, lastContentHeight)
			local current = self.viewRef.current

			if current then
				v5:debug(
					"onContentSizeChange - Window height: {} vs Content height: {}",
					current.AbsoluteSize.Y,
					lastContentHeight
				)

				if fFlagAppIaScrollAway and fFlagEnableScrollAwayContentScrollableFix then
					self.lastContentHeight = lastContentHeight
					self.onViewportAbsoluteSizeChange(current)
				end

				if lastContentHeight <= current.AbsoluteSize.Y then
					v5:info("Not enough content to fill the view, loading more conversations")
					self.props.loadNext()
				end
			end
		end
		function refsByRef.onEndReached()
			v5:debug("onEndReached - Loading more conversations")
			self.props.loadNext()
			return Promise.resolve()
		end

		function refsByRef.onStartReached()
			v5:debug("onStartReached - Loading previous conversations")

			if self.props.loadPrevious then
				self.props.loadPrevious()
			end

			return Promise.resolve()
		end

		refsByRef.AutomaticCanvasSize = Enum.AutomaticSize.XY
		refsByRef.CanvasSize = UDim2.fromScale(0, 0)
		refsByRef.onEndReachedThreshold = self.ENTRY_HEIGHT * defineFastInt6
		refsByRef.onStartReachedThreshold = self.ENTRY_HEIGHT * defineFastInt5
		function refsByRef.compareItemData(p3, p4): boolean
			return p3.id == p4.id
		end

		refsByRef[Roact.Ref] = self.ref
		refsByRef.autoscrollToTopThreshold = 33
		refsByRef.enableAutoscrollToTop = true
		local v14 = if FFlagAppChatConsoleFocusFixes then self.props.scrollEnabled else nil
		refsByRef.scrollEnabled = v14
		return createElement("Frame", v9, {
			scroller = createElement2(bidirectionalFlatList, refsByRef)
		})
	end

	return withStyle(function(p2)
		if #itemList ~= 0 then
			return renderScroller(p2)
		end

		local createElement = Roact.createElement
		local v8 = {
			Size = self.props.Size,
			BackgroundColor3 = p2.Theme.BackgroundDefault.Color,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			LayoutOrder = 0
		}
		local v9 = if self.props.pageBackgroundTransparency == nil then p2.Tokens.Color.None.Transparency else self.props.pageBackgroundTransparency
		v8.BackgroundTransparency = v9

		v8.LayoutOrder = self.props.LayoutOrder
		return createElement("Frame", v8)
	end)
end

return extended
