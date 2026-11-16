local FFlagSduiEdpRenderStarted = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/Flags/FFlagSduiEdpRenderStarted")
local ExperienceDetailsPageUtils = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/ExperienceDetailsPageUtils")
local ExperienceDetailsPageConstants = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/ExperienceDetailsPageConstants")
local ExperienceDetailsPageScopeFields = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/ExperienceDetailsPageScopeFields")
local fetchExperienceDetailsPage = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/fetchExperienceDetailsPage")
local getExperienceDetailsPageKey = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/getExperienceDetailsPageKey")
local PeekViewTopBar = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/PeekViewTopBar")
local useEdpFunctionallyReadyLogger = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/useEdpFunctionallyReadyLogger")
local createExperienceDetailsPageTimer = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/createExperienceDetailsPageTimer")
local useMotionJitterMetric = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/useMotionJitterMetric")
local usePublishContainerWidth = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/usePublishContainerWidth")
local ExperienceDetailsFallbackActionBar = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/Fallback/ExperienceDetailsFallbackActionBar")
local ExperienceDetailsFallbackFeed = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/Fallback/ExperienceDetailsFallbackFeed")

local setTabBarVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/AppTabBarRodux").Actions.SetTabBarVisible
local gameDetailsPeekViewEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/DiscoveryAnalytics").Events.gameDetailsPeekViewEvents

require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Navigation")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/React")
local PeekView = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/PeekView")
local useTokens = Foundation.Hooks.useTokens
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Navigation").useNavigation
local peekViewWithTopBar = PeekView.PeekViewWithTopBar
local peekViewState = PeekView.PeekViewState
local getSafeAreaSize = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/InputUi").getSafeAreaSize
local useDeviceInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Responsive").useDeviceInsets
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/DataHydration")

local useTopBarHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppHooks").useTopBarHeight
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppHooks").useScreenSize
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppHooks").useRoactService
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RoactServiceTags")
local appEventIngestService = RoactServiceTags.AppEventIngestService
local appSessionService = RoactServiceTags.AppSessionService
local sessionType = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppSessionization").SessionType
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppEnums").AppPage

local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RoactUtils")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local edpttiConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/GameDetailTelemetry").EDPTTIConstants

local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SduiSharedUtilities")
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local sduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local sduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local sduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local uiStatus = SduiSharedUtilities.UiStatus
local useUiStatus = SduiSharedUtilities.useUiStatus
local useEntrySurfacing = SduiSharedUtilities.useEntrySurfacing
local filterPlayWithReward = ExperienceDetailsPageScopeFields.FilterPlayWithReward

local compositionTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/AppComposition").CompositionTags

local ExperienceDetailsPersistentActionBar = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/ExperienceDetailsPersistentActionBar")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SharedFlags")
local fFlagSduiContainerQueries = SharedFlags.FFlagSduiContainerQueries
local fFlagEDPTTIParityDefinitions = SharedFlags.FFlagEDPTTIParityDefinitions
local fFlagSduiPageEntryUseSharedHooks = SharedFlags.FFlagSduiPageEntryUseSharedHooks
local fFlagLuaAppSduiEdpHideSystemBarOnPeekViewMount = SharedFlags.FFlagLuaAppSduiEdpHideSystemBarOnPeekViewMount
local fFlagEnableMotionJitterMetric = SharedFlags.FFlagEnableMotionJitterMetric
local fFlagSduiEdpPersistentActionBarPlayButton = SharedFlags.FFlagSduiEdpPersistentActionBarPlayButton
local fFlagLuaAppEdpBottomSheetPeekViewEvents = SharedFlags.FFlagLuaAppEdpBottomSheetPeekViewEvents

local function ExperienceDetailsPeekView(p2)
	local universeId = ExperienceDetailsPageUtils.getUniverseId(p2)
	local analyticsSource = ExperienceDetailsPageUtils.getAnalyticsSource(p2)
	local tilePositionIndex = ExperienceDetailsPageUtils.getTilePositionIndex(p2)
	local v5 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p2, "onPeekViewClosed")
	local v6 = getExperienceDetailsPageKey(universeId)
	usePageScopeRef(v6)
	local v7 = React.useMemo(function()
		local v8 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p2, "pageTimer")
		local v9

		if fFlagEDPTTIParityDefinitions then
			v9 = v8
				or createExperienceDetailsPageTimer(v6, {
					page = "Untracked",
					category = edpttiConstants.EDP_IMPLEMENTATION.SDUI_PEEK_VIEW
				})
		else
			v9 = v8 or sduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v6, {
				eventName = edpttiConstants.EDP_TTI_EVENT_NAME,
				metadata = {
					page = "Untracked",
					category = edpttiConstants.EDP_IMPLEMENTATION.SDUI_PEEK_VIEW
				},
				manualSurfaceReady = true
			})
		end

		getSduiClientPageScope(v6).set(sduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY, v9)
		return v9
	end, {})

	if FFlagSduiEdpRenderStarted then
		v7.logRenderStarted()
	end

	useEdpFunctionallyReadyLogger(v7, universeId)

	local v8 = useTokens()
	local v9 = useNavigation()
	local v10 = useRoactService(appEventIngestService)
	local v11 = useRoactService(appSessionService)
	local v12 = useDispatch()

	if fFlagLuaAppSduiEdpHideSystemBarOnPeekViewMount then
		React.useEffect(function()
			v12(setTabBarVisible(false))
		end, { v12 })
	end

	local v13 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p2, "referralSource")
	local v14 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p2, "experienceJoinData")
	local v15 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p2, "placeIdOverride")
	React.useEffect(function()
		local sduiClientPageScope = getSduiClientPageScope(v6)
		sduiClientPageScope.set("referralSource", v13)
		sduiClientPageScope.set("experienceJoinData", v14)
		sduiClientPageScope.set("placeId", v15)
		sduiClientPageScope.set("launchSource", "LuaGameCard")
		sduiClientPageScope.set(filterPlayWithReward, nil)
	end, { v6, v13, v14, v15 })

	local v16 = useTopBarHeight()
	local v17 = useScreenSize()
	local v18 = useDeviceInsets()
	local v19 = math.min(getSafeAreaSize(v17, v18).X.Offset, 640)

	local v20 = if fFlagSduiContainerQueries then usePublishContainerWidth(v6) else nil

	local ref = React.useRef(nil)
	local state, setState = React.useState(function()
		return v8.Padding.Medium + v8.Size.Size_1200
	end)

	local v21 = React.useCallback(function(p3)
		local v22 = p3.AbsoluteSize.Y

		if v22 > 0 then
			local v23 = v8.Padding.Medium + v8.Size.Size_1200

			if v22 <= v23 + v8.Padding.Medium then
				v22 = v23
			end

			setState(v22)
		end
	end, { v8 })

	local v22 = useEntrySurfacing(v6, ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER, "peekView")
	local heightOffset = v22 and v22.heightOffset or 0
	local udim = UDim.new(0, v19 + state + heightOffset)

	local v23 = useSelector(function(p3)
		return p3.GameDetailsPeekView.viewState
	end)

	local v24 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p2, "mountAsFullView")

	if v24 == nil then
		v24 = v23 == peekViewState.Full or v23 == peekViewState.Extended
	end

	local v25 = v23 == peekViewState.Closed

	if fFlagEnableMotionJitterMetric then
		useMotionJitterMetric(ref, ExperienceDetailsPageConstants.EDP_PEEK_VIEW_SURFACE, true, "CanvasPosition")
	end

	local v26 = React.useCallback(function()
		if v5 and typeof(v5) == "function" then
			v5()
		end

		v9.clearAppScreens({ appPage.GameDetail })

		if v11 then
			v11:RemoveSession(sessionType.StructuralIdentifier.GameDetailSource)
		end
	end, { v9, v11, v5, universeId, analyticsSource, tilePositionIndex })

	React.useEffect(function()
		if universeId and v7 then
			fetchExperienceDetailsPage(universeId, v7)
		end
	end, { universeId, v7 })

	local v27 = useUiStatus(v6)
	React.useEffect(function()
		if v27 == uiStatus.Error and universeId then
			DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(universeId, function(p3): boolean
				return p3 == nil or p3.creator == nil
			end)

			DataHydration.Game.getAgeRecommendationStore(false).getAndFetchAgeRecommendation(universeId)
		end
	end, { v27, universeId })

	local v28 = React.useCallback(function()
		if universeId and v7 then
			fetchExperienceDetailsPage(universeId, v7, true)
		end
	end, { universeId, v7 })

	local v29 = React.useCallback(function(p3, p4)
		local v30 = universeId or ""

		if universeId and p3 == peekViewState.Brief then
			if v23 == peekViewState.Brief then
				local v36 = if fFlagLuaAppEdpBottomSheetPeekViewEvents then ExperienceDetailsPageConstants.EDP_PEEK_VIEW_SURFACE else nil
				gameDetailsPeekViewEvents(v10, "SwitchGame", v30, analyticsSource, tilePositionIndex, v36)
			elseif p4 == peekViewState.Closed then
				local v36 = if fFlagLuaAppEdpBottomSheetPeekViewEvents then ExperienceDetailsPageConstants.EDP_PEEK_VIEW_SURFACE else nil
				gameDetailsPeekViewEvents(v10, "OpenPeekView", v30, analyticsSource, tilePositionIndex, v36)
			end
		end

		v12({ type = "SetGameDetailsPeekViewState", viewState = p3 })

		if universeId and p3 == peekViewState.Full and p4 == peekViewState.Brief then
			local v36 = if fFlagLuaAppEdpBottomSheetPeekViewEvents then ExperienceDetailsPageConstants.EDP_PEEK_VIEW_SURFACE else nil
			gameDetailsPeekViewEvents(v10, "GoToFullView", v30, analyticsSource, tilePositionIndex, v36)
		end

		if p3 == peekViewState.Closed then
			v26()
		end
	end, { v12, v10, universeId, analyticsSource, tilePositionIndex, v23, v26 })

	if universeId == nil then
		return nil
	end

	local createElement = React.createElement
	local v31 = {
		topBarHeight = v16,
		bottomDockedContainerHeight = state,
		fullViewContentHeight = UDim.new(1, -v16),
		briefViewContentHeight = udim,
		onViewStateChanged = v29,
		viewChangedEventMeta = {
			universeId = universeId,
			source = analyticsSource,
			index = tilePositionIndex
		},
		mountAsFullView = v24,
		mountAnimation = v25,
		scrollingFrameRef = ref,
		topBarSlot = React.createElement(PeekViewTopBar, { pageProps = p2, onClose = v26 }),
		contentSlot = 0,
		bottomBarSlot = 0
	}

	local createElement2 = React.createElement

	if not fFlagSduiContainerQueries then
		v20 = nil
	end

	local v33 = {
		ref = v20,
		Size = UDim2.new(1, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1
	}

	local createElement3 = React.createElement
	local children = {
		appPage = appPage.GameDetail,
		configKey = v6,
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

	local v36 = if fFlagSduiPageEntryUseSharedHooks then ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER else ExperienceDetailsPageUtils.getResolvedIdentifier(
		v6,
		ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER_SUFFIX
	)
	children.identifier = v36

	children.pageTimer = v7
	children.backgroundStyle = v8.Color.Surface.Surface_100

	children.scrollingFrameRef = ref
	children.contentTag = compositionTags.ContentRegion.Body
	children.loadingSlot = React.createElement(ExperienceDetailsFallbackFeed.Skeleton, {
		universeId = universeId,
		isSmallScreen = true,
		launchSource = "LuaGameCard"
	})

	children.errorSlot = React.createElement(ExperienceDetailsFallbackFeed.Error, {
		universeId = universeId,
		refresh = v28,
		isSmallScreen = true,
		launchSource = "LuaGameCard",
		referralSource = v13,
		experienceJoinData = v14,
		placeIdOverride = v15
	})
	v31.contentSlot = createElement2("Frame", v33, {
		Content = createElement3(sduiPageEntryPoint, children)
	})
	local v37

	if fFlagSduiEdpPersistentActionBarPlayButton then
		v37 = React.createElement(ExperienceDetailsPersistentActionBar, {
			universeId = universeId,
			configKey = v6,
			loadTimer = v7,
			launchSource = "LuaGameCard",
			referralSource = v13,
			experienceJoinData = v14,
			placeIdOverride = v15,
			onAbsoluteSizeChange = v21
		})
	else
		v37 = React.createElement(sduiFeatureEntryPoint, {
			appPage = appPage.GameDetail,
			configKey = v6,
			identifier = ExperienceDetailsPageConstants.EDP_ACTION_BAR_IDENTIFIER,
			loadTimer = v7,
			AutomaticSize = Enum.AutomaticSize.XY,
			onAbsoluteSizeChange = v21,
			loadingSlot = React.createElement(ExperienceDetailsFallbackActionBar.Skeleton, {
				universeId = universeId,
				launchSource = "LuaGameCard",
				referralSource = v13,
				experienceJoinData = v14,
				placeIdOverride = v15
			}),
			errorSlot = React.createElement(ExperienceDetailsFallbackActionBar.Error, {
				universeId = universeId,
				launchSource = "LuaGameCard",
				referralSource = v13,
				experienceJoinData = v14,
				placeIdOverride = v15
			})
		})
	end

	v31.bottomBarSlot = v37
	return createElement(peekViewWithTopBar, v31)
end

return React.memo(ExperienceDetailsPeekView)
