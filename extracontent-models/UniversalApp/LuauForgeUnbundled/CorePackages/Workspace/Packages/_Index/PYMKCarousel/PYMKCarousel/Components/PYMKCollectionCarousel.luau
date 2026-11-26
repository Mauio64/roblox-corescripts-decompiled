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
local fFlagPymkCarouselExtendProps = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SharedFlags").FFlagPymkCarouselExtendProps

local HttpService = if fFlagPymkCarouselExtendProps then game:GetService("HttpService") else nil

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

	local v5 = not fFlagPymkCarouselExtendProps and "PYMKCollectionCarousel" or React.useMemo(function()
		return `PYMKCollectionCarousel{HttpService:GenerateGUID(false)}`
	end, {})

	local v6, v7 = useCollectionImpressionsSignal(props.scrollViewPositionChangedSignal)

	local recommendationsById = nil
	local v8

	if fFlagLuaAppEnableSduiHomePage then
		local v9 = React.useMemo(function()
			return buildDirectRecommendationOverrides(props.recommendations or {})
		end, { props.recommendations })

		v8 = v9.recommendationIds

		recommendationsById = v9.recommendationsById
	elseif fFlagPymkCarouselExtendProps then
		local function fn(p2)
			return getPYMKSortedRecommendationIds(p2.LocalUserId)(p2)
		end
		local v10 = if FFlagPYMKCarouselStableSelectors then tutils.deepEqual else tutils.shallowEqual
		v8 = useSelector(fn, v10)

		local v11 = React.useMemo(function()
			return buildDirectRecommendationOverrides(props.recommendations or {})
		end, { props.recommendations })

		if props.recommendations then
			v8 = v11.recommendationIds
			recommendationsById = v11.recommendationsById
		end
	else
		local function fn(p2)
			return getPYMKSortedRecommendationIds(p2.LocalUserId)(p2)
		end
		local v10 = if FFlagPYMKCarouselStableSelectors then tutils.deepEqual else tutils.shallowEqual
		v8 = useSelector(fn, v10)
	end

	local v9 = v8 and #v8 or 0
	local recommendationSessionId = props.recommendationSessionId
	local fireAnalyticsEvent = props.fireAnalyticsEvent

	local v10 = usePYMKCarouselItemList({
		recommendationIds = v8,
		recommendationCount = v9,
		findFriendsTileEnabled = props.findFriendsTileEnabled,
		seeAllTileEnabled = props.seeAllTileEnabled
	})
	local v11

	if fFlagLuaAppPYMKSendUserSeenCollection then
		v11 = React.useMemo(function()
			return Dash.filter(v10, function(p2): boolean
				return not (p2.isButtonTile or p2.isTooltip)
			end)
		end, { v10 })
	else
		v11 = nil
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

		local v12 = useThrottledCallback(function()
			setState2(state2 + 1)
		end, defineFastInt)

		useCallbackWhenVisible({
			elementRef = ref,
			scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
			callback = v12
		})
	else
		local v12 = useDispatch()
		local v14 = useThrottledCallback(React.useCallback(function()
			local reduced = Dash.reduce(v8, function(ids, p2)
				if p2.recommendationContextType ~= recommendationContextType.Contacts then
					table.insert(ids, p2.id)
				end

				return ids
			end, {})

			if #reduced > 0 then
				v12(networkingPresence.GetPresencesFromUserIds.API(reduced))
				fireAnalyticsEvent(eventNames.PYMKUserPresenceLoad)
			end
		end, { v12, v8, fireAnalyticsEvent }), defineFastInt)
		useCallbackWhenVisible({
			elementRef = ref,
			scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
			callback = v14
		})
	end

	React.useEffect(function()
		fireAnalyticsEvent(eventNames.CarouselLoadedWithUsers, {
			recommendationCount = v9,
			refreshCount = count,
			findFriendsTileEnabled = props.findFriendsTileEnabled
		})

		count += 1
		setState(os.clock())
	end, { recommendationSessionId, v9 })

	if fFlagPymkCarouselExtendProps then
		local v12 = v9 > 0
		React.useEffect(function()
			if v12 and props.onRecommendationsShown then
				props.onRecommendationsShown()
			end
		end, { v12, props.onRecommendationsShown })
	end

	local v12 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.CarouselGenericTileClicked, {
			btn = btnValues.SeeAll.rawValue()
		})
		props.goToAddFriendsPage(false)
	end, { props.goToAddFriendsPage, fireAnalyticsEvent })

	local v13 = useUserSeenEvent(fireAnalyticsEvent)
	local v14

	if fFlagLuaAppPYMKSendUserSeenCollection then
		if fFlagLuaAppUserSeenCollectionUnifiedFields then
			local v17 = if props.sortAnalyticsData then props.sortAnalyticsData.sortId else nil
			local v18 = if props.sortAnalyticsData then props.sortAnalyticsData.sortIndex else nil
			local v19 = if props.sortAnalyticsData then props.sortAnalyticsData.startRow else nil
			v14 = useUserSeenCollectionEvent(fireAnalyticsEvent, {
				collectionId = v17,
				collectionPosition = v18,
				feedRowNumber = v19,
				totalNumberOfItems = v9
			})
		else
			v14 = useUserSeenCollectionEvent(fireAnalyticsEvent)
		end
	else
		v14 = nil
	end

	local useCallback = React.useCallback
	local function fn(items)
		local v15 = {}

		for k, item in items do
			if fFlagLuaAppPYMKSendUserSeenCollection then
				local v16 = v11[item]

				if v16 and v16.id then
					v14.addTileToCollection(v16.id, item, v16)
				end
			end

			table.insert(v15, { item = v10[item] })
		end

		if #v13 > 0 then
			v13[1].onViewableItemsChanged({ changed = v15 })
		end
	end

	local v16 = if fFlagLuaAppPYMKSendUserSeenCollection then v11 else nil
	local v18 = useCallback(fn, {
		v13,
		v10,
		v16,
		if fFlagLuaAppPYMKSendUserSeenCollection then v14 else nil
	})

	local v19 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.SeeAll] = { handler = InputHandlers.onRelease(v12) }
		}
	end, { v12 })

	local v20 = ReactFocusNavigation.useEventMap(seeAllsByButtonX)

	local v21 = ReactFocusNavigation.useEventHandlerMap(v19, v20)

	React.useEffect(function()
		if v21 and ref then
			v21(ref.current)
		end

		return function()
			v21(nil)
		end
	end, { v21, ref, ref and ref.current })

	local v22 = usePYMKCarouselUserEntitiesList(v10)
	local v24

	if fFlagPymkCarouselExtendProps or fFlagLuaAppEnableSduiHomePage then
		v24 = recommendationsById
	end

	local v25 = useContactsContext(v10, v24)

	local useCallback2 = React.useCallback
	local function fn2(p2, p3, p4)
		local createElement = React.createElement
		local v27 = {
			createRow = p2,
			entity = p3,
			showToast = props.showToast,
			fireAnalyticsEvent = fireAnalyticsEvent,
			absolutePosition = p4,
			recommendationSessionId = props.recommendationSessionId,
			openProfilePeekView = props.openProfilePeekView,
			impressionsTag = v5,
			forceFetchUserPresence = if FFlagPymkCarouselPresenceStoreMigration then state2 else nil,
			recommendation = 0,
			analyticsSurface = 0
		}

		local v29 = if (fFlagPymkCarouselExtendProps or fFlagLuaAppEnableSduiHomePage) and recommendationsById then recommendationsById[tostring(p3.id)] else nil
		v27.recommendation = v29

		local v30 = if fFlagPymkCarouselExtendProps then props.analyticsSurface else nil
		v27.analyticsSurface = v30
		return createElement(PYMKUser, v27)
	end

	local showToast = props.showToast

	local recommendationSessionId2 = props.recommendationSessionId
	local openProfilePeekView = props.openProfilePeekView
	local v27 = if FFlagPymkCarouselPresenceStoreMigration then state2 else nil
	local v28

	if fFlagPymkCarouselExtendProps or fFlagLuaAppEnableSduiHomePage then
		v28 = recommendationsById
	end

	local analyticsSurface = if fFlagPymkCarouselExtendProps then props.analyticsSurface else nil
	local v30 = useCallback2(fn2, {
		showToast,
		fireAnalyticsEvent,
		recommendationSessionId2,
		openProfilePeekView,
		v27,
		v28,
		analyticsSurface,
		if fFlagPymkCarouselExtendProps then v5 else nil
	})

	if #v10 == 0 then
		return nil
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v32 = {
		ContactsContextProvider = React.createElement(contactsContext.Provider, {
			value = v25
		}, {
			PYMKCarousel = React.createElement(horizontalUserList, {
				entities = v22,
				renderRow = v30,
				header = { title = props.carouselTitle, onTitleActivated = v12 },
				collectionCarouselConfigs = {
					onViewableItemsChanged = v7,
					onChangeCanvasPosition = v7
				},
				listConfigs = { showSubtitle = false },
				scrollingFrameRef = ref,
				appCompositionEnabled = props.appCompositionEnabled
			})
		}),
		ScreenSizeImpressionsTracker = 0
	}

	local createElement2 = React.createElement
	local v33

	if fFlagLuaAppUseFrameBoundsImpressions then
		v33 = frameBoundsImpressionsTracker
	else
		v33 = screenSizeImpressionsTracker
	end

	v32.ScreenSizeImpressionsTracker = createElement2(v33, {
		pageContext = props.pageContext,
		parentRef = ref,
		impressionsTag = v5,
		scrollViewPositionChangedSignal = v6,
		sendImpressions = v18,
		dataUpdatedTimestamp = state
	})
	return createElement(fragment, nil, v32)
end

return React.memo(PYMKCollectionCarousel)
