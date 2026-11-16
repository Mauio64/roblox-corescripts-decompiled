local GameDetail = script:FindFirstAncestor("GameDetail")
local parent = GameDetail.Parent

local FFlagSduiEdpRenderStarted = require(GameDetail.Flags.FFlagSduiEdpRenderStarted)
local ExperienceDetailsPageUtils = require(script.Parent.ExperienceDetailsPageUtils)
local ExperienceDetailsPageConstants = require(script.Parent.ExperienceDetailsPageConstants)
local ExperienceDetailsPageScopeFields = require(script.Parent.ExperienceDetailsPageScopeFields)
local ExperienceDetailsBottomSheetTopBar = require(script.Parent.ExperienceDetailsBottomSheetTopBar)
local fetchExperienceDetailsPage = require(script.Parent.fetchExperienceDetailsPage)
local getExperienceDetailsPageKey = require(script.Parent.getExperienceDetailsPageKey)
local removeGameDetailSessionIfDeparted = require(script.Parent.removeGameDetailSessionIfDeparted)
local useEdpFunctionallyReadyLogger = require(script.Parent.useEdpFunctionallyReadyLogger)
local createExperienceDetailsPageTimer = require(script.Parent.createExperienceDetailsPageTimer)
local useMotionJitterMetric = require(script.Parent.useMotionJitterMetric)
local usePublishContainerWidth = require(script.Parent.usePublishContainerWidth)
local ExperienceDetailsFallbackActionBar = require(script.Parent.Fallback.ExperienceDetailsFallbackActionBar)
local ExperienceDetailsFallbackFeed = require(script.Parent.Fallback.ExperienceDetailsFallbackFeed)

local AppTabBarRodux = require(parent.AppTabBarRodux)
local SetTabBarVisible = AppTabBarRodux.Actions.SetTabBarVisible
local DiscoveryTypes = require(parent.DiscoveryTypes)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local gameDetailsPeekViewEvents = DiscoveryAnalytics.Events.gameDetailsPeekViewEvents

local Navigation = require(parent.Navigation)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Sheet = Foundation.Sheet
local OverlayProvider = Foundation.OverlayProvider
local useTokens = Foundation.Hooks.useTokens
local useNavigation = Navigation.useNavigation
local InputUi = require(parent.InputUi)
local getSafeAreaSize = InputUi.getSafeAreaSize
local Responsive = require(parent.Responsive)
local useDeviceInsets = Responsive.useDeviceInsets
local DataHydration = require(parent.DataHydration)

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useTopBarHeight = RobloxAppHooks.useTopBarHeight
local Display = require(parent.Display)
local shouldUseDeviceSafeInsets = Display.shouldUseDeviceSafeInsets
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
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local DiscoveryRouting = require(parent.DiscoveryRouting)
local useGetCurrentLegacyRoute = DiscoveryRouting.useGetCurrentLegacyRoute
local DiscoveryRouting2 = require(parent.DiscoveryRouting)
local hasPageInCurrentRoute = DiscoveryRouting2.hasPageInCurrentRoute
local PeekView = require(parent.PeekView)
local PeekViewState = PeekView.PeekViewState
local SetGameDetailsPeekViewState = require(GameDetail.PeekView.SetGameDetailsPeekViewState)
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
local FFlagEnableExperienceDetailsBottomSheetTopBar = SharedFlags.FFlagEnableExperienceDetailsBottomSheetTopBar
local FFlagEnableMotionJitterMetric = SharedFlags.FFlagEnableMotionJitterMetric
local FFlagSduiEdpPersistentActionBarPlayButton = SharedFlags.FFlagSduiEdpPersistentActionBarPlayButton
local FFlagLuaAppEdpBottomSheetPeekViewEvents = SharedFlags.FFlagLuaAppEdpBottomSheetPeekViewEvents
local FFlagSduiPlayWithRewardRefactor = SharedFlags.FFlagSduiPlayWithRewardRefactor
local FFlagFixOverlayTopInsetForDeviceSafeInsets = SharedFlags.FFlagFixOverlayTopInsetForDeviceSafeInsets

local function snapPointIndexFor(flag: boolean): number -- 2 equivalent calls inferred from this helper
	return if flag then 2 else 1
end

local function ExperienceDetailsBottomSheet(p)
	local universeId = ExperienceDetailsPageUtils.getUniverseId(p)
	local v = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p, "onPeekViewClosed")
	local experienceDetailsPageKey = getExperienceDetailsPageKey(universeId)

	usePageScopeRef(experienceDetailsPageKey)
	local v2 = React.useMemo(function()
		local v2 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p, "pageTimer")
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

	local tokens = useTokens()
	local navigation = useNavigation()
	local v3 = useRoactService(AppSessionService)
	local v4 = useDispatch()
	local v5

	if FFlagLuaAppEdpBottomSheetPeekViewEvents then
		v5 = useRoactService(AppEventIngestService)
	else
		v5 = nil
	end

	local v6 = useGetCurrentLegacyRoute()

	React.useEffect(function()
		v4(SetTabBarVisible(false))
	end, { v4 })

	local referralSource = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p, "referralSource")
	local experienceJoinData = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p, "experienceJoinData")
	local placeIdOverride = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p, "placeIdOverride")

	React.useEffect(function()
		local sduiClientPageScope = getSduiClientPageScope(experienceDetailsPageKey)
		sduiClientPageScope.set("referralSource", referralSource)
		sduiClientPageScope.set("experienceJoinData", experienceJoinData)
		sduiClientPageScope.set("placeId", placeIdOverride)
		sduiClientPageScope.set("launchSource", "LuaGameCard")

		if FFlagSduiPlayWithRewardRefactor then
			sduiClientPageScope.set(FilterPlayWithReward, nil)
		end
	end, { experienceDetailsPageKey, referralSource, experienceJoinData, placeIdOverride })
	local topBarHeight

	if FFlagEnableExperienceDetailsBottomSheetTopBar then
		topBarHeight = useTopBarHeight()
	else
		topBarHeight = nil
	end

	local v7 = useScreenSize()
	local deviceInsets = useDeviceInsets()

	if
		FFlagEnableExperienceDetailsBottomSheetTopBar
		and FFlagFixOverlayTopInsetForDeviceSafeInsets
		and shouldUseDeviceSafeInsets
	then
		topBarHeight += deviceInsets.top
	end

	local safeAreaSize = getSafeAreaSize(v7, deviceInsets)
	local v8 = math.min(safeAreaSize.X.Offset, 640)
	local ref4

	if FFlagSduiContainerQueries then
		ref4 = usePublishContainerWidth(experienceDetailsPageKey)
	end

	local ref

	if FFlagEnableExperienceDetailsBottomSheetTopBar then
		ref = React.useRef(nil)
	end

	local ref2 = React.useRef(nil)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(DiscoveryTypes.Constants.GAME_DETAILS_ACTION_BAR_HEIGHT)

	local onAbsoluteSizeChange = React.useCallback(function(p2)
		local y = p2.AbsoluteSize.Y

		if y > 0 then
			setState2(y)
		end
	end, {})

	local v9 = useEntrySurfacing(
		experienceDetailsPageKey,
		ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER,
		"peekView"
	)
	local heightOffset = v9 and v9.heightOffset or 0

	local useMemo = React.useMemo
	local function fn()
		local v10 = v8 + state2 + heightOffset + 25
		local v11

		if FFlagEnableExperienceDetailsBottomSheetTopBar then
			v11 = math.ceil(v7.Y) - deviceInsets.bottom - topBarHeight
		else
			v11 = safeAreaSize.Y.Offset
		end

		return { v10, v11 }
	end

	local v10

	if FFlagEnableExperienceDetailsBottomSheetTopBar then
		v10 = { v8, state2, heightOffset, v7.Y, deviceInsets.bottom, topBarHeight }
	else
		v10 = { v8, state2, heightOffset, safeAreaSize.Y.Offset }
	end

	local snapPoints = useMemo(fn, v10)

	local v11 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p, "mountAsFullView")
	local shouldMountAsFullView = v11 == true
	local onSnapPointChanged

	if FFlagLuaAppEdpBottomSheetPeekViewEvents then
		local v12 = useStore()
		local analyticsSource = ExperienceDetailsPageUtils.getAnalyticsSource(p)
		local tilePositionIndex = ExperienceDetailsPageUtils.getTilePositionIndex(p)

		local v13 = React.useMemo(function()
			return v12:getState().GameDetailsPeekView.viewState
		end, {})

		if v11 == nil then
			shouldMountAsFullView = v13 == PeekViewState.Full or v13 == PeekViewState.Extended
		else
			shouldMountAsFullView = v11 == true
		end

		React.useEffect(function()
			local v14 = universeId
				and not shouldMountAsFullView
				and (v13 == PeekViewState.Brief and "SwitchGame" or v13 == PeekViewState.Closed and "OpenPeekView" or nil)

			if v14 then
				gameDetailsPeekViewEvents(
					v5,
					v14,
					universeId,
					analyticsSource,
					tilePositionIndex,
					ExperienceDetailsPageConstants.EDP_BOTTOM_SHEET_SURFACE
				)
			end

			local v15

			if shouldMountAsFullView then
				v15 = PeekViewState.Full
			else
				v15 = PeekViewState.Brief
			end

			v4(SetGameDetailsPeekViewState(v15))

			return function()
				if not hasPageInCurrentRoute(v6(), AppPage.GameDetail) then
					v4(SetGameDetailsPeekViewState(PeekViewState.Closed))
				end
			end
		end, {})

		local ref3 = React.useRef(snapPointIndexFor(shouldMountAsFullView)) -- inferred equivalent call
		onSnapPointChanged = React.useCallback(function(_: number, current: number)
			local current2 = ref3.current
			ref3.current = current

			if navigation.isFocused() then
				local v14

				if current == 2 then
					v14 = PeekViewState.Full
				else
					v14 = PeekViewState.Brief
				end

				v4(SetGameDetailsPeekViewState(v14))
			end

			if universeId and current2 == 1 and current == 2 then
				gameDetailsPeekViewEvents(
					v5,
					"GoToFullView",
					universeId,
					analyticsSource,
					tilePositionIndex,
					ExperienceDetailsPageConstants.EDP_BOTTOM_SHEET_SURFACE
				)
			end
		end, { v5, universeId, analyticsSource, tilePositionIndex, v4, navigation })
	end

	local defaultSnapPointIndex = snapPointIndexFor(shouldMountAsFullView) -- inferred equivalent call

	if FFlagEnableMotionJitterMetric then
		useMotionJitterMetric(ref2, ExperienceDetailsPageConstants.EDP_BOTTOM_SHEET_SURFACE, false, "AbsolutePosition")
	end

	local onBack = React.useCallback(function()
		if navigation.isFocused() then
			local v12 = v6()

			if v and typeof(v) == "function" then
				v()
			end

			navigation.goBack()
			removeGameDetailSessionIfDeparted(v3, v12)
		end
	end, { navigation, v3, v, v6 })

	local onClose = React.useCallback(function()
		if navigation.isFocused() then
			if v and typeof(v) == "function" then
				v()
			end

			navigation.clearAppScreens({ AppPage.GameDetail })

			if v3 then
				v3:RemoveSession(SessionType.StructuralIdentifier.GameDetailSource)
			end
		end
	end, { navigation, v3, v })
	local onClose2

	if FFlagLuaAppEdpBottomSheetPeekViewEvents then
		onClose2 = onClose
	else
		onClose2 = if shouldMountAsFullView then onBack else onClose
	end

	React.useEffect(function()
		if universeId and v2 then
			fetchExperienceDetailsPage(universeId, v2)
		end
	end, { universeId, v2 })

	local v12 = useUiStatus(experienceDetailsPageKey)
	React.useEffect(function()
		if v12 == UiStatus.Error and universeId then
			DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(universeId, function(p2): boolean
				return p2 == nil or p2.creator == nil
			end)

			DataHydration.Game.getAgeRecommendationStore(false).getAndFetchAgeRecommendation(universeId)
		end
	end, { v12, universeId })

	local refresh = React.useCallback(function()
		if universeId and v2 then
			fetchExperienceDetailsPage(universeId, v2, true)
		end
	end, { universeId, v2 })

	if universeId == nil then
		return nil
	end

	local createElement = React.createElement
	local v13 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ref = setState }
	local sheetProvider

	if state then
		local createElement2 = React.createElement
		local topBar

		if FFlagEnableExperienceDetailsBottomSheetTopBar then
			topBar = React.createElement(ExperienceDetailsBottomSheetTopBar, {
				tokens = tokens,
				navigation = navigation,
				deviceInsets = deviceInsets,
				topBarHeight = topBarHeight,
				briefH = snapPoints[1],
				fullH = snapPoints[2],
				overlayFrame = state,
				sheetContentRef = ref,
				shouldMountAsFullView = shouldMountAsFullView,
				onBack = onBack,
				onClose = onClose
			})
		end

		local createElement3 = React.createElement
		local root = Sheet.Root

		if not FFlagLuaAppEdpBottomSheetPeekViewEvents then
			onSnapPointChanged = nil
		end

		local createElement4 = React.createElement
		local content = Sheet.Content

		if not FFlagEnableExperienceDetailsBottomSheetTopBar then
			ref = nil
		end

		local createElement5 = React.createElement
		local view = Foundation.View

		if not FFlagSduiContainerQueries then
			ref4 = nil
		end

		local createElement6 = React.createElement
		local children2 = {
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

		children2.identifier = identifier

		children2.pageTimer = v2
		children2.backgroundStyle = tokens.Color.Surface.Surface_100

		children2.scrollingFrameRef = ref2
		children2.contentTag = CompositionTags.ContentRegion.Body
		children2.loadingSlot = React.createElement(ExperienceDetailsFallbackFeed.Skeleton, {
			universeId = universeId,
			isSmallScreen = true,
			launchSource = "LuaGameCard"
		})

		children2.errorSlot = React.createElement(ExperienceDetailsFallbackFeed.Error, {
			universeId = universeId,
			refresh = refresh,
			isSmallScreen = true,
			launchSource = "LuaGameCard",
			referralSource = referralSource,
			experienceJoinData = experienceJoinData,
			placeIdOverride = placeIdOverride
		})
		local children = {
			Content = createElement4(content, {
				isContentFullBleed = true,
				scrollingFrameRef = ref2,
				ref = ref
			}, {
				ContentWrapper = createElement5(view, { ref = ref4, tag = "col size-full-0 auto-y" }, {
					Content = createElement6(SduiPageEntryPoint, children2)
				})
			}),
			Actions = 0
		}

		local createElement7 = React.createElement
		local actions = Sheet.Actions
		local createElement8 = React.createElement
		local view2 = Foundation.View
		local v14 = {
			tag = "col size-full-0 auto-y",
			padding = UDim.new(0, -tokens.Margin.Small)
		}
		local actionBar

		if FFlagSduiEdpPersistentActionBarPlayButton then
			actionBar = React.createElement(ExperienceDetailsPersistentActionBar, {
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
			actionBar = React.createElement(SduiFeatureEntryPoint, {
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

		children.Actions = createElement7(actions, {}, {
			ActionBarWrapper = createElement8(view2, v14, { ActionBar = actionBar })
		})
		sheetProvider = createElement2(OverlayProvider, { gui = state }, {
			TopBar = topBar,
			SheetRoot = createElement3(root, {
				isOpen = true,
				onClose = onClose2,
				snapPoints = snapPoints,
				defaultSnapPointIndex = defaultSnapPointIndex,
				onSnapPointChanged = onSnapPointChanged,
				testId = "--experience-details-bottom-sheet"
			}, children)
		}) or nil
	end

	return createElement("Frame", v13, { SheetProvider = sheetProvider })
end

return React.memo(ExperienceDetailsBottomSheet)
