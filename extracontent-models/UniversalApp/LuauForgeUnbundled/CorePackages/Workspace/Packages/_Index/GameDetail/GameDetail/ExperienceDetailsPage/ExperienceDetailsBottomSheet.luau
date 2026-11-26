local FFlagSduiEdpRenderStarted = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/Flags/FFlagSduiEdpRenderStarted")
local ExperienceDetailsPageUtils = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/ExperienceDetailsPageUtils")
local ExperienceDetailsPageConstants = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/ExperienceDetailsPageConstants")
local ExperienceDetailsPageScopeFields = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/ExperienceDetailsPageScopeFields")
local ExperienceDetailsBottomSheetTopBar = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/ExperienceDetailsBottomSheetTopBar")
local fetchExperienceDetailsPage = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/fetchExperienceDetailsPage")
local getExperienceDetailsPageKey = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/getExperienceDetailsPageKey")
local removeGameDetailSessionIfDeparted = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/removeGameDetailSessionIfDeparted")
local useEdpFunctionallyReadyLogger = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/useEdpFunctionallyReadyLogger")
local createExperienceDetailsPageTimer = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/createExperienceDetailsPageTimer")
local useMotionJitterMetric = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/useMotionJitterMetric")
local ExperienceDetailsFallbackActionBar = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/Fallback/ExperienceDetailsFallbackActionBar")
local ExperienceDetailsFallbackFeed = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/Fallback/ExperienceDetailsFallbackFeed")

local setTabBarVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/AppTabBarRodux").Actions.SetTabBarVisible
local DiscoveryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/DiscoveryTypes")
local gameDetailsPeekViewEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/DiscoveryAnalytics").Events.gameDetailsPeekViewEvents

local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Navigation")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/React")
local sheet = Foundation.Sheet
local overlayProvider = Foundation.OverlayProvider
local useTokens = Foundation.Hooks.useTokens
local useNavigation = Navigation.useNavigation
local getSafeAreaSize = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/InputUi").getSafeAreaSize
local useDeviceInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Responsive").useDeviceInsets
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/DataHydration")

local useTopBarHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppHooks").useTopBarHeight
local shouldUseDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Display").shouldUseDeviceSafeInsets
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppHooks").useScreenSize
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppHooks").useRoactService
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RoactServiceTags")
local appEventIngestService = RoactServiceTags.AppEventIngestService
local appSessionService = RoactServiceTags.AppSessionService
local sessionType = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppSessionization").SessionType
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppEnums").AppPage

local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local useGetCurrentLegacyRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/DiscoveryRouting").useGetCurrentLegacyRoute
local hasPageInCurrentRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/DiscoveryRouting").hasPageInCurrentRoute
local peekViewState = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/PeekView").PeekViewState
local SetGameDetailsPeekViewState = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/PeekView/SetGameDetailsPeekViewState")
local edpttiConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/GameDetailTelemetry").EDPTTIConstants

local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SduiSharedUtilities")
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local sduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local sduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local sduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local uiStatus = SduiSharedUtilities.UiStatus
local usePublishContainerWidth = SduiSharedUtilities.usePublishContainerWidth
local useUiStatus = SduiSharedUtilities.useUiStatus
local useEntrySurfacing = SduiSharedUtilities.useEntrySurfacing
local filterPlayWithReward = ExperienceDetailsPageScopeFields.FilterPlayWithReward

local compositionTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/AppComposition").CompositionTags

local ExperienceDetailsPersistentActionBar = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/ExperienceDetailsPersistentActionBar")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SharedFlags")
local fFlagSduiContainerQueries = SharedFlags.FFlagSduiContainerQueries
local fFlagEDPTTIParityDefinitions = SharedFlags.FFlagEDPTTIParityDefinitions
local fFlagSduiPageEntryUseSharedHooks = SharedFlags.FFlagSduiPageEntryUseSharedHooks
local fFlagEnableExperienceDetailsBottomSheetTopBar = SharedFlags.FFlagEnableExperienceDetailsBottomSheetTopBar
local fFlagEnableMotionJitterMetric = SharedFlags.FFlagEnableMotionJitterMetric
local fFlagSduiEdpPersistentActionBarPlayButton = SharedFlags.FFlagSduiEdpPersistentActionBarPlayButton
local fFlagLuaAppEdpBottomSheetPeekViewEvents = SharedFlags.FFlagLuaAppEdpBottomSheetPeekViewEvents
local fFlagSduiPlayWithRewardRefactor = SharedFlags.FFlagSduiPlayWithRewardRefactor
local fFlagFixOverlayTopInsetForDeviceSafeInsets = SharedFlags.FFlagFixOverlayTopInsetForDeviceSafeInsets

local function snapPointIndexFor(p2): number
	if p2 then
		return 2
	end

	return 1
end

local function ExperienceDetailsBottomSheet(p2)
	local universeId = ExperienceDetailsPageUtils.getUniverseId(p2)
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
	local v10 = useRoactService(appSessionService)
	local v11 = useDispatch()
	local v12

	if fFlagLuaAppEdpBottomSheetPeekViewEvents then
		v12 = useRoactService(appEventIngestService)
	else
		v12 = nil
	end

	local v13 = useGetCurrentLegacyRoute()

	React.useEffect(function()
		v11(setTabBarVisible(false))
	end, { v11 })

	local v14 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p2, "referralSource")
	local v15 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p2, "experienceJoinData")
	local v16 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p2, "placeIdOverride")

	React.useEffect(function()
		local sduiClientPageScope = getSduiClientPageScope(v6)
		sduiClientPageScope.set("referralSource", v14)
		sduiClientPageScope.set("experienceJoinData", v15)
		sduiClientPageScope.set("placeId", v16)
		sduiClientPageScope.set("launchSource", "LuaGameCard")

		if fFlagSduiPlayWithRewardRefactor then
			sduiClientPageScope.set(filterPlayWithReward, nil)
		end
	end, { v6, v14, v15, v16 })

	local v17 = if fFlagEnableExperienceDetailsBottomSheetTopBar then useTopBarHeight() else nil

	local v18 = useScreenSize()
	local v19 = useDeviceInsets()

	if
		fFlagEnableExperienceDetailsBottomSheetTopBar
		and fFlagFixOverlayTopInsetForDeviceSafeInsets
		and shouldUseDeviceSafeInsets
	then
		v17 += v19.top
	end

	local safeAreaSize = getSafeAreaSize(v18, v19)
	local v20 = math.min(safeAreaSize.X.Offset, 640)

	local v21 = if fFlagSduiContainerQueries then usePublishContainerWidth(v6) else nil

	local ref = if fFlagEnableExperienceDetailsBottomSheetTopBar then React.useRef(nil) else nil

	local ref2 = React.useRef(nil)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(DiscoveryTypes.Constants.GAME_DETAILS_ACTION_BAR_HEIGHT)

	local v22 = React.useCallback(function(p3)
		local y = p3.AbsoluteSize.Y

		if y > 0 then
			setState2(y)
		end
	end, {})

	local v23 = useEntrySurfacing(v6, ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER, "peekView")
	local heightOffset = v23 and v23.heightOffset or 0

	local useMemo = React.useMemo
	local function fn()
		local v24 = v20 + state2 + heightOffset + 25

		local v25 = if fFlagEnableExperienceDetailsBottomSheetTopBar then math.ceil(v18.Y) - v19.bottom - v17 else safeAreaSize.Y.Offset
		return { v24, v25 }
	end

	local v24

	if fFlagEnableExperienceDetailsBottomSheetTopBar then
		v24 = { v20, state2, heightOffset, v18.Y, v19.bottom, v17 }
	else
		v24 = { v20, state2, heightOffset, safeAreaSize.Y.Offset }
	end

	local v25 = useMemo(fn, v24)

	local v26 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p2, "mountAsFullView")
	local v27 = v26 == true
	local v28

	if fFlagLuaAppEdpBottomSheetPeekViewEvents then
		local v29 = useStore()
		local analyticsSource = ExperienceDetailsPageUtils.getAnalyticsSource(p2)
		local tilePositionIndex = ExperienceDetailsPageUtils.getTilePositionIndex(p2)

		local v30 = React.useMemo(function()
			return v29:getState().GameDetailsPeekView.viewState
		end, {})

		if v26 == nil then
			v27 = v30 == peekViewState.Full or v30 == peekViewState.Extended
		else
			v27 = v26 == true
		end

		React.useEffect(function()
			local v31 = universeId
				and not v27
				and (v30 == peekViewState.Brief and "SwitchGame" or v30 == peekViewState.Closed and "OpenPeekView" or nil)

			if v31 then
				gameDetailsPeekViewEvents(
					v12,
					v31,
					universeId,
					analyticsSource,
					tilePositionIndex,
					ExperienceDetailsPageConstants.EDP_BOTTOM_SHEET_SURFACE
				)
			end

			local v34 = if v27 then peekViewState.Full else peekViewState.Brief
			v11(SetGameDetailsPeekViewState(v34))

			return function()
				if not hasPageInCurrentRoute(v13(), appPage.GameDetail) then
					v11(SetGameDetailsPeekViewState(peekViewState.Closed))
				end
			end
		end, {})

		local ref3 = React.useRef(v27 and 2 or 1)
		v28 = React.useCallback(function(p3, current)
			local current2 = ref3.current
			ref3.current = current

			if v9.isFocused() then
				local v33 = if current == 2 then peekViewState.Full else peekViewState.Brief
				v11(SetGameDetailsPeekViewState(v33))
			end

			if universeId and current2 == 1 and current == 2 then
				gameDetailsPeekViewEvents(
					v12,
					"GoToFullView",
					universeId,
					analyticsSource,
					tilePositionIndex,
					ExperienceDetailsPageConstants.EDP_BOTTOM_SHEET_SURFACE
				)
			end
		end, { v12, universeId, analyticsSource, tilePositionIndex, v11, v9 })
	end

	local v29 = v27 and 2 or 1

	if fFlagEnableMotionJitterMetric then
		useMotionJitterMetric(ref2, ExperienceDetailsPageConstants.EDP_BOTTOM_SHEET_SURFACE, false, "AbsolutePosition")
	end

	local v30 = React.useCallback(function()
		if v9.isFocused() then
			local v31 = v13()

			if v5 and typeof(v5) == "function" then
				v5()
			end

			v9.goBack()
			removeGameDetailSessionIfDeparted(v10, v31)
		end
	end, { v9, v10, v5, v13 })

	local v31 = React.useCallback(function()
		if v9.isFocused() then
			if v5 and typeof(v5) == "function" then
				v5()
			end

			v9.clearAppScreens({ appPage.GameDetail })

			if v10 then
				v10:RemoveSession(sessionType.StructuralIdentifier.GameDetailSource)
			end
		end
	end, { v9, v10, v5 })
	local v32 = if fFlagLuaAppEdpBottomSheetPeekViewEvents then v31 elseif v27 then v30 else v31
	React.useEffect(function()
		if universeId and v7 then
			fetchExperienceDetailsPage(universeId, v7)
		end
	end, { universeId, v7 })

	local v33 = useUiStatus(v6)
	React.useEffect(function()
		if v33 == uiStatus.Error and universeId then
			DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(universeId, function(p3): boolean
				return p3 == nil or p3.creator == nil
			end)

			DataHydration.Game.getAgeRecommendationStore(false).getAndFetchAgeRecommendation(universeId)
		end
	end, { v33, universeId })

	local v34 = React.useCallback(function()
		if universeId and v7 then
			fetchExperienceDetailsPage(universeId, v7, true)
		end
	end, { universeId, v7 })

	if universeId == nil then
		return nil
	end

	local createElement = React.createElement
	local v36 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ref = setState
	}
	local v38

	if state then
		local createElement2 = React.createElement

		local v42 = if fFlagEnableExperienceDetailsBottomSheetTopBar then React.createElement(ExperienceDetailsBottomSheetTopBar, {
			tokens = v8,
			navigation = v9,
			deviceInsets = v19,
			topBarHeight = v17,
			briefH = v25[1],
			fullH = v25[2],
			overlayFrame = state,
			sheetContentRef = ref,
			shouldMountAsFullView = v27,
			onBack = v30,
			onClose = v31
		}) else nil

		local createElement3 = React.createElement
		local root = sheet.Root

		if not fFlagLuaAppEdpBottomSheetPeekViewEvents then
			v28 = nil
		end

		local createElement4 = React.createElement
		local content = sheet.Content

		if not fFlagEnableExperienceDetailsBottomSheetTopBar then
			ref = nil
		end

		local createElement5 = React.createElement
		local view = Foundation.View

		if not fFlagSduiContainerQueries then
			v21 = nil
		end

		local createElement6 = React.createElement
		local children2 = {
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

		local v49 = if fFlagSduiPageEntryUseSharedHooks then ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER else ExperienceDetailsPageUtils.getResolvedIdentifier(
			v6,
			ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER_SUFFIX
		)
		children2.identifier = v49

		children2.pageTimer = v7
		children2.backgroundStyle = v8.Color.Surface.Surface_100

		children2.scrollingFrameRef = ref2
		children2.contentTag = compositionTags.ContentRegion.Body
		children2.loadingSlot = React.createElement(ExperienceDetailsFallbackFeed.Skeleton, {
			universeId = universeId,
			isSmallScreen = true,
			launchSource = "LuaGameCard"
		})

		children2.errorSlot = React.createElement(ExperienceDetailsFallbackFeed.Error, {
			universeId = universeId,
			refresh = v34,
			isSmallScreen = true,
			launchSource = "LuaGameCard",
			referralSource = v14,
			experienceJoinData = v15,
			placeIdOverride = v16
		})
		local children = {
			Content = createElement4(
				content,
				{ isContentFullBleed = true, scrollingFrameRef = ref2, ref = ref },
				{
					ContentWrapper = createElement5(view, {
						ref = v21,
						tag = "col size-full-0 auto-y"
					}, {
						Content = createElement6(sduiPageEntryPoint, children2)
					})
				}
			),
			Actions = 0
		}

		local createElement7 = React.createElement
		local actions = sheet.Actions
		local createElement8 = React.createElement
		local view2 = Foundation.View
		local v52 = {
			tag = "col size-full-0 auto-y",
			padding = UDim.new(0, -v8.Margin.Small)
		}
		local v54

		if fFlagSduiEdpPersistentActionBarPlayButton then
			v54 = React.createElement(ExperienceDetailsPersistentActionBar, {
				universeId = universeId,
				configKey = v6,
				loadTimer = v7,
				launchSource = "LuaGameCard",
				referralSource = v14,
				experienceJoinData = v15,
				placeIdOverride = v16,
				onAbsoluteSizeChange = v22
			})
		else
			v54 = React.createElement(sduiFeatureEntryPoint, {
				appPage = appPage.GameDetail,
				configKey = v6,
				identifier = ExperienceDetailsPageConstants.EDP_ACTION_BAR_IDENTIFIER,
				loadTimer = v7,
				AutomaticSize = Enum.AutomaticSize.XY,
				onAbsoluteSizeChange = v22,
				loadingSlot = React.createElement(ExperienceDetailsFallbackActionBar.Skeleton, {
					universeId = universeId,
					launchSource = "LuaGameCard",
					referralSource = v14,
					experienceJoinData = v15,
					placeIdOverride = v16
				}),
				errorSlot = React.createElement(ExperienceDetailsFallbackActionBar.Error, {
					universeId = universeId,
					launchSource = "LuaGameCard",
					referralSource = v14,
					experienceJoinData = v15,
					placeIdOverride = v16
				})
			})
		end

		children.Actions = createElement7(actions, {}, {
			ActionBarWrapper = createElement8(view2, v52, { ActionBar = v54 })
		})
		v38 = createElement2(overlayProvider, { gui = state }, {
			TopBar = v42,
			SheetRoot = createElement3(root, {
				isOpen = true,
				onClose = v32,
				snapPoints = v25,
				defaultSnapPointIndex = v29,
				onSnapPointChanged = v28,
				testId = "--experience-details-bottom-sheet"
			}, children)
		}) or nil
	end

	return createElement("Frame", v36, { SheetProvider = v38 })
end

return React.memo(ExperienceDetailsBottomSheet)
