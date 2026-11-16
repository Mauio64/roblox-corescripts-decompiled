local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")
local useSelector = dependencies.Hooks.useSelector
local networkingPresence = dependencies.NetworkingPresence
local recommendationContextType = dependencies.RoduxFriends.Enums.RecommendationContextType

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/React")
local SocialStopwatch = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SocialStopwatch")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/tutils")
local useCollectionImpressionsSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/CollectionViews").useCollectionImpressionsSignal
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/ReactFocusNavigation")
local focusNavigationEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/FocusNavigationUtils").FocusNavigationEventNameEnum
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/InputHandlers")
local useThrottledCallback = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/RoactUtils").Hooks.useThrottledCallback
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/Dash")

local Impressions = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/Impressions")
local screenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local frameBoundsImpressionsTracker = Impressions.FrameBoundsImpressionsTracker

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/RoactUtils").Hooks.RoactRodux.useDispatch

local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics")
local btnValues = Analytics.BtnValues
local eventNames = Analytics.EventNames
local useUserSeenEvent = Analytics.useUserSeenEvent
local useUserSeenCollectionEvent = Analytics.useUserSeenCollectionEvent
require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/AnalyticsTypes")

local UserList = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/UserList")
local horizontalUserList = UserList.HorizontalUserList.HorizontalUserList
local contactsContext = UserList.ContactsContext

local usePYMKCarouselItemList = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Components/PYMKCarouselComponent/usePYMKCarouselItemList")
local getPYMKSortedRecommendationIds = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/installReducer/Selectors/getPYMKSortedRecommendationIds")
local useCallbackWhenVisible = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Components/useCallbackWhenVisible")

local usePYMKCarouselUserEntitiesList = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Components/PYMKCarouselComponent/usePYMKCarouselUserEntitiesList")
local useContactsContext = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Components/PYMKCarouselComponent/useContactsContext")
local PYMKUser = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Components/PYMKUser")
require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/DirectRecommendationTypes")

local fFlagLuaAppUseFrameBoundsImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SharedFlags").FFlagLuaAppUseFrameBoundsImpressions
local FFlagPymkCarouselPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Flags/FFlagPymkCarouselPresenceStoreMigration")
local FFlagPYMKCarouselStableSelectors = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Flags/FFlagPYMKCarouselStableSelectors")
local fFlagLuaAppPYMKSendUserSeenCollection = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SharedFlags").FFlagLuaAppPYMKSendUserSeenCollection

local fFlagLuaAppUserSeenCollectionUnifiedFields = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SharedFlags").FFlagLuaAppUserSeenCollectionUnifiedFields
local fFlagLuaAppEnableSduiHomePage = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SharedFlags").FFlagLuaAppEnableSduiHomePage

local count = 0

local seeAllsByButtonX = {
	[Enum.KeyCode.ButtonX] = focusNavigationEventNameEnum.SeeAll
}

local defineFastInt = game:DefineFastInt("HomePagePYMKPresenceFetchThrottleInterval", 60)

local function buildDirectRecommendationOverrides(recommendations)
	local v5 = {}
	local v6 = {}

	for k, item in recommendations do
		local v7 = recommendationContextType.fromRawValue(item.contextType)
			or recommendationContextType.None
		local v8 = {
			id = item.id,
			rank = item.rank,
			contextType = v7,
			mutualFriendsCount = item.mutualFriendsCount,
			hasIncomingFriendRequest = item.hasIncomingFriendRequest,
			entityDisplayName = item.entityDisplayName,
			thumbnailEntities = item.thumbnailEntities,
			absolutePosition = k,
			recommendationRank = item.rank,
			recommendationContextType = v7
		}

		table.insert(v5, v8)
		v6[item.id] = v8
	end

	return { recommendationIds = v5, recommendationsById = v6 }
end

local function PYMKCollectionCarousel(props)
	local ref = React.useRef(nil)

	local v5, v6 = useCollectionImpressionsSignal(props.scrollViewPositionChangedSignal)

	local recommendationsById = nil
	local v7

	if fFlagLuaAppEnableSduiHomePage then
		local v8 = React.useMemo(function()
			return buildDirectRecommendationOverrides(props.recommendations or {})
		end, { props.recommendations })

		v7 = v8.recommendationIds

		recommendationsById = v8.recommendationsById
	else
		local function fn(p2)
			return getPYMKSortedRecommendationIds(p2.LocalUserId)(p2)
		end
		local v9 = if FFlagPYMKCarouselStableSelectors then tutils.deepEqual else tutils.shallowEqual
		v7 = useSelector(fn, v9)
	end

	local v8 = v7 and #v7 or 0
	local recommendationSessionId = props.recommendationSessionId
	local fireAnalyticsEvent = props.fireAnalyticsEvent

	local v9 = usePYMKCarouselItemList({
		recommendationIds = v7,
		recommendationCount = v8,
		findFriendsTileEnabled = props.findFriendsTileEnabled,
		seeAllTileEnabled = props.seeAllTileEnabled
	})
	local v10

	if fFlagLuaAppPYMKSendUserSeenCollection then
		v10 = React.useMemo(function()
			return Dash.filter(v9, function(p2): boolean
				return not (p2.isButtonTile or p2.isTooltip)
			end)
		end, { v9 })
	else
		v10 = nil
	end

	React.useLayoutEffect(function()
		SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.PYMKCarouselLoaded)
		return function()
			if SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.PYMKCarouselLoaded) then
				SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.PYMKCarouselLoaded)
			end
		end
	end, { recommendationSessionId })

	local state, setState = React.useState(os.clock())
	local state2 = nil
	local setState2 = nil

	if FFlagPymkCarouselPresenceStoreMigration then
		state2, setState2 = React.useState(0)

		local v11 = useThrottledCallback(function()
			setState2(state2 + 1)
		end, defineFastInt)

		useCallbackWhenVisible({
			elementRef = ref,
			scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
			callback = v11
		})
	else
		local v11 = useDispatch()
		local v13 = useThrottledCallback(React.useCallback(function()
			local reduced = Dash.reduce(v7, function(ids, p2)
				if p2.recommendationContextType ~= recommendationContextType.Contacts then
					table.insert(ids, p2.id)
				end

				return ids
			end, {})

			if #reduced > 0 then
				v11(networkingPresence.GetPresencesFromUserIds.API(reduced))
				fireAnalyticsEvent(eventNames.PYMKUserPresenceLoad)
			end
		end, { v11, v7, fireAnalyticsEvent }), defineFastInt)
		useCallbackWhenVisible({
			elementRef = ref,
			scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
			callback = v13
		})
	end

	React.useEffect(function()
		fireAnalyticsEvent(eventNames.CarouselLoadedWithUsers, {
			recommendationCount = v8,
			refreshCount = count,
			findFriendsTileEnabled = props.findFriendsTileEnabled
		})

		count += 1
		setState(os.clock())
	end, { recommendationSessionId, v8 })

	local v11 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.CarouselGenericTileClicked, {
			btn = btnValues.SeeAll.rawValue()
		})
		props.goToAddFriendsPage(false)
	end, { props.goToAddFriendsPage, fireAnalyticsEvent })

	local v12 = useUserSeenEvent(fireAnalyticsEvent)
	local v13

	if fFlagLuaAppPYMKSendUserSeenCollection then
		if fFlagLuaAppUserSeenCollectionUnifiedFields then
			local v16 = if props.sortAnalyticsData then props.sortAnalyticsData.sortId else nil
			local v17 = if props.sortAnalyticsData then props.sortAnalyticsData.sortIndex else nil
			local v18 = if props.sortAnalyticsData then props.sortAnalyticsData.startRow else nil
			v13 = useUserSeenCollectionEvent(fireAnalyticsEvent, {
				collectionId = v16,
				collectionPosition = v17,
				feedRowNumber = v18,
				totalNumberOfItems = v8
			})
		else
			v13 = useUserSeenCollectionEvent(fireAnalyticsEvent)
		end
	else
		v13 = nil
	end

	local useCallback = React.useCallback
	local function fn(items)
		local v14 = {}

		for k, item in items do
			if fFlagLuaAppPYMKSendUserSeenCollection then
				local v15 = v10[item]

				if v15 and v15.id then
					v13.addTileToCollection(v15.id, item, v15)
				end
			end

			table.insert(v14, { item = v9[item] })
		end

		if #v12 > 0 then
			v12[1].onViewableItemsChanged({ changed = v14 })
		end
	end

	local v15 = if fFlagLuaAppPYMKSendUserSeenCollection then v10 else nil
	local v17 = useCallback(fn, {
		v12,
		v9,
		v15,
		if fFlagLuaAppPYMKSendUserSeenCollection then v13 else nil
	})

	local v18 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.SeeAll] = { handler = InputHandlers.onRelease(v11) }
		}
	end, { v11 })

	local v19 = ReactFocusNavigation.useEventMap(seeAllsByButtonX)

	local v20 = ReactFocusNavigation.useEventHandlerMap(v18, v19)

	React.useEffect(function()
		if v20 and ref then
			v20(ref.current)
		end

		return function()
			v20(nil)
		end
	end, { v20, ref, ref and ref.current })

	local v21 = usePYMKCarouselUserEntitiesList(v9)
	local v23 = if fFlagLuaAppEnableSduiHomePage then recommendationsById else nil
	local v24 = useContactsContext(v9, v23)

	local useCallback2 = React.useCallback
	local function fn2(p2, p3, p4)
		local createElement = React.createElement
		local v26 = {
			createRow = p2,
			entity = p3,
			showToast = props.showToast,
			fireAnalyticsEvent = fireAnalyticsEvent,
			absolutePosition = p4,
			recommendationSessionId = props.recommendationSessionId,
			openProfilePeekView = props.openProfilePeekView,
			impressionsTag = "PYMKCollectionCarousel",
			forceFetchUserPresence = if FFlagPymkCarouselPresenceStoreMigration then state2 else nil,
			recommendation = 0
		}

		local v28 = if fFlagLuaAppEnableSduiHomePage and recommendationsById then recommendationsById[tostring(p3.id)] else nil
		v26.recommendation = v28
		return createElement(PYMKUser, v26)
	end

	local showToast = props.showToast

	local recommendationSessionId2 = props.recommendationSessionId
	local openProfilePeekView = props.openProfilePeekView
	local v26 = if FFlagPymkCarouselPresenceStoreMigration then state2 else nil
	local v28 = useCallback2(fn2, {
		showToast,
		fireAnalyticsEvent,
		recommendationSessionId2,
		openProfilePeekView,
		v26,
		if fFlagLuaAppEnableSduiHomePage then recommendationsById else nil
	})

	if #v9 == 0 then
		return nil
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v30 = {
		ContactsContextProvider = React.createElement(contactsContext.Provider, {
			value = v24
		}, {
			PYMKCarousel = React.createElement(horizontalUserList, {
				entities = v21,
				renderRow = v28,
				header = { title = props.carouselTitle, onTitleActivated = v11 },
				collectionCarouselConfigs = {
					onViewableItemsChanged = v6,
					onChangeCanvasPosition = v6
				},
				listConfigs = { showSubtitle = false },
				scrollingFrameRef = ref,
				appCompositionEnabled = props.appCompositionEnabled
			})
		}),
		ScreenSizeImpressionsTracker = 0
	}

	local createElement2 = React.createElement
	local v31

	if fFlagLuaAppUseFrameBoundsImpressions then
		v31 = frameBoundsImpressionsTracker
	else
		v31 = screenSizeImpressionsTracker
	end

	v30.ScreenSizeImpressionsTracker = createElement2(v31, {
		pageContext = props.pageContext,
		parentRef = ref,
		impressionsTag = "PYMKCollectionCarousel",
		scrollViewPositionChangedSignal = v5,
		sendImpressions = v17,
		dataUpdatedTimestamp = state
	})
	return createElement(fragment, nil, v30)
end

return React.memo(PYMKCollectionCarousel)
