local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)
local useStyle = dependencies.UIBlox.Core.Style.useStyle
local useSelector = dependencies.Hooks.useSelector
local NetworkingPresence = dependencies.NetworkingPresence
local RecommendationContextType = dependencies.RoduxFriends.Enums.RecommendationContextType
local PYMKCarouselParent = PYMKCarousel.Parent
local React = require(PYMKCarouselParent.React)
local Responsive = require(PYMKCarouselParent.Responsive)
local SocialCommon = require(PYMKCarouselParent.SocialCommon)
local SocialStopwatch = require(PYMKCarouselParent.SocialStopwatch)
local calculateContextualMaxHeight = SocialCommon.Components.CarouselUserTile.calculateContextualMaxHeight
local tutils = require(PYMKCarouselParent.tutils)
local useAppPolicy = require(PYMKCarouselParent.UniversalAppPolicy).useAppPolicy
local CollectionViews = require(PYMKCarouselParent.CollectionViews)
local CollectionCarousel = CollectionViews.CollectionCarousel
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local ReactFocusNavigation = require(PYMKCarouselParent.ReactFocusNavigation)
local FocusNavigationEventNameEnum = require(PYMKCarouselParent.FocusNavigationUtils).FocusNavigationEventNameEnum
local InputHandlers = require(PYMKCarouselParent.InputHandlers)
local useThrottledCallback = require(PYMKCarouselParent.RoactUtils).Hooks.useThrottledCallback
local Dash = require(PYMKCarouselParent.Dash)
local Impressions = require(PYMKCarouselParent.Impressions)
local ScreenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local FrameBoundsImpressionsTracker = Impressions.FrameBoundsImpressionsTracker
local useDispatch = require(PYMKCarouselParent.RoactUtils).Hooks.RoactRodux.useDispatch
local Analytics = require(PYMKCarousel.Analytics)
local BtnValues = Analytics.BtnValues
local EventNames = Analytics.EventNames
local useUserSeenEvent = Analytics.useUserSeenEvent
local UserList = require(PYMKCarouselParent.UserList)
local HorizontalUserList = UserList.HorizontalUserList.HorizontalUserList
local ContactsContext = UserList.ContactsContext
local PYMKCarouselUserTile = require(PYMKCarousel.Components.PYMKCarouselUserTile)
local PYMKCarouselButtonTile = require(PYMKCarousel.Components.PYMKCarouselButtonTile)
local PYMKCarouselFindFriendsTooltip = require(PYMKCarousel.Components.PYMKCarouselFindFriendsTooltip)
local usePYMKCarouselItemList = require(PYMKCarousel.Components.PYMKCarouselComponent.usePYMKCarouselItemList)
local getPYMKSortedRecommendationIds = require(PYMKCarousel.installReducer.Selectors.getPYMKSortedRecommendationIds)
local useCallbackWhenVisible = require(PYMKCarousel.Components.useCallbackWhenVisible)
local usePYMKCarouselUserEntitiesList = require(PYMKCarousel.Components.PYMKCarouselComponent.usePYMKCarouselUserEntitiesList)
local useContactsContext = require(PYMKCarousel.Components.PYMKCarouselComponent.useContactsContext)
local PYMKUser = require(PYMKCarousel.Components.PYMKUser)
local FFlagLuaAppCompositionAlways = require(PYMKCarouselParent.SharedFlags).FFlagLuaAppCompositionAlways
local FFlagHomepagePYMKPresence = require(PYMKCarouselParent.SharedFlags).FFlagHomepagePYMKPresence
local FFlagHomepagePYMKPresenceAnalytics = require(PYMKCarouselParent.SharedFlags).FFlagHomepagePYMKPresenceAnalytics
local FFlagHomepagePYMKUseHorizontalUserList = require(PYMKCarouselParent.SharedFlags).FFlagHomepagePYMKUseHorizontalUserList
local FFlagLuaAppUseFrameBoundsImpressions = require(PYMKCarouselParent.SharedFlags).FFlagLuaAppUseFrameBoundsImpressions
local n1 = 0
local t1 = {
	[Enum.KeyCode.ButtonX] = FocusNavigationEventNameEnum.SeeAll
}
local v52 = game:DefineFastInt("HomePagePYMKPresenceFetchThrottleInterval", 60)

local function PYMKCollectionCarousel(t2: {[any]: any}) -- line: 98
	-- upvalues: FFlagLuaAppCompositionAlways (copy), FFlagHomepagePYMKUseHorizontalUserList (copy), useAppPolicy (copy), React (copy), useCollectionImpressionsSignal (copy), useSelector (copy), getPYMKSortedRecommendationIds (copy), tutils (copy), usePYMKCarouselItemList (copy), SocialStopwatch (copy), FFlagHomepagePYMKPresence (copy), useDispatch (copy), Dash (copy), RecommendationContextType (copy), NetworkingPresence (copy), FFlagHomepagePYMKPresenceAnalytics (copy), EventNames (copy), useThrottledCallback (copy), v52 (copy), useCallbackWhenVisible (copy), n1 (ref), BtnValues (copy), useStyle (copy), calculateContextualMaxHeight (copy), useCollectionLayoutParams (copy), CollectionItemSize (copy), useUserSeenEvent (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), ReactFocusNavigation (copy), t1 (copy), Responsive (copy), PYMKCarouselButtonTile (copy), PYMKCarouselFindFriendsTooltip (copy), PYMKCarouselUserTile (copy), usePYMKCarouselUserEntitiesList (copy), useContactsContext (copy), PYMKUser (copy), ContactsContext (copy), HorizontalUserList (copy), FFlagLuaAppUseFrameBoundsImpressions (copy), FrameBoundsImpressionsTracker (copy), ScreenSizeImpressionsTracker (copy), CollectionCarousel (copy)
	local v55 = FFlagLuaAppCompositionAlways or t2.appCompositionEnabled
	local v56 = nil

	if not FFlagHomepagePYMKUseHorizontalUserList then
		v56 = useAppPolicy(function(p1) -- line: 102
			return p1.useGridPageLayout()
		end)
	end

	local v57, v58 = React.useState(nil)
	local v59 = React.useRef(nil)
	local v60, v61 = useCollectionImpressionsSignal(t2.scrollViewPositionChangedSignal)
	local v62 = useSelector(function(p2) -- line: 117
		-- upvalues: getPYMKSortedRecommendationIds (copy)
		local LocalUserId = p2.LocalUserId

		return getPYMKSortedRecommendationIds(LocalUserId)(p2)
	end, tutils.shallowEqual)
	local v63 = v62 and #v62 or 0
	local recommendationSessionId = t2.recommendationSessionId
	local fireAnalyticsEvent = t2.fireAnalyticsEvent
	local v66 = usePYMKCarouselItemList({
		recommendationIds = v62,
		recommendationCount = v63,
		findFriendsTileEnabled = t2.findFriendsTileEnabled,
		seeAllTileEnabled = t2.seeAllTileEnabled
	})

	React.useLayoutEffect(function() -- line: 133
		-- upvalues: SocialStopwatch (copy)
		SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.PYMKCarouselLoaded)

		return function() -- line: 135
			-- upvalues: SocialStopwatch (copy)
			if SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.PYMKCarouselLoaded) then
				SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.PYMKCarouselLoaded)
			end
		end
	end, { recommendationSessionId })

	local v67, v68 = React.useState(os.clock())

	if FFlagHomepagePYMKPresence then
		local v69 = useDispatch()
		local v70 = React.useCallback(function() -- line: 147
			-- upvalues: Dash (copy), v62 (copy), RecommendationContextType (copy), v69 (copy), NetworkingPresence (copy), FFlagHomepagePYMKPresenceAnalytics (copy), fireAnalyticsEvent (copy), EventNames (copy)
			local v96 = Dash.reduce(v62, function(p3, p4) -- line: 148
				-- upvalues: RecommendationContextType (copy)
				if p4.recommendationContextType ~= RecommendationContextType.Contacts then
					table.insert(p3, p4.id)
				end

				return p3
			end, {})

			if #v96 > 0 then
				v69(NetworkingPresence.GetPresencesFromUserIds.API(v96))

				if FFlagHomepagePYMKPresenceAnalytics then
					fireAnalyticsEvent(EventNames.PYMKUserPresenceLoad)
				end
			end
		end, {
			v69,
			v62,
			if not FFlagHomepagePYMKPresenceAnalytics then nil else fireAnalyticsEvent
		})
		local v71 = useThrottledCallback(v70, v52)

		useCallbackWhenVisible({
			elementRef = v59,
			scrollViewPositionChangedSignal = t2.scrollViewPositionChangedSignal,
			callback = v71
		})
	end

	React.useEffect(function() -- line: 174
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v63 (copy), n1 (ref), t2 (copy), v68 (copy)
		fireAnalyticsEvent(EventNames.CarouselLoadedWithUsers, {
			recommendationCount = v63,
			refreshCount = n1,
			findFriendsTileEnabled = t2.findFriendsTileEnabled
		})
		n1 += 1
		v68(os.clock())
	end, {
		recommendationSessionId,
		v63
	})

	local v72 = React.useCallback(function() -- line: 189
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), BtnValues (copy), t2 (copy)
		fireAnalyticsEvent(EventNames.CarouselGenericTileClicked, {
			btn = BtnValues.SeeAll.rawValue()
		})
		t2.goToAddFriendsPage(false)
	end, {
		t2.goToAddFriendsPage,
		fireAnalyticsEvent
	})
	local u73 = nil
	local u74 = nil
	local v75 = nil
	local u76 = nil
	local u77 = nil
	local u78 = nil

	if not FFlagHomepagePYMKUseHorizontalUserList then
		u73 = useStyle()
		u74 = React.useMemo(function() -- line: 203
			-- upvalues: calculateContextualMaxHeight (copy), u73 (ref)
			return calculateContextualMaxHeight({
				font = u73.Font
			})
		end, { u73.Font })
		v75 = React.useCallback(function(n2: number) -- line: 209
			-- upvalues: u74 (ref)
			return n2 + u74
		end, { u74 })

		local v79, v80 = React.useState(0)

		u77 = v79
		u78 = v80

		local t3 = {
			sideMargin = if not v55 then if not v56 then t2.sideMargin else nil else nil
		}

		u76 = useCollectionLayoutParams(CollectionItemSize.Small, v57, true, t3)
	end

	local v82 = useUserSeenEvent(fireAnalyticsEvent)
	local v83 = React.useCallback(function(t4: {[any]: any}) -- line: 227
		-- upvalues: v66 (copy), v82 (copy)
		local t5 = {}

		for _, v101 in t4 do
			table.insert(t5, {
				item = v66[v101]
			})
		end

		if #v82 > 0 then
			v82[1].onViewableItemsChanged({
				changed = t5
			})
		end
	end, {
		v82,
		v66
	})
	local v84 = React.useMemo(function() -- line: 241
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v72 (copy)
		return {
			[FocusNavigationEventNameEnum.SeeAll] = {
				handler = InputHandlers.onRelease(v72)
			}
		}
	end, { v72 })
	local v85 = ReactFocusNavigation.useEventMap(t1)
	local v86 = ReactFocusNavigation.useEventHandlerMap(v84, v85)

	React.useEffect(function() -- line: 253
		-- upvalues: v86 (copy), v59 (copy)
		if v86 and v59 then
			v86(v59.current)
		end

		return function() -- line: 257
			-- upvalues: v86 (copy)
			v86(nil)
		end
	end, {
		v86,
		v59,
		v59 and v59.current
	})

	local u87 = nil
	local v88 = nil

	if not FFlagHomepagePYMKUseHorizontalUserList then
		u87 = Responsive.usePreferredInput() == Responsive.Input.Directional

		local v89 = React.useCallback(function(p5) -- line: 267
			-- upvalues: u78 (ref)
			local AbsoluteSizeX = p5.AbsoluteSize.X

			if AbsoluteSizeX > 0 then
				u78(AbsoluteSizeX)
			end
		end, {})

		v88 = React.useCallback(function(p6, n3: number, p7, _) -- line: 275
			-- upvalues: v55 (copy), u77 (ref), u76 (ref), React (copy), PYMKCarouselButtonTile (copy), t2 (copy), fireAnalyticsEvent (copy), PYMKCarouselFindFriendsTooltip (copy), PYMKCarouselUserTile (copy), recommendationSessionId (copy), u87 (ref), v89 (copy)
			local v108 = if not v55 then u76.itemWidth else u77
			local v109, s1

			if p6.isButtonTile then
				v109 = React.createElement(PYMKCarouselButtonTile, {
					id = p6.id,
					tileWidth = v108,
					goToAddFriendsPage = t2.goToAddFriendsPage,
					fireAnalyticsEvent = fireAnalyticsEvent,
					shouldShowContactImporterBadge = t2.shouldShowContactImporterBadge,
					LayoutOrder = n3
				})
				s1 = "PYMKCarouselButtonTile"
			elseif p6.isTooltip then
				v109 = React.createElement(PYMKCarouselFindFriendsTooltip, {
					LayoutOrder = n3
				})
				s1 = "PYMKCarouselFindFriendsTooltip"
			else
				v109 = React.createElement(PYMKCarouselUserTile, {
					contextualInfoLines = 2,
					impressionsTag = "PYMKCollectionCarousel",
					userId = p6.id,
					tileWidth = v108,
					openProfilePeekView = t2.openProfilePeekView,
					showToast = t2.showToast,
					fireAnalyticsEvent = fireAnalyticsEvent,
					absolutePosition = p6.absolutePosition,
					recommendationSessionId = recommendationSessionId,
					LayoutOrder = n3,
					hideButtons = u87
				})
				s1 = "PYMKCarouselUserTile"
			end

			if v55 then
				return React.createElement("Frame", {
					Size = p7,
					BackgroundTransparency = 1,
					LayoutOrder = n3,
					[React.Change.AbsoluteSize] = v89
				}, {
					Tile = v109
				}), s1
			end

			return v109, s1
		end, {
			t2.goToAddFriendsPage,
			fireAnalyticsEvent,
			t2.shouldShowContactImporterBadge,
			t2.openProfilePeekView,
			t2.showToast,
			recommendationSessionId,
			u76.itemWidth,
			u87,
			v55,
			u77,
			v89
		})
	end

	if FFlagHomepagePYMKUseHorizontalUserList then
		local v90 = usePYMKCarouselUserEntitiesList(v66)
		local v91 = useContactsContext(v66)
		local v92 = React.useCallback(function(p9, p10, p11) -- line: 352
			-- upvalues: React (copy), PYMKUser (copy), t2 (copy), fireAnalyticsEvent (copy)
			return React.createElement(PYMKUser, {
				impressionsTag = "PYMKCollectionCarousel",
				createRow = p9,
				entity = p10,
				showToast = t2.showToast,
				fireAnalyticsEvent = fireAnalyticsEvent,
				absolutePosition = p11,
				recommendationSessionId = t2.recommendationSessionId,
				openProfilePeekView = t2.openProfilePeekView
			})
		end, {
			t2.showToast,
			fireAnalyticsEvent,
			t2.recommendationSessionId,
			t2.openProfilePeekView
		})

		if #v66 == 0 then
			return nil
		end

		return React.createElement(React.Fragment, nil, {
			ContactsContextProvider = React.createElement(ContactsContext.Provider, {
				value = v91
			}, {
				PYMKCarousel = React.createElement(HorizontalUserList, {
					entities = v90,
					renderRow = v92,
					header = {
						title = t2.carouselTitle,
						onTitleActivated = v72
					},
					collectionCarouselConfigs = {
						onViewableItemsChanged = v61,
						onChangeCanvasPosition = v61
					},
					listConfigs = {
						showSubtitle = false
					},
					scrollingFrameRef = v59,
					appCompositionEnabled = t2.appCompositionEnabled
				})
			}),
			ScreenSizeImpressionsTracker = React.createElement(if not FFlagLuaAppUseFrameBoundsImpressions then ScreenSizeImpressionsTracker else FrameBoundsImpressionsTracker, {
				impressionsTag = "PYMKCollectionCarousel",
				pageContext = t2.pageContext,
				parentRef = v59,
				scrollViewPositionChangedSignal = v60,
				sendImpressions = v83,
				dataUpdatedTimestamp = v67
			})
		})
	end

	if #v66 == 0 then
		return nil
	end

	return React.createElement(React.Fragment, nil, {
		PYMKCarousel = React.createElement(CollectionCarousel, {
			title = t2.carouselTitle,
			onActivateHeader = v72,
			containerRef = v58,
			scrollingFrameRef = v59,
			items = v66,
			renderItem = v88,
			getItemHeight = v75,
			collectionItemSize = if not v55 then nil else CollectionItemSize.Small,
			numColumns = if not v55 then u76.numColumns else nil,
			fractionalItemAmount = if not v55 then u76.fractionalItemAmount else nil,
			columnGap = if not v55 then u76.columnGap else nil,
			sideMargin = if not v55 then u76.sideMargin else nil,
			maxItemsToShow = u76.maxTilesToShow,
			onViewableItemsChanged = v61,
			onChangeCanvasPosition = v61
		}),
		ScreenSizeImpressionsTracker = React.createElement(if not FFlagLuaAppUseFrameBoundsImpressions then ScreenSizeImpressionsTracker else FrameBoundsImpressionsTracker, {
			impressionsTag = "PYMKCollectionCarousel",
			pageContext = t2.pageContext,
			parentRef = v59,
			scrollViewPositionChangedSignal = v60,
			sendImpressions = v83,
			dataUpdatedTimestamp = v67
		})
	})
end

return React.memo(PYMKCollectionCarousel)
