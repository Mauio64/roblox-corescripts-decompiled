local GameDetail = script:FindFirstAncestor("GameDetail")
local parent = GameDetail.Parent

local AppCommonLib = require(parent.AppCommonLib)
local isTenFootInterface = AppCommonLib.isTenFootInterface

local FFlagSduiEdpRenderStarted = require(GameDetail.Flags.FFlagSduiEdpRenderStarted)
local ExperienceDetailsPageUtils = require(script.Parent.ExperienceDetailsPageUtils)
local ExperienceDetailsPageConstants = require(script.Parent.ExperienceDetailsPageConstants)
local ExperienceDetailsPageScopeFields = require(script.Parent.ExperienceDetailsPageScopeFields)
local fetchExperienceDetailsPage = require(script.Parent.fetchExperienceDetailsPage)
local getExperienceDetailsPageKey = require(script.Parent.getExperienceDetailsPageKey)
local removeGameDetailSessionIfDeparted = require(script.Parent.removeGameDetailSessionIfDeparted)
local useEdpFunctionallyReadyLogger = require(script.Parent.useEdpFunctionallyReadyLogger)
local createExperienceDetailsPageTimer = require(script.Parent.createExperienceDetailsPageTimer)
local ExperienceDetailsFallbackBannerImage = require(script.Parent.Fallback.ExperienceDetailsFallbackBannerImage)
local ExperienceDetailsFallbackFeed = require(script.Parent.Fallback.ExperienceDetailsFallbackFeed)
local ExperienceDetailsPersistentActionBar = require(script.Parent.ExperienceDetailsPersistentActionBar)

require(parent.Navigation)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local useTokens = Foundation.Hooks.useTokens
local RoactServiceTags = require(parent.RoactServiceTags)
local AppSessionService = RoactServiceTags.AppSessionService
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local AppBlox = require(parent.AppBlox)
local DetailsPageLayout = AppBlox.DetailsPageLayout
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local DataHydration = require(parent.DataHydration)
local Responsive = require(parent.Responsive)
local DiscoveryRouting = require(parent.DiscoveryRouting)
local useGetCurrentLegacyRoute = DiscoveryRouting.useGetCurrentLegacyRoute

local GameDetailTelemetry = require(parent.GameDetailTelemetry)
local EDPTTIConstants = GameDetailTelemetry.EDPTTIConstants

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local SduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local UiStatus = SduiSharedUtilities.UiStatus
local usePublishContainerWidth = SduiSharedUtilities.usePublishContainerWidth
local useUiStatus = SduiSharedUtilities.useUiStatus
local FilterPlayWithReward = ExperienceDetailsPageScopeFields.FilterPlayWithReward
local IsTenFoot = ExperienceDetailsPageScopeFields.IsTenFoot

local AppComposition = require(parent.AppComposition)
local CompositionTags = AppComposition.CompositionTags

local SharedFlags = require(parent.SharedFlags)
local FFlagEDPTTIParityDefinitions = SharedFlags.FFlagEDPTTIParityDefinitions
local FFlagSduiPageEntryUseSharedHooks = SharedFlags.FFlagSduiPageEntryUseSharedHooks
local FFlagSduiContainerQueries = SharedFlags.FFlagSduiContainerQueries
local defineFastFlag = game:DefineFastFlag("SduiEdpPageScopeIsTenFoot", false)
local FFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local FFlagLuaAppEdpDirectionalGradientMidTransparency = SharedFlags.FFlagLuaAppEdpDirectionalGradientMidTransparency
local FFlagEnableSplitPaneEDPFix = SharedFlags.FFlagEnableSplitPaneEDPFix
local defineFastInt = game:DefineFastInt("EdpBannerAspectRatioTenths", 0)
local defineFastInt2 = game:DefineFastInt("EdpFullBleedOverlapOffset", 180)
local defineFastInt3 = game:DefineFastInt("EdpGradientTopBleedOffset", 120)
local defineFastInt4 = game:DefineFastInt("EdpBannerBottomVisiblePercent", 20)
local defineFastInt5 = game:DefineFastInt("EdpDirectionalFullBleedOverlapOffset", 195)
local defineFastInt6 = game:DefineFastInt("EdpDirectionalBannerBottomVisiblePercent", 50)

local defineFastInt7 = game:DefineFastInt("EdpDirectionalGradientMidTransparencyHundredths", 12)

local selectionGroup = {
	SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
	SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
	SelectionBehaviorRight = Enum.SelectionBehavior.Stop
}

local function ExperienceDetailsFullPage(p)
	local useExperienceDetailsFocusNavigation = require(GameDetail.FocusNavigation.useExperienceDetailsFocusNavigation)

	local universeId = ExperienceDetailsPageUtils.getUniverseId(p)
	local experienceDetailsPageKey = getExperienceDetailsPageKey(universeId)

	local ref = React.useRef(nil)
	usePageScopeRef(experienceDetailsPageKey)
	local v = React.useMemo(function()
		local v = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p, "pageTimer")
		local v2

		if FFlagEDPTTIParityDefinitions then
			v2 = v
				or createExperienceDetailsPageTimer(experienceDetailsPageKey, {
					page = "Untracked",
					category = EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_FULL_PAGE
				})
		else
			v2 = v or SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(experienceDetailsPageKey, {
				eventName = EDPTTIConstants.EDP_TTI_EVENT_NAME,
				metadata = {
					page = "Untracked",
					category = EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_FULL_PAGE
				},
				manualSurfaceReady = true
			})
		end

		getSduiClientPageScope(experienceDetailsPageKey).set(
			SduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY,
			v2
		)
		return v2
	end, {})

	if FFlagSduiEdpRenderStarted then
		v.logRenderStarted()
	end

	useEdpFunctionallyReadyLogger(v, universeId)

	local v2 = useNavigation()
	local v3 = useRoactService(AppSessionService)
	local v4 = useTokens()

	local v5 = useGetCurrentLegacyRoute()

	local referralSource = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p, "referralSource")
	local experienceJoinData = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p, "experienceJoinData")
	local placeIdOverride = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(p, "placeIdOverride")
	React.useEffect(function()
		local sduiClientPageScope = getSduiClientPageScope(experienceDetailsPageKey)
		sduiClientPageScope.set("referralSource", referralSource)
		sduiClientPageScope.set("experienceJoinData", experienceJoinData)
		sduiClientPageScope.set("placeId", placeIdOverride)
		sduiClientPageScope.set("launchSource", "ExperienceDetailsPage")
		sduiClientPageScope.set(FilterPlayWithReward, nil)

		if defineFastFlag then
			sduiClientPageScope.set(IsTenFoot, isTenFootInterface())
		end
	end, { experienceDetailsPageKey, referralSource, experienceJoinData, placeIdOverride })

	local onClose = React.useCallback(function()
		local v6 = v5()
		v2.goBack()
		removeGameDetailSessionIfDeparted(v3, v6)
	end, { v2, v3, v5 })

	React.useEffect(function()
		if universeId and v then
			fetchExperienceDetailsPage(universeId, v)
		end
	end, { universeId, v })

	local v6 = useUiStatus(experienceDetailsPageKey)
	React.useEffect(function()
		if v6 == UiStatus.Error and universeId then
			DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(universeId, function(p2): boolean
				return p2 == nil or p2.creator == nil
			end)

			DataHydration.Game.getAgeRecommendationStore(false).getAndFetchAgeRecommendation(universeId)
		end
	end, { v6, universeId })

	local refresh = React.useCallback(function()
		if universeId and v then
			fetchExperienceDetailsPage(universeId, v, true)
		end
	end, { universeId, v })

	local ref2 = useExperienceDetailsFocusNavigation(onClose)

	if FFlagSduiContainerQueries then
		ref2 = usePublishContainerWidth(experienceDetailsPageKey, ref2)
	end

	local v7

	if FFlagLuaAppMediaGalleryGamepadSupport then
		v7 = Responsive.useLastInput() == Responsive.Input.Directional
	else
		v7 = Responsive.usePreferredInput() == Responsive.Input.Directional
	end

	local v8

	if FFlagEnableSplitPaneEDPFix then
		v8 = p.hideCloseButtonOnHeader == true
	else
		v8 = nil
	end

	if FFlagEnableSplitPaneEDPFix then
		React.useEffect(function()
			getSduiClientPageScope(experienceDetailsPageKey).set(
				ExperienceDetailsPageScopeFields.HideCloseButtonOnHeader,
				v8
			)
		end, { experienceDetailsPageKey, v8 })
	end

	local v9, v10

	if FFlagEnableSplitPaneEDPFix then
		v9 = p.showBottomActionBar == true
		v10 = v7 or v9
	else
		v10 = v7
	end

	if universeId == nil then
		return nil
	end

	local createElement = React.createElement
	local root = DetailsPageLayout.Root

	if v10 or v8 then
		onClose = nil
	end

	local v11 = {
		ref = ref2,
		onClose = onClose,
		selectionGroup = selectionGroup,
		fullBleedAspectRatio = 0,
		fullBleedOverlapOffset = 0,
		gradientTopBleedOffset = 0,
		gradientMidTransparency = 0,
		bannerBottomVisiblePercent = 0,
		reserveHeaderBarSpace = 0,
		disableFocusNavEngineScroll = 0,
		fullBleedContent = 0
	}
	local fullBleedAspectRatio

	if FFlagLuaAppMediaGalleryGamepadSupport and v7 and defineFastInt > 0 then
		fullBleedAspectRatio = defineFastInt / 10
	end

	v11.fullBleedAspectRatio = fullBleedAspectRatio
	local fullBleedOverlapOffset

	if FFlagLuaAppMediaGalleryGamepadSupport and v7 then
		fullBleedOverlapOffset = defineFastInt5
	else
		fullBleedOverlapOffset = defineFastInt2
	end

	v11.fullBleedOverlapOffset = fullBleedOverlapOffset
	local gradientTopBleedOffset

	if FFlagLuaAppMediaGalleryGamepadSupport and v7 then
		gradientTopBleedOffset = defineFastInt3
	end

	v11.gradientTopBleedOffset = gradientTopBleedOffset
	local gradientMidTransparency

	if FFlagLuaAppEdpDirectionalGradientMidTransparency and FFlagLuaAppMediaGalleryGamepadSupport and v7 then
		gradientMidTransparency = defineFastInt7 / 100
	end

	v11.gradientMidTransparency = gradientMidTransparency
	local bannerBottomVisiblePercent

	if FFlagLuaAppMediaGalleryGamepadSupport and v7 then
		bannerBottomVisiblePercent = defineFastInt6 / 100
	else
		bannerBottomVisiblePercent = defineFastInt4 / 100
	end

	v11.bannerBottomVisiblePercent = bannerBottomVisiblePercent

	v11.reserveHeaderBarSpace = not (FFlagLuaAppMediaGalleryGamepadSupport and v7) and nil
	v11.disableFocusNavEngineScroll = FFlagLuaAppMediaGalleryGamepadSupport and v7 and true or nil

	v11.fullBleedContent = React.createElement(SduiFeatureEntryPoint, {
		appPage = AppPage.ExperienceDetail,
		configKey = experienceDetailsPageKey,
		identifier = ExperienceDetailsPageConstants.EDP_BANNER_IMAGE_IDENTIFIER,
		loadTimer = v,
		Size = UDim2.fromScale(1, 1),
		loadingSlot = React.createElement(ExperienceDetailsFallbackBannerImage.Skeleton),
		errorSlot = React.createElement(ExperienceDetailsFallbackBannerImage.Error, {
			universeId = universeId
		})
	})
	local header

	if not v10 then
		header = React.createElement(
			DetailsPageLayout.Header,
			{
				closeIconName = Foundation.Enums.IconName.X,
				backgroundColor = v4.Color.Surface.Surface_300,
				fullWidthContent = true
			},
			{
				StickyHeaderContent = React.createElement(SduiFeatureEntryPoint, {
					appPage = AppPage.ExperienceDetail,
					configKey = experienceDetailsPageKey,
					identifier = ExperienceDetailsPageConstants.EDP_STICKY_HEADER_IDENTIFIER,
					loadTimer = v,
					shouldDisplayLoading = false,
					shouldDisplayError = false,
					Size = UDim2.fromScale(1, 1),
					AutomaticSize = Enum.AutomaticSize.None
				})
			}
		)
	end

	local createElement2 = React.createElement
	local content = DetailsPageLayout.Content

	local createElement3 = React.createElement
	local children = {
		appPage = AppPage.ExperienceDetail,
		configKey = experienceDetailsPageKey,
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
	local identifier

	if FFlagSduiPageEntryUseSharedHooks then
		identifier = ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER
	else
		identifier = ExperienceDetailsPageUtils.getResolvedIdentifier(
			experienceDetailsPageKey,
			ExperienceDetailsPageConstants.EDP_FEED_IDENTIFIER_SUFFIX
		)
	end

	children.identifier = identifier

	children.pageTimer = v

	children.scrollingFrameRef = ref
	children.scrollToSelectionRevealOnly = FFlagLuaAppMediaGalleryGamepadSupport and v7 and true or nil

	children.backgroundStyle = v4.Color.None

	children.contentTag = CompositionTags.ContentRegion.Body
	children.loadingSlot = React.createElement(ExperienceDetailsFallbackFeed.Skeleton, {
		universeId = universeId,
		launchSource = "ExperienceDetailsPage",
		isSmallScreen = false,
		referralSource = referralSource,
		experienceJoinData = experienceJoinData,
		placeIdOverride = placeIdOverride
	})

	children.errorSlot = React.createElement(ExperienceDetailsFallbackFeed.Error, {
		universeId = universeId,
		refresh = refresh,
		launchSource = "ExperienceDetailsPage",
		isSmallScreen = false,
		referralSource = referralSource,
		experienceJoinData = experienceJoinData,
		placeIdOverride = placeIdOverride
	})
	local v12 = {
		Header = header,
		Content = createElement2(content, { scrollingFrameRef = ref }, {
			Feed = createElement3(SduiPageEntryPoint, children)
		}),
		Actions = 0
	}
	local actions

	if FFlagEnableSplitPaneEDPFix and v9 then
		actions = React.createElement(DetailsPageLayout.Actions, {}, {
			ActionBar = React.createElement(ExperienceDetailsPersistentActionBar, {
				universeId = universeId,
				configKey = experienceDetailsPageKey,
				loadTimer = v,
				launchSource = "ExperienceDetailsPage",
				referralSource = referralSource,
				experienceJoinData = experienceJoinData,
				placeIdOverride = placeIdOverride,
				showOutline = false
			})
		})
	end

	v12.Actions = actions
	return createElement(root, v11, v12)
end

return React.memo(ExperienceDetailsFullPage)
