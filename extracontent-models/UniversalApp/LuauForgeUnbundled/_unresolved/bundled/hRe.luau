local CorePackages = game:GetService("CorePackages")

local fFlagAppThemeHalloween2026HomeBackground = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAppThemeHalloween2026HomeBackground
local module = require("@luauforge/bundled/fHw")
local module2 = require("@luauforge/bundled/fHU")
local module3 = require("@luauforge/bundled/fHV")

local module4 = require("@luauforge/bundled/hPF")
local useThemeBackground = require("@luauforge/bundled/ehR").useThemeBackground

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default
default:logEventOnce("home_page_require_begin")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId
local combineReactTags = require("@game/CorePackages/Workspace/Packages/RoactUtils").combineReactTags
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appNotificationService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppNotificationService
local module5 = require("@luauforge/bundled/dKz")
local module6 = require("@luauforge/bundled/fBo")
local promptsSystemBanner = module6.PromptsSystemBanner
local promptsHandler = module6.PromptsHandler
local promptsEntryPoint = module6.PromptsEntryPoint
local promptStyle = module6.PromptStyle

local module7 = require("@luauforge/bundled/dAB")
local module8 = require("@luauforge/bundled/fvR")
local module9 = require("@luauforge/bundled/hRf")
local module10 = require("@luauforge/bundled/hPC")
local module11 = require("@luauforge/bundled/dFu")
local module12 = require("@luauforge/bundled/dKv")
local homePageLoadTracker = require("@luauforge/bundled/hQG").HomePageLoadTracker
local module13 = require("@luauforge/bundled/hQF")
local flyoutSidePanelIXP = require("@luauforge/bundled/dKM").FlyoutSidePanelIXP
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags
local sources = require("@luauforge/bundled/ecs").Analytics.Enums.Sources
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusOnMount = require("@luauforge/bundled/ehL").useFocusOnMount

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local getFFlagEnableAccessBlockAtAppContainerLevel = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableAccessBlockAtAppContainerLevel
local module15 = require("@luauforge/bundled/hRd")
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagEnableHomepagePromptsForModalsAndBanners = SharedFlags.FFlagEnableHomepagePromptsForModalsAndBanners
local fFlagPromptsHandlerEnabled = SharedFlags.FFlagPromptsHandlerEnabled
local fFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local fFlagLuaAppEnableChartsPageProfileLink = SharedFlags.FFlagLuaAppEnableChartsPageProfileLink
local fFlagLuaAppAddTestIdsForArrow = SharedFlags.FFlagLuaAppAddTestIdsForArrow
local fFlagLuaAppHomePageLoadTracker = SharedFlags.FFlagLuaAppHomePageLoadTracker
local fFlagLuaAppHomePageFirstImageLoadObserver = SharedFlags.FFlagLuaAppHomePageFirstImageLoadObserver
local fFlagLuaAppHomePageReadyToRender = SharedFlags.FFlagLuaAppHomePageReadyToRender
local fFlagEnableClassicThemeHeaderBackground = SharedFlags.FFlagEnableClassicThemeHeaderBackground

local createImageLoadObserver = require("@luauforge/bundled/hQU").createImageLoadObserver

local fFlagUseSignalsForStartup = SharedFlags.FFlagUseSignalsForStartup

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local getStartupStore = if fFlagUseSignalsForStartup then require("@luauforge/bundled/gfE").GetStartupStore else nil

local useTTINavigationTracking = require("@luauforge/bundled/fEs").useTTINavigationTracking

local promptsConstants = require("@luauforge/bundled/fBo").PromptsConstants

local extended = React.PureComponent:extend("HomePageWithFeed")

local appAppLifecycleObserverService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppAppLifecycleObserverService

local strictInterface = t.strictInterface
local v5 = {
	homePageDataStatus = t.string,
	navigateToUAppBlock = 0,
	topBarHeight = 0,
	useGridPageLayout = 0,
	policyEnableHomePageAgeBlock = 0,
	setThrottleFramerateEnabled = 0,
	navigation = 0,
	screenProps = 0,
	notificationService = 0,
	appLifecycleObserverService = 0,
	backgroundColor = 0,
	backgroundTransparency = 0,
	hasTopBar = 0,
	themeBackgroundImage = 0,
	themeBackgroundGeometry = 0,
	onThemeBackgroundPageChanged = 0,
	defaultFocusRef = 0,
	containerRef = 0
}
local v6 = if not getFFlagEnableAccessBlockAtAppContainerLevel() then t.callback else nil
v5.navigateToUAppBlock = v6
local v7 = if fFlagAppIaScrollAway then t.number else nil
v5.topBarHeight = v7

v5.useGridPageLayout = t.optional(t.boolean)
v5.policyEnableHomePageAgeBlock = t.optional(t.boolean)

v5.setThrottleFramerateEnabled = t.optional(t.callback)

v5.navigation = t.table
v5.screenProps = t.optional(t.table)

v5.notificationService = t.any
local v8 = if fFlagLuaAppHomePageReadyToRender then t.optional(t.any) else nil
v5.appLifecycleObserverService = v8

v5.backgroundColor = t.Color3
v5.backgroundTransparency = t.number
v5.hasTopBar = t.boolean

local v9 = if fFlagAppThemeHalloween2026HomeBackground and not module4 then t.optional(t.string) else nil
v5.themeBackgroundImage = v9

local v10 = if fFlagAppThemeHalloween2026HomeBackground and not module4 then t.optional(t.table) else nil
v5.themeBackgroundGeometry = v10

local v11 = if fFlagAppThemeHalloween2026HomeBackground then t.optional(t.callback) else nil
v5.onThemeBackgroundPageChanged = v11

v5.defaultFocusRef = t.optional(t.callback)
v5.containerRef = t.optional(t.callback)
extended.validateProps = strictInterface(v5)

function extended:destroyImageLoadObserver()
	if self.imageLoadObserver then
		self.imageLoadObserver.destroy()
		self.imageLoadObserver = nil
	end
end

function extended:init()
	if not getFFlagEnableAccessBlockAtAppContainerLevel() and self.props.policyEnableHomePageAgeBlock then
		self.props.navigateToUAppBlock()
	end

	if fFlagLuaAppHomePageFirstImageLoadObserver then
		function self.composedContainerRef(p2)
			if self.props.containerRef then
				self.props.containerRef(p2)
			end

			if p2 and not self.imageLoadObserver then
				self.imageLoadObserver = createImageLoadObserver(p2, {
					onFirstReport = function()
						homePageLoadTracker.logFunctionallyReadyAndEnd()
					end
				})
			elseif not p2 then
				self:destroyImageLoadObserver()
			end
		end
	end

	function self.notifyPageLoaded()
		self.props.notificationService:ActionEnabled(Enum.AppShellActionType.HomePageLoaded)
	end
end

function extended.render(p2)
	if fFlagLuaAppHomePageLoadTracker then
		homePageLoadTracker.logRenderStarted()
	end

	local function fn(p3)
		local backgroundColor = p2.props.backgroundColor
		local backgroundTransparency = p2.props.backgroundTransparency
		local useGridPageLayout = p2.props.useGridPageLayout
		local themeBackgroundImage

		if fFlagAppThemeHalloween2026HomeBackground and not module4 then
			themeBackgroundImage = p2.props.themeBackgroundImage
		end

		local createElement = React.createElement
		local v13 = { defaultFocusRef = p2.props.defaultFocusRef, canvasTopPadding = 0 }
		local v14

		if fFlagAppIaHomeSubTab and flyoutSidePanelIXP.isHomeSubTabEnabled() and fFlagAppIaScrollAway then
			if p2.props.screenProps then
				v14 = p2.props.screenProps.headerHeight
			end
		elseif fFlagAppIaScrollAway and p2.props.hasTopBar and module5.getScrollAwayEnabled() then
			v14 = p2.props.topBarHeight
		end

		v13.canvasTopPadding = v14
		local v15 = createElement(module9, v13)

		local createElement2 = React.createElement
		local pageWrapper = module8.PageWrapper
		local v17

		if not (fFlagAppIaHomeSubTab and flyoutSidePanelIXP.isHomeSubTabEnabled() or not p2.props.hasTopBar) then
			local createElement3 = React.createElement
			local v19 = {
				tag = compositionTags.ContentRegion.Header,
				useGridPageLayout = useGridPageLayout,
				enableHeaderImageBackground = fFlagEnableClassicThemeHeaderBackground and true or nil,
				profileSource = 0,
				sideMarginOverride = 0,
				transparentBackground = 0,
				backgroundSlot = 0
			}

			local v20 = if fFlagLuaAppEnableChartsPageProfileLink then sources.HomePageSelfWidget else nil
			v19.profileSource = v20

			v19.transparentBackground = themeBackgroundImage and true or nil

			local v21 = if themeBackgroundImage then React.createElement(module2.HomeThemeBackgroundSlice, {
				image = themeBackgroundImage,
				baseColor = backgroundColor,
				pageGeometry = p2.props.themeBackgroundGeometry
			}) else nil
			v19.backgroundSlot = v21
			v17 = createElement3(module10, v19)
		end

		if fFlagPromptsHandlerEnabled then
			v15 = React.createElement(promptsHandler, {
				entryPoint = promptsEntryPoint.HomepageLaunch,
				promptStyle = promptStyle.SurfaceBanner,
				surfaceBannerContent = v15
			})
		elseif fFlagEnableHomepagePromptsForModalsAndBanners then
			v15 = React.createElement(promptsSystemBanner, {
				configKey = promptsConstants.HOMEPAGE_PROMPTS_CONFIG_KEY,
				appPage = module11.Home,
				contentSlot = v15
			})
		end

		local element = createElement2(
			pageWrapper,
			{
				topBarSlot = v17,
				BackgroundColor3 = backgroundColor,
				BackgroundTransparency = backgroundTransparency
			},
			{ HomeOmniFeed = v15 }
		)

		if themeBackgroundImage then
			element = React.createElement(module.Provider, {
				value = themeBackgroundImage
			}, element)
		end

		local v19 = { Effects = React.createElement(module13), Content = element }

		if themeBackgroundImage then
			v19.ThemeBackground = React.createElement(module2.HomeThemeBackgroundFill, {
				image = themeBackgroundImage,
				baseColor = backgroundColor,
				onPageChanged = p2.props.onThemeBackgroundPageChanged
			})
		end

		local v20 = if fFlagLuaAppAddTestIdsForArrow then getTestId("page-home") else nil

		local createElement3 = React.createElement

		local v23 = if fFlagLuaAppHomePageFirstImageLoadObserver then p2.composedContainerRef else p2.props.containerRef
		local tag = React.Tag
		local v24 = if fFlagLuaAppAddTestIdsForArrow then combineReactTags(
			module15() and "app-screen.home" or nil,
			v20
		) else module15() and "app-screen.home" or nil
		return createElement3("Frame", {
			ref = v23,
			[tag] = v24,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = backgroundColor,
			BackgroundTransparency = backgroundTransparency,
			BorderSizePixel = 0
		}, v19)
	end

	return withStyle(function(p3)
		return fn(p3)
	end)
end

function extended:didMount()
	self.isMounted = true

	if
		fFlagLuaAppHomePageReadyToRender
		and game:GetEngineFeature("SlowDownRendering")
		and self.props.appLifecycleObserverService
	then
		self.props.appLifecycleObserverService:TriggerOnLuaAppReadyToRender()
	end

	if self.props.homePageDataStatus == module7.Done then
		self.notifyPageLoaded()
	end
end

function extended.didUpdate(p2, p3)
	if not getFFlagEnableAccessBlockAtAppContainerLevel() and p2.props.policyEnableHomePageAgeBlock then
		p2.props.navigateToUAppBlock()
	end

	local v12 = p2.props.homePageDataStatus == module7.Done
	local v13 = p3.homePageDataStatus == module7.Done

	if v12 and not v13 then
		p2.notifyPageLoaded()
	end
end

function extended:willUnmount()
	self.isMounted = false

	if fFlagLuaAppHomePageFirstImageLoadObserver then
		self:destroyImageLoadObserver()
	end
end

local v12 = RoactRodux.connect(function(p2, p3)
	local v14 = if not fFlagUseSignalsForStartup then p2.Startup.HomePageDataStatus else nil
	local v15 = if fFlagAppIaScrollAway then p2.TopBar.topBarHeight else nil
	return { homePageDataStatus = v14, topBarHeight = v15 }
end, function(callback)
	return {
		navigateToUAppBlock = not getFFlagEnableAccessBlockAtAppContainerLevel() and function()
			callback(module12({
				{ name = module11.UAppBlock }
			}))
		end or nil
	}
end)(extended)
local v13

if fFlagUseSignalsForStartup then
	v13 = React.memo(function(p2)
		local v14 = useSignalState(getStartupStore(false).getHomePageDataStatus)
		return React.createElement(v12, Cryo.Dictionary.union(p2, {
			homePageDataStatus = v14
		}))
	end)
else
	v13 = v12
end

local v14 = RoactNavigation.withNavigation(v13)

local function fn(p2)
	useTTINavigationTracking("NavigateTo_Home")

	local v15 = useDesignTokens()
	local v16, v17 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior()
	local v18 = useFocusOnMount(v16)

	local v19 = v15.LuaApps.App.Page.BackgroundTransparency
	local v20 = nil

	if module4 then
		if useThemeBackground() then
			v19 = 1
		end
	elseif fFlagAppThemeHalloween2026HomeBackground and not module4 then
		v20 = module3()

		if v20 and v20.isTransparent then
			v19 = 1
		end
	end

	local join = Cryo.Dictionary.join
	local v21 = {
		backgroundColor = v15.LuaApps.App.Page.BackgroundColor,
		backgroundTransparency = v19,
		themeBackgroundImage = 0,
		themeBackgroundGeometry = 0,
		onThemeBackgroundPageChanged = 0,
		hasTopBar = true,
		defaultFocusRef = 0,
		containerRef = 0
	}

	local v22 = if v20 then v20.image else nil
	v21.themeBackgroundImage = v22
	local v23 = if v20 then v20.geometry else nil
	v21.themeBackgroundGeometry = v23
	local v24 = if v20 then v20.onPageChanged else nil
	v21.onThemeBackgroundPageChanged = v24

	v21.defaultFocusRef = v18
	v21.containerRef = v17
	local v25 = join(p2, v21)

	return React.createElement(v14, v25)
end

local connect = roactServices.connect

if not fFlagLuaAppHomePageReadyToRender then
	appAppLifecycleObserverService = nil
end

local v16 = connect({
	notificationService = appNotificationService,
	appLifecycleObserverService = appAppLifecycleObserverService
})(fn)

local v17 = roactAppPolicy.connect(function(p2, p3)
	return {
		useGridPageLayout = p2.useGridPageLayout(),
		policyEnableHomePageAgeBlock = p2.getEnableHomePageAgeBlock()
	}
end)(v16)

default:logEventOnce("home_page_require_end")

return v17
