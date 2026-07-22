local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Foundation = require(MomentsParent.Foundation)
local React = require(MomentsParent.React)
local AppPage = require(MomentsParent.RobloxAppEnums).AppPage
local RobloxAppEvents = require(MomentsParent.RobloxAppEvents)
local View = Foundation.View
local TopBar = require(Moments.Components.TopBar)
local MomentsFeedSurface = require(Moments.Components.MomentsFeedSurface)
local Feed = require(Moments.Components.Feed)
local CreationFlowScreen = require(MomentsParent.MomentsCreation).CreationFlowScreen
local FTUXEducationScreen = require(Moments.Components.FTUXEducationScreen)
local useMomentsHost = require(Moments.MomentsHostContext).useMomentsHost
local Constants = require(Moments.Constants)
local useScreenBottomInset = require(Moments.Hooks.useScreenBottomInset)
local useFeedPlaybackActive = require(Moments.Hooks.useFeedPlaybackActive)
local useCreationEntry = require(Moments.Hooks.useCreationEntry)
local useUploadHost = require(Moments.Hooks.useUploadHost)
local logCreateIntent = require(Moments.Analytics.logCreateIntent)
local GetUploadStore = require(Moments.Stores.GetUploadStore)
local SignalsReact = require(MomentsParent.SignalsReact)
local MomentOverlayInsetContext = require(Moments.Components.Feed.Items.Moment.MomentOverlayInsetContext)
local FFlagMomentsImmersiveChrome = require(Moments.Flags.FFlagMomentsImmersiveChrome)
local FFlagMomentsUseCompositionLibrary = require(Moments.Flags.FFlagMomentsUseCompositionLibrary)
local FFlagMomentsUseFoundationHeaderBar = require(Moments.Flags.FFlagMomentsUseFoundationHeaderBar)
local GetFFlagMomentsRefreshFromTopAfterUpload = require(Moments.Flags.GetFFlagMomentsRefreshFromTopAfterUpload)
local GetFFlagMomentsFixBackgroundFeedInput = require(Moments.Flags.GetFFlagMomentsFixBackgroundFeedInput)
local GetFFlagMomentsFixUnavailableDeeplink = require(Moments.Flags.GetFFlagMomentsFixUnavailableDeeplink)
local GetImmersiveChromeStore = require(Moments.Stores.GetImmersiveChromeStore)
local MomentsLocalStorage = require(Moments.Storage.MomentsLocalStorage)
local MomentsLocalStorageKeys = require(Moments.Storage.MomentsLocalStorageKeys)
local useMomentsSession = require(Moments.Stores.GetMomentsStore.MomentsSessionContext).useMomentsSession
local createMomentsFeedSource = require(Moments.Stores.GetMomentsStore.createMomentsFeedSource)
local createSignalTracker = require(Moments.SignalTracker).createSignalTracker
local FFlagEnableArgus = require(MomentsParent.SharedFlags).FFlagEnableArgus
local isStudio = require(MomentsParent.MomentsCommon.isStudio)
local GetFFlagArgusStudioMockFeed = require(Moments.Flags.GetFFlagArgusStudioMockFeed)
local createMockFeedSource = Feed.createMockFeedSource
local v39 = if not FFlagEnableArgus then nil else createSignalTracker()
local v40 = GetFFlagMomentsFixUnavailableDeeplink()
local v41 = if not v40 then nil else require(Moments.Components.MomentUnavailableDialog)
local createRecommendationTelemetry = Feed.createRecommendationTelemetry
local MomentsCommon = require(MomentsParent.MomentsCommon)
local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local SessionManager = Analytics.SessionManager
local FunnelEventNames = Analytics.FunnelEventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local fireFunnelAnalyticsEvent = Analytics.fireFunnelAnalyticsEvent
local useMomentsGating = MomentsCommon.Hooks.useMomentsGating

local function TrendingScreen(_: {[any]: any}) -- line: 95
	-- upvalues: React (copy), MomentsLocalStorage (copy), MomentsLocalStorageKeys (copy), useScreenBottomInset (copy), useFeedPlaybackActive (copy), useMomentsSession (copy), useMomentsHost (copy), FFlagMomentsUseFoundationHeaderBar (copy), useMomentsGating (copy), useCreationEntry (copy), useUploadHost (copy), SessionManager (copy), FunnelEventNames (copy), fireFunnelAnalyticsEvent (copy), v40 (copy), isStudio (copy), GetFFlagArgusStudioMockFeed (copy), createMockFeedSource (copy), createMomentsFeedSource (copy), v39 (copy), FFlagEnableArgus (copy), createRecommendationTelemetry (copy), FFlagMomentsImmersiveChrome (copy), SignalsReact (copy), GetImmersiveChromeStore (copy), GetFFlagMomentsFixBackgroundFeedInput (copy), RobloxAppEvents (copy), AppPage (copy), GetUploadStore (copy), GetFFlagMomentsRefreshFromTopAfterUpload (copy), logCreateIntent (copy), fireAnalyticsEvent (copy), EventNames (copy), TopBar (copy), MomentOverlayInsetContext (copy), View (copy), Constants (copy), FFlagMomentsUseCompositionLibrary (copy), MomentsFeedSurface (copy), v41 (copy), CreationFlowScreen (copy), FTUXEducationScreen (copy)
	local v53, v54 = React.useState(function() -- line: 96
		-- upvalues: MomentsLocalStorage (copy), MomentsLocalStorageKeys (copy)
		return not MomentsLocalStorage.getField(MomentsLocalStorageKeys.CreateTooltipSeen)
	end)
	local v55, v56 = React.useState(false)
	local v57 = React.useRef(nil)
	local v58 = React.useRef(nil)
	local v59 = useScreenBottomInset()
	local v60 = useFeedPlaybackActive()
	local v61 = useMomentsSession()
	local openOwnMoments = useMomentsHost().openOwnMoments
	local v63 = nil

	if FFlagMomentsUseFoundationHeaderBar then
		v63 = useMomentsGating()
	end

	local v64 = v63 == nil or v63.isFlyoutEntryEnabled and v63.platformIntegrationEnabled
	local v65 = useCreationEntry()
	local v66 = useUploadHost({
		onExit = v65.onExitCreation,
		captureSource = v65.captureSource
	})

	React.useEffect(function() -- line: 133
		-- upvalues: SessionManager (copy), FunnelEventNames (copy), fireFunnelAnalyticsEvent (copy)
		local v87 = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.AppNavigation) or SessionManager.startSession(FunnelEventNames.FunnelTypes.AppNavigation)

		fireFunnelAnalyticsEvent(FunnelEventNames.FunnelTypes.AppNavigation, FunnelEventNames.AppNavigationSteps.TrendingScreenView, v87)
	end, {})

	local v67 = React.useCallback(function() -- line: 143
		-- upvalues: v40 (copy), v56 (copy)
		if v40 then
			v56(true)
		end
	end, {})
	local v68 = React.useMemo(function() -- line: 149
		-- upvalues: isStudio (copy), GetFFlagArgusStudioMockFeed (copy), createMockFeedSource (copy), createMomentsFeedSource (copy), v61 (copy), v39 (copy), v40 (copy), v67 (copy)
		if isStudio() and GetFFlagArgusStudioMockFeed() then
			return createMockFeedSource()
		end

		return createMomentsFeedSource(v61.getMomentsSessionId, {
			signalTracker = v39,
			onDeepLinkedMomentUnavailable = if not v40 then nil else v67
		})
	end, {
		v61,
		v67
	})
	local v69 = React.useMemo(function() -- line: 161
		-- upvalues: FFlagEnableArgus (copy), createRecommendationTelemetry (copy), v61 (copy), v39 (copy)
		if not FFlagEnableArgus then
			return nil
		end

		return createRecommendationTelemetry({
			getMomentsSessionId = v61.getMomentsSessionId,
			signalTracker = v39
		})
	end, { v61 })
	local v70 = FFlagMomentsImmersiveChrome
	local v71 = SignalsReact.useSignalState(GetImmersiveChromeStore(false).getOverlayCovering)
	local v72 = GetFFlagMomentsFixBackgroundFeedInput() and v71
	local v73 = v40 and v55
	local v74 = not v65.isCreating and (not v72 and not v73)
	local v75 = v60 and (not v65.isCreating and not v73)
	local v76 = React.useCallback(function() -- line: 191
		-- upvalues: v57 (copy)
		local current = v57.current

		if current ~= nil then
			current.refresh()
		end
	end, {})

	React.useEffect(function() -- line: 198
		-- upvalues: RobloxAppEvents (copy), AppPage (copy), v76 (copy)
		local v89 = RobloxAppEvents.ReloadPage:connect(function(p1) -- line: 199
			-- upvalues: AppPage (copy), v76 (copy)
			if p1 == AppPage.Moments then
				v76()
			end
		end)

		return function() -- line: 205
			-- upvalues: v89 (copy)
			v89:disconnect()
		end
	end, { v76 })

	local v77 = GetUploadStore(false)
	local v78 = SignalsReact.useSignalState(v77.getState)
	local v79 = SignalsReact.useSignalState(v77.getUploadedMoment)

	React.useEffect(function() -- line: 214
		-- upvalues: GetFFlagMomentsRefreshFromTopAfterUpload (copy), v78 (copy), v58 (copy), v57 (copy), v79 (copy), v76 (copy)
		if GetFFlagMomentsRefreshFromTopAfterUpload() then
			if v78 ~= "Success" then
				v58.current = v78

				return
			end

			if v58.current ~= "Success" then
				v58.current = v78

				local current = v57.current

				if type(v79) == "table" and v79.momentId ~= nil and current ~= nil then
					current.prependMoment(v79)

					return
				end

				v76()
			end

			return
		end

		if v78 == "Success" then
			v76()
		end
	end, {
		v78,
		v79,
		v76
	})

	local v80 = React.useCallback(function() -- line: 237
		-- upvalues: v54 (copy), MomentsLocalStorage (copy), MomentsLocalStorageKeys (copy)
		v54(false)
		MomentsLocalStorage.setField(MomentsLocalStorageKeys.CreateTooltipSeen, true)
	end, {})
	local v81 = React.useCallback(function() -- line: 242
		-- upvalues: logCreateIntent (copy), FunnelEventNames (copy), v65 (copy)
		logCreateIntent(FunnelEventNames.CreationIntentSource.TopBar)
		v65.onCreatePressed()
	end, { v65.onCreatePressed })
	local v82 = React.useCallback(function() -- line: 250
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v76 (copy)
		fireAnalyticsEvent(EventNames.FeedHomeButtonPressed)
		v76()
	end, { v76 })
	local v83 = React.useCallback(function() -- line: 255
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), openOwnMoments (copy)
		fireAnalyticsEvent(EventNames.MyCreationButtonPressed)

		if openOwnMoments ~= nil then
			openOwnMoments()
		end
	end, { openOwnMoments })
	local v84 = React.useMemo(function() -- line: 263
		-- upvalues: React (copy), TopBar (copy), v53 (copy), v60 (copy), v64 (copy), v80 (copy), v81 (copy), v82 (copy), v83 (copy)
		return React.createElement(TopBar, {
			isBaseScreen = true,
			showTopScrim = true,
			showFtuxTooltip = v53 and v60,
			showHamburger = v64,
			onFtuxTooltipDismissed = v80,
			onCreatePressed = v81,
			onNavigateToTrending = v82,
			onNavigateToMyMoments = v83
		})
	end, {
		v53,
		v60,
		v64,
		v80,
		v81,
		v82,
		v83
	})
	local v85 = React.useCallback(function(p2) -- line: 290
		-- upvalues: v70 (copy), React (copy), MomentOverlayInsetContext (copy), v59 (copy), View (copy), Constants (copy)
		local v92 = if not v70 then p2 else React.createElement(MomentOverlayInsetContext.Context.Provider, {
			value = v59
		}, {
			Feed = p2
		})

		return React.createElement(View, {
			tag = "size-full",
			testId = not v70 and "--moments-feed-container-inset" or "--moments-feed-container-full-bleed",
			padding = if not v70 then {
				bottom = UDim.new(0, v59)
			} else nil,
			ZIndex = Constants.DisplayOrder.Feed
		}, {
			Feed = v92
		})
	end, {
		v59,
		v70
	})
	local v86 = nil

	if not FFlagMomentsUseCompositionLibrary and v59 > 0 then
		v86 = React.createElement(View, {
			tag = "position-bottom-center anchor-bottom-center bg-surface-0",
			testId = "--moments-nav-bar-backfill",
			Size = UDim2.new(1, 0, 0, v59),
			ZIndex = Constants.DisplayOrder.FeedTopBar
		})
	end

	return React.createElement(View, {
		tag = "size-full bg-surface-0"
	}, {
		Surface = React.createElement(MomentsFeedSurface, {
			trackSurfaceLoad = true,
			source = v68,
			active = v74,
			playbackActive = v75,
			telemetry = v69,
			controllerRef = v57,
			header = v84,
			renderFeedContainer = v85
		}),
		NavBarBackfill = v86,
		MomentUnavailableDialog = if not v40 or (not v60 or not v55) then nil else React.createElement(v41, {
			onDismiss = function() -- line: 353
				-- upvalues: v56 (copy)
				v56(false)
			end
		}),
		CreationFlowOverlay = if not v65.isCreating then nil else React.createElement(View, {
			tag = "size-full",
			ZIndex = Constants.DisplayOrder.Modals
		}, {
			Screen = React.createElement(CreationFlowScreen, {
				host = v66
			})
		}),
		FtuxOverlay = if not v65.showFtux then nil else React.createElement(View, {
			tag = "size-full",
			ZIndex = Constants.DisplayOrder.Modals
		}, {
			Screen = React.createElement(FTUXEducationScreen, {
				onClose = v65.onExitFtux
			})
		})
	})
end

return TrendingScreen
