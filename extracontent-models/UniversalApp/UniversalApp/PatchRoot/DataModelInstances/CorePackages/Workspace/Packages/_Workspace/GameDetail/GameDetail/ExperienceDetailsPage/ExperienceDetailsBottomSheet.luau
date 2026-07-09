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
local AppSessionService = require(Parent.RoactServiceTags).AppSessionService
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

local function ExperienceDetailsBottomSheet(p1) -- line: 73
	-- upvalues: ExperienceDetailsPageUtils (copy), getExperienceDetailsPageKey (copy), usePageScopeRef (copy), React (copy), SduiSurfaceLoadTimeTracker (copy), EDPTTIConstants (copy), getSduiClientPageScope (copy), useEdpFunctionallyReadyLogger (copy), useTokens (copy), useNavigation (copy), useRoactService (copy), AppSessionService (copy), useDispatch (copy), FFlagLuaAppSduiEdpRouteAwareSessionRemoval (copy), useGetCurrentLegacyRoute (copy), SetTabBarVisible (copy), FFlagEnableExperienceDetailsBottomSheetTopBar (copy), useTopBarHeight (copy), useScreenSize (copy), useDeviceInsets (copy), getSafeAreaSize (copy), DiscoveryTypes (copy), useEntrySurfacing (copy), ExperienceDetailsPageConstants (copy), FFlagEnableMotionJitterMetric (copy), useMotionJitterMetric (copy), removeGameDetailSessionIfDeparted (copy), SessionType (copy), AppPage (copy), fetchExperienceDetailsPage (copy), useUiStatus (copy), UiStatus (copy), DataHydration (copy), OverlayProvider (copy), ExperienceDetailsBottomSheetTopBar (copy), Sheet (copy), FoundationFullBleedSheetContent (copy), Foundation (copy), SduiPageEntryPoint (copy), FFlagSduiPageEntryUseSharedHooks (copy), CompositionTags (copy), ExperienceDetailsFallbackFeed (copy), FFlagSduiEdpPersistentActionBarPlayButton (copy), ExperienceDetailsPersistentActionBar (copy), SduiFeatureEntryPoint (copy), ExperienceDetailsFallbackActionBar (copy)
	local v53 = ExperienceDetailsPageUtils.getUniverseId(p1)
	local v54 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "onPeekViewClosed")
	local v55 = getExperienceDetailsPageKey(v53)

	usePageScopeRef(v55)

	local v56 = React.useMemo(function() -- line: 79
		-- upvalues: ExperienceDetailsPageUtils (copy), p1 (copy), SduiSurfaceLoadTimeTracker (copy), v55 (copy), EDPTTIConstants (copy), getSduiClientPageScope (copy)
		local v86 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "pageTimer") or SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v55, {
			manualSurfaceReady = true,
			eventName = EDPTTIConstants.EDP_TTI_EVENT_NAME,
			metadata = {
				page = "Untracked",
				category = EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_PEEK_VIEW
			}
		})

		getSduiClientPageScope(v55).set(SduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY, v86)

		return v86
	end, {})

	useEdpFunctionallyReadyLogger(v56, v53)

	local v57 = useTokens()
	local v58 = useNavigation()
	local v59 = useRoactService(AppSessionService)
	local v60 = useDispatch()
	local u61 = nil

	if FFlagLuaAppSduiEdpRouteAwareSessionRemoval then
		u61 = useGetCurrentLegacyRoute()
	end

	React.useEffect(function() -- line: 106
		-- upvalues: v60 (copy), SetTabBarVisible (copy)
		v60(SetTabBarVisible(false))
	end, { v60 })

	local v62 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "referralSource")
	local v63 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "experienceJoinData")
	local v64 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "placeIdOverride")

	React.useEffect(function() -- line: 114
		-- upvalues: getSduiClientPageScope (copy), v55 (copy), v62 (copy), v63 (copy), v64 (copy)
		local v87 = getSduiClientPageScope(v55)

		v87.set("referralSource", v62)
		v87.set("experienceJoinData", v63)
		v87.set("placeId", v64)
		v87.set("launchSource", "LuaGameCard")
	end, {
		v55,
		v62,
		v63,
		v64
	})

	local u65 = nil

	if FFlagEnableExperienceDetailsBottomSheetTopBar then
		u65 = useTopBarHeight()
	end

	local v66 = useScreenSize()
	local v67 = useDeviceInsets()
	local v68 = getSafeAreaSize(v66, v67)
	local v69 = math.min(v68.X.Offset, 640)
	local v70 = nil

	if FFlagEnableExperienceDetailsBottomSheetTopBar then
		v70 = React.useRef(nil)
	end

	local v71 = React.useRef(nil)
	local v72, v73 = React.useState(nil)
	local v74, v75 = React.useState(DiscoveryTypes.Constants.GAME_DETAILS_ACTION_BAR_HEIGHT)
	local v76 = React.useCallback(function(p2) -- line: 138
		-- upvalues: v75 (copy)
		local AbsoluteSizeY = p2.AbsoluteSize.Y

		if AbsoluteSizeY > 0 then
			v75(AbsoluteSizeY)
		end
	end, {})
	local v77 = useEntrySurfacing(v55, ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER, "peekView")
	local v78 = v77 and v77.heightOffset or 0
	local v79 = React.useMemo(function() -- line: 149
		-- upvalues: v69 (copy), v74 (copy), v78 (copy), FFlagEnableExperienceDetailsBottomSheetTopBar (copy), v66 (copy), v67 (copy), u65 (ref), v68 (copy)
		return {
			v69 + v74 + v78 + 25,
			if not FFlagEnableExperienceDetailsBottomSheetTopBar then v68.Y.Offset else math.ceil(v66.Y) - v67.bottom - u65
		}
	end, if not FFlagEnableExperienceDetailsBottomSheetTopBar then {
		v69,
		v74,
		v78,
		v68.Y.Offset
	} else {
		v69,
		v74,
		v78,
		v66.Y,
		v67.bottom,
		u65
	})
	local v80 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "mountAsFullView") == true
	local v81 = not v80 and 1 or 2

	if FFlagEnableMotionJitterMetric then
		useMotionJitterMetric(v71, "bottomSheet", false, "AbsolutePosition")
	end

	local v82 = React.useCallback(function() -- line: 182
		-- upvalues: v58 (copy), FFlagLuaAppSduiEdpRouteAwareSessionRemoval (copy), u61 (ref), v54 (copy), removeGameDetailSessionIfDeparted (copy), v59 (copy), SessionType (copy)
		if v58.isFocused() then
			local v90 = if not FFlagLuaAppSduiEdpRouteAwareSessionRemoval then nil else u61()

			if v54 and typeof(v54) == "function" then
				v54()
			end

			v58.goBack()

			if FFlagLuaAppSduiEdpRouteAwareSessionRemoval then
				removeGameDetailSessionIfDeparted(v59, v90)

				return
			end

			if v59 then
				v59:RemoveSession(SessionType.StructuralIdentifier.GameDetailSource)
			end
		end
	end, {
		v58,
		v59,
		v54,
		if not FFlagLuaAppSduiEdpRouteAwareSessionRemoval then nil else u61
	})
	local v83 = React.useCallback(function() -- line: 204
		-- upvalues: v58 (copy), v54 (copy), AppPage (copy), v59 (copy), SessionType (copy)
		if v58.isFocused() then
			if v54 and typeof(v54) == "function" then
				v54()
			end

			v58.clearAppScreens({ AppPage.GameDetail })

			if v59 then
				v59:RemoveSession(SessionType.StructuralIdentifier.GameDetailSource)
			end
		end
	end, {
		v58,
		v59,
		v54
	})

	React.useEffect(function() -- line: 216
		-- upvalues: v53 (copy), v56 (copy), fetchExperienceDetailsPage (copy)
		if v53 and v56 then
			fetchExperienceDetailsPage(v53, v56)
		end
	end, {
		v53,
		v56
	})

	local v84 = useUiStatus(v55)

	React.useEffect(function() -- line: 223
		-- upvalues: v84 (copy), UiStatus (copy), v53 (copy), DataHydration (copy)
		if v84 == UiStatus.Error and v53 then
			DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(v53, function(p3) -- line: 225
				return p3 == nil or p3.creator == nil
			end)
			DataHydration.Game.getAgeRecommendationStore(false).getAndFetchAgeRecommendation(v53)
		end
	end, {
		v84,
		v53
	})

	local v85 = React.useCallback(function() -- line: 232
		-- upvalues: v53 (copy), v56 (copy), fetchExperienceDetailsPage (copy)
		if v53 and v56 then
			fetchExperienceDetailsPage(v53, v56, true)
		end
	end, {
		v53,
		v56
	})

	if v53 == nil then
		return nil
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ref = v73
	}, {
		SheetProvider = v72 and React.createElement(OverlayProvider, {
			gui = v72
		}, {
			TopBar = if not FFlagEnableExperienceDetailsBottomSheetTopBar then nil else React.createElement(ExperienceDetailsBottomSheetTopBar, {
				tokens = v57,
				navigation = v58,
				deviceInsets = v67,
				topBarHeight = u65,
				briefH = v79[1],
				fullH = v79[2],
				overlayFrame = v72,
				sheetContentRef = v70,
				shouldMountAsFullView = v80,
				onBack = v82,
				onClose = v83
			}),
			SheetRoot = React.createElement(Sheet.Root, {
				isOpen = true,
				testId = "--experience-details-bottom-sheet",
				onClose = if not v80 then v83 else v82,
				snapPoints = v79,
				defaultSnapPointIndex = v81
			}, {
				Content = React.createElement(Sheet.Content, {
					isContentFullBleed = not not FoundationFullBleedSheetContent or nil,
					scrollingFrameRef = v71,
					ref = if not FFlagEnableExperienceDetailsBottomSheetTopBar then nil else v70
				}, {
					ContentWrapper = React.createElement(Foundation.View, {
						tag = "col size-full-0 auto-y",
						padding = if FoundationFullBleedSheetContent then nil else {
							bottom = UDim.new(0, -v57.Margin.Small),
							left = UDim.new(0, -(v57.Padding.Small + v57.Padding.Medium)),
							right = UDim.new(0, -(v57.Padding.Small + v57.Padding.Medium))
						}
					}, {
						Content = React.createElement(SduiPageEntryPoint, {
							includeNavigationHeaderBar = false,
							snackbarPortalLayoutOrder = 2147483647,
							appPage = AppPage.GameDetail,
							configKey = v55,
							identifier = if not FFlagSduiPageEntryUseSharedHooks then ExperienceDetailsPageUtils.getResolvedIdentifier(v55, ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER_SUFFIX) else ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER,
							pageTimer = v56,
							backgroundStyle = v57.Color.Surface.Surface_100,
							scrollingFrameRef = v71,
							contentTag = CompositionTags.ContentRegion.Body,
							loadingSlot = React.createElement(ExperienceDetailsFallbackFeed.Skeleton, {
								isSmallScreen = true,
								launchSource = "LuaGameCard",
								universeId = v53
							}),
							errorSlot = React.createElement(ExperienceDetailsFallbackFeed.Error, {
								isSmallScreen = true,
								launchSource = "LuaGameCard",
								universeId = v53,
								refresh = v85,
								referralSource = v62,
								experienceJoinData = v63,
								placeIdOverride = v64
							})
						})
					})
				}),
				Actions = React.createElement(Sheet.Actions, {}, {
					ActionBarWrapper = React.createElement(Foundation.View, {
						tag = "col size-full-0 auto-y",
						padding = UDim.new(0, -v57.Margin.Small)
					}, {
						ActionBar = if not FFlagSduiEdpPersistentActionBarPlayButton then React.createElement(SduiFeatureEntryPoint, {
							appPage = AppPage.GameDetail,
							configKey = v55,
							identifier = ExperienceDetailsPageConstants.EDP_ACTION_BAR_IDENTIFIER,
							loadTimer = v56,
							AutomaticSize = Enum.AutomaticSize.XY,
							onAbsoluteSizeChange = v76,
							loadingSlot = React.createElement(ExperienceDetailsFallbackActionBar.Skeleton, {
								launchSource = "LuaGameCard",
								universeId = v53,
								referralSource = v62,
								experienceJoinData = v63,
								placeIdOverride = v64
							}),
							errorSlot = React.createElement(ExperienceDetailsFallbackActionBar.Error, {
								launchSource = "LuaGameCard",
								universeId = v53,
								referralSource = v62,
								experienceJoinData = v63,
								placeIdOverride = v64
							})
						}) else React.createElement(ExperienceDetailsPersistentActionBar, {
							launchSource = "LuaGameCard",
							universeId = v53,
							configKey = v55,
							loadTimer = v56,
							referralSource = v62,
							experienceJoinData = v63,
							placeIdOverride = v64,
							onAbsoluteSizeChange = v76
						})
					})
				})
			})
		}) or nil
	})
end

return React.memo(ExperienceDetailsBottomSheet)
