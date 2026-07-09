local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default

default:logEventOnce("home_page_require_begin")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local getTestId = require(CorePackages.Workspace.Packages.RoactUtils).getTestId
local combineReactTags = require(CorePackages.Workspace.Packages.RoactUtils).combineReactTags
local t = require(CorePackages.Packages.t)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppNotificationService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppNotificationService
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local ServerTriggeredModals = require(CorePackages.Workspace.Packages.ServerTriggeredModals)
local CheckForSduiModal = ServerTriggeredModals.CheckForSduiModal
local CheckForPrompts = ServerTriggeredModals.CheckForPrompts
local PromptsSystemBanner = ServerTriggeredModals.PromptsSystemBanner
local PromptsHandler = ServerTriggeredModals.PromptsHandler
local PromptsEntryPoint = ServerTriggeredModals.PromptsEntryPoint
local PromptStyle = ServerTriggeredModals.PromptStyle
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local HomeOmniFeed = require(Modules.Personalization.Home.HomeOmniFeed.HomeOmniFeed)
local withThrottleFramerateGivenPolicy = require(Modules.LuaApp.Common.withThrottleFramerateGivenPolicy)
local PersonalizationTopBar = require(Modules.Personalization.PersonalizationTopBar)
local RobloxAppHooks = require(CorePackages.Workspace.Packages.RobloxAppHooks)
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local AppPage = require(Modules.LuaApp.AppPage)
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)
local HomePageLoadTracker = require(CorePackages.Workspace.Packages.HomePageLoadTracker).HomePageLoadTracker
local CheckForVngAppUpsell = require(Modules.Personalization.Home.VngAppUpsell.CheckForVngAppUpsell)
local CheckForPushNotificationsUpsell = require(Modules.Personalization.Home.PushNotificationsUpsell.CheckForPushNotificationsUpsell)
local CheckForReminderOfNorms = require(Modules.LuaApp.Components.Moderation.CheckForReminderOfNorms)
local FlyoutSidePanelIXP = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).FlyoutSidePanelIXP
local CompositionTags = require(CorePackages.Workspace.Packages.AppComposition).CompositionTags
local Sources = require(CorePackages.Workspace.Packages.SocialLuaAnalytics).Analytics.Enums.Sources
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusOnMount = require(CorePackages.Workspace.Packages.FocusNavigationUtils).useFocusOnMount
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local isSubjectToDesktopPolicies = require(CorePackages.Workspace.Packages.SharedFlags).isSubjectToDesktopPolicies
local GetFFlagEnableAccessBlockAtAppContainerLevel = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAccessBlockAtAppContainerLevel
local GetFFlagInjectAnalyticsService = require(Modules.LuaApp.Flags.GetFFlagInjectAnalyticsService)
local FFlagLuaAppHomeVngAppUpsell = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppHomeVngAppUpsell
local GetFFlagEnablePushNotificationsUpsellModal = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnablePushNotificationsUpsellModal
local GetFFlagEnableReminderOfNormsABTest = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableReminderOfNormsABTest
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagLuaAppsServerTriggeredModals = SharedFlags.FFlagLuaAppsServerTriggeredModals
local FFlagEnableSduiV2HomepagePrompts = SharedFlags.FFlagEnableSduiV2HomepagePrompts
local FFlagEnableHomepagePromptsForModalsAndBanners = SharedFlags.FFlagEnableHomepagePromptsForModalsAndBanners
local FFlagPromptsHandlerEnabled = SharedFlags.FFlagPromptsHandlerEnabled
local FFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local FFlagEnableLeftNavOnConsole = SharedFlags.FFlagEnableLeftNavOnConsole
local FFlagLuaAppEnableChartsPageProfileLink = SharedFlags.FFlagLuaAppEnableChartsPageProfileLink
local FFlagLuaAppCompositionHome = SharedFlags.FFlagLuaAppCompositionHome
local FFlagLuaAppAddTestIdsForArrow = SharedFlags.FFlagLuaAppAddTestIdsForArrow
local FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone = SharedFlags.FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone
local FFlagLuaAppsDefaultSelection = SharedFlags.FFlagLuaAppsDefaultSelection
local FFlagLuaAppHomePageLoadTracker = SharedFlags.FFlagLuaAppHomePageLoadTracker
local useTTINavigationTracking = require(CorePackages.Workspace.Packages.TTINavigationTracking).useTTINavigationTracking
local PromptsConstants = require(CorePackages.Workspace.Packages.ServerTriggeredModals).PromptsConstants

local function logFirstTileImageLoaded() -- line: 82
	-- upvalues: default (copy), FFlagLuaAppHomePageLoadTracker (copy), HomePageLoadTracker (copy)
	default:logEventOnce("home_first_tile_thumbnail_loaded")

	if FFlagLuaAppHomePageLoadTracker then
		HomePageLoadTracker.logFunctionallyReadyAndEnd()
	end
end

local v66 = React.PureComponent:extend("HomePageWithFeed")

v66.validateProps = t.strictInterface({
	homePageDataStatus = t.string,
	navigateToUAppBlock = if not GetFFlagEnableAccessBlockAtAppContainerLevel() then t.callback else nil,
	topBarHeight = if not FFlagAppIaScrollAway then nil else t.number,
	useGridPageLayout = t.optional(t.boolean),
	policyEnableHomePageAgeBlock = t.optional(t.boolean),
	setThrottleFramerateEnabled = t.optional(t.callback),
	navigation = t.table,
	screenProps = t.optional(t.table),
	notificationService = t.any,
	backgroundColor = t.Color3,
	backgroundTransparency = t.number,
	hasTopBar = t.boolean,
	onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t.optional(t.callback),
	defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else t.optional(t.callback),
	containerRef = if not FFlagLuaAppsDefaultSelection then nil else t.optional(t.callback)
})

function v66.init(p1) -- line: 124
	-- upvalues: GetFFlagEnableAccessBlockAtAppContainerLevel (copy), FFlagLuaAppHomePageLoadTracker (copy), HomePageLoadTracker (copy), isSubjectToDesktopPolicies (copy)
	if not GetFFlagEnableAccessBlockAtAppContainerLevel() and p1.props.policyEnableHomePageAgeBlock then
		p1.props.navigateToUAppBlock()
	end

	function p1.notifyPageLoaded() -- line: 131
		-- upvalues: p1 (copy)
		p1.props.notificationService:ActionEnabled(Enum.AppShellActionType.HomePageLoaded)
	end
	function p1.onDidFocus() -- line: 135
		-- upvalues: FFlagLuaAppHomePageLoadTracker (copy), HomePageLoadTracker (copy), isSubjectToDesktopPolicies (copy), p1 (copy)
		if FFlagLuaAppHomePageLoadTracker then
			HomePageLoadTracker.logSurfaceMounted()

			if HomePageLoadTracker.isWarmVisit() then
				HomePageLoadTracker.logFunctionallyReadyAndEnd()
			end
		end

		if isSubjectToDesktopPolicies() then
			p1.props.setThrottleFramerateEnabled(false)
		end
	end
	function p1.onWillBlur() -- line: 147
		-- upvalues: isSubjectToDesktopPolicies (copy), p1 (copy)
		if isSubjectToDesktopPolicies() then
			p1.props.setThrottleFramerateEnabled(true)
		end
	end
end
function v66.render(p2) -- line: 154
	-- upvalues: FFlagLuaAppHomePageLoadTracker (copy), HomePageLoadTracker (copy), React (copy), HomeOmniFeed (copy), FFlagLuaAppsDefaultSelection (copy), FFlagAppIaHomeSubTab (copy), FlyoutSidePanelIXP (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), TopBar (copy), PersonalizationTopBar (copy), FFlagLuaAppCompositionHome (copy), CompositionTags (copy), FFlagLuaAppEnableChartsPageProfileLink (copy), Sources (copy), FFlagPromptsHandlerEnabled (copy), PromptsHandler (copy), PromptsEntryPoint (copy), PromptStyle (copy), FFlagEnableHomepagePromptsForModalsAndBanners (copy), PromptsSystemBanner (copy), PromptsConstants (copy), AppPage (copy), RoactNavigation (copy), FFlagLuaAppHomeVngAppUpsell (copy), CheckForVngAppUpsell (copy), GetFFlagEnablePushNotificationsUpsellModal (copy), CheckForPushNotificationsUpsell (copy), GetFFlagEnableReminderOfNormsABTest (copy), CheckForReminderOfNorms (copy), FFlagLuaAppsServerTriggeredModals (copy), CheckForSduiModal (copy), FFlagEnableSduiV2HomepagePrompts (copy), CheckForPrompts (copy), FFlagLuaAppAddTestIdsForArrow (copy), getTestId (copy), combineReactTags (copy), GetFFlagInjectAnalyticsService (copy), withStyle (copy)
	if FFlagLuaAppHomePageLoadTracker then
		HomePageLoadTracker.logRenderStarted()
	end

	local function v73(_) -- line: 158
		-- upvalues: p2 (copy), React (copy), HomeOmniFeed (copy), FFlagLuaAppsDefaultSelection (copy), FFlagAppIaHomeSubTab (copy), FlyoutSidePanelIXP (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), TopBar (copy), PersonalizationTopBar (copy), FFlagLuaAppCompositionHome (copy), CompositionTags (copy), FFlagLuaAppEnableChartsPageProfileLink (copy), Sources (copy), FFlagPromptsHandlerEnabled (copy), PromptsHandler (copy), PromptsEntryPoint (copy), PromptStyle (copy), FFlagEnableHomepagePromptsForModalsAndBanners (copy), PromptsSystemBanner (copy), PromptsConstants (copy), AppPage (copy), RoactNavigation (copy), FFlagLuaAppHomeVngAppUpsell (copy), CheckForVngAppUpsell (copy), GetFFlagEnablePushNotificationsUpsellModal (copy), CheckForPushNotificationsUpsell (copy), GetFFlagEnableReminderOfNormsABTest (copy), CheckForReminderOfNorms (copy), FFlagLuaAppsServerTriggeredModals (copy), CheckForSduiModal (copy), FFlagEnableSduiV2HomepagePrompts (copy), CheckForPrompts (copy), FFlagLuaAppAddTestIdsForArrow (copy), getTestId (copy), combineReactTags (copy), GetFFlagInjectAnalyticsService (copy)
		local backgroundColor = p2.props.backgroundColor
		local backgroundTransparency = p2.props.backgroundTransparency
		local useGridPageLayout = p2.props.useGridPageLayout
		local v96 = React.createElement(HomeOmniFeed, {
			defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else p2.props.defaultFocusRef,
			canvasTopPadding = if not FFlagAppIaHomeSubTab or (not FlyoutSidePanelIXP.isHomeSubTabEnabled() or not FFlagAppIaScrollAway) then if not FFlagAppIaScrollAway or (not p2.props.hasTopBar or not AppNavBar.getScrollAwayEnabled()) then nil else p2.props.topBarHeight else if not p2.props.screenProps then nil else p2.props.screenProps.headerHeight,
			onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else p2.props.onTileImageLoaded
		})
		local v97 = React.createElement(TopBar.PageWrapper, {
			topBarSlot = if not FFlagAppIaHomeSubTab or not FlyoutSidePanelIXP.isHomeSubTabEnabled() then if not p2.props.hasTopBar then nil else React.createElement(PersonalizationTopBar, {
				tag = if not FFlagLuaAppCompositionHome then nil else CompositionTags.ContentRegion.Header,
				useGridPageLayout = useGridPageLayout,
				profileSource = if not FFlagLuaAppEnableChartsPageProfileLink then nil else Sources.HomePageSelfWidget,
				sideMarginOverride = if not FFlagLuaAppCompositionHome then nil else 0
			}) else nil,
			BackgroundColor3 = backgroundColor,
			BackgroundTransparency = backgroundTransparency
		}, {
			HomeOmniFeed = if not FFlagPromptsHandlerEnabled then if not FFlagEnableHomepagePromptsForModalsAndBanners then v96 else React.createElement(PromptsSystemBanner, {
				configKey = PromptsConstants.HOMEPAGE_PROMPTS_CONFIG_KEY,
				appPage = AppPage.Home,
				contentSlot = v96
			}) else React.createElement(PromptsHandler, {
				entryPoint = PromptsEntryPoint.HomepageLaunch,
				promptStyle = PromptStyle.SurfaceBanner,
				surfaceBannerContent = v96
			})
		})
		local t1 = {
			NavigationEvents = React.createElement(RoactNavigation.NavigationEvents, {
				onDidFocus = p2.onDidFocus,
				onWillBlur = p2.onWillBlur
			}),
			CheckForVngAppUpsell = if not FFlagLuaAppHomeVngAppUpsell then nil else React.createElement(CheckForVngAppUpsell),
			CheckForPushNotificationsUpsell = if not GetFFlagEnablePushNotificationsUpsellModal() then nil else React.createElement(CheckForPushNotificationsUpsell),
			CheckForReminderOfNorms = if not GetFFlagEnableReminderOfNormsABTest() then nil else React.createElement(CheckForReminderOfNorms),
			CheckForSduiModal = if not FFlagLuaAppsServerTriggeredModals then nil else React.createElement(CheckForSduiModal),
			CheckForPrompts = if not FFlagEnableSduiV2HomepagePrompts then nil else React.createElement(CheckForPrompts),
			Content = v97
		}
		local v99 = if not FFlagLuaAppAddTestIdsForArrow then nil else getTestId("page-home")

		return React.createElement("Frame", {
			ref = if not FFlagLuaAppsDefaultSelection then nil else p2.props.containerRef,
			[React.Tag] = if not FFlagLuaAppAddTestIdsForArrow then if not GetFFlagInjectAnalyticsService() then nil else "app-screen.home" else combineReactTags(if not GetFFlagInjectAnalyticsService() then nil else "app-screen.home", v99),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = backgroundColor,
			BackgroundTransparency = backgroundTransparency,
			BorderSizePixel = 0
		}, t1)
	end

	return withStyle(function(p4) -- line: 250
		-- upvalues: v73 (copy)
		return v73(p4)
	end)
end
function v66.didMount(p5) -- line: 255
	-- upvalues: RetrievalStatus (copy)
	p5.isMounted = true

	if p5.props.homePageDataStatus == RetrievalStatus.Done then
		p5.notifyPageLoaded()
	end

	p5.onDidFocus()
end
function v66.didUpdate(p6, p7) -- line: 265
	-- upvalues: GetFFlagEnableAccessBlockAtAppContainerLevel (copy), RetrievalStatus (copy)
	if not GetFFlagEnableAccessBlockAtAppContainerLevel() and p6.props.policyEnableHomePageAgeBlock then
		p6.props.navigateToUAppBlock()
	end

	local v77 = p6.props.homePageDataStatus == RetrievalStatus.Done
	local v78 = p7.homePageDataStatus == RetrievalStatus.Done

	if v77 and not v78 then
		p6.notifyPageLoaded()
	end
end
function v66.willUnmount(p8) -- line: 282
	p8.isMounted = false
end

local v67 = RoactRodux.connect(function(p9, _) -- line: 286
	-- upvalues: FFlagAppIaScrollAway (copy)
	return {
		homePageDataStatus = p9.Startup.HomePageDataStatus,
		topBarHeight = if not FFlagAppIaScrollAway then nil else p9.TopBar.topBarHeight
	}
end, function(p11) -- line: 291
	-- upvalues: GetFFlagEnableAccessBlockAtAppContainerLevel (copy), ResetNavigationHistory (copy), AppPage (copy)
	return {
		navigateToUAppBlock = not GetFFlagEnableAccessBlockAtAppContainerLevel() and function() -- line: 295
			-- upvalues: p11 (copy), ResetNavigationHistory (copy), AppPage (copy)
			p11(ResetNavigationHistory({{
				name = AppPage.UAppBlock
			}}))
		end or nil
	}
end)(v66)
local v68 = RoactNavigation.withNavigation(v67)
local v69 = RoactServices.connect({
	notificationService = AppNotificationService
})(function(p12) -- line: 304
	-- upvalues: SharedFlags (copy), useTTINavigationTracking (copy), useDesignTokens (copy), useUiModeInfo (copy), UiMode (copy), FFlagEnableLeftNavOnConsole (copy), FFlagLuaAppsDefaultSelection (copy), ReactFocusNavigation (copy), useFocusOnMount (copy), Cryo (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), logFirstTileImageLoaded (copy), React (copy), v68 (copy)
	if SharedFlags.FFlagLuaAppNavigationTTITracking then
		useTTINavigationTracking("NavigateTo_Home")
	end

	local v84 = useDesignTokens()
	local v85 = useUiModeInfo().uiMode ~= UiMode.TenFoot or FFlagEnableLeftNavOnConsole
	local v86 = nil
	local v87 = nil

	if FFlagLuaAppsDefaultSelection then
		local v88

		v88, v87 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior()
		v86 = useFocusOnMount(v88)
	end

	local v89 = Cryo.Dictionary.join(p12, {
		backgroundColor = v84.LuaApps.App.Page.BackgroundColor,
		backgroundTransparency = v84.LuaApps.App.Page.BackgroundTransparency,
		hasTopBar = v85,
		onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else logFirstTileImageLoaded,
		defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else v86,
		containerRef = if not FFlagLuaAppsDefaultSelection then nil else v87
	})

	return React.createElement(v68, v89)
end)
local v70 = withThrottleFramerateGivenPolicy((RoactAppPolicy.connect(function(p13, _) -- line: 337
	return {
		useGridPageLayout = p13.useGridPageLayout(),
		policyEnableHomePageAgeBlock = p13.getEnableHomePageAgeBlock()
	}
end)(v69)))

default:logEventOnce("home_page_require_end")

return v70
