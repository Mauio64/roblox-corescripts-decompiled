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
local GetFFlagMomentsFixBackgroundFeedInput = require(Moments.Flags.GetFFlagMomentsFixBackgroundFeedInput)
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
local v37 = if not FFlagEnableArgus then nil else createSignalTracker()
local Feed2 = Feed.Feed
local createRecommendationTelemetry = Feed.createRecommendationTelemetry
local Analytics = require(MomentsParent.MomentsCommon).Analytics
local EventNames = Analytics.EventNames
local SessionManager = Analytics.SessionManager
local FunnelEventNames = Analytics.FunnelEventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local fireFunnelAnalyticsEvent = Analytics.fireFunnelAnalyticsEvent

local function ResizeFeedContainer(t1: {[any]: any}) -- line: 103
	-- upvalues: useChromeRatio (copy), React (copy), Constants (copy), Feed2 (copy)
	local v50 = useChromeRatio()
	local bottomInset = t1.bottomInset

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = v50:map(function(n1: number) -- line: 109
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
local function ImmersiveNavBarBackfill(t2: {[any]: any}) -- line: 135
	-- upvalues: useChromeRatio (copy), React (copy), View (copy), Constants (copy)
	local v53 = useChromeRatio()
	local bottomInset = t2.bottomInset

	if t2.resizeViewport then
		return React.createElement(View, {
			tag = "position-bottom-center anchor-bottom-center bg-surface-0",
			Size = v53:map(function(n2: number) -- line: 141
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
		Position = v53:map(function(n3: number) -- line: 152
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
local function TrendingScreen(_: {[any]: any}) -- line: 163
	-- upvalues: React (copy), MomentsLocalStorage (copy), MomentsLocalStorageKeys (copy), useScreenBottomInset (copy), useFeedPlaybackActive (copy), useMomentsSession (copy), useMomentsHost (copy), useCreationEntry (copy), useUploadHost (copy), SessionManager (copy), FunnelEventNames (copy), fireFunnelAnalyticsEvent (copy), isStudio (copy), GetFFlagArgusStudioMockFeed (copy), createMockFeedSource (copy), createMomentsFeedSource (copy), v37 (copy), FFlagEnableArgus (copy), createRecommendationTelemetry (copy), GetFFlagMomentsImmersiveChrome (copy), GetFFlagMomentsImmersiveResizeViewport (copy), SignalsReact (copy), GetImmersiveChromeStore (copy), GetFFlagMomentsFixBackgroundFeedInput (copy), RobloxAppEvents (copy), AppPage (copy), GetUploadStore (copy), GetFFlagMomentsRefreshFromTopAfterUpload (copy), Feed2 (copy), MomentOverlayInsetContext (copy), ResizeFeedContainer (copy), View (copy), Constants (copy), ImmersiveNavBarBackfill (copy), Foundation (copy), TopBar (copy), logCreateIntent (copy), fireAnalyticsEvent (copy), EventNames (copy), CreationFlowScreen (copy), FTUXEducationScreen (copy)
	local v56, v57 = React.useState(function() -- line: 164
		-- upvalues: MomentsLocalStorage (copy), MomentsLocalStorageKeys (copy)
		return not MomentsLocalStorage.getField(MomentsLocalStorageKeys.CreateTooltipSeen)
	end)
	local v58 = React.useRef(nil)
	local v59 = React.useRef(nil)
	local v60 = useScreenBottomInset()
	local v61 = useFeedPlaybackActive()
	local v62 = useMomentsSession()
	local openOwnMoments = useMomentsHost().openOwnMoments
	local v64 = useCreationEntry()
	local v65 = useUploadHost({
		onExit = v64.onExitCreation,
		captureSource = v64.captureSource
	})

	React.useEffect(function() -- line: 193
		-- upvalues: SessionManager (copy), FunnelEventNames (copy), fireFunnelAnalyticsEvent (copy)
		local v86 = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.AppNavigation) or SessionManager.startSession(FunnelEventNames.FunnelTypes.AppNavigation)

		fireFunnelAnalyticsEvent(FunnelEventNames.FunnelTypes.AppNavigation, FunnelEventNames.AppNavigationSteps.TrendingScreenView, v86)
	end, {})

	local v66 = React.useMemo(function() -- line: 203
		-- upvalues: isStudio (copy), GetFFlagArgusStudioMockFeed (copy), createMockFeedSource (copy), createMomentsFeedSource (copy), v62 (copy), v37 (copy)
		if isStudio() and GetFFlagArgusStudioMockFeed() then
			return createMockFeedSource()
		end

		return createMomentsFeedSource(v62.getMomentsSessionId, {
			signalTracker = v37
		})
	end, { v62 })
	local v67 = React.useMemo(function() -- line: 212
		-- upvalues: FFlagEnableArgus (copy), createRecommendationTelemetry (copy), v62 (copy), v37 (copy)
		if not FFlagEnableArgus then
			return nil
		end

		return createRecommendationTelemetry({
			getMomentsSessionId = v62.getMomentsSessionId,
			signalTracker = v37
		})
	end, { v62 })
	local v68 = GetFFlagMomentsImmersiveChrome()
	local v69 = v68 and GetFFlagMomentsImmersiveResizeViewport()
	local v70 = v68 and not v69
	local v71 = SignalsReact.useSignalState(GetImmersiveChromeStore(false).getOverlayCovering)
	local v72 = GetFFlagMomentsFixBackgroundFeedInput() and v71
	local v73 = not v64.isCreating and not v72
	local v74 = v61 and not v64.isCreating
	local v75 = React.useCallback(function() -- line: 246
		-- upvalues: v58 (copy)
		local current = v58.current

		if current ~= nil then
			current.refresh()
		end
	end, {})

	React.useEffect(function() -- line: 253
		-- upvalues: RobloxAppEvents (copy), AppPage (copy), v75 (copy)
		local v88 = RobloxAppEvents.ReloadPage:connect(function(p1) -- line: 254
			-- upvalues: AppPage (copy), v75 (copy)
			if p1 == AppPage.Moments then
				v75()
			end
		end)

		return function() -- line: 260
			-- upvalues: v88 (copy)
			v88:disconnect()
		end
	end, { v75 })

	local v76 = GetUploadStore(false)
	local v77 = SignalsReact.useSignalState(v76.getState)
	local v78 = SignalsReact.useSignalState(v76.getUploadedMoment)

	React.useEffect(function() -- line: 269
		-- upvalues: GetFFlagMomentsRefreshFromTopAfterUpload (copy), v77 (copy), v59 (copy), v58 (copy), v78 (copy), v75 (copy)
		if GetFFlagMomentsRefreshFromTopAfterUpload() then
			if v77 ~= "Success" then
				v59.current = v77

				return
			end

			if v59.current ~= "Success" then
				v59.current = v77

				local current = v58.current

				if type(v78) == "table" and v78.momentId ~= nil and current ~= nil then
					current.prependMoment(v78)

					return
				end

				v75()
			end

			return
		end

		if v77 == "Success" then
			v75()
		end
	end, {
		v77,
		v78,
		v75
	})

	local v79 = React.createElement(Feed2, {
		trackSurfaceLoad = true,
		source = v66,
		active = v73,
		playbackActive = v74,
		telemetry = v67,
		controllerRef = v58
	})
	local v80 = if not v70 then v79 else React.createElement(MomentOverlayInsetContext.Context.Provider, {
		value = v60
	}, {
		Feed = v79
	})
	local v81 = if not v69 then React.createElement(View, {
		tag = "size-full",
		padding = if not v70 then {
			bottom = UDim.new(0, v60)
		} else nil,
		ZIndex = Constants.DisplayOrder.Feed
	}, {
		Feed = v80
	}) else React.createElement(ResizeFeedContainer, {
		active = v73,
		bottomInset = v60,
		source = v66,
		playbackActive = v74,
		telemetry = v67,
		controllerRef = v58
	})
	local v82 = nil

	if v60 > 0 then
		v82 = if not v68 then React.createElement(View, {
			tag = "position-bottom-center anchor-bottom-center bg-surface-0",
			Size = UDim2.new(1, 0, 0, v60),
			ZIndex = Constants.DisplayOrder.FeedTopBar
		}) else React.createElement(ImmersiveNavBarBackfill, {
			bottomInset = v60,
			resizeViewport = v69
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
				FeedContainer = v81,
				TopBar = React.createElement(TopBar, {
					isBaseScreen = true,
					showTopScrim = true,
					showFtuxTooltip = v56 and v61,
					onFtuxTooltipDismissed = function() -- line: 384
						-- upvalues: v57 (copy), MomentsLocalStorage (copy), MomentsLocalStorageKeys (copy)
						v57(false)
						MomentsLocalStorage.setField(MomentsLocalStorageKeys.CreateTooltipSeen, true)
					end,
					onCreatePressed = function() -- line: 388
						-- upvalues: logCreateIntent (copy), FunnelEventNames (copy), v64 (copy)
						logCreateIntent(FunnelEventNames.CreationIntentSource.TopBar)
						v64.onCreatePressed()
					end,
					onNavigateToTrending = function() -- line: 395
						-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v75 (copy)
						fireAnalyticsEvent(EventNames.FeedHomeButtonPressed)
						v75()
					end,
					onNavigateToMyMoments = function() -- line: 399
						-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), openOwnMoments (copy)
						fireAnalyticsEvent(EventNames.MyCreationButtonPressed)

						if openOwnMoments ~= nil then
							openOwnMoments()
						end
					end
				})
			})
		}),
		NavBarBackfill = v82,
		CreationFlowOverlay = if not v64.isCreating then nil else React.createElement(View, {
			tag = "size-full",
			ZIndex = Constants.DisplayOrder.Modals
		}, {
			Screen = React.createElement(CreationFlowScreen, {
				host = v65
			})
		}),
		FtuxOverlay = if not v64.showFtux then nil else React.createElement(View, {
			tag = "size-full",
			ZIndex = Constants.DisplayOrder.Modals
		}, {
			Screen = React.createElement(FTUXEducationScreen, {
				onClose = v64.onExitFtux
			})
		})
	})
end

return TrendingScreen
