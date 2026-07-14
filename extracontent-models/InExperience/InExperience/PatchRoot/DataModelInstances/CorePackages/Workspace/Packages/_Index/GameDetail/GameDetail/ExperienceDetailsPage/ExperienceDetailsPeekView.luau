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

local function ExperienceDetailsPeekView(p1) -- line: 81
	-- upvalues: ExperienceDetailsPageUtils (copy), getExperienceDetailsPageKey (copy), FFlagSduiEdpPageScopeTimerFix (copy), usePageScopeRef (copy), React (copy), SduiSurfaceLoadTimeTracker (copy), EDPTTIConstants (copy), getSduiClientPageScope (copy), useEdpFunctionallyReadyLogger (copy), useTokens (copy), useNavigation (copy), useRoactService (copy), AppEventIngestService (copy), AppSessionService (copy), useDispatch (copy), FFlagLuaAppSduiEdpHideSystemBarOnPeekViewMount (copy), SetTabBarVisible (copy), FFlagSduiPlayWithRewardGapFix (copy), FilterPlayWithReward (copy), useTopBarHeight (copy), useScreenSize (copy), useDeviceInsets (copy), getSafeAreaSize (copy), FFlagSduiEdpActionBarJitterFix (copy), DiscoveryTypes (copy), FFlagSduiPageEntrySurfacing (copy), useEntrySurfacing (copy), ExperienceDetailsPageConstants (copy), useSelector (copy), PeekViewState (copy), FFlagEnableMotionJitterMetric (copy), useMotionJitterMetric (copy), AppPage (copy), SessionType (copy), fetchExperienceDetailsPage (copy), useUiStatus (copy), UiStatus (copy), DataHydration (copy), gameDetailsPeekViewEvents (copy), PeekViewWithTopBar (copy), PeekViewTopBar (copy), SduiPageEntryPoint (copy), FFlagSduiPageEntryUseSharedHooks (copy), CompositionTags (copy), ExperienceDetailsFallbackFeed (copy), FFlagSduiEdpPersistentActionBarPlayButton (copy), ExperienceDetailsPersistentActionBar (copy), SduiFeatureEntryPoint (copy), ExperienceDetailsFallbackActionBar (copy)
	local v60 = ExperienceDetailsPageUtils.getUniverseId(p1)
	local v61 = ExperienceDetailsPageUtils.getAnalyticsSource(p1)
	local v62 = ExperienceDetailsPageUtils.getTilePositionIndex(p1)
	local v63 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "onPeekViewClosed")
	local v64 = getExperienceDetailsPageKey(v60)

	if FFlagSduiEdpPageScopeTimerFix then
		usePageScopeRef(v64)
	end

	local v65 = React.useMemo(function() -- line: 91
		-- upvalues: ExperienceDetailsPageUtils (copy), p1 (copy), FFlagSduiEdpPageScopeTimerFix (copy), SduiSurfaceLoadTimeTracker (copy), v64 (copy), EDPTTIConstants (copy), getSduiClientPageScope (copy)
		local v93 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "pageTimer")

		if FFlagSduiEdpPageScopeTimerFix then
			local v94 = v93 or SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v64, {
				manualSurfaceReady = true,
				eventName = EDPTTIConstants.EDP_TTI_EVENT_NAME,
				metadata = {
					page = "Untracked",
					category = EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_PEEK_VIEW
				}
			})

			getSduiClientPageScope(v64).set(SduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY, v94)

			return v94
		end

		if v93 then
			return v93
		end

		return SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v64, {
			manualSurfaceReady = true,
			eventName = EDPTTIConstants.EDP_TTI_EVENT_NAME,
			metadata = {
				page = "Untracked",
				category = EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_PEEK_VIEW
			}
		})
	end, {})

	useEdpFunctionallyReadyLogger(v65, v60)

	local v66 = useTokens()
	local v67 = useNavigation()
	local v68 = useRoactService(AppEventIngestService)
	local v69 = useRoactService(AppSessionService)
	local v70 = useDispatch()

	if FFlagLuaAppSduiEdpHideSystemBarOnPeekViewMount then
		React.useEffect(function() -- line: 131
			-- upvalues: v70 (copy), SetTabBarVisible (copy)
			v70(SetTabBarVisible(false))
		end, { v70 })
	end

	local v71 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "referralSource")
	local v72 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "experienceJoinData")
	local v73 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "placeIdOverride")

	if not FFlagSduiEdpPageScopeTimerFix then
		usePageScopeRef(v64)
	end

	React.useEffect(function() -- line: 143
		-- upvalues: getSduiClientPageScope (copy), v64 (copy), v71 (copy), v72 (copy), v73 (copy), FFlagSduiPlayWithRewardGapFix (copy), FilterPlayWithReward (copy)
		local v95 = getSduiClientPageScope(v64)

		v95.set("referralSource", v71)
		v95.set("experienceJoinData", v72)
		v95.set("placeId", v73)
		v95.set("launchSource", "LuaGameCard")

		if FFlagSduiPlayWithRewardGapFix then
			v95.set(FilterPlayWithReward, nil)
		end
	end, {
		v64,
		v71,
		v72,
		v73
	})

	local v74 = useTopBarHeight()
	local v75 = useScreenSize()
	local v76 = useDeviceInsets()
	local v77 = math.min(getSafeAreaSize(v75, v76).X.Offset, 640)
	local v78 = React.useRef(nil)
	local v79, v80 = React.useState(function() -- line: 160
		-- upvalues: FFlagSduiEdpActionBarJitterFix (copy), v66 (copy), DiscoveryTypes (copy)
		if FFlagSduiEdpActionBarJitterFix then
			return v66.Padding.Medium + v66.Size.Size_1200
		end

		return DiscoveryTypes.Constants.GAME_DETAILS_ACTION_BAR_HEIGHT
	end)
	local v81 = React.useCallback(function(p2) -- line: 169
		-- upvalues: FFlagSduiEdpActionBarJitterFix (copy), v66 (copy), v80 (copy)
		local AbsoluteSizeY = p2.AbsoluteSize.Y

		if FFlagSduiEdpActionBarJitterFix and AbsoluteSizeY > 0 then
			local v98 = v66.Padding.Medium + v66.Size.Size_1200

			if AbsoluteSizeY <= v98 + v66.Padding.Medium then
				AbsoluteSizeY = v98
			end
		end

		if AbsoluteSizeY > 0 then
			v80(AbsoluteSizeY)
		end
	end, { v66 })
	local v82 = if not FFlagSduiPageEntrySurfacing then nil else useEntrySurfacing(v64, ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER, "peekView")
	local v83 = v82 and v82.heightOffset or 0
	local uDim = UDim.new(0, v77 + v79 + v83)
	local v85 = useSelector(function(p3) -- line: 188
		return p3.GameDetailsPeekView.viewState
	end)
	local v86 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "mountAsFullView")
	local v87 = if v86 == nil then v85 == PeekViewState.Full or v85 == PeekViewState.Extended else v86
	local v88 = v85 == PeekViewState.Closed

	if FFlagEnableMotionJitterMetric then
		useMotionJitterMetric(v78, "peekView", true, "CanvasPosition")
	end

	local v89 = React.useCallback(function() -- line: 201
		-- upvalues: v63 (copy), v67 (copy), AppPage (copy), v69 (copy), SessionType (copy)
		if v63 and typeof(v63) == "function" then
			v63()
		end

		v67.clearAppScreens({ AppPage.GameDetail })

		if v69 then
			v69:RemoveSession(SessionType.StructuralIdentifier.GameDetailSource)
		end
	end, {
		v67,
		v69,
		v63,
		v60,
		v61,
		v62
	})

	React.useEffect(function() -- line: 211
		-- upvalues: v60 (copy), v65 (copy), fetchExperienceDetailsPage (copy)
		if v60 and v65 then
			fetchExperienceDetailsPage(v60, v65)
		end
	end, {
		v60,
		v65
	})

	local v90 = useUiStatus(v64)

	React.useEffect(function() -- line: 218
		-- upvalues: v90 (copy), UiStatus (copy), v60 (copy), DataHydration (copy)
		if v90 == UiStatus.Error and v60 then
			DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(v60, function(p4) -- line: 222
				return p4 == nil or p4.creator == nil
			end)
			DataHydration.Game.getAgeRecommendationStore(false).getAndFetchAgeRecommendation(v60)
		end
	end, {
		v90,
		v60
	})

	local v91 = React.useCallback(function() -- line: 229
		-- upvalues: v60 (copy), v65 (copy), fetchExperienceDetailsPage (copy)
		if v60 and v65 then
			fetchExperienceDetailsPage(v60, v65, true)
		end
	end, {
		v60,
		v65
	})
	local v92 = React.useCallback(function(p5, p6) -- line: 236
		-- upvalues: v60 (copy), PeekViewState (copy), v85 (copy), gameDetailsPeekViewEvents (copy), v68 (copy), v61 (copy), v62 (copy), v70 (copy), v89 (copy)
		local v102 = v60 or ""

		if v60 and p5 == PeekViewState.Brief then
			if v85 == PeekViewState.Brief then
				gameDetailsPeekViewEvents(v68, "SwitchGame", v102, v61, v62)
			elseif p6 == PeekViewState.Closed then
				gameDetailsPeekViewEvents(v68, "OpenPeekView", v102, v61, v62)
			end
		end

		v70({
			type = "SetGameDetailsPeekViewState",
			viewState = p5
		})

		if v60 and p5 == PeekViewState.Full and p6 == PeekViewState.Brief then
			gameDetailsPeekViewEvents(v68, "GoToFullView", v102, v61, v62)
		end

		if p5 == PeekViewState.Closed then
			v89()
		end
	end, {
		v70,
		v68,
		v60,
		v61,
		v62,
		v85,
		v89
	})

	if v60 == nil then
		return nil
	end

	return React.createElement(PeekViewWithTopBar, {
		topBarHeight = v74,
		bottomDockedContainerHeight = v79,
		fullViewContentHeight = UDim.new(1, -v74),
		briefViewContentHeight = uDim,
		onViewStateChanged = v92,
		viewChangedEventMeta = {
			universeId = v60,
			source = v61,
			index = v62
		},
		mountAsFullView = v87,
		mountAnimation = v88,
		scrollingFrameRef = v78,
		topBarSlot = React.createElement(PeekViewTopBar, {
			pageProps = p1,
			onClose = v89
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
				configKey = v64,
				identifier = if not FFlagSduiPageEntryUseSharedHooks then ExperienceDetailsPageUtils.getResolvedIdentifier(v64, ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER_SUFFIX) else ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER,
				pageTimer = v65,
				backgroundStyle = v66.Color.Surface.Surface_100,
				scrollingFrameRef = v78,
				contentTag = CompositionTags.ContentRegion.Body,
				loadingSlot = React.createElement(ExperienceDetailsFallbackFeed.Skeleton, {
					isSmallScreen = true,
					launchSource = "LuaGameCard",
					universeId = v60
				}),
				errorSlot = React.createElement(ExperienceDetailsFallbackFeed.Error, {
					isSmallScreen = true,
					launchSource = "LuaGameCard",
					universeId = v60,
					refresh = v91,
					referralSource = v71,
					experienceJoinData = v72,
					placeIdOverride = v73
				})
			})
		}),
		bottomBarSlot = if not FFlagSduiEdpPersistentActionBarPlayButton then React.createElement(SduiFeatureEntryPoint, {
			appPage = AppPage.GameDetail,
			configKey = v64,
			identifier = ExperienceDetailsPageConstants.EDP_ACTION_BAR_IDENTIFIER,
			loadTimer = v65,
			AutomaticSize = Enum.AutomaticSize.XY,
			onAbsoluteSizeChange = v81,
			loadingSlot = React.createElement(ExperienceDetailsFallbackActionBar.Skeleton, {
				launchSource = "LuaGameCard",
				universeId = v60,
				referralSource = v71,
				experienceJoinData = v72,
				placeIdOverride = v73
			}),
			errorSlot = React.createElement(ExperienceDetailsFallbackActionBar.Error, {
				launchSource = "LuaGameCard",
				universeId = v60,
				referralSource = v71,
				experienceJoinData = v72,
				placeIdOverride = v73
			})
		}) else React.createElement(ExperienceDetailsPersistentActionBar, {
			launchSource = "LuaGameCard",
			universeId = v60,
			configKey = v64,
			loadTimer = v65,
			referralSource = v71,
			experienceJoinData = v72,
			placeIdOverride = v73,
			onAbsoluteSizeChange = v81
		})
	})
end

return React.memo(ExperienceDetailsPeekView)
