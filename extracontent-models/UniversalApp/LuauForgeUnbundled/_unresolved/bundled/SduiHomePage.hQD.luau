local CorePackages = game:GetService("CorePackages")

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default
default:logEventOnce("home_page_require_begin")

local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusOnMount = require("@luauforge/bundled/ehL").useFocusOnMount
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/RoactServiceTags")
local appNotificationService = RoactServiceTags.AppNotificationService
local appSessionService = RoactServiceTags.AppSessionService
local appAppLifecycleObserverService = RoactServiceTags.AppAppLifecycleObserverService
local appLogging = RoactServiceTags.AppLogging
local appStartupSequenceTag = RoactServiceTags.AppStartupSequenceTag
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local roactRodux = RoactUtils.Hooks.RoactRodux
local getTestId = RoactUtils.getTestId
local combineReactTags = RoactUtils.combineReactTags
local useSelector = roactRodux.useSelector
local useDispatch = roactRodux.useDispatch
local useTTINavigationTracking = require("@luauforge/bundled/fEs").useTTINavigationTracking
local module3 = require("@luauforge/bundled/dKz")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags
local sources = require("@luauforge/bundled/ecs").Analytics.Enums.Sources

local module4 = require("@luauforge/bundled/dKv")
local module5 = require("@luauforge/bundled/hPC")
local module6 = require("@luauforge/bundled/hQE")
local module7 = require("@luauforge/bundled/hQF")
local module8 = require("@luauforge/bundled/hQP")
local module9 = require("@luauforge/bundled/hQS")

local homePageLoadTracker = require("@luauforge/bundled/hQG").HomePageLoadTracker
local createImageLoadObserver = require("@luauforge/bundled/hQU").createImageLoadObserver

local flyoutSidePanelIXP = require("@luauforge/bundled/dKM").FlyoutSidePanelIXP

local module10 = require("@luauforge/bundled/fzZ")
local homeContentEntryPoint = module10.HomeContentEntryPoint
local homeConstants = module10.HomeConstants
local homePageSession = module10.HomePageSession
local setHomePageSessionInfo = module10.setHomePageSessionInfo

local module11 = require("@luauforge/bundled/dXB")
local useUiStatus = module11.useUiStatus
local uiStatus = module11.UiStatus

local module12 = require("@luauforge/bundled/fBo")
local promptsHandler = module12.PromptsHandler
local promptsEntryPoint = module12.PromptsEntryPoint

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagLuaAppHomePageLoadTracker = SharedFlags.FFlagLuaAppHomePageLoadTracker
local fFlagAppThemeHalloween2026HomeBackground = SharedFlags.FFlagAppThemeHalloween2026HomeBackground
local module14 = require("@luauforge/bundled/fHU")
local module15 = require("@luauforge/bundled/fHV")

local module16 = require("@luauforge/bundled/hPF")
local useThemeBackground = require("@luauforge/bundled/ehR").useThemeBackground
local fFlagLuaAppHomePageFirstImageLoadObserver = SharedFlags.FFlagLuaAppHomePageFirstImageLoadObserver
local getFFlagEnableAccessBlockAtAppContainerLevel = SharedFlags.GetFFlagEnableAccessBlockAtAppContainerLevel
local module17 = require("@luauforge/bundled/hRd")
local fFlagLuaAppHomePageReadyToRender = SharedFlags.FFlagLuaAppHomePageReadyToRender
local fFlagLuaAppAddTestIdsForArrow = SharedFlags.FFlagLuaAppAddTestIdsForArrow
local fFlagAppPageShellScrollToTopFocus = SharedFlags.FFlagAppPageShellScrollToTopFocus
local fFlagLuaAppEnableChartsPageProfileLink = SharedFlags.FFlagLuaAppEnableChartsPageProfileLink
local fFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagPromptsHandlerEnabled = SharedFlags.FFlagPromptsHandlerEnabled
local fFlagEnableClassicThemeHeaderBackground = SharedFlags.FFlagEnableClassicThemeHeaderBackground

local function SduiHomePage(p2)
	if fFlagLuaAppHomePageLoadTracker then
		homePageLoadTracker.logRenderStarted()
	end

	useTTINavigationTracking("NavigateTo_Home")

	local v5 = useRoactService(appNotificationService)
	local v6 = useRoactService(appSessionService)
	local v7 = useRoactService(appAppLifecycleObserverService)
	local v8 = useRoactService(appLogging)
	local v9 = useRoactService(appStartupSequenceTag)
	local v10 = useDispatch()

	React.useEffect(function()
		if fFlagLuaAppHomePageReadyToRender and game:GetEngineFeature("SlowDownRendering") and v7 then
			v7:TriggerOnLuaAppReadyToRender()
		end
	end, { v7 })

	local v11 = React.useCallback(function()
		local committed = homePageSession:GetCommitted()

		local requestId = if committed then committed.requestId else nil
		local v14 = if committed then committed.sessionId else nil
		setHomePageSessionInfo(v6, requestId, v14)
	end, { v6 })

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v12 = React.useCallback(function(current)
		ref2.current = current

		if not fFlagLuaAppHomePageFirstImageLoadObserver then
			return
		end

		if current ~= nil and ref.current == nil then
			ref.current = createImageLoadObserver(current, {
				onFirstReport = function()
					homePageLoadTracker.logFunctionallyReadyAndEnd()
				end
			})
		elseif current == nil and ref.current ~= nil then
			ref.current.destroy()
			ref.current = nil
		end
	end, {})

	local v13 = nil
	local v14

	if fFlagAppPageShellScrollToTopFocus then
		local v15
		v15, v14 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior(v12)

		v13 = useFocusOnMount(v15)
	else
		local v15
		v15, v14 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior(v12)
	end

	local v15 = useUiStatus(homeConstants.ConfigKey)
	React.useEffect(function()
		if v5 and v15 == uiStatus.Resolved then
			v5:ActionEnabled(Enum.AppShellActionType.HomePageLoaded)
		end
	end, { v5, v15 })

	React.useEffect(function()
		if v15 == uiStatus.Loading then
			return
		end

		module8(ref2.current, {
			loggingProtocol = v8,
			appStartupSequence = v9,
			appLifecycleObserverService = v7
		})
	end, { v15, v8, v9, v7 })

	local v16 = useTokens()
	local color3 = v16.Color.Surface.Surface_0.Color3
	local v17 = v16.Color.Surface.Surface_0.Transparency
	local v18 = nil
	local surface_0 = nil
	local v19 = nil

	if module16 then
		local v20 = useThemeBackground() ~= nil

		if v20 then
			surface_0 = v16.Color.Surface.Surface_0
			v17 = 1
		end

		v18 = React.useMemo(function()
			if v20 then
				return { Color3 = color3, Transparency = 1 }
			end

			return nil
		end, { v20, color3 })
	elseif fFlagAppThemeHalloween2026HomeBackground and not module16 then
		v19 = module15()

		if v19.isTransparent then
			surface_0 = v16.Color.Surface.Surface_0
			v17 = 1
		end

		v18 = React.useMemo(function()
			if v19.isTransparent then
				return { Color3 = color3, Transparency = 1 }
			end

			return nil
		end, { v19.isTransparent, color3 })
	end

	local v20 = useAppPolicy(function(p3)
		return p3.useGridPageLayout()
	end)

	local v21 = useAppPolicy(function(p3)
		return p3.getEnableHomePageAgeBlock()
	end)

	React.useEffect(function()
		if not getFFlagEnableAccessBlockAtAppContainerLevel() and v21 then
			v10(module4({
				{ name = appPage.UAppBlock }
			}))
		end
	end, { v21, v10 })

	local v22 = module9()

	local v23 = fFlagAppIaHomeSubTab and flyoutSidePanelIXP.isHomeSubTabEnabled()

	local v24 = useSelector(function(p3)
		return p3.TopBar.topBarHeight
	end)

	local v25 = fFlagAppIaScrollAway and module3.getScrollAwayEnabled()

	if v23 then
		v24 = if p2.screenProps then p2.screenProps.headerHeight else nil
	end

	local subTabsBottomBinding = if v23 and p2.screenProps then p2.screenProps.subTabsBottomBinding else nil

	local v26 = React.useMemo(function()
		if subTabsBottomBinding then
			return subTabsBottomBinding:map(function(p3)
				return p3.Y.Offset
			end)
		end

		return nil
	end, { subTabsBottomBinding })

	local v27 = React.useMemo(function()
		if v25 and v24 and v24 > 0 then
			if v23 and v26 == nil then
				return nil
			end

			return { scrollAwayHeight = v24, headerHeightBinding = v26 }
		end

		return nil
	end, { v25, v24, v26, v23 })

	local topMargin = v22.topMargin

	local createElement = React.createElement
	local v29 = {
		["ref"] = v14,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = color3,
		BackgroundTransparency = v17,
		BorderSizePixel = 0
	}

	local tag = React.Tag
	local v30 = if fFlagLuaAppAddTestIdsForArrow then combineReactTags(
		module17() and "app-screen.home" or nil,
		getTestId("page-home")
	) else module17() and "app-screen.home" or nil
	v29[tag] = v30

	local v31 = if v19 and v19.image then React.createElement(module14.HomeThemeBackgroundFill, {
		image = v19.image,
		baseColor = color3,
		onPageChanged = v19.onPageChanged
	}) else nil
	local children = {
		ThemeBackground = v31,
		Effects = React.createElement(module7),
		PageSessionManager = React.createElement(module6, {
			appPage = appPage.Home,
			setPageSession = v11
		}),
		TopBar = 0,
		Content = 0,
		Prompts = 0
	}
	local v32

	if not v23 then
		local createElement2 = React.createElement
		local v34 = {
			tag = compositionTags.ContentRegion.Header,
			useGridPageLayout = v20,
			enableHeaderImageBackground = fFlagEnableClassicThemeHeaderBackground and true or nil,
			profileSource = 0,
			sideMarginOverride = 0,
			transparentBackground = 0,
			backgroundSlot = 0
		}

		local v35 = if fFlagLuaAppEnableChartsPageProfileLink then sources.HomePageSelfWidget else nil
		v34.profileSource = v35

		v34.transparentBackground = v19 and v19.image and true or nil
		local v36 = if v19 and v19.image then React.createElement(module14.HomeThemeBackgroundSlice, {
			image = v19.image,
			baseColor = color3,
			pageGeometry = v19.geometry
		}) else nil
		v34.backgroundSlot = v36
		v32 = createElement2(module5, v34)
	end

	children.TopBar = v32

	local createElement2 = React.createElement
	local v34 = {
		navigation = p2.navigation,
		pageTopPadding = v24,
		feedTopMargin = topMargin,
		scrollAway = v27,
		defaultFocusRef = 0,
		backgroundStyle = 0,
		stickyBackgroundStyle = 0
	}

	if not fFlagAppPageShellScrollToTopFocus then
		v13 = nil
	end

	v34.defaultFocusRef = v13

	if not fFlagAppThemeHalloween2026HomeBackground then
		v18 = nil
	end

	v34.backgroundStyle = v18

	if not fFlagAppThemeHalloween2026HomeBackground then
		surface_0 = nil
	end

	v34.stickyBackgroundStyle = surface_0
	children.Content = createElement2(homeContentEntryPoint, v34)

	local v35 = if fFlagPromptsHandlerEnabled then React.createElement(promptsHandler, {
		entryPoint = promptsEntryPoint.HomepageLaunch
	}) else nil
	children.Prompts = v35
	return createElement("Frame", v29, children)
end

default:logEventOnce("home_page_require_end")

return SduiHomePage
