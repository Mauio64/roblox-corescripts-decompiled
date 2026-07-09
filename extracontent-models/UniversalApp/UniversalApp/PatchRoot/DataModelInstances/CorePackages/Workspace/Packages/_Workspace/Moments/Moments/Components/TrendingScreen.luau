local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Foundation = require(MomentsParent.Foundation)
local React = require(MomentsParent.React)
local AppPage = require(MomentsParent.RobloxAppEnums).AppPage
local RobloxAppEvents = require(MomentsParent.RobloxAppEvents)
local View = Foundation.View
local TopBar = require(Moments.Components.TopBar)
local Feed = require(Moments.Components.Feed)
local CreationFlowScreen = require(MomentsParent.MomentsCreation).CreationFlowScreen
local FTUXEducationScreen = require(Moments.Components.FTUXEducationScreen)
local useMomentsHost = require(Moments.MomentsHostContext).useMomentsHost
local Constants = require(Moments.Constants)
local useScreenBottomInset = require(Moments.Hooks.useScreenBottomInset)
local useFeedPlaybackActive = require(Moments.Hooks.useFeedPlaybackActive)
local useChromeRatio = require(Moments.Hooks.useChromeRatio)
local useCreationEntry = require(Moments.Hooks.useCreationEntry)
local useUploadHost = require(Moments.Hooks.useUploadHost)
local logCreateIntent = require(Moments.Analytics.logCreateIntent)
local GetUploadStore = require(Moments.Stores.GetUploadStore)
local SignalsReact = require(MomentsParent.SignalsReact)
local MomentOverlayInsetContext = require(Moments.Components.Feed.Items.Moment.MomentOverlayInsetContext)
local GetFFlagMomentsImmersiveChrome = require(Moments.Flags.GetFFlagMomentsImmersiveChrome)
local GetFFlagMomentsImmersiveResizeViewport = require(Moments.Flags.GetFFlagMomentsImmersiveResizeViewport)
local GetFFlagMomentsRefreshFromTopAfterUpload = require(Moments.Flags.GetFFlagMomentsRefreshFromTopAfterUpload)
local MomentsLocalStorage = require(Moments.Storage.MomentsLocalStorage)
local MomentsLocalStorageKeys = require(Moments.Storage.MomentsLocalStorageKeys)
local useMomentsSession = require(Moments.Stores.GetMomentsStore.MomentsSessionContext).useMomentsSession
local createMomentsFeedSource = require(Moments.Stores.GetMomentsStore.createMomentsFeedSource)
local createSignalTracker = require(Moments.SignalTracker).createSignalTracker
local FFlagEnableArgus = require(MomentsParent.SharedFlags).FFlagEnableArgus
local isStudio = require(MomentsParent.MomentsCommon.isStudio)
local GetFFlagArgusStudioMockFeed = require(Moments.Flags.GetFFlagArgusStudioMockFeed)
local createMockFeedSource = Feed.createMockFeedSource
local v35 = if not FFlagEnableArgus then nil else createSignalTracker()
local Feed2 = Feed.Feed
local createRecommendationTelemetry = Feed.createRecommendationTelemetry
local Analytics = require(MomentsParent.MomentsCommon).Analytics
local EventNames = Analytics.EventNames
local SessionManager = Analytics.SessionManager
local FunnelEventNames = Analytics.FunnelEventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local fireFunnelAnalyticsEvent = Analytics.fireFunnelAnalyticsEvent

local function ResizeFeedContainer(t1: {[any]: any}) -- line: 101
	-- upvalues: useChromeRatio (copy), React (copy), Constants (copy), Feed2 (copy)
	local v48 = useChromeRatio()
	local bottomInset = t1.bottomInset

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = v48:map(function(n1: number) -- line: 107
			-- upvalues: bottomInset (copy)
			return UDim2.new(1, 0, 1, -math.round(bottomInset * n1))
		end),
		ZIndex = Constants.DisplayOrder.Feed
	}, {
		Feed = React.createElement(Feed2, {
			trackSurfaceLoad = true,
			source = t1.source,
			active = t1.active,
			playbackActive = t1.playbackActive,
			telemetry = t1.telemetry,
			controllerRef = t1.controllerRef
		})
	})
end
local function ImmersiveNavBarBackfill(t2: {[any]: any}) -- line: 133
	-- upvalues: useChromeRatio (copy), React (copy), View (copy), Constants (copy)
	local v51 = useChromeRatio()
	local bottomInset = t2.bottomInset

	if t2.resizeViewport then
		return React.createElement(View, {
			tag = "position-bottom-center anchor-bottom-center bg-surface-0",
			Size = v51:map(function(n2: number) -- line: 139
				-- upvalues: bottomInset (copy)
				return UDim2.new(1, 0, 0, (math.round(bottomInset * n2)))
			end),
			ZIndex = Constants.DisplayOrder.FeedTopBar
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 1),
		Size = UDim2.new(1, 0, 0, bottomInset),
		Position = v51:map(function(n3: number) -- line: 150
			-- upvalues: bottomInset (copy)
			return UDim2.new(0.5, 0, 1, (math.round((1 - n3) * bottomInset)))
		end),
		ZIndex = Constants.DisplayOrder.FeedTopBar
	}, {
		Fill = React.createElement(View, {
			tag = "size-full bg-surface-0"
		})
	})
end
local function TrendingScreen(_: {[any]: any}) -- line: 161
	-- upvalues: React (copy), MomentsLocalStorage (copy), MomentsLocalStorageKeys (copy), useScreenBottomInset (copy), useFeedPlaybackActive (copy), useMomentsSession (copy), useMomentsHost (copy), useCreationEntry (copy), useUploadHost (copy), SessionManager (copy), FunnelEventNames (copy), fireFunnelAnalyticsEvent (copy), isStudio (copy), GetFFlagArgusStudioMockFeed (copy), createMockFeedSource (copy), createMomentsFeedSource (copy), v35 (copy), FFlagEnableArgus (copy), createRecommendationTelemetry (copy), GetFFlagMomentsImmersiveChrome (copy), GetFFlagMomentsImmersiveResizeViewport (copy), RobloxAppEvents (copy), AppPage (copy), GetUploadStore (copy), SignalsReact (copy), GetFFlagMomentsRefreshFromTopAfterUpload (copy), Feed2 (copy), MomentOverlayInsetContext (copy), ResizeFeedContainer (copy), View (copy), Constants (copy), ImmersiveNavBarBackfill (copy), Foundation (copy), TopBar (copy), logCreateIntent (copy), fireAnalyticsEvent (copy), EventNames (copy), CreationFlowScreen (copy), FTUXEducationScreen (copy)
	local v54, v55 = React.useState(function() -- line: 162
		-- upvalues: MomentsLocalStorage (copy), MomentsLocalStorageKeys (copy)
		return not MomentsLocalStorage.getField(MomentsLocalStorageKeys.CreateTooltipSeen)
	end)
	local v56 = React.useRef(nil)
	local v57 = React.useRef(nil)
	local v58 = useScreenBottomInset()
	local v59 = useFeedPlaybackActive()
	local v60 = useMomentsSession()
	local openOwnMoments = useMomentsHost().openOwnMoments
	local v62 = useCreationEntry()
	local v63 = useUploadHost({
		onExit = v62.onExitCreation,
		captureSource = v62.captureSource
	})

	React.useEffect(function() -- line: 191
		-- upvalues: SessionManager (copy), FunnelEventNames (copy), fireFunnelAnalyticsEvent (copy)
		local v82 = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.AppNavigation) or SessionManager.startSession(FunnelEventNames.FunnelTypes.AppNavigation)

		fireFunnelAnalyticsEvent(FunnelEventNames.FunnelTypes.AppNavigation, FunnelEventNames.AppNavigationSteps.TrendingScreenView, v82)
	end, {})

	local v64 = React.useMemo(function() -- line: 201
		-- upvalues: isStudio (copy), GetFFlagArgusStudioMockFeed (copy), createMockFeedSource (copy), createMomentsFeedSource (copy), v60 (copy), v35 (copy)
		if isStudio() and GetFFlagArgusStudioMockFeed() then
			return createMockFeedSource()
		end

		return createMomentsFeedSource(v60.getMomentsSessionId, {
			signalTracker = v35
		})
	end, { v60 })
	local v65 = React.useMemo(function() -- line: 210
		-- upvalues: FFlagEnableArgus (copy), createRecommendationTelemetry (copy), v60 (copy), v35 (copy)
		if not FFlagEnableArgus then
			return nil
		end

		return createRecommendationTelemetry({
			getMomentsSessionId = v60.getMomentsSessionId,
			signalTracker = v35
		})
	end, { v60 })
	local v66 = GetFFlagMomentsImmersiveChrome()
	local v67 = v66 and GetFFlagMomentsImmersiveResizeViewport()
	local v68 = v66 and not v67
	local v69 = not v62.isCreating
	local v70 = v59 and not v62.isCreating
	local v71 = React.useCallback(function() -- line: 237
		-- upvalues: v56 (copy)
		local current = v56.current

		if current ~= nil then
			current.refresh()
		end
	end, {})

	React.useEffect(function() -- line: 244
		-- upvalues: RobloxAppEvents (copy), AppPage (copy), v71 (copy)
		local v84 = RobloxAppEvents.ReloadPage:connect(function(p1) -- line: 245
			-- upvalues: AppPage (copy), v71 (copy)
			if p1 == AppPage.Moments then
				v71()
			end
		end)

		return function() -- line: 251
			-- upvalues: v84 (copy)
			v84:disconnect()
		end
	end, { v71 })

	local v72 = GetUploadStore(false)
	local v73 = SignalsReact.useSignalState(v72.getState)
	local v74 = SignalsReact.useSignalState(v72.getUploadedMoment)

	React.useEffect(function() -- line: 260
		-- upvalues: GetFFlagMomentsRefreshFromTopAfterUpload (copy), v73 (copy), v57 (copy), v56 (copy), v74 (copy), v71 (copy)
		if GetFFlagMomentsRefreshFromTopAfterUpload() then
			if v73 ~= "Success" then
				v57.current = v73

				return
			end

			if v57.current ~= "Success" then
				v57.current = v73

				local current = v56.current

				if type(v74) == "table" and v74.momentId ~= nil and current ~= nil then
					current.prependMoment(v74)

					return
				end

				v71()
			end

			return
		end

		if v73 == "Success" then
			v71()
		end
	end, {
		v73,
		v74,
		v71
	})

	local v75 = React.createElement(Feed2, {
		trackSurfaceLoad = true,
		source = v64,
		active = v69,
		playbackActive = v70,
		telemetry = v65,
		controllerRef = v56
	})
	local v76 = if not v68 then v75 else React.createElement(MomentOverlayInsetContext.Context.Provider, {
		value = v58
	}, {
		Feed = v75
	})
	local v77 = if not v67 then React.createElement(View, {
		tag = "size-full",
		padding = if not v68 then {
			bottom = UDim.new(0, v58)
		} else nil,
		ZIndex = Constants.DisplayOrder.Feed
	}, {
		Feed = v76
	}) else React.createElement(ResizeFeedContainer, {
		active = v69,
		bottomInset = v58,
		source = v64,
		playbackActive = v70,
		telemetry = v65,
		controllerRef = v56
	})
	local v78 = nil

	if v58 > 0 then
		v78 = if not v66 then React.createElement(View, {
			tag = "position-bottom-center anchor-bottom-center bg-surface-0",
			Size = UDim2.new(1, 0, 0, v58),
			ZIndex = Constants.DisplayOrder.FeedTopBar
		}) else React.createElement(ImmersiveNavBarBackfill, {
			bottomInset = v58,
			resizeViewport = v67
		})
	end

	return React.createElement(View, {
		tag = "size-full bg-surface-0"
	}, {
		FoundationContainer = React.createElement(View, {
			tag = "size-full"
		}, {
			OnVideoUI = React.createElement(Foundation.FoundationProvider, {
				theme = Foundation.Enums.Theme.Dark
			}, {
				FeedContainer = v77,
				TopBar = React.createElement(TopBar, {
					isBaseScreen = true,
					showTopScrim = true,
					showFtuxTooltip = v54 and v59,
					onFtuxTooltipDismissed = function() -- line: 375
						-- upvalues: v55 (copy), MomentsLocalStorage (copy), MomentsLocalStorageKeys (copy)
						v55(false)
						MomentsLocalStorage.setField(MomentsLocalStorageKeys.CreateTooltipSeen, true)
					end,
					onCreatePressed = function() -- line: 379
						-- upvalues: logCreateIntent (copy), FunnelEventNames (copy), v62 (copy)
						logCreateIntent(FunnelEventNames.CreationIntentSource.TopBar)
						v62.onCreatePressed()
					end,
					onNavigateToTrending = function() -- line: 386
						-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v71 (copy)
						fireAnalyticsEvent(EventNames.FeedHomeButtonPressed)
						v71()
					end,
					onNavigateToMyMoments = function() -- line: 390
						-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), openOwnMoments (copy)
						fireAnalyticsEvent(EventNames.MyCreationButtonPressed)

						if openOwnMoments ~= nil then
							openOwnMoments()
						end
					end
				})
			})
		}),
		NavBarBackfill = v78,
		CreationFlowOverlay = if not v62.isCreating then nil else React.createElement(View, {
			tag = "size-full",
			ZIndex = Constants.DisplayOrder.Modals
		}, {
			Screen = React.createElement(CreationFlowScreen, {
				host = v63
			})
		}),
		FtuxOverlay = if not v62.showFtux then nil else React.createElement(View, {
			tag = "size-full",
			ZIndex = Constants.DisplayOrder.Modals
		}, {
			Screen = React.createElement(FTUXEducationScreen, {
				onClose = v62.onExitFtux
			})
		})
	})
end

return TrendingScreen
