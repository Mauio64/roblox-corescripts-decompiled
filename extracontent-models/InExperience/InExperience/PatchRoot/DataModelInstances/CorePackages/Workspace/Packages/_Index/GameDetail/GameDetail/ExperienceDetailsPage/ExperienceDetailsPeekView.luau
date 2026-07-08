local Parent = script:FindFirstAncestor("GameDetail").Parent
local ExperienceDetailsPageUtils = require(script.Parent.ExperienceDetailsPageUtils)
local ExperienceDetailsPageConstants = require(script.Parent.ExperienceDetailsPageConstants)
local ExperienceDetailsPageScopeFields = require(script.Parent.ExperienceDetailsPageScopeFields)
local fetchExperienceDetailsPage = require(script.Parent.fetchExperienceDetailsPage)
local getExperienceDetailsPageKey = require(script.Parent.getExperienceDetailsPageKey)
local PeekViewTopBar = require(script.Parent.PeekViewTopBar)
local useEdpFunctionallyReadyLogger = require(script.Parent.useEdpFunctionallyReadyLogger)
local useMotionJitterMetric = require(script.Parent.useMotionJitterMetric)
local ExperienceDetailsFallbackActionBar = require(script.Parent.Fallback.ExperienceDetailsFallbackActionBar)
local ExperienceDetailsFallbackFeed = require(script.Parent.Fallback.ExperienceDetailsFallbackFeed)
local SetTabBarVisible = require(Parent.AppTabBarRodux).Actions.SetTabBarVisible
local DiscoveryTypes = require(Parent.DiscoveryTypes)
local gameDetailsPeekViewEvents = require(Parent.DiscoveryAnalytics).Events.gameDetailsPeekViewEvents

require(Parent.Navigation)

local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local PeekView = require(Parent.PeekView)
local useTokens = Foundation.Hooks.useTokens
local useNavigation = require(Parent.Navigation).useNavigation
local PeekViewWithTopBar = PeekView.PeekViewWithTopBar
local PeekViewState = PeekView.PeekViewState
local getSafeAreaSize = require(Parent.InputUi).getSafeAreaSize
local useDeviceInsets = require(Parent.Responsive).useDeviceInsets
local DataHydration = require(Parent.DataHydration)
local useTopBarHeight = require(Parent.RobloxAppHooks).useTopBarHeight
local useScreenSize = require(Parent.RobloxAppHooks).useScreenSize
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local RoactServiceTags = require(Parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local AppSessionService = RoactServiceTags.AppSessionService
local SessionType = require(Parent.RobloxAppSessionization).SessionType
local AppPage = require(Parent.RobloxAppEnums).AppPage
local RoactUtils = require(Parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local EDPTTIConstants = require(Parent.GameDetailTelemetry).EDPTTIConstants
local SduiSharedUtilities = require(Parent.SduiSharedUtilities)
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local SduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local UiStatus = SduiSharedUtilities.UiStatus
local useUiStatus = SduiSharedUtilities.useUiStatus
local useEntrySurfacing = SduiSharedUtilities.useEntrySurfacing
local FilterPlayWithReward = ExperienceDetailsPageScopeFields.FilterPlayWithReward
local CompositionTags = require(Parent.AppComposition).CompositionTags
local ExperienceDetailsPersistentActionBar = require(script.Parent.ExperienceDetailsPersistentActionBar)
local SharedFlags = require(Parent.SharedFlags)
local FFlagSduiPageEntryUseSharedHooks = SharedFlags.FFlagSduiPageEntryUseSharedHooks
local FFlagSduiPageEntrySurfacing = SharedFlags.FFlagSduiPageEntrySurfacing
local FFlagLuaAppSduiEdpHideSystemBarOnPeekViewMount = SharedFlags.FFlagLuaAppSduiEdpHideSystemBarOnPeekViewMount
local FFlagSduiEdpPageScopeTimerFix = SharedFlags.FFlagSduiEdpPageScopeTimerFix
local FFlagSduiPlayWithRewardGapFix = SharedFlags.FFlagSduiPlayWithRewardGapFix
local FFlagEnableMotionJitterMetric = SharedFlags.FFlagEnableMotionJitterMetric
local FFlagSduiEdpPersistentActionBarPlayButton = SharedFlags.FFlagSduiEdpPersistentActionBarPlayButton

local function ExperienceDetailsPeekView(p1) -- line: 80
	-- upvalues: ExperienceDetailsPageUtils (copy), getExperienceDetailsPageKey (copy), FFlagSduiEdpPageScopeTimerFix (copy), usePageScopeRef (copy), React (copy), SduiSurfaceLoadTimeTracker (copy), EDPTTIConstants (copy), getSduiClientPageScope (copy), useEdpFunctionallyReadyLogger (copy), useTokens (copy), useNavigation (copy), useRoactService (copy), AppEventIngestService (copy), AppSessionService (copy), useDispatch (copy), FFlagLuaAppSduiEdpHideSystemBarOnPeekViewMount (copy), SetTabBarVisible (copy), FFlagSduiPlayWithRewardGapFix (copy), FilterPlayWithReward (copy), useTopBarHeight (copy), useScreenSize (copy), useDeviceInsets (copy), getSafeAreaSize (copy), DiscoveryTypes (copy), FFlagSduiPageEntrySurfacing (copy), useEntrySurfacing (copy), ExperienceDetailsPageConstants (copy), useSelector (copy), PeekViewState (copy), FFlagEnableMotionJitterMetric (copy), useMotionJitterMetric (copy), AppPage (copy), SessionType (copy), fetchExperienceDetailsPage (copy), useUiStatus (copy), UiStatus (copy), DataHydration (copy), gameDetailsPeekViewEvents (copy), PeekViewWithTopBar (copy), PeekViewTopBar (copy), SduiPageEntryPoint (copy), FFlagSduiPageEntryUseSharedHooks (copy), CompositionTags (copy), ExperienceDetailsFallbackFeed (copy), FFlagSduiEdpPersistentActionBarPlayButton (copy), ExperienceDetailsPersistentActionBar (copy), SduiFeatureEntryPoint (copy), ExperienceDetailsFallbackActionBar (copy)
	local v59 = ExperienceDetailsPageUtils.getUniverseId(p1)
	local v60 = ExperienceDetailsPageUtils.getAnalyticsSource(p1)
	local v61 = ExperienceDetailsPageUtils.getTilePositionIndex(p1)
	local v62 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "onPeekViewClosed")
	local v63 = getExperienceDetailsPageKey(v59)

	if FFlagSduiEdpPageScopeTimerFix then
		usePageScopeRef(v63)
	end

	local v64 = React.useMemo(function() -- line: 90
		-- upvalues: ExperienceDetailsPageUtils (copy), p1 (copy), FFlagSduiEdpPageScopeTimerFix (copy), SduiSurfaceLoadTimeTracker (copy), v63 (copy), EDPTTIConstants (copy), getSduiClientPageScope (copy)
		local v92 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "pageTimer")

		if FFlagSduiEdpPageScopeTimerFix then
			local v93 = v92 or SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v63, {
				manualSurfaceReady = true,
				eventName = EDPTTIConstants.EDP_TTI_EVENT_NAME,
				metadata = {
					page = "Untracked",
					category = EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_PEEK_VIEW
				}
			})

			getSduiClientPageScope(v63).set(SduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY, v93)

			return v93
		end

		if v92 then
			return v92
		end

		return SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v63, {
			manualSurfaceReady = true,
			eventName = EDPTTIConstants.EDP_TTI_EVENT_NAME,
			metadata = {
				page = "Untracked",
				category = EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_PEEK_VIEW
			}
		})
	end, {})

	useEdpFunctionallyReadyLogger(v64, v59)

	local v65 = useTokens()
	local v66 = useNavigation()
	local v67 = useRoactService(AppEventIngestService)
	local v68 = useRoactService(AppSessionService)
	local v69 = useDispatch()

	if FFlagLuaAppSduiEdpHideSystemBarOnPeekViewMount then
		React.useEffect(function() -- line: 130
			-- upvalues: v69 (copy), SetTabBarVisible (copy)
			v69(SetTabBarVisible(false))
		end, { v69 })
	end

	local v70 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "referralSource")
	local v71 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "experienceJoinData")
	local v72 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "placeIdOverride")

	if not FFlagSduiEdpPageScopeTimerFix then
		usePageScopeRef(v63)
	end

	React.useEffect(function() -- line: 142
		-- upvalues: getSduiClientPageScope (copy), v63 (copy), v70 (copy), v71 (copy), v72 (copy), FFlagSduiPlayWithRewardGapFix (copy), FilterPlayWithReward (copy)
		local v94 = getSduiClientPageScope(v63)

		v94.set("referralSource", v70)
		v94.set("experienceJoinData", v71)
		v94.set("placeId", v72)
		v94.set("launchSource", "LuaGameCard")

		if FFlagSduiPlayWithRewardGapFix then
			v94.set(FilterPlayWithReward, nil)
		end
	end, {
		v63,
		v70,
		v71,
		v72
	})

	local v73 = useTopBarHeight()
	local v74 = useScreenSize()
	local v75 = useDeviceInsets()
	local v76 = math.min(getSafeAreaSize(v74, v75).X.Offset, 640)
	local v77 = React.useRef(nil)
	local v78, v79 = React.useState(DiscoveryTypes.Constants.GAME_DETAILS_ACTION_BAR_HEIGHT)
	local v80 = React.useCallback(function(p2) -- line: 161
		-- upvalues: v79 (copy)
		local AbsoluteSizeY = p2.AbsoluteSize.Y

		if AbsoluteSizeY > 0 then
			v79(AbsoluteSizeY)
		end
	end, {})
	local v81 = if not FFlagSduiPageEntrySurfacing then nil else useEntrySurfacing(v63, ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER, "peekView")
	local v82 = v81 and v81.heightOffset or 0
	local uDim = UDim.new(0, v76 + v78 + v82)
	local v84 = useSelector(function(p3) -- line: 173
		return p3.GameDetailsPeekView.viewState
	end)
	local v85 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "mountAsFullView")
	local v86 = if v85 == nil then v84 == PeekViewState.Full or v84 == PeekViewState.Extended else v85
	local v87 = v84 == PeekViewState.Closed

	if FFlagEnableMotionJitterMetric then
		useMotionJitterMetric(v77, "peekView", true, "CanvasPosition")
	end

	local v88 = React.useCallback(function() -- line: 186
		-- upvalues: v62 (copy), v66 (copy), AppPage (copy), v68 (copy), SessionType (copy)
		if v62 and typeof(v62) == "function" then
			v62()
		end

		v66.clearAppScreens({ AppPage.GameDetail })

		if v68 then
			v68:RemoveSession(SessionType.StructuralIdentifier.GameDetailSource)
		end
	end, {
		v66,
		v68,
		v62,
		v59,
		v60,
		v61
	})

	React.useEffect(function() -- line: 196
		-- upvalues: v59 (copy), v64 (copy), fetchExperienceDetailsPage (copy)
		if v59 and v64 then
			fetchExperienceDetailsPage(v59, v64)
		end
	end, {
		v59,
		v64
	})

	local v89 = useUiStatus(v63)

	React.useEffect(function() -- line: 203
		-- upvalues: v89 (copy), UiStatus (copy), v59 (copy), DataHydration (copy)
		if v89 == UiStatus.Error and v59 then
			DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(v59, function(p4) -- line: 207
				return p4 == nil or p4.creator == nil
			end)
			DataHydration.Game.getAgeRecommendationStore(false).getAndFetchAgeRecommendation(v59)
		end
	end, {
		v89,
		v59
	})

	local v90 = React.useCallback(function() -- line: 214
		-- upvalues: v59 (copy), v64 (copy), fetchExperienceDetailsPage (copy)
		if v59 and v64 then
			fetchExperienceDetailsPage(v59, v64, true)
		end
	end, {
		v59,
		v64
	})
	local v91 = React.useCallback(function(p5, p6) -- line: 221
		-- upvalues: v59 (copy), PeekViewState (copy), v84 (copy), gameDetailsPeekViewEvents (copy), v67 (copy), v60 (copy), v61 (copy), v69 (copy), v88 (copy)
		local v100 = v59 or ""

		if v59 and p5 == PeekViewState.Brief then
			if v84 == PeekViewState.Brief then
				gameDetailsPeekViewEvents(v67, "SwitchGame", v100, v60, v61)
			elseif p6 == PeekViewState.Closed then
				gameDetailsPeekViewEvents(v67, "OpenPeekView", v100, v60, v61)
			end
		end

		v69({
			type = "SetGameDetailsPeekViewState",
			viewState = p5
		})

		if v59 and p5 == PeekViewState.Full and p6 == PeekViewState.Brief then
			gameDetailsPeekViewEvents(v67, "GoToFullView", v100, v60, v61)
		end

		if p5 == PeekViewState.Closed then
			v88()
		end
	end, {
		v69,
		v67,
		v59,
		v60,
		v61,
		v84,
		v88
	})

	if v59 == nil then
		return nil
	end

	return React.createElement(PeekViewWithTopBar, {
		topBarHeight = v73,
		bottomDockedContainerHeight = v78,
		fullViewContentHeight = UDim.new(1, -v73),
		briefViewContentHeight = uDim,
		onViewStateChanged = v91,
		viewChangedEventMeta = {
			universeId = v59,
			source = v60,
			index = v61
		},
		mountAsFullView = v86,
		mountAnimation = v87,
		scrollingFrameRef = v77,
		topBarSlot = React.createElement(PeekViewTopBar, {
			pageProps = p1,
			onClose = v88
		}),
		contentSlot = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Content = React.createElement(SduiPageEntryPoint, {
				includeNavigationHeaderBar = false,
				snackbarPortalLayoutOrder = 2147483647,
				appPage = AppPage.GameDetail,
				configKey = v63,
				identifier = if not FFlagSduiPageEntryUseSharedHooks then ExperienceDetailsPageUtils.getResolvedIdentifier(v63, ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER_SUFFIX) else ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER,
				pageTimer = v64,
				backgroundStyle = v65.Color.Surface.Surface_100,
				scrollingFrameRef = v77,
				contentTag = CompositionTags.ContentRegion.Body,
				loadingSlot = React.createElement(ExperienceDetailsFallbackFeed.Skeleton, {
					isSmallScreen = true,
					launchSource = "LuaGameCard",
					universeId = v59
				}),
				errorSlot = React.createElement(ExperienceDetailsFallbackFeed.Error, {
					isSmallScreen = true,
					launchSource = "LuaGameCard",
					universeId = v59,
					refresh = v90,
					referralSource = v70,
					experienceJoinData = v71,
					placeIdOverride = v72
				})
			})
		}),
		bottomBarSlot = if not FFlagSduiEdpPersistentActionBarPlayButton then React.createElement(SduiFeatureEntryPoint, {
			appPage = AppPage.GameDetail,
			configKey = v63,
			identifier = ExperienceDetailsPageConstants.EDP_ACTION_BAR_IDENTIFIER,
			loadTimer = v64,
			AutomaticSize = Enum.AutomaticSize.XY,
			onAbsoluteSizeChange = v80,
			loadingSlot = React.createElement(ExperienceDetailsFallbackActionBar.Skeleton, {
				launchSource = "LuaGameCard",
				universeId = v59,
				referralSource = v70,
				experienceJoinData = v71,
				placeIdOverride = v72
			}),
			errorSlot = React.createElement(ExperienceDetailsFallbackActionBar.Error, {
				launchSource = "LuaGameCard",
				universeId = v59,
				referralSource = v70,
				experienceJoinData = v71,
				placeIdOverride = v72
			})
		}) else React.createElement(ExperienceDetailsPersistentActionBar, {
			launchSource = "LuaGameCard",
			universeId = v59,
			configKey = v63,
			loadTimer = v64,
			referralSource = v70,
			experienceJoinData = v71,
			placeIdOverride = v72,
			onAbsoluteSizeChange = v80
		})
	})
end

return React.memo(ExperienceDetailsPeekView)
