local Parent = script:FindFirstAncestor("GameDetail").Parent
local ExperienceDetailsPageUtils = require(script.Parent.ExperienceDetailsPageUtils)
local ExperienceDetailsPageConstants = require(script.Parent.ExperienceDetailsPageConstants)
local ExperienceDetailsBottomSheetTopBar = require(script.Parent.ExperienceDetailsBottomSheetTopBar)
local fetchExperienceDetailsPage = require(script.Parent.fetchExperienceDetailsPage)
local getExperienceDetailsPageKey = require(script.Parent.getExperienceDetailsPageKey)
local removeGameDetailSessionIfDeparted = require(script.Parent.removeGameDetailSessionIfDeparted)
local useEdpFunctionallyReadyLogger = require(script.Parent.useEdpFunctionallyReadyLogger)
local useMotionJitterMetric = require(script.Parent.useMotionJitterMetric)
local ExperienceDetailsFallbackActionBar = require(script.Parent.Fallback.ExperienceDetailsFallbackActionBar)
local ExperienceDetailsFallbackFeed = require(script.Parent.Fallback.ExperienceDetailsFallbackFeed)
local SetTabBarVisible = require(Parent.AppTabBarRodux).Actions.SetTabBarVisible
local DiscoveryTypes = require(Parent.DiscoveryTypes)
local gameDetailsPeekViewEvents = require(Parent.DiscoveryAnalytics).Events.gameDetailsPeekViewEvents
local Navigation = require(Parent.Navigation)
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Sheet = Foundation.Sheet
local OverlayProvider = Foundation.OverlayProvider
local useTokens = Foundation.Hooks.useTokens
local useNavigation = Navigation.useNavigation
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
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local useGetCurrentLegacyRoute = require(Parent.DiscoveryRouting).useGetCurrentLegacyRoute
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
local CompositionTags = require(Parent.AppComposition).CompositionTags
local ExperienceDetailsPersistentActionBar = require(script.Parent.ExperienceDetailsPersistentActionBar)
local SharedFlags = require(Parent.SharedFlags)
local FFlagSduiPageEntryUseSharedHooks = SharedFlags.FFlagSduiPageEntryUseSharedHooks
local FFlagEnableExperienceDetailsBottomSheetTopBar = SharedFlags.FFlagEnableExperienceDetailsBottomSheetTopBar
local FFlagEnableMotionJitterMetric = SharedFlags.FFlagEnableMotionJitterMetric
local FFlagLuaAppSduiEdpRouteAwareSessionRemoval = SharedFlags.FFlagLuaAppSduiEdpRouteAwareSessionRemoval
local FFlagSduiEdpPersistentActionBarPlayButton = SharedFlags.FFlagSduiEdpPersistentActionBarPlayButton
local FoundationFullBleedSheetContent = Foundation.Utility.Flags.FoundationFullBleedSheetContent
local FFlagLuaAppEdpBottomSheetPeekViewEvents = SharedFlags.FFlagLuaAppEdpBottomSheetPeekViewEvents

local function ExperienceDetailsBottomSheet(p1) -- line: 78
	-- upvalues: ExperienceDetailsPageUtils (copy), getExperienceDetailsPageKey (copy), usePageScopeRef (copy), React (copy), SduiSurfaceLoadTimeTracker (copy), EDPTTIConstants (copy), getSduiClientPageScope (copy), useEdpFunctionallyReadyLogger (copy), useTokens (copy), useNavigation (copy), useRoactService (copy), AppSessionService (copy), useDispatch (copy), FFlagLuaAppEdpBottomSheetPeekViewEvents (copy), AppEventIngestService (copy), FFlagLuaAppSduiEdpRouteAwareSessionRemoval (copy), useGetCurrentLegacyRoute (copy), SetTabBarVisible (copy), FFlagEnableExperienceDetailsBottomSheetTopBar (copy), useTopBarHeight (copy), useScreenSize (copy), useDeviceInsets (copy), getSafeAreaSize (copy), DiscoveryTypes (copy), useEntrySurfacing (copy), ExperienceDetailsPageConstants (copy), gameDetailsPeekViewEvents (copy), FFlagEnableMotionJitterMetric (copy), useMotionJitterMetric (copy), removeGameDetailSessionIfDeparted (copy), SessionType (copy), AppPage (copy), fetchExperienceDetailsPage (copy), useUiStatus (copy), UiStatus (copy), DataHydration (copy), OverlayProvider (copy), ExperienceDetailsBottomSheetTopBar (copy), Sheet (copy), FoundationFullBleedSheetContent (copy), Foundation (copy), SduiPageEntryPoint (copy), FFlagSduiPageEntryUseSharedHooks (copy), CompositionTags (copy), ExperienceDetailsFallbackFeed (copy), FFlagSduiEdpPersistentActionBarPlayButton (copy), ExperienceDetailsPersistentActionBar (copy), SduiFeatureEntryPoint (copy), ExperienceDetailsFallbackActionBar (copy)
	local v57 = ExperienceDetailsPageUtils.getUniverseId(p1)
	local v58 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "onPeekViewClosed")
	local v59 = getExperienceDetailsPageKey(v57)

	usePageScopeRef(v59)

	local v60 = React.useMemo(function() -- line: 84
		-- upvalues: ExperienceDetailsPageUtils (copy), p1 (copy), SduiSurfaceLoadTimeTracker (copy), v59 (copy), EDPTTIConstants (copy), getSduiClientPageScope (copy)
		local v95 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "pageTimer") or SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v59, {
			manualSurfaceReady = true,
			eventName = EDPTTIConstants.EDP_TTI_EVENT_NAME,
			metadata = {
				page = "Untracked",
				category = EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_PEEK_VIEW
			}
		})

		getSduiClientPageScope(v59).set(SduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY, v95)

		return v95
	end, {})

	useEdpFunctionallyReadyLogger(v60, v57)

	local v61 = useTokens()
	local v62 = useNavigation()
	local v63 = useRoactService(AppSessionService)
	local v64 = useDispatch()
	local u65 = nil

	if FFlagLuaAppEdpBottomSheetPeekViewEvents then
		u65 = useRoactService(AppEventIngestService)
	end

	local u66 = nil

	if FFlagLuaAppSduiEdpRouteAwareSessionRemoval then
		u66 = useGetCurrentLegacyRoute()
	end

	React.useEffect(function() -- line: 115
		-- upvalues: v64 (copy), SetTabBarVisible (copy)
		v64(SetTabBarVisible(false))
	end, { v64 })

	local v67 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "referralSource")
	local v68 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "experienceJoinData")
	local v69 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "placeIdOverride")

	React.useEffect(function() -- line: 123
		-- upvalues: getSduiClientPageScope (copy), v59 (copy), v67 (copy), v68 (copy), v69 (copy)
		local v96 = getSduiClientPageScope(v59)

		v96.set("referralSource", v67)
		v96.set("experienceJoinData", v68)
		v96.set("placeId", v69)
		v96.set("launchSource", "LuaGameCard")
	end, {
		v59,
		v67,
		v68,
		v69
	})

	local u70 = nil

	if FFlagEnableExperienceDetailsBottomSheetTopBar then
		u70 = useTopBarHeight()
	end

	local v71 = useScreenSize()
	local v72 = useDeviceInsets()
	local v73 = getSafeAreaSize(v71, v72)
	local v74 = math.min(v73.X.Offset, 640)
	local v75 = nil

	if FFlagEnableExperienceDetailsBottomSheetTopBar then
		v75 = React.useRef(nil)
	end

	local v76 = React.useRef(nil)
	local v77, v78 = React.useState(nil)
	local v79, v80 = React.useState(DiscoveryTypes.Constants.GAME_DETAILS_ACTION_BAR_HEIGHT)
	local v81 = React.useCallback(function(p2) -- line: 147
		-- upvalues: v80 (copy)
		local AbsoluteSizeY = p2.AbsoluteSize.Y

		if AbsoluteSizeY > 0 then
			v80(AbsoluteSizeY)
		end
	end, {})
	local v82 = useEntrySurfacing(v59, ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER, "peekView")
	local v83 = v82 and v82.heightOffset or 0
	local v84 = React.useMemo(function() -- line: 158
		-- upvalues: v74 (copy), v79 (copy), v83 (copy), FFlagEnableExperienceDetailsBottomSheetTopBar (copy), v71 (copy), v72 (copy), u70 (ref), v73 (copy)
		return {
			v74 + v79 + v83 + 25,
			if not FFlagEnableExperienceDetailsBottomSheetTopBar then v73.Y.Offset else math.ceil(v71.Y) - v72.bottom - u70
		}
	end, if not FFlagEnableExperienceDetailsBottomSheetTopBar then {
		v74,
		v79,
		v83,
		v73.Y.Offset
	} else {
		v74,
		v79,
		v83,
		v71.Y,
		v72.bottom,
		u70
	})
	local v85 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "mountAsFullView") == true
	local v86 = not v85 and 1 or 2
	local u87 = nil
	local v88 = nil

	if FFlagLuaAppEdpBottomSheetPeekViewEvents then
		local v89 = ExperienceDetailsPageUtils.getAnalyticsSource(p1)
		local v90 = ExperienceDetailsPageUtils.getTilePositionIndex(p1)

		u87 = React.useRef(v86)
		v88 = React.useCallback(function(_: number, n2: number) -- line: 192
			-- upvalues: u87 (ref), v57 (copy), gameDetailsPeekViewEvents (copy), u65 (ref), v89 (copy), v90 (copy), ExperienceDetailsPageConstants (copy)
			local current = u87.current

			u87.current = n2

			if v57 and (current == 1 and n2 == 2) then
				gameDetailsPeekViewEvents(u65, "GoToFullView", v57, v89, v90, ExperienceDetailsPageConstants.EDP_BOTTOM_SHEET_SURFACE)
			end
		end, {
			u65,
			v57,
			v89,
			v90
		})
	end

	if FFlagEnableMotionJitterMetric then
		useMotionJitterMetric(v76, ExperienceDetailsPageConstants.EDP_BOTTOM_SHEET_SURFACE, false, "AbsolutePosition")
	end

	local v91 = React.useCallback(function() -- line: 218
		-- upvalues: v62 (copy), FFlagLuaAppSduiEdpRouteAwareSessionRemoval (copy), u66 (ref), v58 (copy), removeGameDetailSessionIfDeparted (copy), v63 (copy), SessionType (copy)
		if v62.isFocused() then
			local v102 = if not FFlagLuaAppSduiEdpRouteAwareSessionRemoval then nil else u66()

			if v58 and typeof(v58) == "function" then
				v58()
			end

			v62.goBack()

			if FFlagLuaAppSduiEdpRouteAwareSessionRemoval then
				removeGameDetailSessionIfDeparted(v63, v102)

				return
			end

			if v63 then
				v63:RemoveSession(SessionType.StructuralIdentifier.GameDetailSource)
			end
		end
	end, {
		v62,
		v63,
		v58,
		if not FFlagLuaAppSduiEdpRouteAwareSessionRemoval then nil else u66
	})
	local v92 = React.useCallback(function() -- line: 240
		-- upvalues: v62 (copy), v58 (copy), AppPage (copy), v63 (copy), SessionType (copy)
		if v62.isFocused() then
			if v58 and typeof(v58) == "function" then
				v58()
			end

			v62.clearAppScreens({ AppPage.GameDetail })

			if v63 then
				v63:RemoveSession(SessionType.StructuralIdentifier.GameDetailSource)
			end
		end
	end, {
		v62,
		v63,
		v58
	})

	React.useEffect(function() -- line: 252
		-- upvalues: v57 (copy), v60 (copy), fetchExperienceDetailsPage (copy)
		if v57 and v60 then
			fetchExperienceDetailsPage(v57, v60)
		end
	end, {
		v57,
		v60
	})

	local v93 = useUiStatus(v59)

	React.useEffect(function() -- line: 259
		-- upvalues: v93 (copy), UiStatus (copy), v57 (copy), DataHydration (copy)
		if v93 == UiStatus.Error and v57 then
			DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(v57, function(p3) -- line: 261
				return p3 == nil or p3.creator == nil
			end)
			DataHydration.Game.getAgeRecommendationStore(false).getAndFetchAgeRecommendation(v57)
		end
	end, {
		v93,
		v57
	})

	local v94 = React.useCallback(function() -- line: 268
		-- upvalues: v57 (copy), v60 (copy), fetchExperienceDetailsPage (copy)
		if v57 and v60 then
			fetchExperienceDetailsPage(v57, v60, true)
		end
	end, {
		v57,
		v60
	})

	if v57 == nil then
		return nil
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ref = v78
	}, {
		SheetProvider = v77 and React.createElement(OverlayProvider, {
			gui = v77
		}, {
			TopBar = if not FFlagEnableExperienceDetailsBottomSheetTopBar then nil else React.createElement(ExperienceDetailsBottomSheetTopBar, {
				tokens = v61,
				navigation = v62,
				deviceInsets = v72,
				topBarHeight = u70,
				briefH = v84[1],
				fullH = v84[2],
				overlayFrame = v77,
				sheetContentRef = v75,
				shouldMountAsFullView = v85,
				onBack = v91,
				onClose = v92
			}),
			SheetRoot = React.createElement(Sheet.Root, {
				isOpen = true,
				testId = "--experience-details-bottom-sheet",
				onClose = if not v85 then v92 else v91,
				snapPoints = v84,
				defaultSnapPointIndex = v86,
				onSnapPointChanged = if not FFlagLuaAppEdpBottomSheetPeekViewEvents then nil else v88
			}, {
				Content = React.createElement(Sheet.Content, {
					isContentFullBleed = not not FoundationFullBleedSheetContent or nil,
					scrollingFrameRef = v76,
					ref = if not FFlagEnableExperienceDetailsBottomSheetTopBar then nil else v75
				}, {
					ContentWrapper = React.createElement(Foundation.View, {
						tag = "col size-full-0 auto-y",
						padding = if FoundationFullBleedSheetContent then nil else {
							bottom = UDim.new(0, -v61.Margin.Small),
							left = UDim.new(0, -(v61.Padding.Small + v61.Padding.Medium)),
							right = UDim.new(0, -(v61.Padding.Small + v61.Padding.Medium))
						}
					}, {
						Content = React.createElement(SduiPageEntryPoint, {
							includeNavigationHeaderBar = false,
							snackbarPortalLayoutOrder = 2147483647,
							appPage = AppPage.GameDetail,
							configKey = v59,
							identifier = if not FFlagSduiPageEntryUseSharedHooks then ExperienceDetailsPageUtils.getResolvedIdentifier(v59, ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER_SUFFIX) else ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER,
							pageTimer = v60,
							backgroundStyle = v61.Color.Surface.Surface_100,
							scrollingFrameRef = v76,
							contentTag = CompositionTags.ContentRegion.Body,
							loadingSlot = React.createElement(ExperienceDetailsFallbackFeed.Skeleton, {
								isSmallScreen = true,
								launchSource = "LuaGameCard",
								universeId = v57
							}),
							errorSlot = React.createElement(ExperienceDetailsFallbackFeed.Error, {
								isSmallScreen = true,
								launchSource = "LuaGameCard",
								universeId = v57,
								refresh = v94,
								referralSource = v67,
								experienceJoinData = v68,
								placeIdOverride = v69
							})
						})
					})
				}),
				Actions = React.createElement(Sheet.Actions, {}, {
					ActionBarWrapper = React.createElement(Foundation.View, {
						tag = "col size-full-0 auto-y",
						padding = UDim.new(0, -v61.Margin.Small)
					}, {
						ActionBar = if not FFlagSduiEdpPersistentActionBarPlayButton then React.createElement(SduiFeatureEntryPoint, {
							appPage = AppPage.GameDetail,
							configKey = v59,
							identifier = ExperienceDetailsPageConstants.EDP_ACTION_BAR_IDENTIFIER,
							loadTimer = v60,
							AutomaticSize = Enum.AutomaticSize.XY,
							onAbsoluteSizeChange = v81,
							loadingSlot = React.createElement(ExperienceDetailsFallbackActionBar.Skeleton, {
								launchSource = "LuaGameCard",
								universeId = v57,
								referralSource = v67,
								experienceJoinData = v68,
								placeIdOverride = v69
							}),
							errorSlot = React.createElement(ExperienceDetailsFallbackActionBar.Error, {
								launchSource = "LuaGameCard",
								universeId = v57,
								referralSource = v67,
								experienceJoinData = v68,
								placeIdOverride = v69
							})
						}) else React.createElement(ExperienceDetailsPersistentActionBar, {
							launchSource = "LuaGameCard",
							universeId = v57,
							configKey = v59,
							loadTimer = v60,
							referralSource = v67,
							experienceJoinData = v68,
							placeIdOverride = v69,
							onAbsoluteSizeChange = v81
						})
					})
				})
			})
		}) or nil
	})
end

return React.memo(ExperienceDetailsBottomSheet)
