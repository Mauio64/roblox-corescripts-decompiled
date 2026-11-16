local IXPService = game:GetService("IXPService")

local appChatPerfExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments").AppChatPerfExperimentation
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppEnums").AppPage
local coreGui = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation").EngineInterface.CoreGui
local focusNavigationService = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation").FocusNavigationService
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactOtter")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").Signal
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SocialCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCarousel")
local SocialExperiments = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local ViewRecyclerReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ViewRecyclerReact")
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local FFlagAppChatConversationListViewRecyclerConsoleProps = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConversationListViewRecyclerConsoleProps")
local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")
local createScrollIntervalTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/createScrollIntervalTracker")

local constants = SocialCarousel.Constants
local enums = SocialCarousel.Enums

local squadQuickStartExperimentation = SocialExperiments.SquadQuickStartExperimentation

local ConversationListViewRecyclerItems = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationListViewRecyclerItems")
local defineFastInt = game:DefineFastInt("AppChatChatLandingInitialFetchLimit", 5)
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagFriendsChatConversationListShowScrollBar = SharedFlags.FFlagFriendsChatConversationListShowScrollBar

local defineFastInt2 = game:DefineFastInt("AppChatChatLandingInitialFetchMinimumConversations", 30)

local FFlagAppChatRemoveConversationListDividerIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatRemoveConversationListDividerIxpEnabled")

local FStringAppChatRemoveConversationListDividerIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FStringAppChatRemoveConversationListDividerIxpLayer")

local defineFastInt3 = game:DefineFastInt("AppChatPerfChatLandingPaginationOnStartReachedUnits", 1)

local defineFastInt4 = game:DefineFastInt("AppChatPerfChatLandingPaginationOnEndReachedUnits", 10)

local partyPageCarouselExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments").PartyPageCarouselExperimentation

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/Logger"):new("ConversationListViewRecycler")

local v6 = game:DefineFastInt("AppChatConversationListScrollBarIdleHideMs", 1500) / 1000
local v7 = {
	dampingRatio = 1,
	frequency = 2,
	restingVelocityLimit = 0.1,
	restingPositionLimit = 0.1
}

local function noop() end

local v8 = {
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

local function getAutoLoadNextRequestKey(list)
	local id = if list[1] ~= nil then list[1].id else nil
	local v9 = if list[#list] ~= nil then list[#list].id else nil
	return `{#list}:{tostring(id)}:{tostring(v9)}`
end

local function buildConversationItems(itemList, p2)
	local conversationItems = table.create(#itemList)

	for k, item in itemList do
		conversationItems[k] = ConversationListViewRecyclerItems.conversation(item.id, p2)
	end

	return conversationItems
end

local function concatItems(list, list2)
	local v9 = table.create(#list + #list2)
	table.move(list, 1, #list, 1, v9)
	table.move(list2, 1, #list2, #list + 1, v9)
	return v9
end

local function usePresentationSignal(p2)
	local v9 = React.useState(function()
		local signal2, v10 = Signals.createSignal(p2)
		return { get = signal2, set = v10 }
	end)

	React.useLayoutEffect(function()
		v9.set(p2)
	end, { v9, p2 })

	return v9.get
end

local function usePagination(joined, itemList)
	local ref = React.useRef(0)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(false)
	local v9 = React.useMemo(function()
		local v10 = itemList
		local id = if v10[1] ~= nil then v10[1].id else nil
		local v11 = if v10[#v10] ~= nil then v10[#v10].id else nil
		return `{#v10}:{tostring(id)}:{tostring(v11)}`
	end, { itemList })
	local v10

	if joined.loadNext == nil then
		v10 = false
	else
		v10 = not (joined.isLoadingNext or joined.oldestConversationIsFetched)
	end

	React.useEffect(function()
		if ref3.current and not joined.isLoadingNext then
			ref2.current = nil
		end

		ref3.current = joined.isLoadingNext == true
	end, { joined.isLoadingNext })

	local v11 = React.useCallback(function(): boolean
		if not v10 or ref2.current == v9 then
			return false
		end

		ref2.current = v9
		joined.loadNext()
		return true
	end, { v10, v9, joined.loadNext })

	React.useEffect(function()
		if v10 and ref.current < defineFastInt and #itemList < defineFastInt2 then
			local v12 = ref.current + 1

			if v11() then
				ref.current = v12
				v5:info(
					"Loading more conversations because the list (count: {} out of {}) is not enough (attempt {} out of {})",
					#itemList,
					defineFastInt2,
					ref.current,
					defineFastInt
				)
			end
		end
	end, { itemList, v10, v11 })

	local v12 = React.useCallback(function()
		if v11() then
			v5:debug("ViewRecycler onEndReached - Loading more conversations")
		end
	end, { v11 })

	return v10, v11, React.useCallback(function()
		if joined.loadPrevious ~= nil and not joined.isLoadingPrevious then
			v5:debug("ViewRecycler onStartReached - Loading previous conversations")
			joined.loadPrevious()
		end
	end, { joined.loadPrevious, joined.isLoadingPrevious }), v12
end

local function useUnderfillPagination(callback)
	local ref = React.useRef(0)
	local ref2 = React.useRef(0)
	local v9 = React.useCallback(function()
		if ref2.current > 0 and ref.current > 0 and ref2.current <= ref.current and callback() then
			v5:info("Loading more conversations because ViewRecycler content does not fill the viewport")
		end
	end, { callback })

	return React.useCallback(function(p2)
		ref.current = p2.Y
		v9()
	end, { v9 }), (React.useCallback(function(current)
		ref2.current = current
		v9()
	end, { v9 }))
end

local function useScrollTracking(onScrollUpdate, callback)
	local v9 = React.useMemo(function()
		return signal.new()
	end, {})
	local ref = React.useRef(nil)
	local state, setState = React.useState(nil)

	local v10 = React.useCallback(function(p2)
		if FFlagAppChatPerfTracking and ref.current then
			ref.current.onScrollTick()
		end

		if callback ~= nil then
			callback()
		end

		v9:fire()
		onScrollUpdate({ CanvasPosition = Vector2.new(0, p2) })
	end, { v9, onScrollUpdate, callback })

	local v11 = React.useCallback(function(p2)
		setState(p2)
	end, {})

	React.useEffect(function()
		local v12 = state

		if v12 == nil then
			return nil
		end

		v12.Selectable = false

		if FFlagAppChatPerfTracking then
			ref.current = createScrollIntervalTracker(AppChatPerfTracker.Events.ScrollConversationList, v12)
		end

		return function()
			if ref.current then
				ref.current.cleanup()
				ref.current = nil
			end
		end
	end, { state })

	return v9, v11, v10
end

local function useMeasuredLayout(entryHeight)
	local v9 = React.useState(function()
		return ViewRecyclerReact.Layout.measured({ estimatedItemLength = entryHeight })
	end)

	React.useEffect(function()
		return function()
			v9.destroy()
		end
	end, { v9 })

	return v9
end

local function useConversationListScrollbar(p2, scrollbarThickness, color3)
	local ref, v9, v10

	if fFlagFriendsChatConversationListShowScrollBar then
		ref = React.useRef(nil)
		v9, v10 = ReactOtter.useAnimatedBinding(1)
	else
		ref = nil
		v10 = nil
	end

	local v11

	if fFlagFriendsChatConversationListShowScrollBar then
		v11 = React.useCallback(function()
			if not p2 then
				return
			end

			if ref.current ~= nil then
				pcall(task.cancel, ref.current)
				ref.current = nil
			end

			v10(ReactOtter.instant(0))
			ref.current = task.delay(v6, function()
				ref.current = nil
				v10(ReactOtter.spring(1, v7))
			end)
		end, { p2, v10 })

		React.useEffect(function()
			return function()
				if ref.current ~= nil then
					pcall(task.cancel, ref.current)
					ref.current = nil
				end
			end
		end, {})
	end

	local v12 = fFlagFriendsChatConversationListShowScrollBar and p2
	local v13 = {
		ScrollBarThickness = v12 and (scrollbarThickness or 8) or 0,
		ScrollBarImageColor3 = nil,
		ScrollBarImageTransparency = nil
	}

	if not v12 then
		color3 = nil
	end

	v13.ScrollBarImageColor3 = color3

	if not v12 then
		v9 = nil
	end

	v13.ScrollBarImageTransparency = v9

	return v13, v11
end

local function useListData(p2, p3)
	local v9 = React.useMemo(function()
		return concatItems(p2, p3)
	end, { p2, p3 })

	return React.useMemo(function()
		return { items = v9, getItemKey = ConversationListViewRecyclerItems.getItemKey }
	end, { v9 }), v9
end

local function useCanvasBottomPadding(p2, p3, p4)
	return React.useMemo(function()
		if p3 == nil or p3 <= 0 then
			return p2
		end

		return concatItems(p2, { ConversationListViewRecyclerItems.canvasBottomPadding(p3, p4) })
	end, { p2, p3, p4 })
end

local function useLegacyListRef(listRef, p2, callback)
	local v9 = React.useMemo(function()
		if p2 then
			return { current = nil }
		end

		return nil
	end, { p2 })

	React.useLayoutEffect(function()
		if listRef == nil then
			return nil
		end

		local nativeScrollRef = v9 ~= nil and { _nativeRef = v9 } or nil
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
	end, { listRef, v9 })

	return React.useCallback(function(current)
		if v9 ~= nil then
			v9.current = current
		end

		callback(current)
	end, { v9, callback })
end

local function ConversationListViewRecycler(p2)
	local joined = Cryo.Dictionary.join(v8, p2)
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
	local v9 = useTokens()
	local v10, v11, v12, v13 = usePagination(joined, itemList)
	local v14, v15 = useUnderfillPagination(v11)
	local v16, v17 = useConversationListScrollbar(
		joined.showScrollbarOnScroll == true,
		joined.scrollbarThickness,
		v9.Color.Content.Emphasis.Color3
	)

	local v18, v19, v20 = useScrollTracking(onScrollUpdate, v17)

	React.useEffect(function()
		appChatPerfExperimentation.logExposure()

		if joined.shouldLogHeaderEntryExposures ~= false then
			partyPageCarouselExperimentation.logExposure()

			if squadQuickStartExperimentation.isLogExposureEnabled then
				squadQuickStartExperimentation.logExposure()
			end

			if FFlagAppChatRemoveConversationListDividerIxpEnabled then
				IXPService:LogFlagLinkedUserLayerExposure(FStringAppChatRemoveConversationListDividerIxpLayer)
			end
		end
	end, {})

	React.useEffect(function()
		local v21 = focusNavigationService.new(coreGui)
		return function()
			v21:teardown()
		end
	end, {})

	local canAccessParty = joined.canAccessParty == true
	local isPartyQuickStartEnabled = joined.isPartyQuickStartEnabled
	local v21 = React.useMemo(function()
		local v22 = {
			appPage = appPage.Chat,
			impressionTag = 0,
			scrollViewPositionChangedSignal = 0,
			sortId = 0,
			sortIndex = 1
		}
		local v23 = if joined.isInExperience then constants.ANALYTICS.SRC.PARTY_PAGE_IN_EXP else constants.ANALYTICS.SRC.PARTY_PAGE_UA
		v22.impressionTag = v23

		v22.scrollViewPositionChangedSignal = v18
		return v22
	end, { joined.isInExperience, v18 })

	local v22 = React.useCallback(function(p3)
		navigateToConversationFromUserId(p3.id)
	end, { navigateToConversationFromUserId })

	local v23 = React.useMemo(function()
		return {
			{
				tileGroup = enums.TileGroup.StartSquad,
				onActivated = navigateToQuickStartSquadInviteFriends
			},
			{ tileGroup = enums.TileGroup.FriendsList, onActivated = v22 }
		}
	end, { navigateToQuickStartSquadInviteFriends, v22 })

	local v25 = usePresentationSignal(React.useMemo(function()
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

	local v26 = joined.filterText == "" or joined.filterText == nil
	local v27 = showHeaderEntries and v26
	local partyPageCarouselEnabled = partyPageCarouselExperimentation.getPartyPageCarouselEnabled()
	local v28 = React.useMemo(function()
		local v29 = {}

		if fFlagAppIaScrollAway and joined.canvasTopPadding ~= nil and joined.canvasTopPadding > 0 then
			table.insert(v29, ConversationListViewRecyclerItems.canvasTopPadding(joined.canvasTopPadding, v9.Color.None))
		end

		if not v27 then
			return v29
		end

		table.insert(v29, ConversationListViewRecyclerItems.chatLandingModal())

		if
			isPartyQuickStartEnabled
			and partyPageCarouselEnabled
			and (joined.isWideMode or not joined.isInExperience)
		then
			table.insert(v29, ConversationListViewRecyclerItems.socialCarousel(v23, joined.isInExperience, v21))
		elseif isPartyQuickStartEnabled and not partyPageCarouselEnabled then
			table.insert(v29, ConversationListViewRecyclerItems.quickStart(entryHeight))
		end

		if joined.showGroupsLink == true then
			table.insert(v29, ConversationListViewRecyclerItems.groupLink(entryHeight))
		end

		return v29
	end, {
		v27,
		isPartyQuickStartEnabled,
		partyPageCarouselEnabled,
		joined.isWideMode,
		joined.isInExperience,
		joined.showGroupsLink,
		joined.canvasTopPadding,
		v9.Color.None,
		v23,
		v21,
		entryHeight
	})

	local v29 = React.useMemo(function()
		return buildConversationItems(itemList, v25)
	end, { itemList, v25 })
	local v30

	if FFlagAppChatConversationListViewRecyclerConsoleProps then
		local canvasBottomPadding = joined.canvasBottomPadding
		local none = v9.Color.None
		v30 = React.useMemo(function()
			if canvasBottomPadding == nil or canvasBottomPadding <= 0 then
				return v29
			end

			return concatItems(v29, { ConversationListViewRecyclerItems.canvasBottomPadding(canvasBottomPadding, none) })
		end, { v29, canvasBottomPadding, none })
	else
		v30 = v29
	end

	local v31, v32 = useListData(v28, v30)

	if FFlagAppChatConversationListViewRecyclerConsoleProps then
		v19 = useLegacyListRef(joined.listRef, #v32 > 0, v19)
	end

	local v33 = useMeasuredLayout(entryHeight)

	if #v32 == 0 then
		return React.createElement(view, {
			Size = size,
			backgroundStyle = v9.Color.None,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder
		})
	end

	local createElement = React.createElement
	local v35 = {
		Size = size,
		backgroundStyle = v9.Color.None,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder
	}

	local createElement2 = React.createElement
	local virtualList = ViewRecyclerReact.VirtualList
	local v37 = {
		data = v31,
		layout = v33,
		overscan = 2,
		axis = ViewRecyclerReact.Axis.Y,
		itemType = ConversationListViewRecyclerItems.getItemType,
		scrollingFrameRef = v19,
		onViewportChanged = v14,
		onContentLengthChanged = v15,
		onScrollOffsetChanged = v20,
		onStartReached = 0,
		onEndReached = 0,
		startReachedThreshold = 0,
		endReachedThreshold = 0,
		autoScrollOnChange = 0,
		autoScrollThreshold = 33,
		scrollingFrameProps = 0
	}

	if joined.loadPrevious == nil or joined.isLoadingPrevious then
		v12 = nil
	end

	v37.onStartReached = v12

	if not v10 then
		v13 = nil
	end

	v37.onEndReached = v13
	v37.startReachedThreshold = entryHeight * defineFastInt3
	v37.endReachedThreshold = entryHeight * defineFastInt4
	v37.autoScrollOnChange = ViewRecyclerReact.AutoScrollPolicy.WhenAtStart

	local rctScrollView = {
		Name = "RCTScrollView",
		BackgroundTransparency = 1,
		ScrollBarThickness = v16.ScrollBarThickness,
		ScrollBarImageColor3 = v16.ScrollBarImageColor3,
		ScrollBarImageTransparency = v16.ScrollBarImageTransparency,
		BorderSizePixel = 0,
		ScrollingEnabled = 0
	}

	local v38 = if FFlagAppChatConversationListViewRecyclerConsoleProps then joined.scrollEnabled ~= false else nil
	rctScrollView.ScrollingEnabled = v38
	v37.scrollingFrameProps = rctScrollView
	return createElement(view, v35, {
		List = createElement2(virtualList, v37)
	})
end

return React.memo(ConversationListViewRecycler)
