local IXPService = game:GetService("IXPService")

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local SocialExperiments = require(parent.SocialExperiments)
local AppChatPerfExperimentation = SocialExperiments.AppChatPerfExperimentation
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local CoreGui = ReactFocusNavigation.EngineInterface.CoreGui
local ReactFocusNavigation2 = require(parent.ReactFocusNavigation)
local FocusNavigationService = ReactFocusNavigation2.FocusNavigationService
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local SharedFlags = require(parent.SharedFlags)
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal
local Signals = require(parent.Signals)
local SocialCarousel = require(parent.SocialCarousel)
local SocialExperiments2 = require(parent.SocialExperiments)
local Foundation = require(parent.Foundation)
local ViewRecycler = require(parent.ViewRecycler)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local FFlagAppChatConversationListViewRecyclerConsoleProps = require(AppChat.Flags.FFlagAppChatConversationListViewRecyclerConsoleProps)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local createScrollIntervalTracker = require(AppChat.Telemetry.createScrollIntervalTracker)

local Constants = SocialCarousel.Constants
local Enums = SocialCarousel.Enums

local SquadQuickStartExperimentation = SocialExperiments2.SquadQuickStartExperimentation

local ConversationListViewRecyclerItems = require(script.Parent.ConversationListViewRecyclerItems)
local defineFastInt = game:DefineFastInt("AppChatChatLandingInitialFetchLimit", 5)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagFriendsChatConversationListShowScrollBar = SharedFlags.FFlagFriendsChatConversationListShowScrollBar

local defineFastInt2 = game:DefineFastInt("AppChatChatLandingInitialFetchMinimumConversations", 30)

local FFlagAppChatRemoveConversationListDividerIxpEnabled = require(AppChat.Flags.FFlagAppChatRemoveConversationListDividerIxpEnabled)

local FStringAppChatRemoveConversationListDividerIxpLayer = require(AppChat.Flags.FStringAppChatRemoveConversationListDividerIxpLayer)

local defineFastInt3 = game:DefineFastInt("AppChatPerfChatLandingPaginationOnStartReachedUnits", 1)

local defineFastInt4 = game:DefineFastInt("AppChatPerfChatLandingPaginationOnEndReachedUnits", 10)

local SocialExperiments3 = require(parent.SocialExperiments)
local PartyPageCarouselExperimentation = SocialExperiments3.PartyPageCarouselExperimentation

local Logger = require(script.Parent.Logger)
local v = Logger:new(script.Name)

local v2 = game:DefineFastInt("AppChatConversationListScrollBarIdleHideMs", 1500) / 1000
local v3 = {
	dampingRatio = 1,
	frequency = 2,
	restingVelocityLimit = 0.1,
	restingPositionLimit = 0.1
}

local function noop() end

local v4 = {
	entryHeight = 64,
	itemList = {},
	Size = UDim2.fromScale(1, 1),
	LayoutOrder = 1,
	onScrollUpdate = noop,
	navigateToConversationFromUserId = noop,
	navigateToQuickStartSquadInviteFriends = noop,
	navigateToSquadLobby = noop,
	fireConversationImpressionEvent = noop,
	fireConversationClickedEvent = noop,
	showHeaderEntries = true,
	rowProps = {}
}

local function getAutoLoadNextRequestKey(list) -- 1 equivalent call inferred from this helper
	local id

	if list[1] ~= nil then
		id = list[1].id
	end

	local v5

	if list[#list] ~= nil then
		v5 = list[#list].id
	end

	return `{#list}:{tostring(id)}:{tostring(v5)}`
end

local function buildConversationItems(itemList, p)
	local conversationItems = table.create(#itemList)

	for k, item in itemList do
		conversationItems[k] = ConversationListViewRecyclerItems.conversation(item.id, p)
	end

	return conversationItems
end

local function concatItems(list, list2)
	local v5 = table.create(#list + #list2)
	table.move(list, 1, #list, 1, v5)
	table.move(list2, 1, #list2, #list + 1, v5)
	return v5
end

local function usePresentationSignal(p)
	local v5 = React.useState(function()
		local signal, set = Signals.createSignal(p)
		return { get = signal, set = set }
	end)

	React.useLayoutEffect(function()
		v5.set(p)
	end, { v5, p })

	return v5.get
end

local function usePagination(joined, itemList)
	local ref = React.useRef(0)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(false)
	local current = React.useMemo(function()
		return getAutoLoadNextRequestKey(itemList) -- inferred equivalent call
	end, { itemList })
	local v5

	if joined.loadNext == nil then
		v5 = false
	else
		v5 = not (joined.isLoadingNext or joined.oldestConversationIsFetched)
	end

	React.useEffect(function()
		if ref3.current and not joined.isLoadingNext then
			ref2.current = nil
		end

		ref3.current = joined.isLoadingNext == true
	end, { joined.isLoadingNext })

	local v6 = React.useCallback(function(): boolean
		if not v5 or ref2.current == current then
			return false
		end

		ref2.current = current
		joined.loadNext()
		return true
	end, { v5, current, joined.loadNext })

	React.useEffect(function()
		if v5 and ref.current < defineFastInt and #itemList < defineFastInt2 then
			local current2 = ref.current + 1

			if v6() then
				ref.current = current2
				v:info(
					"Loading more conversations because the list (count: {} out of {}) is not enough (attempt {} out of {})",
					#itemList,
					defineFastInt2,
					ref.current,
					defineFastInt
				)
			end
		end
	end, { itemList, v5, v6 })

	local v7 = React.useCallback(function()
		if v6() then
			v:debug("ViewRecycler onEndReached - Loading more conversations")
		end
	end, { v6 })

	return v5, v6, React.useCallback(function()
		if joined.loadPrevious ~= nil and not joined.isLoadingPrevious then
			v:debug("ViewRecycler onStartReached - Loading previous conversations")
			joined.loadPrevious()
		end
	end, { joined.loadPrevious, joined.isLoadingPrevious }), v7
end

local function useUnderfillPagination(callback)
	local ref = React.useRef(0)
	local ref2 = React.useRef(0)
	local v5 = React.useCallback(function()
		if ref2.current > 0 and ref.current > 0 and ref2.current <= ref.current and callback() then
			v:info("Loading more conversations because ViewRecycler content does not fill the viewport")
		end
	end, { callback })

	return React.useCallback(function(p)
		ref.current = p.Y
		v5()
	end, { v5 }), (React.useCallback(function(current)
		ref2.current = current
		v5()
	end, { v5 }))
end

local function useScrollTracking(onScrollUpdate, callback)
	local v5 = React.useMemo(function()
		return Signal.new()
	end, {})
	local ref = React.useRef(nil)
	local state, setState = React.useState(nil)

	local v6 = React.useCallback(function(p)
		if FFlagAppChatPerfTracking and ref.current then
			ref.current.onScrollTick()
		end

		if callback ~= nil then
			callback()
		end

		v5:fire()
		onScrollUpdate({ CanvasPosition = Vector2.new(0, p) })
	end, { v5, onScrollUpdate, callback })

	local v7 = React.useCallback(function(p)
		setState(p)
	end, {})

	React.useEffect(function()
		local v8 = state

		if v8 == nil then
			return nil
		end

		v8.Selectable = false

		if FFlagAppChatPerfTracking then
			ref.current = createScrollIntervalTracker(AppChatPerfTracker.Events.ScrollConversationList, v8)
		end

		return function()
			if ref.current then
				ref.current.cleanup()
				ref.current = nil
			end
		end
	end, { state })

	return v5, v7, v6
end

local function useMeasuredLayout(entryHeight)
	local v5 = React.useState(function()
		return ViewRecycler.Layout.measured({ estimatedItemLength = entryHeight })
	end)

	React.useEffect(function()
		return function()
			v5.destroy()
		end
	end, { v5 })

	return v5
end

local function useConversationListScrollbar(p, scrollbarThickness, color3)
	local ref, scrollBarImageTransparency, v5

	if FFlagFriendsChatConversationListShowScrollBar then
		ref = React.useRef(nil)
		scrollBarImageTransparency, v5 = ReactOtter.useAnimatedBinding(1)
	else
		ref = nil
		v5 = nil
	end

	local v6

	if FFlagFriendsChatConversationListShowScrollBar then
		v6 = React.useCallback(function()
			if not p then
				return
			end

			if ref.current ~= nil then
				pcall(task.cancel, ref.current)
				ref.current = nil
			end

			v5(ReactOtter.instant(0))
			ref.current = task.delay(v2, function()
				ref.current = nil
				v5(ReactOtter.spring(1, v3))
			end)
		end, { p, v5 })

		React.useEffect(function()
			return function()
				if ref.current ~= nil then
					pcall(task.cancel, ref.current)
					ref.current = nil
				end
			end
		end, {})
	end

	local v7 = FFlagFriendsChatConversationListShowScrollBar and p
	local v8 = {
		ScrollBarThickness = v7 and (scrollbarThickness or 8) or 0,
		ScrollBarImageColor3 = nil,
		ScrollBarImageTransparency = nil
	}

	if not v7 then
		color3 = nil
	end

	v8.ScrollBarImageColor3 = color3

	if not v7 then
		scrollBarImageTransparency = nil
	end

	v8.ScrollBarImageTransparency = scrollBarImageTransparency

	return v8, v6
end

local function useListData(p, p2)
	local items = React.useMemo(function()
		return concatItems(p, p2)
	end, { p, p2 })

	return React.useMemo(function()
		return { items = items, getItemKey = ConversationListViewRecyclerItems.getItemKey }
	end, { items }), items
end

local function useCanvasBottomPadding(p, canvasBottomPadding, none) -- 1 equivalent call inferred from this helper
	return React.useMemo(function()
		if canvasBottomPadding == nil or canvasBottomPadding <= 0 then
			return p
		end

		return concatItems(p, { ConversationListViewRecyclerItems.canvasBottomPadding(canvasBottomPadding, none) })
	end, { p, canvasBottomPadding, none })
end

local function useLegacyListRef(listRef, p, callback)
	local nativeRef = React.useMemo(function()
		if p then
			return { current = nil }
		end

		return nil
	end, { p })

	React.useLayoutEffect(function()
		if listRef == nil then
			return nil
		end

		local nativeScrollRef = nativeRef ~= nil and { _nativeRef = nativeRef } or nil
		listRef.current = {
			_listRef = {
				_scrollRef = {
					getNativeScrollRef = function()
						return nativeScrollRef
					end
				}
			}
		}

		return function()
			listRef.current = nil
		end
	end, { listRef, nativeRef })

	return React.useCallback(function(current)
		if nativeRef ~= nil then
			nativeRef.current = current
		end

		callback(current)
	end, { nativeRef, callback })
end

local function ConversationListViewRecycler(p)
	local joined = Cryo.Dictionary.join(v4, p)
	local entryHeight = joined.entryHeight
	local itemList = joined.itemList
	local size = joined.Size
	local layoutOrder = joined.LayoutOrder
	local onScrollUpdate = joined.onScrollUpdate
	local navigateToConversationFromUserId = joined.navigateToConversationFromUserId
	local navigateToQuickStartSquadInviteFriends = joined.navigateToQuickStartSquadInviteFriends
	local navigateToSquadLobby = joined.navigateToSquadLobby
	local fireConversationImpressionEvent = joined.fireConversationImpressionEvent
	local fireConversationClickedEvent = joined.fireConversationClickedEvent
	local showHeaderEntries = joined.showHeaderEntries
	local rowProps = joined.rowProps
	local v5 = useTokens()
	local v6, v7, onStartReached, onEndReached = usePagination(joined, itemList)
	local onViewportChanged, onContentLengthChanged = useUnderfillPagination(v7)
	local v8, v9 = useConversationListScrollbar(
		joined.showScrollbarOnScroll == true,
		joined.scrollbarThickness,
		v5.Color.Content.Emphasis.Color3
	)

	local scrollViewPositionChangedSignal, scrollingFrameRef, onScrollOffsetChanged = useScrollTracking(onScrollUpdate, v9)

	React.useEffect(function()
		AppChatPerfExperimentation.logExposure()

		if joined.shouldLogHeaderEntryExposures ~= false then
			PartyPageCarouselExperimentation.logExposure()

			if SquadQuickStartExperimentation.isLogExposureEnabled then
				SquadQuickStartExperimentation.logExposure()
			end

			if FFlagAppChatRemoveConversationListDividerIxpEnabled then
				IXPService:LogFlagLinkedUserLayerExposure(FStringAppChatRemoveConversationListDividerIxpLayer)
			end
		end
	end, {})

	React.useEffect(function()
		local v10 = FocusNavigationService.new(CoreGui)
		return function()
			v10:teardown()
		end
	end, {})

	local canAccessParty = joined.canAccessParty == true
	local isPartyQuickStartEnabled = joined.isPartyQuickStartEnabled
	local v10 = React.useMemo(function()
		local v10 = {
			appPage = AppPage.Chat,
			impressionTag = 0,
			scrollViewPositionChangedSignal = 0,
			sortId = 0,
			sortIndex = 1
		}
		local impressionTag

		if joined.isInExperience then
			impressionTag = Constants.ANALYTICS.SRC.PARTY_PAGE_IN_EXP
		else
			impressionTag = Constants.ANALYTICS.SRC.PARTY_PAGE_UA
		end

		v10.impressionTag = impressionTag

		v10.scrollViewPositionChangedSignal = scrollViewPositionChangedSignal
		return v10
	end, { joined.isInExperience, scrollViewPositionChangedSignal })

	local onActivated = React.useCallback(function(p2)
		navigateToConversationFromUserId(p2.id)
	end, { navigateToConversationFromUserId })

	local v11 = React.useMemo(function()
		return {
			{
				tileGroup = Enums.TileGroup.StartSquad,
				onActivated = navigateToQuickStartSquadInviteFriends
			},
			{ tileGroup = Enums.TileGroup.FriendsList, onActivated = onActivated }
		}
	end, { navigateToQuickStartSquadInviteFriends, onActivated })

	local v12 = usePresentationSignal(React.useMemo(function()
		return {
			entryHeight = entryHeight,
			isSquadEnabled = canAccessParty,
			isWideMode = joined.isWideMode,
			onActivated = joined.onActivated,
			onSquadJoinButtonActivated = navigateToSquadLobby,
			fireImpressionEvent = fireConversationImpressionEvent,
			fireClickEvent = fireConversationClickedEvent,
			showBackground = rowProps.showBackground,
			localUserId = joined.localUserId,
			isDebugEnabled = joined.isDebugEnabled == true
		}
	end, {
		entryHeight,
		canAccessParty,
		joined.isWideMode,
		joined.onActivated,
		navigateToSquadLobby,
		fireConversationImpressionEvent,
		fireConversationClickedEvent,
		rowProps.showBackground,
		joined.localUserId,
		joined.isDebugEnabled
	}))

	local v13 = joined.filterText == "" or joined.filterText == nil
	local v14 = showHeaderEntries and v13
	local partyPageCarouselEnabled = PartyPageCarouselExperimentation.getPartyPageCarouselEnabled()
	local v15 = React.useMemo(function()
		local v15 = {}

		if FFlagAppIaScrollAway and joined.canvasTopPadding ~= nil and joined.canvasTopPadding > 0 then
			table.insert(
				v15,
				ConversationListViewRecyclerItems.canvasTopPadding(joined.canvasTopPadding, v5.Color.None)
			)
		end

		if not v14 then
			return v15
		end

		table.insert(v15, ConversationListViewRecyclerItems.chatLandingModal())

		if
			isPartyQuickStartEnabled
			and partyPageCarouselEnabled
			and (joined.isWideMode or not joined.isInExperience)
		then
			table.insert(v15, ConversationListViewRecyclerItems.socialCarousel(v11, joined.isInExperience, v10))
		elseif isPartyQuickStartEnabled and not partyPageCarouselEnabled then
			table.insert(v15, ConversationListViewRecyclerItems.quickStart(entryHeight))
		end

		if joined.showGroupsLink == true then
			table.insert(v15, ConversationListViewRecyclerItems.groupLink(entryHeight))
		end

		return v15
	end, {
		v14,
		isPartyQuickStartEnabled,
		partyPageCarouselEnabled,
		joined.isWideMode,
		joined.isInExperience,
		joined.showGroupsLink,
		joined.canvasTopPadding,
		v5.Color.None,
		v11,
		v10,
		entryHeight
	})

	local v16 = React.useMemo(function()
		return buildConversationItems(itemList, v12)
	end, { itemList, v12 })
	local v17

	if FFlagAppChatConversationListViewRecyclerConsoleProps then
		v17 = useCanvasBottomPadding(v16, joined.canvasBottomPadding, v5.Color.None) -- inferred equivalent call
	else
		v17 = v16
	end

	local v18, v19 = useListData(v15, v17)

	if FFlagAppChatConversationListViewRecyclerConsoleProps then
		scrollingFrameRef = useLegacyListRef(joined.listRef, #v19 > 0, scrollingFrameRef)
	end

	local layout = useMeasuredLayout(entryHeight)

	if #v19 == 0 then
		return React.createElement(View, {
			Size = size,
			backgroundStyle = v5.Color.None,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder
		})
	end

	local createElement = React.createElement
	local v20 = {
		Size = size,
		backgroundStyle = v5.Color.None,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder
	}

	local createElement2 = React.createElement
	local virtualList = ViewRecycler.VirtualList
	local v21 = {
		data = v18,
		layout = layout,
		overscan = 2,
		axis = ViewRecycler.Axis.Y,
		itemType = ConversationListViewRecyclerItems.getItemType,
		scrollingFrameRef = scrollingFrameRef,
		onViewportChanged = onViewportChanged,
		onContentLengthChanged = onContentLengthChanged,
		onScrollOffsetChanged = onScrollOffsetChanged,
		onStartReached = 0,
		onEndReached = 0,
		startReachedThreshold = 0,
		endReachedThreshold = 0,
		autoScrollOnChange = 0,
		autoScrollThreshold = 33,
		scrollingFrameProps = 0
	}

	if joined.loadPrevious == nil or joined.isLoadingPrevious then
		onStartReached = nil
	end

	v21.onStartReached = onStartReached

	if not v6 then
		onEndReached = nil
	end

	v21.onEndReached = onEndReached
	v21.startReachedThreshold = entryHeight * defineFastInt3
	v21.endReachedThreshold = entryHeight * defineFastInt4
	v21.autoScrollOnChange = ViewRecycler.AutoScrollPolicy.WhenAtStart

	local rctScrollView = {
		Name = "RCTScrollView",
		BackgroundTransparency = 1,
		ScrollBarThickness = v8.ScrollBarThickness,
		ScrollBarImageColor3 = v8.ScrollBarImageColor3,
		ScrollBarImageTransparency = v8.ScrollBarImageTransparency,
		BorderSizePixel = 0,
		ScrollingEnabled = 0
	}
	local scrollingEnabled

	if FFlagAppChatConversationListViewRecyclerConsoleProps then
		scrollingEnabled = joined.scrollEnabled ~= false
	end

	rctScrollView.ScrollingEnabled = scrollingEnabled
	v21.scrollingFrameProps = rctScrollView
	return createElement(View, v20, {
		List = createElement2(virtualList, v21)
	})
end

return React.memo(ConversationListViewRecycler)
