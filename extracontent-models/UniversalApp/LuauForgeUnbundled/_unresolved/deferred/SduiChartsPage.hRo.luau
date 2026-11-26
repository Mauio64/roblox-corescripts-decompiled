local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/RoactServiceTags")
local appSessionService = RoactServiceTags.AppSessionService
local appNotificationService = RoactServiceTags.AppNotificationService
local sessionType = require("@luauforge/bundled/fwa").SessionType
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId
local module2 = require("@luauforge/bundled/dKz")

local module3 = require("@luauforge/bundled/hPC")
local module4 = require("@luauforge/bundled/fvR")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local module6 = require("@luauforge/deferred/hPI")
local module7 = require("@luauforge/deferred/hPJ")
local module8 = require("@luauforge/bundled/hQS")

local flyoutSidePanelIXP = require("@luauforge/bundled/dKM").FlyoutSidePanelIXP
local sources = require("@luauforge/bundled/ecs").Analytics.Enums.Sources

local module9 = require("@luauforge/bundled/gfF")
local chartsContentEntryPoint = module9.ChartsContentEntryPoint
local chartsConstants = module9.ChartsConstants
local chartsPageSession = module9.ChartsPageSession

local module10 = require("@luauforge/bundled/dXB")
local useUiStatus = module10.useUiStatus
local uiStatus = module10.UiStatus

local useTTINavigationTracking = require("@luauforge/bundled/fEs").useTTINavigationTracking

local module11 = require("@luauforge/bundled/fBo")
local promptsHandler = module11.PromptsHandler
local promptsEntryPoint = module11.PromptsEntryPoint

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local fFlagSubTabAddDesktopTopMargin = SharedFlags.FFlagSubTabAddDesktopTopMargin
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagLuaAppEnableChartsPageProfileLink = SharedFlags.FFlagLuaAppEnableChartsPageProfileLink
local fFlagLuaAppAddTestIdsForArrow = SharedFlags.FFlagLuaAppAddTestIdsForArrow
local fFlagLuaAppLogChartsAppPageExposure = SharedFlags.FFlagLuaAppLogChartsAppPageExposure
local fFlagSubTabNavigationTTITracking = SharedFlags.FFlagSubTabNavigationTTITracking
local fFlagEnableIsChartsInSubTab = SharedFlags.FFlagEnableIsChartsInSubTab
local fFlagAppThemeHalloween2026HomeBackground = SharedFlags.FFlagAppThemeHalloween2026HomeBackground
local module13 = require("@luauforge/bundled/fHw")

local module14 = require("@luauforge/bundled/hPF")
local useThemeBackground = require("@luauforge/bundled/ehR").useThemeBackground

local fFlagPromptsHandlerEnabled = game:DefineFastFlag("SduiChartsPagePromptsHandlerEnabled", false)
	and SharedFlags.FFlagPromptsHandlerEnabled

local function SduiChartsPage(p2)
	if fFlagSubTabNavigationTTITracking then
		useTTINavigationTracking("NavigateTo_Games")
	end

	if fFlagLuaAppLogChartsAppPageExposure then
		module7()
	end

	local v5 = useRoactService(appSessionService)
	local v6 = useRoactService(appNotificationService)

	React.useEffect(function()
		if v5 == nil then
			return nil
		end

		local signal = chartsPageSession:GetSignal()
		return Signals.createEffect(function(p3)
			local v7 = signal(p3)

			if v7 == "" then
				return
			end

			v5:SetSession(
				sessionType.StructuralIdentifier.Level1,
				sessionType.StructuralIdentifier.DiscoverPageSessionInfo,
				sessionType.StructuralIdentifier.DiscoverPageSessionInfo
			)

			v5:SetMetadata(
				sessionType.StructuralIdentifier.DiscoverPageSessionInfo,
				sessionType.Metadata.DiscoverPage.DiscoverSessionId,
				v7
			)
		end)
	end, { v5 })

	local v7 = useUiStatus(chartsConstants.ConfigKey)
	React.useEffect(function()
		if v6 and v7 == uiStatus.Resolved then
			v6:ActionEnabled(Enum.AppShellActionType.GamePageLoaded)
		end
	end, { v6, v7 })
	local v8

	if fFlagLuaAppEnableChartsPageProfileLink or fFlagSubTabAddDesktopTopMargin then
		v8 = useAppPolicy(function(p3)
			return p3.useGridPageLayout()
		end)
	end

	local v9 = useTokens()
	local color3 = v9.Color.Surface.Surface_0.Color3
	local v10 = v9.Color.Surface.Surface_0.Transparency

	local v11 = fFlagAppIaHomeSubTab and flyoutSidePanelIXP.isHomeSubTabEnabled()

	if fFlagEnableIsChartsInSubTab then
		v11 = v11 and flyoutSidePanelIXP.isChartsInSubTab()
	end

	local v12

	if fFlagAppThemeHalloween2026HomeBackground then
		local v13 = if module14 then useThemeBackground() ~= nil else React.useContext(module13) ~= nil

		v12 = React.useMemo(function()
			if v13 then
				return { Color3 = color3, Transparency = 1 }
			end

			return nil
		end, { v13, color3 })
		v10 = v13 and 1 or v10
	end

	local v13 = module6()

	local v14 = useSelector(function(p3)
		return p3.TopBar.topBarHeight
	end)

	local v15 = fFlagAppIaScrollAway and module2.getScrollAwayEnabled()

	if v11 and p2.screenProps then
		v14 = p2.screenProps.headerHeight
	elseif not v15 then
		v14 = nil
	end

	local v17 = if fFlagEnableIsChartsInSubTab then v11 else nil
	local topMargin = module8(v17).topMargin

	local subTabsBottomBinding = if v11 and p2.screenProps then p2.screenProps.subTabsBottomBinding else nil

	local v18 = React.useMemo(function()
		if subTabsBottomBinding then
			return subTabsBottomBinding:map(function(p3)
				return p3.Y.Offset
			end)
		end

		return nil
	end, { subTabsBottomBinding })

	local v19 = React.useMemo(function()
		if v15 and v14 and v14 > 0 then
			if v11 and v18 == nil then
				return nil
			end

			return { scrollAwayHeight = v14, headerHeightBinding = v18 }
		end

		return nil
	end, { v15, v14, v18, v11 })

	local createElement = React.createElement
	local v21 = {
		["Size"] = nil,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = color3,
		BackgroundTransparency = v10,
		BorderSizePixel = 0
	}

	local tag = React.Tag
	local v22 = if fFlagLuaAppAddTestIdsForArrow then getTestId("page-discover") else nil
	v21[tag] = v22
	local v24

	if not v11 then
		local createElement2 = React.createElement
		local v26 = {
			tag = compositionTags.ContentRegion.Header,
			titleText = v13,
			useGridPageLayout = 0,
			profileSource = 0,
			sideMarginOverride = 0,
			zIndexOverride = 3
		}

		if not fFlagLuaAppEnableChartsPageProfileLink then
			v8 = nil
		end

		v26.useGridPageLayout = v8

		local v27 = if fFlagLuaAppEnableChartsPageProfileLink then sources.ChartsPageSelfWidget else nil
		v26.profileSource = v27
		v24 = createElement2(module3, v26)
	end

	local createElement2 = React.createElement
	local v25 = if v11 then module4.PageWrapper else module4.PageContent

	local createElement3 = React.createElement
	local v29 = {
		navigation = p2.navigation,
		pageTopPadding = v14,
		feedTopMargin = topMargin,
		scrollAway = v19,
		backgroundStyle = 0
	}

	if not fFlagAppThemeHalloween2026HomeBackground then
		v12 = nil
	end

	v29.backgroundStyle = v12
	local v23 = {
		TopBar = v24,
		Content = createElement2(
			v25,
			{ BackgroundColor3 = color3, BackgroundTransparency = v10, ZIndex = 1 },
			{
				ChartsContent = createElement3(chartsContentEntryPoint, v29)
			}
		),
		Prompts = 0
	}

	local v30 = if fFlagPromptsHandlerEnabled then React.createElement(promptsHandler, {
		entryPoint = promptsEntryPoint.ChartsLaunch
	}) else nil
	v23.Prompts = v30
	return createElement("Frame", v21, v23)
end

return SduiChartsPage
