local GameDetail = script:FindFirstAncestor("GameDetail")
local parent = GameDetail.Parent

local FFlagSduiEdpRenderStarted = require(GameDetail.Flags.FFlagSduiEdpRenderStarted)
local ExperienceDetailsPageUtils = require(script.Parent.ExperienceDetailsPageUtils)
local ExperienceDetailsPageConstants = require(script.Parent.ExperienceDetailsPageConstants)
local ExperienceDetailsPageScopeFields = require(script.Parent.ExperienceDetailsPageScopeFields)
local fetchExperienceDetailsPage = require(script.Parent.fetchExperienceDetailsPage)
local getExperienceDetailsPageKey = require(script.Parent.getExperienceDetailsPageKey)
local PeekViewTopBar = require(script.Parent.PeekViewTopBar)
local useEdpFunctionallyReadyLogger = require(script.Parent.useEdpFunctionallyReadyLogger)
local createExperienceDetailsPageTimer = require(script.Parent.createExperienceDetailsPageTimer)
local useMotionJitterMetric = require(script.Parent.useMotionJitterMetric)
local usePublishContainerWidth = require(script.Parent.usePublishContainerWidth)
local ExperienceDetailsFallbackActionBar = require(script.Parent.Fallback.ExperienceDetailsFallbackActionBar)
local ExperienceDetailsFallbackFeed = require(script.Parent.Fallback.ExperienceDetailsFallbackFeed)

local AppTabBarRodux = require(parent.AppTabBarRodux)
local SetTabBarVisible = AppTabBarRodux.Actions.SetTabBarVisible
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local gameDetailsPeekViewEvents = DiscoveryAnalytics.Events.gameDetailsPeekViewEvents

require(parent.Navigation)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local PeekView = require(parent.PeekView)
local useTokens = Foundation.Hooks.useTokens
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local PeekViewWithTopBar = PeekView.PeekViewWithTopBar
local PeekViewState = PeekView.PeekViewState
local InputUi = require(parent.InputUi)
local getSafeAreaSize = InputUi.getSafeAreaSize
local Responsive = require(parent.Responsive)
local useDeviceInsets = Responsive.useDeviceInsets
local DataHydration = require(parent.DataHydration)

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useTopBarHeight = RobloxAppHooks.useTopBarHeight
local RobloxAppHooks2 = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks2.useScreenSize
local RobloxAppHooks3 = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks3.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local AppSessionService = RoactServiceTags.AppSessionService
local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local SessionType = RobloxAppSessionization.SessionType
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local GameDetailTelemetry = require(parent.GameDetailTelemetry)
local EDPTTIConstants = GameDetailTelemetry.EDPTTIConstants

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local SduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local UiStatus = SduiSharedUtilities.UiStatus
local useUiStatus = SduiSharedUtilities.useUiStatus
local useEntrySurfacing = SduiSharedUtilities.useEntrySurfacing
local FilterPlayWithReward = ExperienceDetailsPageScopeFields.FilterPlayWithReward

local AppComposition = require(parent.AppComposition)
local CompositionTags = AppComposition.CompositionTags

local ExperienceDetailsPersistentActionBar = require(script.Parent.ExperienceDetailsPersistentActionBar)

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiContainerQueries = SharedFlags.FFlagSduiContainerQueries
local FFlagEDPTTIParityDefinitions = SharedFlags.FFlagEDPTTIParityDefinitions
local FFlagSduiPageEntryUseSharedHooks = SharedFlags.FFlagSduiPageEntryUseSharedHooks
local FFlagLuaAppSduiEdpHideSystemBarOnPeekViewMount = SharedFlags.FFlagLuaAppSduiEdpHideSystemBarOnPeekViewMount
local FFlagEnableMotionJitterMetric = SharedFlags.FFlagEnableMotionJitterMetric
local FFlagSduiEdpPersistentActionBarPlayButton = SharedFlags.FFlagSduiEdpPersistentActionBarPlayButton
local FFlagLuaAppEdpBottomSheetPeekViewEvents = SharedFlags.FFlagLuaAppEdpBottomSheetPeekViewEvents

local function ExperienceDetailsPeekView(pageProps)
	local universeId = ExperienceDetailsPageUtils.getUniverseId(pageProps)
	local analyticsSource = ExperienceDetailsPageUtils.getAnalyticsSource(pageProps)
	local tilePositionIndex = ExperienceDetailsPageUtils.getTilePositionIndex(pageProps)
	local v = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(pageProps, "onPeekViewClosed")
	local experienceDetailsPageKey = getExperienceDetailsPageKey(universeId)
	usePageScopeRef(experienceDetailsPageKey)
	local v2 = React.useMemo(function()
		local v2 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(pageProps, "pageTimer")
		local v3

		if FFlagEDPTTIParityDefinitions then
			v3 = v2
				or createExperienceDetailsPageTimer(experienceDetailsPageKey, {
					page = "Untracked",
					category = EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_PEEK_VIEW
				})
		else
			v3 = v2 or SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(experienceDetailsPageKey, {
				eventName = EDPTTIConstants.EDP_TTI_EVENT_NAME,
				metadata = {
					page = "Untracked",
					category = EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_PEEK_VIEW
				},
				manualSurfaceReady = true
			})
		end

		getSduiClientPageScope(experienceDetailsPageKey).set(
			SduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY,
			v3
		)
		return v3
	end, {})

	if FFlagSduiEdpRenderStarted then
		v2.logRenderStarted()
	end

	useEdpFunctionallyReadyLogger(v2, universeId)

	local v3 = useTokens()
	local v4 = useNavigation()
	local v5 = useRoactService(AppEventIngestService)
	local v6 = useRoactService(AppSessionService)
	local v7 = useDispatch()

	if FFlagLuaAppSduiEdpHideSystemBarOnPeekViewMount then
		React.useEffect(function()
			v7(SetTabBarVisible(false))
		end, { v7 })
	end

	local referralSource = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(pageProps, "referralSource")
	local experienceJoinData = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(
		pageProps,
		"experienceJoinData"
	)
	local placeIdOverride = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(pageProps, "placeIdOverride")
	React.useEffect(function()
		local sduiClientPageScope = getSduiClientPageScope(experienceDetailsPageKey)
		sduiClientPageScope.set("referralSource", referralSource)
		sduiClientPageScope.set("experienceJoinData", experienceJoinData)
		sduiClientPageScope.set("placeId", placeIdOverride)
		sduiClientPageScope.set("launchSource", "LuaGameCard")
		sduiClientPageScope.set(FilterPlayWithReward, nil)
	end, { experienceDetailsPageKey, referralSource, experienceJoinData, placeIdOverride })

	local topBarHeight = useTopBarHeight()
	local v8 = math.min(getSafeAreaSize(useScreenSize(), (useDeviceInsets())).X.Offset, 640)
	local ref2

	if FFlagSduiContainerQueries then
		ref2 = usePublishContainerWidth(experienceDetailsPageKey)
	end

	local ref = React.useRef(nil)
	local state, setState = React.useState(function()
		return v3.Padding.Medium + v3.Size.Size_1200
	end)

	local onAbsoluteSizeChange = React.useCallback(function(p)
		local v9 = p.AbsoluteSize.Y

		if v9 > 0 then
			local v10 = v3.Padding.Medium + v3.Size.Size_1200

			if v9 <= v10 + v3.Padding.Medium then
				v9 = v10
			end

			setState(v9)
		end
	end, { v3 })

	local v9 = useEntrySurfacing(
		experienceDetailsPageKey,
		ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER,
		"peekView"
	)
	local heightOffset = v9 and v9.heightOffset or 0
	local udim = UDim.new(0, v8 + state + heightOffset)

	local v10 = useSelector(function(p)
		return p.GameDetailsPeekView.viewState
	end)

	local mountAsFullView = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(pageProps, "mountAsFullView")

	if mountAsFullView == nil then
		mountAsFullView = v10 == PeekViewState.Full or v10 == PeekViewState.Extended
	end

	local mountAnimation = v10 == PeekViewState.Closed

	if FFlagEnableMotionJitterMetric then
		useMotionJitterMetric(ref, ExperienceDetailsPageConstants.EDP_PEEK_VIEW_SURFACE, true, "CanvasPosition")
	end

	local onClose = React.useCallback(function()
		if v and typeof(v) == "function" then
			v()
		end

		v4.clearAppScreens({ AppPage.GameDetail })

		if v6 then
			v6:RemoveSession(SessionType.StructuralIdentifier.GameDetailSource)
		end
	end, { v4, v6, v, universeId, analyticsSource, tilePositionIndex })

	React.useEffect(function()
		if universeId and v2 then
			fetchExperienceDetailsPage(universeId, v2)
		end
	end, { universeId, v2 })

	local v11 = useUiStatus(experienceDetailsPageKey)
	React.useEffect(function()
		if v11 == UiStatus.Error and universeId then
			DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(universeId, function(p): boolean
				return p == nil or p.creator == nil
			end)

			DataHydration.Game.getAgeRecommendationStore(false).getAndFetchAgeRecommendation(universeId)
		end
	end, { v11, universeId })

	local refresh = React.useCallback(function()
		if universeId and v2 then
			fetchExperienceDetailsPage(universeId, v2, true)
		end
	end, { universeId, v2 })

	local onViewStateChanged = React.useCallback(function(viewState, p)
		local v12 = universeId or ""

		if universeId and viewState == PeekViewState.Brief then
			if v10 == PeekViewState.Brief then
				local v13

				if FFlagLuaAppEdpBottomSheetPeekViewEvents then
					v13 = ExperienceDetailsPageConstants.EDP_PEEK_VIEW_SURFACE
				end

				gameDetailsPeekViewEvents(v5, "SwitchGame", v12, analyticsSource, tilePositionIndex, v13)
			elseif p == PeekViewState.Closed then
				local v13

				if FFlagLuaAppEdpBottomSheetPeekViewEvents then
					v13 = ExperienceDetailsPageConstants.EDP_PEEK_VIEW_SURFACE
				end

				gameDetailsPeekViewEvents(v5, "OpenPeekView", v12, analyticsSource, tilePositionIndex, v13)
			end
		end

		v7({ type = "SetGameDetailsPeekViewState", viewState = viewState })

		if universeId and viewState == PeekViewState.Full and p == PeekViewState.Brief then
			local v13

			if FFlagLuaAppEdpBottomSheetPeekViewEvents then
				v13 = ExperienceDetailsPageConstants.EDP_PEEK_VIEW_SURFACE
			end

			gameDetailsPeekViewEvents(v5, "GoToFullView", v12, analyticsSource, tilePositionIndex, v13)
		end

		if viewState == PeekViewState.Closed then
			onClose()
		end
	end, { v7, v5, universeId, analyticsSource, tilePositionIndex, v10, onClose })

	if universeId == nil then
		return nil
	end

	local createElement = React.createElement
	local v12 = {
		topBarHeight = topBarHeight,
		bottomDockedContainerHeight = state,
		fullViewContentHeight = UDim.new(1, -topBarHeight),
		briefViewContentHeight = udim,
		onViewStateChanged = onViewStateChanged,
		viewChangedEventMeta = {
			universeId = universeId,
			source = analyticsSource,
			index = tilePositionIndex
		},
		mountAsFullView = mountAsFullView,
		mountAnimation = mountAnimation,
		scrollingFrameRef = ref,
		topBarSlot = React.createElement(PeekViewTopBar, {
			pageProps = pageProps,
			onClose = onClose
		}),
		contentSlot = 0,
		bottomBarSlot = 0
	}

	local createElement2 = React.createElement

	if not FFlagSduiContainerQueries then
		ref2 = nil
	end

	local v13 = {
		ref = ref2,
		Size = UDim2.new(1, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1
	}

	local createElement3 = React.createElement
	local children = {
		appPage = AppPage.GameDetail,
		configKey = experienceDetailsPageKey,
		identifier = 0,
		pageTimer = 0,
		backgroundStyle = 0,
		includeNavigationHeaderBar = false,
		scrollingFrameRef = 0,
		contentTag = 0,
		loadingSlot = 0,
		errorSlot = 0,
		snackbarPortalLayoutOrder = 2147483647
	}
	local identifier

	if FFlagSduiPageEntryUseSharedHooks then
		identifier = ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER
	else
		identifier = ExperienceDetailsPageUtils.getResolvedIdentifier(
			experienceDetailsPageKey,
			ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER_SUFFIX
		)
	end

	children.identifier = identifier

	children.pageTimer = v2
	children.backgroundStyle = v3.Color.Surface.Surface_100

	children.scrollingFrameRef = ref
	children.contentTag = CompositionTags.ContentRegion.Body
	children.loadingSlot = React.createElement(ExperienceDetailsFallbackFeed.Skeleton, {
		universeId = universeId,
		isSmallScreen = true,
		launchSource = "LuaGameCard"
	})

	children.errorSlot = React.createElement(ExperienceDetailsFallbackFeed.Error, {
		universeId = universeId,
		refresh = refresh,
		isSmallScreen = true,
		launchSource = "LuaGameCard",
		referralSource = referralSource,
		experienceJoinData = experienceJoinData,
		placeIdOverride = placeIdOverride
	})
	v12.contentSlot = createElement2("Frame", v13, {
		Content = createElement3(SduiPageEntryPoint, children)
	})
	local bottomBarSlot

	if FFlagSduiEdpPersistentActionBarPlayButton then
		bottomBarSlot = React.createElement(ExperienceDetailsPersistentActionBar, {
			universeId = universeId,
			configKey = experienceDetailsPageKey,
			loadTimer = v2,
			launchSource = "LuaGameCard",
			referralSource = referralSource,
			experienceJoinData = experienceJoinData,
			placeIdOverride = placeIdOverride,
			onAbsoluteSizeChange = onAbsoluteSizeChange
		})
	else
		bottomBarSlot = React.createElement(SduiFeatureEntryPoint, {
			appPage = AppPage.GameDetail,
			configKey = experienceDetailsPageKey,
			identifier = ExperienceDetailsPageConstants.EDP_ACTION_BAR_IDENTIFIER,
			loadTimer = v2,
			AutomaticSize = Enum.AutomaticSize.XY,
			onAbsoluteSizeChange = onAbsoluteSizeChange,
			loadingSlot = React.createElement(ExperienceDetailsFallbackActionBar.Skeleton, {
				universeId = universeId,
				launchSource = "LuaGameCard",
				referralSource = referralSource,
				experienceJoinData = experienceJoinData,
				placeIdOverride = placeIdOverride
			}),
			errorSlot = React.createElement(ExperienceDetailsFallbackActionBar.Error, {
				universeId = universeId,
				launchSource = "LuaGameCard",
				referralSource = referralSource,
				experienceJoinData = experienceJoinData,
				placeIdOverride = placeIdOverride
			})
		})
	end

	v12.bottomBarSlot = bottomBarSlot
	return createElement(PeekViewWithTopBar, v12)
end

return React.memo(ExperienceDetailsPeekView)
