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
local FFlagSduiEdpActionBarJitterFix = SharedFlags.FFlagSduiEdpActionBarJitterFix
local FFlagLuaAppEdpBottomSheetPeekViewEvents = SharedFlags.FFlagLuaAppEdpBottomSheetPeekViewEvents

local function ExperienceDetailsPeekView(p1) -- line: 82
	-- upvalues: ExperienceDetailsPageUtils (copy), getExperienceDetailsPageKey (copy), FFlagSduiEdpPageScopeTimerFix (copy), usePageScopeRef (copy), React (copy), SduiSurfaceLoadTimeTracker (copy), EDPTTIConstants (copy), getSduiClientPageScope (copy), useEdpFunctionallyReadyLogger (copy), useTokens (copy), useNavigation (copy), useRoactService (copy), AppEventIngestService (copy), AppSessionService (copy), useDispatch (copy), FFlagLuaAppSduiEdpHideSystemBarOnPeekViewMount (copy), SetTabBarVisible (copy), FFlagSduiPlayWithRewardGapFix (copy), FilterPlayWithReward (copy), useTopBarHeight (copy), useScreenSize (copy), useDeviceInsets (copy), getSafeAreaSize (copy), FFlagSduiEdpActionBarJitterFix (copy), DiscoveryTypes (copy), FFlagSduiPageEntrySurfacing (copy), useEntrySurfacing (copy), ExperienceDetailsPageConstants (copy), useSelector (copy), PeekViewState (copy), FFlagEnableMotionJitterMetric (copy), useMotionJitterMetric (copy), AppPage (copy), SessionType (copy), fetchExperienceDetailsPage (copy), useUiStatus (copy), UiStatus (copy), DataHydration (copy), gameDetailsPeekViewEvents (copy), FFlagLuaAppEdpBottomSheetPeekViewEvents (copy), PeekViewWithTopBar (copy), PeekViewTopBar (copy), SduiPageEntryPoint (copy), FFlagSduiPageEntryUseSharedHooks (copy), CompositionTags (copy), ExperienceDetailsFallbackFeed (copy), FFlagSduiEdpPersistentActionBarPlayButton (copy), ExperienceDetailsPersistentActionBar (copy), SduiFeatureEntryPoint (copy), ExperienceDetailsFallbackActionBar (copy)
	local v61 = ExperienceDetailsPageUtils.getUniverseId(p1)
	local v62 = ExperienceDetailsPageUtils.getAnalyticsSource(p1)
	local v63 = ExperienceDetailsPageUtils.getTilePositionIndex(p1)
	local v64 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "onPeekViewClosed")
	local v65 = getExperienceDetailsPageKey(v61)

	if FFlagSduiEdpPageScopeTimerFix then
		usePageScopeRef(v65)
	end

	local v66 = React.useMemo(function() -- line: 92
		-- upvalues: ExperienceDetailsPageUtils (copy), p1 (copy), FFlagSduiEdpPageScopeTimerFix (copy), SduiSurfaceLoadTimeTracker (copy), v65 (copy), EDPTTIConstants (copy), getSduiClientPageScope (copy)
		local v94 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "pageTimer")

		if FFlagSduiEdpPageScopeTimerFix then
			local v95 = v94 or SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v65, {
				manualSurfaceReady = true,
				eventName = EDPTTIConstants.EDP_TTI_EVENT_NAME,
				metadata = {
					page = "Untracked",
					category = EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_PEEK_VIEW
				}
			})

			getSduiClientPageScope(v65).set(SduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY, v95)

			return v95
		end

		if v94 then
			return v94
		end

		return SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v65, {
			manualSurfaceReady = true,
			eventName = EDPTTIConstants.EDP_TTI_EVENT_NAME,
			metadata = {
				page = "Untracked",
				category = EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_PEEK_VIEW
			}
		})
	end, {})

	useEdpFunctionallyReadyLogger(v66, v61)

	local v67 = useTokens()
	local v68 = useNavigation()
	local v69 = useRoactService(AppEventIngestService)
	local v70 = useRoactService(AppSessionService)
	local v71 = useDispatch()

	if FFlagLuaAppSduiEdpHideSystemBarOnPeekViewMount then
		React.useEffect(function() -- line: 132
			-- upvalues: v71 (copy), SetTabBarVisible (copy)
			v71(SetTabBarVisible(false))
		end, { v71 })
	end

	local v72 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "referralSource")
	local v73 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "experienceJoinData")
	local v74 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "placeIdOverride")

	if not FFlagSduiEdpPageScopeTimerFix then
		usePageScopeRef(v65)
	end

	React.useEffect(function() -- line: 144
		-- upvalues: getSduiClientPageScope (copy), v65 (copy), v72 (copy), v73 (copy), v74 (copy), FFlagSduiPlayWithRewardGapFix (copy), FilterPlayWithReward (copy)
		local v96 = getSduiClientPageScope(v65)

		v96.set("referralSource", v72)
		v96.set("experienceJoinData", v73)
		v96.set("placeId", v74)
		v96.set("launchSource", "LuaGameCard")

		if FFlagSduiPlayWithRewardGapFix then
			v96.set(FilterPlayWithReward, nil)
		end
	end, {
		v65,
		v72,
		v73,
		v74
	})

	local v75 = useTopBarHeight()
	local v76 = useScreenSize()
	local v77 = useDeviceInsets()
	local v78 = math.min(getSafeAreaSize(v76, v77).X.Offset, 640)
	local v79 = React.useRef(nil)
	local v80, v81 = React.useState(function() -- line: 161
		-- upvalues: FFlagSduiEdpActionBarJitterFix (copy), v67 (copy), DiscoveryTypes (copy)
		if FFlagSduiEdpActionBarJitterFix then
			return v67.Padding.Medium + v67.Size.Size_1200
		end

		return DiscoveryTypes.Constants.GAME_DETAILS_ACTION_BAR_HEIGHT
	end)
	local v82 = React.useCallback(function(p2) -- line: 170
		-- upvalues: FFlagSduiEdpActionBarJitterFix (copy), v67 (copy), v81 (copy)
		local AbsoluteSizeY = p2.AbsoluteSize.Y

		if FFlagSduiEdpActionBarJitterFix and AbsoluteSizeY > 0 then
			local v99 = v67.Padding.Medium + v67.Size.Size_1200

			if AbsoluteSizeY <= v99 + v67.Padding.Medium then
				AbsoluteSizeY = v99
			end
		end

		if AbsoluteSizeY > 0 then
			v81(AbsoluteSizeY)
		end
	end, { v67 })
	local v83 = if not FFlagSduiPageEntrySurfacing then nil else useEntrySurfacing(v65, ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER, "peekView")
	local v84 = v83 and v83.heightOffset or 0
	local uDim = UDim.new(0, v78 + v80 + v84)
	local v86 = useSelector(function(p3) -- line: 189
		return p3.GameDetailsPeekView.viewState
	end)
	local v87 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "mountAsFullView")
	local v88 = if v87 == nil then v86 == PeekViewState.Full or v86 == PeekViewState.Extended else v87
	local v89 = v86 == PeekViewState.Closed

	if FFlagEnableMotionJitterMetric then
		useMotionJitterMetric(v79, ExperienceDetailsPageConstants.EDP_PEEK_VIEW_SURFACE, true, "CanvasPosition")
	end

	local v90 = React.useCallback(function() -- line: 207
		-- upvalues: v64 (copy), v68 (copy), AppPage (copy), v70 (copy), SessionType (copy)
		if v64 and typeof(v64) == "function" then
			v64()
		end

		v68.clearAppScreens({ AppPage.GameDetail })

		if v70 then
			v70:RemoveSession(SessionType.StructuralIdentifier.GameDetailSource)
		end
	end, {
		v68,
		v70,
		v64,
		v61,
		v62,
		v63
	})

	React.useEffect(function() -- line: 217
		-- upvalues: v61 (copy), v66 (copy), fetchExperienceDetailsPage (copy)
		if v61 and v66 then
			fetchExperienceDetailsPage(v61, v66)
		end
	end, {
		v61,
		v66
	})

	local v91 = useUiStatus(v65)

	React.useEffect(function() -- line: 224
		-- upvalues: v91 (copy), UiStatus (copy), v61 (copy), DataHydration (copy)
		if v91 == UiStatus.Error and v61 then
			DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(v61, function(p4) -- line: 228
				return p4 == nil or p4.creator == nil
			end)
			DataHydration.Game.getAgeRecommendationStore(false).getAndFetchAgeRecommendation(v61)
		end
	end, {
		v91,
		v61
	})

	local v92 = React.useCallback(function() -- line: 235
		-- upvalues: v61 (copy), v66 (copy), fetchExperienceDetailsPage (copy)
		if v61 and v66 then
			fetchExperienceDetailsPage(v61, v66, true)
		end
	end, {
		v61,
		v66
	})
	local v93 = React.useCallback(function(p5, p6) -- line: 242
		-- upvalues: v61 (copy), PeekViewState (copy), v86 (copy), gameDetailsPeekViewEvents (copy), v69 (copy), v62 (copy), v63 (copy), FFlagLuaAppEdpBottomSheetPeekViewEvents (copy), ExperienceDetailsPageConstants (copy), v71 (copy), v90 (copy)
		local v103 = v61 or ""

		if v61 and p5 == PeekViewState.Brief then
			if v86 == PeekViewState.Brief then
				gameDetailsPeekViewEvents(v69, "SwitchGame", v103, v62, v63, if not FFlagLuaAppEdpBottomSheetPeekViewEvents then nil else ExperienceDetailsPageConstants.EDP_PEEK_VIEW_SURFACE)
			elseif p6 == PeekViewState.Closed then
				gameDetailsPeekViewEvents(v69, "OpenPeekView", v103, v62, v63, if not FFlagLuaAppEdpBottomSheetPeekViewEvents then nil else ExperienceDetailsPageConstants.EDP_PEEK_VIEW_SURFACE)
			end
		end

		v71({
			type = "SetGameDetailsPeekViewState",
			viewState = p5
		})

		if v61 and p5 == PeekViewState.Full and p6 == PeekViewState.Brief then
			gameDetailsPeekViewEvents(v69, "GoToFullView", v103, v62, v63, if not FFlagLuaAppEdpBottomSheetPeekViewEvents then nil else ExperienceDetailsPageConstants.EDP_PEEK_VIEW_SURFACE)
		end

		if p5 == PeekViewState.Closed then
			v90()
		end
	end, {
		v71,
		v69,
		v61,
		v62,
		v63,
		v86,
		v90
	})

	if v61 == nil then
		return nil
	end

	return React.createElement(PeekViewWithTopBar, {
		topBarHeight = v75,
		bottomDockedContainerHeight = v80,
		fullViewContentHeight = UDim.new(1, -v75),
		briefViewContentHeight = uDim,
		onViewStateChanged = v93,
		viewChangedEventMeta = {
			universeId = v61,
			source = v62,
			index = v63
		},
		mountAsFullView = v88,
		mountAnimation = v89,
		scrollingFrameRef = v79,
		topBarSlot = React.createElement(PeekViewTopBar, {
			pageProps = p1,
			onClose = v90
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
				configKey = v65,
				identifier = if not FFlagSduiPageEntryUseSharedHooks then ExperienceDetailsPageUtils.getResolvedIdentifier(v65, ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER_SUFFIX) else ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER,
				pageTimer = v66,
				backgroundStyle = v67.Color.Surface.Surface_100,
				scrollingFrameRef = v79,
				contentTag = CompositionTags.ContentRegion.Body,
				loadingSlot = React.createElement(ExperienceDetailsFallbackFeed.Skeleton, {
					isSmallScreen = true,
					launchSource = "LuaGameCard",
					universeId = v61
				}),
				errorSlot = React.createElement(ExperienceDetailsFallbackFeed.Error, {
					isSmallScreen = true,
					launchSource = "LuaGameCard",
					universeId = v61,
					refresh = v92,
					referralSource = v72,
					experienceJoinData = v73,
					placeIdOverride = v74
				})
			})
		}),
		bottomBarSlot = if not FFlagSduiEdpPersistentActionBarPlayButton then React.createElement(SduiFeatureEntryPoint, {
			appPage = AppPage.GameDetail,
			configKey = v65,
			identifier = ExperienceDetailsPageConstants.EDP_ACTION_BAR_IDENTIFIER,
			loadTimer = v66,
			AutomaticSize = Enum.AutomaticSize.XY,
			onAbsoluteSizeChange = v82,
			loadingSlot = React.createElement(ExperienceDetailsFallbackActionBar.Skeleton, {
				launchSource = "LuaGameCard",
				universeId = v61,
				referralSource = v72,
				experienceJoinData = v73,
				placeIdOverride = v74
			}),
			errorSlot = React.createElement(ExperienceDetailsFallbackActionBar.Error, {
				launchSource = "LuaGameCard",
				universeId = v61,
				referralSource = v72,
				experienceJoinData = v73,
				placeIdOverride = v74
			})
		}) else React.createElement(ExperienceDetailsPersistentActionBar, {
			launchSource = "LuaGameCard",
			universeId = v61,
			configKey = v65,
			loadTimer = v66,
			referralSource = v72,
			experienceJoinData = v73,
			placeIdOverride = v74,
			onAbsoluteSizeChange = v82
		})
	})
end

return React.memo(ExperienceDetailsPeekView)
