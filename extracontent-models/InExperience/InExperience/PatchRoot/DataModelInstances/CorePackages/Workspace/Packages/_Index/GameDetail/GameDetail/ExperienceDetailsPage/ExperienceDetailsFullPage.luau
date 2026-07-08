local GameDetail = script:FindFirstAncestor("GameDetail")
local GameDetailParent = GameDetail.Parent
local ExperienceDetailsPageUtils = require(script.Parent.ExperienceDetailsPageUtils)
local ExperienceDetailsPageConstants = require(script.Parent.ExperienceDetailsPageConstants)
local ExperienceDetailsPageScopeFields = require(script.Parent.ExperienceDetailsPageScopeFields)
local fetchExperienceDetailsPage = require(script.Parent.fetchExperienceDetailsPage)
local getExperienceDetailsPageKey = require(script.Parent.getExperienceDetailsPageKey)
local removeGameDetailSessionIfDeparted = require(script.Parent.removeGameDetailSessionIfDeparted)
local useEdpFunctionallyReadyLogger = require(script.Parent.useEdpFunctionallyReadyLogger)
local ExperienceDetailsFallbackBannerImage = require(script.Parent.Fallback.ExperienceDetailsFallbackBannerImage)
local ExperienceDetailsFallbackFeed = require(script.Parent.Fallback.ExperienceDetailsFallbackFeed)

require(GameDetailParent.Navigation)

local Foundation = require(GameDetailParent.Foundation)
local React = require(GameDetailParent.React)
local useTokens = Foundation.Hooks.useTokens
local AppSessionService = require(GameDetailParent.RoactServiceTags).AppSessionService
local useNavigation = require(GameDetailParent.Navigation).useNavigation
local useRoactService = require(GameDetailParent.RobloxAppHooks).useRoactService
local SessionType = require(GameDetailParent.RobloxAppSessionization).SessionType
local DetailsPageLayout = require(GameDetailParent.AppBlox).DetailsPageLayout
local AppPage = require(GameDetailParent.RobloxAppEnums).AppPage
local DataHydration = require(GameDetailParent.DataHydration)
local Responsive = require(GameDetailParent.Responsive)
local useGetCurrentLegacyRoute = require(GameDetailParent.DiscoveryRouting).useGetCurrentLegacyRoute
local EDPTTIConstants = require(GameDetailParent.GameDetailTelemetry).EDPTTIConstants
local SduiSharedUtilities = require(GameDetailParent.SduiSharedUtilities)
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local SduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local UiStatus = SduiSharedUtilities.UiStatus
local useUiStatus = SduiSharedUtilities.useUiStatus
local FilterPlayWithReward = ExperienceDetailsPageScopeFields.FilterPlayWithReward
local CompositionTags = require(GameDetailParent.AppComposition).CompositionTags
local SharedFlags = require(GameDetailParent.SharedFlags)
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local FFlagSduiPageEntryUseSharedHooks = SharedFlags.FFlagSduiPageEntryUseSharedHooks
local FFlagSduiEdpPageScopeTimerFix = SharedFlags.FFlagSduiEdpPageScopeTimerFix
local FFlagSduiPlayWithRewardGapFix = SharedFlags.FFlagSduiPlayWithRewardGapFix
local FFlagLuaAppSduiEdpRouteAwareSessionRemoval = SharedFlags.FFlagLuaAppSduiEdpRouteAwareSessionRemoval
local v41 = game:DefineFastInt("EdpFullBleedOverlapOffset", 180)
local v42 = game:DefineFastInt("EdpBannerBottomVisiblePercent", 20)
local t1 = {
	SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
	SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
	SelectionBehaviorRight = Enum.SelectionBehavior.Stop
}

local function ExperienceDetailsFullPage(p1) -- line: 67
	-- upvalues: GameDetail (copy), ExperienceDetailsPageUtils (copy), getExperienceDetailsPageKey (copy), React (copy), FFlagSduiEdpPageScopeTimerFix (copy), usePageScopeRef (copy), SduiSurfaceLoadTimeTracker (copy), EDPTTIConstants (copy), getSduiClientPageScope (copy), useEdpFunctionallyReadyLogger (copy), useNavigation (copy), useRoactService (copy), AppSessionService (copy), useTokens (copy), FFlagLuaAppSduiEdpRouteAwareSessionRemoval (copy), useGetCurrentLegacyRoute (copy), FFlagSduiPlayWithRewardGapFix (copy), FilterPlayWithReward (copy), removeGameDetailSessionIfDeparted (copy), SessionType (copy), fetchExperienceDetailsPage (copy), useUiStatus (copy), UiStatus (copy), DataHydration (copy), Responsive (copy), DetailsPageLayout (copy), t1 (copy), v41 (copy), v42 (copy), SduiFeatureEntryPoint (copy), AppPage (copy), ExperienceDetailsPageConstants (copy), ExperienceDetailsFallbackBannerImage (copy), Foundation (copy), SduiPageEntryPoint (copy), FFlagSduiPageEntryUseSharedHooks (copy), FFlagSduiExperienceDetailsSupport (copy), CompositionTags (copy), ExperienceDetailsFallbackFeed (copy)
	local useExperienceDetailsFocusNavigation = require(GameDetail.FocusNavigation.useExperienceDetailsFocusNavigation)
	local v47 = ExperienceDetailsPageUtils.getUniverseId(p1)
	local v48 = getExperienceDetailsPageKey(v47)
	local v49 = React.useRef(nil)

	if FFlagSduiEdpPageScopeTimerFix then
		usePageScopeRef(v48)
	end

	local v50 = React.useMemo(function() -- line: 78
		-- upvalues: ExperienceDetailsPageUtils (copy), p1 (copy), FFlagSduiEdpPageScopeTimerFix (copy), SduiSurfaceLoadTimeTracker (copy), v48 (copy), EDPTTIConstants (copy), getSduiClientPageScope (copy)
		local v63 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "pageTimer")

		if FFlagSduiEdpPageScopeTimerFix then
			local v64 = v63 or SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v48, {
				manualSurfaceReady = true,
				eventName = EDPTTIConstants.EDP_TTI_EVENT_NAME,
				metadata = {
					page = "Untracked",
					category = EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_FULL_PAGE
				}
			})

			getSduiClientPageScope(v48).set(SduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY, v64)

			return v64
		end

		if v63 then
			return v63
		end

		return SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v48, {
			manualSurfaceReady = true,
			eventName = EDPTTIConstants.EDP_TTI_EVENT_NAME,
			metadata = {
				page = "Untracked",
				category = EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_FULL_PAGE
			}
		})
	end, {})

	useEdpFunctionallyReadyLogger(v50, v47)

	local v51 = useNavigation()
	local v52 = useRoactService(AppSessionService)
	local v53 = useTokens()
	local u54 = nil

	if FFlagLuaAppSduiEdpRouteAwareSessionRemoval then
		u54 = useGetCurrentLegacyRoute()
	end

	local v55 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "referralSource")
	local v56 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "experienceJoinData")
	local v57 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p1, "placeIdOverride")

	if not FFlagSduiEdpPageScopeTimerFix then
		usePageScopeRef(v48)
	end

	React.useEffect(function() -- line: 125
		-- upvalues: getSduiClientPageScope (copy), v48 (copy), v55 (copy), v56 (copy), v57 (copy), FFlagSduiPlayWithRewardGapFix (copy), FilterPlayWithReward (copy)
		local v65 = getSduiClientPageScope(v48)

		v65.set("referralSource", v55)
		v65.set("experienceJoinData", v56)
		v65.set("placeId", v57)
		v65.set("launchSource", "ExperienceDetailsPage")

		if FFlagSduiPlayWithRewardGapFix then
			v65.set(FilterPlayWithReward, nil)
		end
	end, {
		v48,
		v55,
		v56,
		v57
	})

	local v58 = React.useCallback(function() -- line: 137
		-- upvalues: FFlagLuaAppSduiEdpRouteAwareSessionRemoval (copy), u54 (ref), v51 (copy), removeGameDetailSessionIfDeparted (copy), v52 (copy), SessionType (copy)
		local v66 = if not FFlagLuaAppSduiEdpRouteAwareSessionRemoval then nil else u54()

		v51.goBack()

		if FFlagLuaAppSduiEdpRouteAwareSessionRemoval then
			removeGameDetailSessionIfDeparted(v52, v66)

			return
		end

		if v52 then
			v52:RemoveSession(SessionType.StructuralIdentifier.GameDetailSource)
		end
	end, {
		v51,
		v52,
		if not FFlagLuaAppSduiEdpRouteAwareSessionRemoval then nil else u54
	})

	React.useEffect(function() -- line: 153
		-- upvalues: v47 (copy), v50 (copy), fetchExperienceDetailsPage (copy)
		if v47 and v50 then
			fetchExperienceDetailsPage(v47, v50)
		end
	end, {
		v47,
		v50
	})

	local v59 = useUiStatus(v48)

	React.useEffect(function() -- line: 160
		-- upvalues: v59 (copy), UiStatus (copy), v47 (copy), DataHydration (copy)
		if v59 == UiStatus.Error and v47 then
			DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(v47, function(p2) -- line: 164
				return p2 == nil or p2.creator == nil
			end)
			DataHydration.Game.getAgeRecommendationStore(false).getAndFetchAgeRecommendation(v47)
		end
	end, {
		v59,
		v47
	})

	local v60 = React.useCallback(function() -- line: 171
		-- upvalues: v47 (copy), v50 (copy), fetchExperienceDetailsPage (copy)
		if v47 and v50 then
			fetchExperienceDetailsPage(v47, v50, true)
		end
	end, {
		v47,
		v50
	})
	local v61 = useExperienceDetailsFocusNavigation(v58)
	local v62 = Responsive.usePreferredInput() == Responsive.Input.Directional

	if v47 == nil then
		return nil
	end

	return React.createElement(DetailsPageLayout.Root, {
		ref = v61,
		onClose = if not v62 then v58 else nil,
		selectionGroup = t1,
		fullBleedOverlapOffset = v41,
		bannerBottomVisiblePercent = v42 / 100,
		fullBleedContent = React.createElement(SduiFeatureEntryPoint, {
			appPage = AppPage.ExperienceDetail,
			configKey = v48,
			identifier = ExperienceDetailsPageConstants.EDP_BANNER_IMAGE_IDENTIFIER,
			loadTimer = v50,
			Size = UDim2.fromScale(1, 1),
			loadingSlot = React.createElement(ExperienceDetailsFallbackBannerImage.Skeleton),
			errorSlot = React.createElement(ExperienceDetailsFallbackBannerImage.Error, {
				universeId = v47
			})
		})
	}, {
		Header = if not v62 then React.createElement(DetailsPageLayout.Header, {
			fullWidthContent = true,
			closeIconName = Foundation.Enums.IconName.X,
			backgroundColor = v53.Color.Surface.Surface_300
		}, {
			StickyHeaderContent = React.createElement(SduiFeatureEntryPoint, {
				shouldDisplayLoading = false,
				shouldDisplayError = false,
				appPage = AppPage.ExperienceDetail,
				configKey = v48,
				identifier = ExperienceDetailsPageConstants.EDP_STICKY_HEADER_IDENTIFIER,
				loadTimer = v50,
				Size = UDim2.fromScale(1, 1),
				AutomaticSize = Enum.AutomaticSize.None
			})
		}) else nil,
		Content = React.createElement(DetailsPageLayout.Content, {
			scrollingFrameRef = v49
		}, {
			Feed = React.createElement(SduiPageEntryPoint, {
				includeNavigationHeaderBar = false,
				snackbarPortalLayoutOrder = 2147483647,
				appPage = AppPage.ExperienceDetail,
				configKey = v48,
				identifier = if not FFlagSduiPageEntryUseSharedHooks then ExperienceDetailsPageUtils.getResolvedIdentifier(v48, ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER_SUFFIX) else ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER,
				pageTimer = v50,
				scrollingFrameRef = v49,
				backgroundStyle = v53.Color.None,
				disableRootPadding = not not FFlagSduiExperienceDetailsSupport or nil,
				clipsDescendantsOverride = not FFlagSduiExperienceDetailsSupport and nil,
				contentTag = CompositionTags.ContentRegion.Body,
				loadingSlot = React.createElement(ExperienceDetailsFallbackFeed.Skeleton, {
					launchSource = "ExperienceDetailsPage",
					isSmallScreen = false,
					universeId = v47,
					referralSource = v55,
					experienceJoinData = v56,
					placeIdOverride = v57
				}),
				errorSlot = React.createElement(ExperienceDetailsFallbackFeed.Error, {
					launchSource = "ExperienceDetailsPage",
					isSmallScreen = false,
					universeId = v47,
					refresh = v60,
					referralSource = v55,
					experienceJoinData = v56,
					placeIdOverride = v57
				})
			})
		})
	})
end

return React.memo(ExperienceDetailsFullPage)
