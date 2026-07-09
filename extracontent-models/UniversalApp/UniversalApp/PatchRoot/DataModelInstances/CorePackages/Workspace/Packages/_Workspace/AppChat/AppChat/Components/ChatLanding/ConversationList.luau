local IXPService = game:GetService("IXPService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatPerfExperimentation = require(AppChatParent.SocialExperiments).AppChatPerfExperimentation
local VisibilityControl = require(AppChatParent.AppNavBar).VisibilityControl
local AppPage = require(AppChatParent.RobloxAppEnums).AppPage
local BidirectionalFlatList = require(AppChatParent.VirtualizedList).BidirectionalFlatList
local CoreGui = require(AppChatParent.ReactFocusNavigation).EngineInterface.CoreGui
local Cryo = require(AppChatParent.Cryo)
local FocusNavigationService = require(AppChatParent.ReactFocusNavigation).FocusNavigationService
local memoize = require(AppChatParent.AppCommonLib).memoize
local React = require(AppChatParent.React)
local Roact = require(AppChatParent.Roact)
local Promise = require(AppChatParent.Promise)
local SharedFlags = require(AppChatParent.SharedFlags)
local Signal = require(AppChatParent.AppCommonLib).Signal
local SocialCarousel = require(AppChatParent.SocialCarousel)
local SocialExperiments = require(AppChatParent.SocialExperiments)
local withStyle = require(AppChatParent.UIBlox).Style.withStyle
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local createScrollIntervalTracker = require(AppChat.Telemetry.createScrollIntervalTracker)
local Constants = SocialCarousel.Constants
local Enums = SocialCarousel.Enums
local SquadQuickStartExperimentation = SocialExperiments.SquadQuickStartExperimentation
local ChatLandingModalContainer = require(script.Parent.ChatLandingModal.ChatLandingModalContainer)
local ConversationEntry = require(script.Parent.ConversationEntry)
local ConversationRow = require(script.Parent.ConversationRow)
local ConversationGroupsEntryContainer = require(script.Parent.ConversationGroupsEntryContainer)
local PartyQuickStartContainer = require(script.Parent.PartyQuickStartContainer)
local v31 = game:DefineFastInt("AppChatChatLandingInitialFetchLimit", 5)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagEnableScrollAwayContentScrollableFix = SharedFlags.FFlagEnableScrollAwayContentScrollableFix
local v34 = game:DefineFastInt("AppChatChatLandingInitialFetchMinimumConversations", 30)
local FFlagAppChatRemoveConversationListDividerIxpEnabled = require(AppChat.Flags.FFlagAppChatRemoveConversationListDividerIxpEnabled)
local FStringAppChatRemoveConversationListDividerIxpLayer = require(AppChat.Flags.FStringAppChatRemoveConversationListDividerIxpLayer)
local FFlagAppChatTimestampInSubtitleIxpEnabled = require(AppChat.Flags.FFlagAppChatTimestampInSubtitleIxpEnabled)
local FStringAppChatTimestampInSubtitleIxpLayer = require(AppChat.Flags.FStringAppChatTimestampInSubtitleIxpLayer)
local v39 = game:DefineFastInt("AppChatPerfChatLandingPaginationWindowSize", 2)
local v40 = game:DefineFastInt("AppChatPerfChatLandingPaginationInitialRender", 8)
local v41 = game:DefineFastInt("AppChatPerfChatLandingPaginationOnStartReachedUnits", 1)
local v42 = game:DefineFastInt("AppChatPerfChatLandingPaginationOnEndReachedUnits", 10)
local PartyPageCarouselExperimentation = require(AppChatParent.SocialExperiments).PartyPageCarouselExperimentation
local v44 = require(script.Parent.Logger):new(script.Name)
local FFlagAppChatUseNewConversationRow = require(AppChat.Flags.FFlagAppChatUseNewConversationRow)
local FFlagAppChatConversationStore = require(AppChat.Flags.FFlagAppChatConversationStore)
local FFlagAppChatSignalsMessageStore = require(AppChat.Flags.FFlagAppChatSignalsMessageStore)
local v48 = FFlagAppChatUseNewConversationRow and (FFlagAppChatConversationStore and FFlagAppChatSignalsMessageStore)
local v49 = Roact.PureComponent:extend("ConversationList")

v49.defaultProps = {
	focusIndex = 1,
	loadNext = nil,
	loadPrevious = nil,
	onActivated = nil,
	isDebugEnabled = false,
	LayoutOrder = 1,
	entryHeight = 64,
	shouldShowPhoneVerificationUpsell = false,
	shouldShowUnfilteredAccessFtux = false,
	shouldShowPartyUpsellFtux = false,
	isPartyQuickStartEnabled = false,
	canAccessParty = false,
	focusLock = {},
	itemList = {},
	navigateToQuickStartSquadInviteFriends = function() -- line: 79
	end,
	navigateToSquadLobby = function() -- line: 80
	end,
	Size = UDim2.fromScale(1, 1),
	onScrollUpdate = function() -- line: 84
	end,
	dismissUnfilteredThreadsFtux = function() -- line: 89
	end,
	canvasTopPadding = if not FFlagAppIaScrollAway then nil else 0,
	fireConversationImpressionEvent = function() -- line: 91
	end,
	fireConversationClickedEvent = function() -- line: 93
	end
}

local function getIsSquadEnabledForRows(p1) -- line: 97
	return p1.canAccessParty == true
end

function v49.init(p2) -- line: 101
	-- upvalues: v49 (copy), FFlagAppChatPerfTracking (copy), Signal (copy), AppPage (copy), Constants (copy), FFlagAppIaScrollAway (copy), FFlagEnableScrollAwayContentScrollableFix (copy), VisibilityControl (copy), PartyPageCarouselExperimentation (copy), memoize (copy), Enums (copy), Roact (copy), ChatLandingModalContainer (copy), ConversationGroupsEntryContainer (copy), PartyQuickStartContainer (copy), React (copy), SocialCarousel (copy), v48 (copy), ConversationRow (copy), ConversationEntry (copy), FocusNavigationService (copy), CoreGui (copy), AppChatPerfExperimentation (copy), SquadQuickStartExperimentation (copy), FFlagAppChatRemoveConversationListDividerIxpEnabled (copy), IXPService (copy), FStringAppChatRemoveConversationListDividerIxpLayer (copy), FFlagAppChatTimestampInSubtitleIxpEnabled (copy), FStringAppChatTimestampInSubtitleIxpLayer (copy)
	v49.ENTRY_HEIGHT = p2.props.entryHeight

	if FFlagAppChatPerfTracking then
		p2.scrollIntervalTracker = nil
	end

	p2.scrollViewPositionChangedSignal = Signal.new()
	p2.unifiedLogging = {
		sortId = 0,
		sortIndex = 1,
		appPage = AppPage.Chat,
		impressionTag = if not p2.props.isInExperience then Constants.ANALYTICS.SRC.PARTY_PAGE_UA else Constants.ANALYTICS.SRC.PARTY_PAGE_IN_EXP,
		scrollViewPositionChangedSignal = p2.scrollViewPositionChangedSignal
	}

	function p2.onScrollUpdate(p3) -- line: 118
		-- upvalues: FFlagAppChatPerfTracking (copy), p2 (copy)
		if FFlagAppChatPerfTracking and p2.scrollIntervalTracker then
			p2.scrollIntervalTracker.onScrollTick()
		end

		p2.currentAnchor = math.floor(p3.CanvasPosition.Y / 64)
		p2.scrollViewPositionChangedSignal:fire()
		p2.props.onScrollUpdate(p3)
	end

	if FFlagAppIaScrollAway and FFlagEnableScrollAwayContentScrollableFix then
		p2.lastContentHeight = 0

		function p2.onViewportAbsoluteSizeChange(p4) -- line: 131
			-- upvalues: VisibilityControl (copy), p2 (copy)
			VisibilityControl.setContentScrollable(p2.lastContentHeight > p4.AbsoluteSize.Y)
		end
	end

	p2.focusLock = p2.props.focusLock

	if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
		function p2.navigateToConversationFromSocialCarousel(p5) -- line: 139
			-- upvalues: p2 (copy)
			p2.props.navigateToConversationFromUserId(p5.id)
		end
	end

	function p2.identifier(p6) -- line: 144
		if not p6 then
			return nil
		end

		return p6.id .. tostring(p6.unixTime)
	end

	local v53 = memoize(function() -- line: 152
		-- upvalues: Enums (copy), p2 (copy)
		return {
			{
				tileGroup = Enums.TileGroup.StartSquad,
				onActivated = p2.props.navigateToQuickStartSquadInviteFriends
			},
			{
				tileGroup = Enums.TileGroup.FriendsList,
				onActivated = p2.navigateToConversationFromSocialCarousel
			}
		}
	end)

	function p2.isPartyQuickStartEnabled() -- line: 165
		-- upvalues: p2 (copy)
		return p2.props.isPartyQuickStartEnabled
	end
	function p2.renderItem(p7, _) -- line: 170
		-- upvalues: Roact (copy), ChatLandingModalContainer (copy), ConversationGroupsEntryContainer (copy), p2 (copy), PartyQuickStartContainer (copy), PartyPageCarouselExperimentation (copy), React (copy), SocialCarousel (copy), v53 (copy), Constants (copy), FFlagAppIaScrollAway (copy), v48 (copy), ConversationRow (copy), ConversationEntry (copy)
		local item = p7.item

		if item.isChatLandingModal then
			return Roact.createElement(ChatLandingModalContainer, {})
		end

		if item.isGroupLink then
			return Roact.createElement(ConversationGroupsEntryContainer, {
				entryHeight = p2.ENTRY_HEIGHT
			})
		end

		if p2.isPartyQuickStartEnabled() and item.isQuickStartLink then
			return Roact.createElement(PartyQuickStartContainer, {
				entryHeight = p2.ENTRY_HEIGHT
			})
		end

		if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() and item.isSocialCarousel then
			return React.createElement(SocialCarousel.Entry, {
				roduxKey = "ChatAppReducer",
				hideCarouselHeader = true,
				customTileList = v53(),
				source = if not p2.props.isInExperience then Constants.ANALYTICS.SRC.PARTY_PAGE_UA else Constants.ANALYTICS.SRC.PARTY_PAGE_IN_EXP,
				unifiedLogging = p2.unifiedLogging
			})
		end

		if FFlagAppIaScrollAway and item.isCanvasTopPadding then
			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, item.height)
			})
		end

		if v48 then
			local v74 = p2.props.rowProps or {}

			return React.createElement(ConversationRow, {
				entryHeight = p2.ENTRY_HEIGHT,
				conversationId = tostring(item.id),
				isSquadEnabled = p2.props.canAccessParty == true,
				isWideMode = p2.props.isWideMode,
				onActivated = p2.props.onActivated,
				onSquadJoinButtonActivated = p2.props.navigateToSquadLobby,
				key = "ConversationEntry" .. tostring(item.id),
				fireImpressionEvent = p2.props.fireConversationImpressionEvent,
				fireClickEvent = p2.props.fireConversationClickedEvent,
				showBackground = v74.showBackground,
				localUserId = p2.props.localUserId,
				debugCellValue = if not p2.props.isDebugEnabled then nil else tostring(item.id)
			})
		end

		return Roact.createElement(ConversationEntry, {
			boldTitle = false,
			entryHeight = p2.ENTRY_HEIGHT,
			conversation = item,
			onActivated = p2.props.onActivated,
			onSquadJoinButtonActivated = p2.props.navigateToSquadLobby,
			key = "ConversationEntry" .. tostring(item.id),
			fireImpressionEvent = p2.props.fireConversationImpressionEvent,
			fireClickEvent = p2.props.fireConversationClickedEvent
		}, p2.props.isDebugEnabled and {
			debugCell = Roact.createElement("StringValue", {
				Value = tostring(item.id)
			})
		})
	end

	p2.ref = Roact.createRef()
	p2.viewRef = Roact.createRef()
	p2.initialFetchesAttempted = 0
	p2.focusNavigationService = FocusNavigationService.new(CoreGui)

	function p2.getScrollRef() -- line: 243
		-- upvalues: p2 (copy)
		if p2.ref.current == nil then
			return nil
		end

		local v75 = p2.ref.current._listRef._scrollRef.getNativeScrollRef()

		if v75 == nil then
			return nil
		end

		return v75._nativeRef.current
	end

	AppChatPerfExperimentation.logExposure()
	PartyPageCarouselExperimentation.logExposure()

	if SquadQuickStartExperimentation.isLogExposureEnabled then
		SquadQuickStartExperimentation.logExposure()
	end

	if FFlagAppChatRemoveConversationListDividerIxpEnabled then
		IXPService:LogFlagLinkedUserLayerExposure(FStringAppChatRemoveConversationListDividerIxpLayer)
	end

	if FFlagAppChatTimestampInSubtitleIxpEnabled and game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
		IXPService:LogFlagLinkedUserLayerExposure(FStringAppChatTimestampInSubtitleIxpLayer)
	end
end
function v49.didMount(p9) -- line: 272
	-- upvalues: FFlagAppChatPerfTracking (copy), createScrollIntervalTracker (copy), AppChatPerfTracker (copy)
	if FFlagAppChatPerfTracking and p9.getScrollRef then
		local v55 = p9.getScrollRef()

		if v55 ~= nil then
			p9.scrollIntervalTracker = createScrollIntervalTracker(AppChatPerfTracker.Events.ScrollConversationList, v55)
		end
	end

	local v56 = p9.getScrollRef()

	if v56 ~= nil then
		v56.Selectable = false
	end
end
function v49.willUnmount(p10) -- line: 286
	-- upvalues: FFlagAppChatPerfTracking (copy), FFlagAppIaScrollAway (copy), FFlagEnableScrollAwayContentScrollableFix (copy), VisibilityControl (copy)
	if FFlagAppChatPerfTracking and p10.scrollIntervalTracker then
		p10.scrollIntervalTracker.cleanup()
	end

	if FFlagAppIaScrollAway and FFlagEnableScrollAwayContentScrollableFix then
		VisibilityControl.setContentScrollable(true)
	end

	p10.focusNavigationService:teardown()
end
function v49.willUpdate(p11, p12, _) -- line: 296
	-- upvalues: v31 (copy), v34 (copy), v44 (copy), v49 (copy)
	if p12.filterText and (p12.filterText ~= "" and p12.filterText ~= p11.props.filterText) then
		p11.focusLock = p12.filterText
	elseif p12.itemList[1] and p11.props.itemList[1] and p12.itemList[1].id ~= p11.props.itemList[1].id and p11.currentAnchor == 1 then
		p11.focusLock = {}
	end

	if p12.itemList and p11.props.itemList ~= p12.itemList and p11.initialFetchesAttempted < v31 and #p12.itemList < v34 then
		p11.initialFetchesAttempted = p11.initialFetchesAttempted + 1
		v44:info("Loading more conversations because the list (count: {} out of {}) is not enough (attempt {} out of {})", #p12.itemList, v34, p11.initialFetchesAttempted, v31)
		p11.props.loadNext()
	end

	if p12.entryHeight ~= p11.props.entryHeight then
		v49.ENTRY_HEIGHT = p12.entryHeight
	end
end
function v49.render(p14) -- line: 331
	-- upvalues: Cryo (copy), PartyPageCarouselExperimentation (copy), FFlagAppIaScrollAway (copy), Roact (copy), FFlagEnableScrollAwayContentScrollableFix (copy), BidirectionalFlatList (copy), v39 (copy), v40 (copy), v44 (copy), Promise (copy), v42 (copy), v41 (copy), withStyle (copy)
	local itemList = p14.props.itemList
	local v63 = p14.props.filterText == "" or p14.props.filterText == nil
	local showGroupsLink = p14.props.showGroupsLink

	if v63 and showGroupsLink then
		itemList = Cryo.List.join({{
			id = "ConversationGroupsEntryContainer",
			isGroupLink = true
		}}, itemList)
	end

	if not PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() and p14.isPartyQuickStartEnabled() then
		itemList = Cryo.List.join({{
			id = "PartyQuickStartContainer",
			isQuickStartLink = true
		}}, itemList)
	end

	if v63 then
		if p14.isPartyQuickStartEnabled() and PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() and (p14.props.isWideMode or not p14.props.isInExperience) then
			itemList = Cryo.List.join({{
				id = "SocialCarousel",
				isSocialCarousel = true
			}}, itemList)
		end

		itemList = Cryo.List.join({{
			id = "UnfilteredThreadsFtux",
			isChatLandingModal = true
		}}, itemList)
	end

	if FFlagAppIaScrollAway and p14.props.canvasTopPadding > 0 then
		itemList = Cryo.List.join({{
			id = "CanvasTopPadding",
			isCanvasTopPadding = true,
			height = p14.props.canvasTopPadding
		}}, itemList)
	end

	local v65 = if not FFlagAppIaScrollAway then nil else function(_, p16) -- line: 389
		-- upvalues: p14 (copy)
		local canvasTopPadding, n1

		if p14.props.canvasTopPadding > 0 then
			if p16 == 1 then
				canvasTopPadding = p14.props.canvasTopPadding
				n1 = 0
			else
				canvasTopPadding = p14.ENTRY_HEIGHT
				n1 = p14.props.canvasTopPadding + p14.ENTRY_HEIGHT * (p16 - 2)
			end
		else
			canvasTopPadding = p14.ENTRY_HEIGHT
			n1 = p14.ENTRY_HEIGHT * (p16 - 1)
		end

		return {
			length = canvasTopPadding,
			offset = n1,
			index = p16
		}
	end

	local function renderScroller(p17) -- line: 413
		-- upvalues: Roact (copy), p14 (copy), FFlagAppIaScrollAway (copy), FFlagEnableScrollAwayContentScrollableFix (copy), BidirectionalFlatList (copy), itemList (ref), v65 (copy), v39 (copy), v40 (copy), v44 (copy), Promise (copy), v42 (copy), v41 (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = p14.props.Size,
			[Roact.Ref] = p14.viewRef,
			[Roact.Change.AbsoluteSize] = if not FFlagAppIaScrollAway or not FFlagEnableScrollAwayContentScrollableFix then nil else p14.onViewportAbsoluteSizeChange
		}, {
			scroller = Roact.createElement(BidirectionalFlatList, {
				data = itemList,
				renderItem = p14.renderItem,
				getItemLayout = not FFlagAppIaScrollAway and function(_, p19) -- line: 427
					-- upvalues: p14 (copy)
					return {
						length = p14.ENTRY_HEIGHT,
						offset = p14.ENTRY_HEIGHT * (p19 - 1),
						index = p19
					}
				end or v65,
				style = {
					ScrollBarThickness = 0,
					BorderSizePixel = 0,
					BackgroundColor3 = p17.Theme.BackgroundDefault.Color,
					BackgroundTransparency = p17.Tokens.Color.None.Transparency
				},
				contentContainerStyle = {
					BorderSizePixel = 0,
					BackgroundColor3 = p17.Theme.BackgroundDefault.Color,
					BackgroundTransparency = p17.Tokens.Color.None.Transparency
				},
				windowSize = v39,
				initialNumToRender = v40,
				onScroll = p14.onScrollUpdate,
				onContentSizeChange = function(_, p21) -- line: 449
					-- upvalues: p14 (copy), v44 (copy), FFlagAppIaScrollAway (copy), FFlagEnableScrollAwayContentScrollableFix (copy)
					local current = p14.viewRef.current

					if current then
						v44:debug("onContentSizeChange - Window height: {} vs Content height: {}", current.AbsoluteSize.Y, p21)

						if FFlagAppIaScrollAway and FFlagEnableScrollAwayContentScrollableFix then
							p14.lastContentHeight = p21
							p14.onViewportAbsoluteSizeChange(current)
						end

						if p21 <= current.AbsoluteSize.Y then
							v44:info("Not enough content to fill the view, loading more conversations")
							p14.props.loadNext()
						end
					end
				end,
				onEndReached = function() -- line: 467
					-- upvalues: v44 (copy), p14 (copy), Promise (copy)
					v44:debug("onEndReached - Loading more conversations")
					p14.props.loadNext()

					return Promise.resolve()
				end,
				onStartReached = function() -- line: 472
					-- upvalues: v44 (copy), p14 (copy), Promise (copy)
					v44:debug("onStartReached - Loading previous conversations")

					if p14.props.loadPrevious then
						p14.props.loadPrevious()
					end

					return Promise.resolve()
				end,
				AutomaticCanvasSize = Enum.AutomaticSize.XY,
				CanvasSize = UDim2.fromScale(0, 0),
				onEndReachedThreshold = p14.ENTRY_HEIGHT * v42,
				onStartReachedThreshold = p14.ENTRY_HEIGHT * v41,
				compareItemData = function(p22, p23) -- line: 483
					return p22.id == p23.id
				end,
				[Roact.Ref] = p14.ref,
				autoscrollToTopThreshold = 33,
				enableAutoscrollToTop = true
			})
		})
	end

	return withStyle(function(p24) -- line: 493
		-- upvalues: itemList (ref), Roact (copy), p14 (copy), renderScroller (copy)
		if #itemList == 0 then
			return Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = p14.props.Size,
				BackgroundColor3 = p24.Theme.BackgroundDefault.Color,
				BackgroundTransparency = p24.Tokens.Color.None.Transparency,
				LayoutOrder = p14.props.LayoutOrder
			})
		end

		return renderScroller(p24)
	end)
end

return v49
