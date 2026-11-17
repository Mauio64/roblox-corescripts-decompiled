local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")

local dependencies = require(PYMKCarousel.dependencies)
local useSelector = dependencies.Hooks.useSelector
local networkingPresence = dependencies.NetworkingPresence
local recommendationContextType = dependencies.RoduxFriends.Enums.RecommendationContextType

local parent = PYMKCarousel.Parent

local React = require(parent.React)
local SocialStopwatch = require(parent.SocialStopwatch)
local tutils = require(parent.tutils)
local CollectionViews = require(parent.CollectionViews)
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(parent.InputHandlers)
local RoactUtils = require(parent.RoactUtils)
local useThrottledCallback = RoactUtils.Hooks.useThrottledCallback
local Dash = require(parent.Dash)

local Impressions = require(parent.Impressions)
local ScreenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local FrameBoundsImpressionsTracker = Impressions.FrameBoundsImpressionsTracker

local RoactUtils2 = require(parent.RoactUtils)
local useDispatch = RoactUtils2.Hooks.RoactRodux.useDispatch

local Analytics = require(PYMKCarousel.Analytics)
local BtnValues = Analytics.BtnValues
local EventNames = Analytics.EventNames
local useUserSeenEvent = Analytics.useUserSeenEvent
local useUserSeenCollectionEvent = Analytics.useUserSeenCollectionEvent
require(PYMKCarousel.Analytics.AnalyticsTypes)

local UserList = require(parent.UserList)
local HorizontalUserList = UserList.HorizontalUserList.HorizontalUserList
local ContactsContext = UserList.ContactsContext

local usePYMKCarouselItemList = require(PYMKCarousel.Components.PYMKCarouselComponent.usePYMKCarouselItemList)
local getPYMKSortedRecommendationIds = require(PYMKCarousel.installReducer.Selectors.getPYMKSortedRecommendationIds)
local useCallbackWhenVisible = require(PYMKCarousel.Components.useCallbackWhenVisible)

local usePYMKCarouselUserEntitiesList = require(PYMKCarousel.Components.PYMKCarouselComponent.usePYMKCarouselUserEntitiesList)
local useContactsContext = require(PYMKCarousel.Components.PYMKCarouselComponent.useContactsContext)
local PYMKUser = require(PYMKCarousel.Components.PYMKUser)
require(PYMKCarousel.Common.DirectRecommendationTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppUseFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseFrameBoundsImpressions
local FFlagPymkCarouselPresenceStoreMigration = require(PYMKCarousel.Flags.FFlagPymkCarouselPresenceStoreMigration)
local FFlagPYMKCarouselStableSelectors = require(PYMKCarousel.Flags.FFlagPYMKCarouselStableSelectors)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppPYMKSendUserSeenCollection = SharedFlags2.FFlagLuaAppPYMKSendUserSeenCollection

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppUserSeenCollectionUnifiedFields = SharedFlags3.FFlagLuaAppUserSeenCollectionUnifiedFields
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppEnableSduiHomePage = SharedFlags4.FFlagLuaAppEnableSduiHomePage
local SharedFlags5 = require(parent.SharedFlags)
local FFlagPymkCarouselExtendProps = SharedFlags5.FFlagPymkCarouselExtendProps
local HttpService

if FFlagPymkCarouselExtendProps then
	HttpService = game:GetService("HttpService")
else
	HttpService = nil
end

local count = 0

local seeAllsByButtonX = { [Enum.KeyCode.ButtonX] = FocusNavigationEventNameEnum.SeeAll }

local defineFastInt = game:DefineFastInt("HomePagePYMKPresenceFetchThrottleInterval", 60)

local function buildDirectRecommendationOverrides(recommendations)
	local recommendationIds = {}
	local recommendationsById = {}

	for k, item in recommendations do
		local v = recommendationContextType.fromRawValue(item.contextType) or recommendationContextType.None
		local v2 = {
			id = item.id,
			rank = item.rank,
			contextType = v,
			mutualFriendsCount = item.mutualFriendsCount,
			hasIncomingFriendRequest = item.hasIncomingFriendRequest,
			entityDisplayName = item.entityDisplayName,
			thumbnailEntities = item.thumbnailEntities,
			absolutePosition = k,
			recommendationRank = item.rank,
			recommendationContextType = v
		}

		table.insert(recommendationIds, v2)
		recommendationsById[item.id] = v2
	end

	return { recommendationIds = recommendationIds, recommendationsById = recommendationsById }
end

local function PYMKCollectionCarousel(props)
	local ref = React.useRef(nil)

	local impressionsTag = not FFlagPymkCarouselExtendProps and "PYMKCollectionCarousel" or React.useMemo(function()
		return `PYMKCollectionCarousel{HttpService:GenerateGUID(false)}`
	end, {})

	local scrollViewPositionChangedSignal, v = useCollectionImpressionsSignal(props.scrollViewPositionChangedSignal)

	local recommendationsById = nil
	local recommendationIds

	if FFlagLuaAppEnableSduiHomePage then
		local v2 = React.useMemo(function()
			return buildDirectRecommendationOverrides(props.recommendations or {})
		end, { props.recommendations })

		recommendationIds = v2.recommendationIds

		recommendationsById = v2.recommendationsById
	elseif FFlagPymkCarouselExtendProps then
		local function fn(p)
			return getPYMKSortedRecommendationIds(p.LocalUserId)(p)
		end

		local v2

		if FFlagPYMKCarouselStableSelectors then
			v2 = tutils.deepEqual
		else
			v2 = tutils.shallowEqual
		end

		recommendationIds = useSelector(fn, v2)

		local v3 = React.useMemo(function()
			return buildDirectRecommendationOverrides(props.recommendations or {})
		end, { props.recommendations })

		if props.recommendations then
			recommendationIds = v3.recommendationIds
			recommendationsById = v3.recommendationsById
		end
	else
		local function fn(p)
			return getPYMKSortedRecommendationIds(p.LocalUserId)(p)
		end

		local v2

		if FFlagPYMKCarouselStableSelectors then
			v2 = tutils.deepEqual
		else
			v2 = tutils.shallowEqual
		end

		recommendationIds = useSelector(fn, v2)
	end

	local v2 = recommendationIds and #recommendationIds or 0
	local recommendationSessionId = props.recommendationSessionId
	local fireAnalyticsEvent = props.fireAnalyticsEvent

	local v3 = usePYMKCarouselItemList({
		recommendationIds = recommendationIds,
		recommendationCount = v2,
		findFriendsTileEnabled = props.findFriendsTileEnabled,
		seeAllTileEnabled = props.seeAllTileEnabled
	})
	local v4

	if FFlagLuaAppPYMKSendUserSeenCollection then
		v4 = React.useMemo(function()
			return Dash.filter(v3, function(p): boolean
				return not (p.isButtonTile or p.isTooltip)
			end)
		end, { v3 })
	else
		v4 = nil
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

		local callback = useThrottledCallback(function()
			setState2(state2 + 1)
		end, defineFastInt)

		useCallbackWhenVisible({
			elementRef = ref,
			scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
			callback = callback
		})
	else
		local v5 = useDispatch()
		local callback = useThrottledCallback(React.useCallback(function()
			local reduced = Dash.reduce(recommendationIds, function(ids, p)
				if p.recommendationContextType ~= recommendationContextType.Contacts then
					table.insert(ids, p.id)
				end

				return ids
			end, {})

			if #reduced > 0 then
				v5(networkingPresence.GetPresencesFromUserIds.API(reduced))
				fireAnalyticsEvent(EventNames.PYMKUserPresenceLoad)
			end
		end, { v5, recommendationIds, fireAnalyticsEvent }), defineFastInt)
		useCallbackWhenVisible({
			elementRef = ref,
			scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
			callback = callback
		})
	end

	React.useEffect(function()
		fireAnalyticsEvent(EventNames.CarouselLoadedWithUsers, {
			recommendationCount = v2,
			refreshCount = count,
			findFriendsTileEnabled = props.findFriendsTileEnabled
		})

		count += 1
		setState(os.clock())
	end, { recommendationSessionId, v2 })

	if FFlagPymkCarouselExtendProps then
		local v5 = v2 > 0
		React.useEffect(function()
			if v5 and props.onRecommendationsShown then
				props.onRecommendationsShown()
			end
		end, { v5, props.onRecommendationsShown })
	end

	local onTitleActivated = React.useCallback(function()
		fireAnalyticsEvent(EventNames.CarouselGenericTileClicked, {
			btn = BtnValues.SeeAll.rawValue()
		})
		props.goToAddFriendsPage(false)
	end, { props.goToAddFriendsPage, fireAnalyticsEvent })

	local v5 = useUserSeenEvent(fireAnalyticsEvent)
	local v6

	if FFlagLuaAppPYMKSendUserSeenCollection then
		if FFlagLuaAppUserSeenCollectionUnifiedFields then
			local collectionId

			if props.sortAnalyticsData then
				collectionId = props.sortAnalyticsData.sortId
			end

			local collectionPosition

			if props.sortAnalyticsData then
				collectionPosition = props.sortAnalyticsData.sortIndex
			end

			local feedRowNumber

			if props.sortAnalyticsData then
				feedRowNumber = props.sortAnalyticsData.startRow
			end

			v6 = useUserSeenCollectionEvent(fireAnalyticsEvent, {
				collectionId = collectionId,
				collectionPosition = collectionPosition,
				feedRowNumber = feedRowNumber,
				totalNumberOfItems = v2
			})
		else
			v6 = useUserSeenCollectionEvent(fireAnalyticsEvent)
		end
	else
		v6 = nil
	end

	local useCallback = React.useCallback
	local function fn(items)
		local changed = {}

		for _, item in items do
			if FFlagLuaAppPYMKSendUserSeenCollection then
				local v7 = v4[item]

				if v7 and v7.id then
					v6.addTileToCollection(v7.id, item, v7)
				end
			end

			table.insert(changed, { item = v3[item] })
		end

		if #v5 > 0 then
			v5[1].onViewableItemsChanged({ changed = changed })
		end
	end

	local v7

	if FFlagLuaAppPYMKSendUserSeenCollection then
		v7 = v4
	end

	local v8

	if FFlagLuaAppPYMKSendUserSeenCollection then
		v8 = v6
	end

	local sendImpressions = useCallback(fn, { v5, v3, v7, v8 })

	local v9 = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.SeeAll] = {
				handler = InputHandlers.onRelease(onTitleActivated)
			}
		}
	end, { onTitleActivated })

	local v10 = ReactFocusNavigation.useEventMap(seeAllsByButtonX)

	local v11 = ReactFocusNavigation.useEventHandlerMap(v9, v10)

	React.useEffect(function()
		if v11 and ref then
			v11(ref.current)
		end

		return function()
			v11(nil)
		end
	end, { v11, ref, ref and ref.current })

	local entities = usePYMKCarouselUserEntitiesList(v3)
	local v12

	if FFlagPymkCarouselExtendProps or FFlagLuaAppEnableSduiHomePage then
		v12 = recommendationsById
	end

	local v13 = useContactsContext(v3, v12)

	local useCallback2 = React.useCallback
	local function fn2(createRow, entity, absolutePosition)
		local createElement = React.createElement
		local v14 = {
			createRow = createRow,
			entity = entity,
			showToast = props.showToast,
			fireAnalyticsEvent = fireAnalyticsEvent,
			absolutePosition = absolutePosition,
			recommendationSessionId = props.recommendationSessionId,
			openProfilePeekView = props.openProfilePeekView,
			impressionsTag = impressionsTag,
			forceFetchUserPresence = 0,
			recommendation = 0,
			analyticsSurface = 0
		}
		local forceFetchUserPresence

		if FFlagPymkCarouselPresenceStoreMigration then
			forceFetchUserPresence = state2
		end

		v14.forceFetchUserPresence = forceFetchUserPresence
		local recommendation

		if (FFlagPymkCarouselExtendProps or FFlagLuaAppEnableSduiHomePage) and recommendationsById then
			recommendation = recommendationsById[tostring(entity.id)]
		end

		v14.recommendation = recommendation
		local analyticsSurface

		if FFlagPymkCarouselExtendProps then
			analyticsSurface = props.analyticsSurface
		end

		v14.analyticsSurface = analyticsSurface
		return createElement(PYMKUser, v14)
	end

	local showToast = props.showToast

	local recommendationSessionId2 = props.recommendationSessionId
	local openProfilePeekView = props.openProfilePeekView
	local v14

	if FFlagPymkCarouselPresenceStoreMigration then
		v14 = state2
	end

	local v15

	if FFlagPymkCarouselExtendProps or FFlagLuaAppEnableSduiHomePage then
		v15 = recommendationsById
	end

	local analyticsSurface

	if FFlagPymkCarouselExtendProps then
		analyticsSurface = props.analyticsSurface
	end

	local v16

	if FFlagPymkCarouselExtendProps then
		v16 = impressionsTag
	end

	local renderRow = useCallback2(fn2, {
		showToast,
		fireAnalyticsEvent,
		recommendationSessionId2,
		openProfilePeekView,
		v14,
		v15,
		analyticsSurface,
		v16
	})

	if #v3 == 0 then
		return nil
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v17 = {
		ContactsContextProvider = React.createElement(ContactsContext.Provider, { value = v13 }, {
			PYMKCarousel = React.createElement(HorizontalUserList, {
				entities = entities,
				renderRow = renderRow,
				header = { title = props.carouselTitle, onTitleActivated = onTitleActivated },
				collectionCarouselConfigs = {
					onViewableItemsChanged = v,
					onChangeCanvasPosition = v
				},
				listConfigs = { showSubtitle = false },
				scrollingFrameRef = ref,
				appCompositionEnabled = props.appCompositionEnabled
			})
		}),
		ScreenSizeImpressionsTracker = 0
	}

	local createElement2 = React.createElement
	local v18

	if FFlagLuaAppUseFrameBoundsImpressions then
		v18 = FrameBoundsImpressionsTracker
	else
		v18 = ScreenSizeImpressionsTracker
	end

	v17.ScreenSizeImpressionsTracker = createElement2(v18, {
		pageContext = props.pageContext,
		parentRef = ref,
		impressionsTag = impressionsTag,
		scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
		sendImpressions = sendImpressions,
		dataUpdatedTimestamp = state
	})
	return createElement(fragment, nil, v17)
end

return React.memo(PYMKCollectionCarousel)
