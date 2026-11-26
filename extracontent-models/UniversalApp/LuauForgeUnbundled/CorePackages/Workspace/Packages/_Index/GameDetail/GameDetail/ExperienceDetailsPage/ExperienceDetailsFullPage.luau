local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/AppCommonLib").isTenFootInterface

local FFlagSduiEdpRenderStarted = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/Flags/FFlagSduiEdpRenderStarted")
local ExperienceDetailsPageUtils = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/ExperienceDetailsPageUtils")
local ExperienceDetailsPageConstants = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/ExperienceDetailsPageConstants")
local ExperienceDetailsPageScopeFields = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/ExperienceDetailsPageScopeFields")
local fetchExperienceDetailsPage = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/fetchExperienceDetailsPage")
local getExperienceDetailsPageKey = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/getExperienceDetailsPageKey")
local removeGameDetailSessionIfDeparted = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/removeGameDetailSessionIfDeparted")
local useEdpFunctionallyReadyLogger = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/useEdpFunctionallyReadyLogger")
local createExperienceDetailsPageTimer = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/createExperienceDetailsPageTimer")
local ExperienceDetailsFallbackBannerImage = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/Fallback/ExperienceDetailsFallbackBannerImage")
local ExperienceDetailsFallbackFeed = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/Fallback/ExperienceDetailsFallbackFeed")
local ExperienceDetailsPersistentActionBar = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/ExperienceDetailsPersistentActionBar")

require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Navigation")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/React")
local useTokens = Foundation.Hooks.useTokens
local appSessionService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RoactServiceTags").AppSessionService
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Navigation").useNavigation
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppHooks").useRoactService
local detailsPageLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/AppBlox").DetailsPageLayout
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppEnums").AppPage
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/DataHydration")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Responsive")
local useGetCurrentLegacyRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/DiscoveryRouting").useGetCurrentLegacyRoute

local edpttiConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/GameDetailTelemetry").EDPTTIConstants

local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SduiSharedUtilities")
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local sduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local sduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local sduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local uiStatus = SduiSharedUtilities.UiStatus
local usePublishContainerWidth = SduiSharedUtilities.usePublishContainerWidth
local useUiStatus = SduiSharedUtilities.useUiStatus
local filterPlayWithReward = ExperienceDetailsPageScopeFields.FilterPlayWithReward
local isTenFoot = ExperienceDetailsPageScopeFields.IsTenFoot

local compositionTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/AppComposition").CompositionTags

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SharedFlags")
local fFlagEDPTTIParityDefinitions = SharedFlags.FFlagEDPTTIParityDefinitions
local fFlagSduiPageEntryUseSharedHooks = SharedFlags.FFlagSduiPageEntryUseSharedHooks
local fFlagSduiContainerQueries = SharedFlags.FFlagSduiContainerQueries
local defineFastFlag = game:DefineFastFlag("SduiEdpPageScopeIsTenFoot", false)
local fFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local fFlagLuaAppEdpDirectionalGradientMidTransparency = SharedFlags.FFlagLuaAppEdpDirectionalGradientMidTransparency
local fFlagEnableSplitPaneEDPFix = SharedFlags.FFlagEnableSplitPaneEDPFix
local defineFastInt = game:DefineFastInt("EdpBannerAspectRatioTenths", 0)
local defineFastInt2 = game:DefineFastInt("EdpFullBleedOverlapOffset", 180)
local defineFastInt3 = game:DefineFastInt("EdpGradientTopBleedOffset", 120)
local defineFastInt4 = game:DefineFastInt("EdpBannerBottomVisiblePercent", 20)
local defineFastInt5 = game:DefineFastInt("EdpDirectionalFullBleedOverlapOffset", 195)
local defineFastInt6 = game:DefineFastInt("EdpDirectionalBannerBottomVisiblePercent", 50)

local defineFastInt7 = game:DefineFastInt("EdpDirectionalGradientMidTransparencyHundredths", 12)

local v5 = {
	SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
	SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
	SelectionBehaviorRight = Enum.SelectionBehavior.Stop
}

local function ExperienceDetailsFullPage(p2)
	local useExperienceDetailsFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/FocusNavigation/useExperienceDetailsFocusNavigation")

	local universeId = ExperienceDetailsPageUtils.getUniverseId(p2)
	local v6 = getExperienceDetailsPageKey(universeId)

	local ref = React.useRef(nil)
	usePageScopeRef(v6)
	local v7 = React.useMemo(function()
		local v8 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p2, "pageTimer")
		local v9

		if fFlagEDPTTIParityDefinitions then
			v9 = v8
				or createExperienceDetailsPageTimer(v6, {
					page = "Untracked",
					category = edpttiConstants.EDP_IMPLEMENTATION.SDUI_FULL_PAGE
				})
		else
			v9 = v8 or sduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v6, {
				eventName = edpttiConstants.EDP_TTI_EVENT_NAME,
				metadata = {
					page = "Untracked",
					category = edpttiConstants.EDP_IMPLEMENTATION.SDUI_FULL_PAGE
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

	local v8 = useNavigation()
	local v9 = useRoactService(appSessionService)
	local v10 = useTokens()

	local v11 = useGetCurrentLegacyRoute()

	local v12 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p2, "referralSource")
	local v13 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p2, "experienceJoinData")
	local v14 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p2, "placeIdOverride")
	React.useEffect(function()
		local sduiClientPageScope = getSduiClientPageScope(v6)
		sduiClientPageScope.set("referralSource", v12)
		sduiClientPageScope.set("experienceJoinData", v13)
		sduiClientPageScope.set("placeId", v14)
		sduiClientPageScope.set("launchSource", "ExperienceDetailsPage")
		sduiClientPageScope.set(filterPlayWithReward, nil)

		if defineFastFlag then
			sduiClientPageScope.set(isTenFoot, isTenFootInterface())
		end
	end, { v6, v12, v13, v14 })

	local v15 = React.useCallback(function()
		local v16 = v11()
		v8.goBack()
		removeGameDetailSessionIfDeparted(v9, v16)
	end, { v8, v9, v11 })

	React.useEffect(function()
		if universeId and v7 then
			fetchExperienceDetailsPage(universeId, v7)
		end
	end, { universeId, v7 })

	local v16 = useUiStatus(v6)
	React.useEffect(function()
		if v16 == uiStatus.Error and universeId then
			DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(universeId, function(p3): boolean
				return p3 == nil or p3.creator == nil
			end)

			DataHydration.Game.getAgeRecommendationStore(false).getAndFetchAgeRecommendation(universeId)
		end
	end, { v16, universeId })

	local v17 = React.useCallback(function()
		if universeId and v7 then
			fetchExperienceDetailsPage(universeId, v7, true)
		end
	end, { universeId, v7 })

	local v18 = useExperienceDetailsFocusNavigation(v15)

	if fFlagSduiContainerQueries then
		v18 = usePublishContainerWidth(v6, v18)
	end

	local v19

	if fFlagLuaAppMediaGalleryGamepadSupport then
		v19 = Responsive.useLastInput() == Responsive.Input.Directional
	else
		v19 = Responsive.usePreferredInput() == Responsive.Input.Directional
	end

	local v20 = if fFlagEnableSplitPaneEDPFix then p2.hideCloseButtonOnHeader == true else nil

	if fFlagEnableSplitPaneEDPFix then
		React.useEffect(function()
			getSduiClientPageScope(v6).set(ExperienceDetailsPageScopeFields.HideCloseButtonOnHeader, v20)
		end, { v6, v20 })
	end

	local v21, v22

	if fFlagEnableSplitPaneEDPFix then
		v21 = p2.showBottomActionBar == true
		v22 = v19 or v21
	else
		v22 = v19
	end

	if universeId == nil then
		return nil
	end

	local createElement = React.createElement
	local root = detailsPageLayout.Root

	if v22 or v20 then
		v15 = nil
	end

	local v23 = {
		ref = v18,
		onClose = v15,
		selectionGroup = v5,
		fullBleedAspectRatio = 0,
		fullBleedOverlapOffset = 0,
		gradientTopBleedOffset = 0,
		gradientMidTransparency = 0,
		bannerBottomVisiblePercent = 0,
		reserveHeaderBarSpace = 0,
		disableFocusNavEngineScroll = 0,
		fullBleedContent = 0
	}

	local v24 = if fFlagLuaAppMediaGalleryGamepadSupport and v19 and defineFastInt > 0 then defineFastInt / 10 else nil
	v23.fullBleedAspectRatio = v24
	local v25 = if fFlagLuaAppMediaGalleryGamepadSupport and v19 then defineFastInt5 else defineFastInt2
	v23.fullBleedOverlapOffset = v25
	local v26 = if fFlagLuaAppMediaGalleryGamepadSupport and v19 then defineFastInt3 else nil
	v23.gradientTopBleedOffset = v26

	local v27 = if fFlagLuaAppEdpDirectionalGradientMidTransparency and fFlagLuaAppMediaGalleryGamepadSupport and v19 then defineFastInt7 / 100 else nil
	v23.gradientMidTransparency = v27

	local v28 = if fFlagLuaAppMediaGalleryGamepadSupport and v19 then defineFastInt6 / 100 else defineFastInt4 / 100
	v23.bannerBottomVisiblePercent = v28
	local v29 = if fFlagLuaAppMediaGalleryGamepadSupport and v19 then false else nil
	v23.reserveHeaderBarSpace = v29
	v23.disableFocusNavEngineScroll = fFlagLuaAppMediaGalleryGamepadSupport and v19 and true or nil

	v23.fullBleedContent = React.createElement(sduiFeatureEntryPoint, {
		appPage = appPage.ExperienceDetail,
		configKey = v6,
		identifier = ExperienceDetailsPageConstants.EDP_BANNER_IMAGE_IDENTIFIER,
		loadTimer = v7,
		Size = UDim2.fromScale(1, 1),
		loadingSlot = React.createElement(ExperienceDetailsFallbackBannerImage.Skeleton),
		errorSlot = React.createElement(ExperienceDetailsFallbackBannerImage.Error, { universeId = universeId })
	})

	local v31 = if not v22 then React.createElement(
		detailsPageLayout.Header,
		{
			closeIconName = Foundation.Enums.IconName.X,
			backgroundColor = v10.Color.Surface.Surface_300,
			fullWidthContent = true
		},
		{
			StickyHeaderContent = React.createElement(sduiFeatureEntryPoint, {
				appPage = appPage.ExperienceDetail,
				configKey = v6,
				identifier = ExperienceDetailsPageConstants.EDP_STICKY_HEADER_IDENTIFIER,
				loadTimer = v7,
				shouldDisplayLoading = false,
				shouldDisplayError = false,
				Size = UDim2.fromScale(1, 1),
				AutomaticSize = Enum.AutomaticSize.None
			})
		}
	) else nil

	local createElement2 = React.createElement
	local content = detailsPageLayout.Content

	local createElement3 = React.createElement
	local children = {
		appPage = appPage.ExperienceDetail,
		configKey = v6,
		identifier = 0,
		pageTimer = 0,
		includeNavigationHeaderBar = false,
		scrollingFrameRef = 0,
		scrollToSelectionRevealOnly = 0,
		backgroundStyle = 0,
		disableRootPadding = true,
		clipsDescendantsOverride = false,
		contentTag = 0,
		loadingSlot = 0,
		errorSlot = 0,
		snackbarPortalLayoutOrder = 2147483647
	}

	local v35 = if fFlagSduiPageEntryUseSharedHooks then ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER else ExperienceDetailsPageUtils.getResolvedIdentifier(
		v6,
		ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER_SUFFIX
	)
	children.identifier = v35

	children.pageTimer = v7

	children.scrollingFrameRef = ref
	children.scrollToSelectionRevealOnly = fFlagLuaAppMediaGalleryGamepadSupport and v19 and true or nil

	children.backgroundStyle = v10.Color.None

	children.contentTag = compositionTags.ContentRegion.Body
	children.loadingSlot = React.createElement(ExperienceDetailsFallbackFeed.Skeleton, {
		universeId = universeId,
		launchSource = "ExperienceDetailsPage",
		isSmallScreen = false,
		referralSource = v12,
		experienceJoinData = v13,
		placeIdOverride = v14
	})

	children.errorSlot = React.createElement(ExperienceDetailsFallbackFeed.Error, {
		universeId = universeId,
		refresh = v17,
		launchSource = "ExperienceDetailsPage",
		isSmallScreen = false,
		referralSource = v12,
		experienceJoinData = v13,
		placeIdOverride = v14
	})
	local v30 = {
		Header = v31,
		Content = createElement2(content, { scrollingFrameRef = ref }, {
			Feed = createElement3(sduiPageEntryPoint, children)
		}),
		Actions = 0
	}

	local v36 = if fFlagEnableSplitPaneEDPFix and v21 then React.createElement(detailsPageLayout.Actions, {}, {
		ActionBar = React.createElement(ExperienceDetailsPersistentActionBar, {
			universeId = universeId,
			configKey = v6,
			loadTimer = v7,
			launchSource = "ExperienceDetailsPage",
			referralSource = v12,
			experienceJoinData = v13,
			placeIdOverride = v14,
			showOutline = false
		})
	}) else nil
	v30.Actions = v36
	return createElement(root, v23, v30)
end

return React.memo(ExperienceDetailsFullPage)
