local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local CompositionTags = require(CorePackages.Workspace.Packages.AppComposition).CompositionTags
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)
local AppSessionService = RoactServiceTags.AppSessionService
local AppNotificationService = RoactServiceTags.AppNotificationService
local SessionType = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SessionType
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local getTestId = require(CorePackages.Workspace.Packages.RoactUtils).getTestId
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local PersonalizationTopBar = require(Modules.Personalization.PersonalizationTopBar)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local useChartsTitleText = require(Modules.Personalization.Games.useChartsTitleText)
local useLogSduiChartsExposure = require(Modules.Personalization.Games.useLogSduiChartsExposure)
local FlyoutSidePanelIXP = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).FlyoutSidePanelIXP
local Sources = require(CorePackages.Workspace.Packages.SocialLuaAnalytics).Analytics.Enums.Sources
local Charts = require(CorePackages.Workspace.Packages.Charts)
local ChartsContentEntryPoint = Charts.ChartsContentEntryPoint
local ChartsConstants = Charts.ChartsConstants
local ChartsPageSession = Charts.ChartsPageSession
local SduiSharedUtilities = require(CorePackages.Workspace.Packages.SduiSharedUtilities)
local useUiStatus = SduiSharedUtilities.useUiStatus
local UiStatus = SduiSharedUtilities.UiStatus
local ServerTriggeredModals = require(CorePackages.Workspace.Packages.ServerTriggeredModals)
local PromptsHandler = ServerTriggeredModals.PromptsHandler
local PromptsEntryPoint = ServerTriggeredModals.PromptsEntryPoint
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagLuaAppEnableChartsPageProfileLink = SharedFlags.FFlagLuaAppEnableChartsPageProfileLink
local FFlagLuaAppAddTestIdsForArrow = SharedFlags.FFlagLuaAppAddTestIdsForArrow
local FFlagLuaAppLogChartsAppPageExposure = SharedFlags.FFlagLuaAppLogChartsAppPageExposure
local FFlagSduiChartsResetSessionOnRefresh = SharedFlags.FFlagSduiChartsResetSessionOnRefresh
local v39 = game:DefineFastFlag("SduiChartsPagePromptsHandlerEnabled", false) and SharedFlags.FFlagPromptsHandlerEnabled

local function SduiChartsPage(t1: {[any]: any}) -- line: 59
	-- upvalues: FFlagLuaAppLogChartsAppPageExposure (copy), useLogSduiChartsExposure (copy), useRoactService (copy), AppSessionService (copy), AppNotificationService (copy), React (copy), FFlagSduiChartsResetSessionOnRefresh (copy), SessionType (copy), ChartsPageSession (copy), Signals (copy), useUiStatus (copy), ChartsConstants (copy), UiStatus (copy), FFlagLuaAppEnableChartsPageProfileLink (copy), useAppPolicy (copy), useTokens (copy), FFlagAppIaHomeSubTab (copy), FlyoutSidePanelIXP (copy), useChartsTitleText (copy), useSelector (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), FFlagLuaAppAddTestIdsForArrow (copy), getTestId (copy), PersonalizationTopBar (copy), CompositionTags (copy), Sources (copy), TopBar (copy), ChartsContentEntryPoint (copy), v39 (copy), PromptsHandler (copy), PromptsEntryPoint (copy)
	if FFlagLuaAppLogChartsAppPageExposure then
		useLogSduiChartsExposure()
	end

	local v42 = useRoactService(AppSessionService)
	local v43 = useRoactService(AppNotificationService)

	React.useEffect(function() -- line: 69
		-- upvalues: v42 (copy), FFlagSduiChartsResetSessionOnRefresh (copy), SessionType (copy), ChartsPageSession (copy), Signals (copy)
		if v42 == nil then
			return nil
		end

		if not FFlagSduiChartsResetSessionOnRefresh then
			v42:SetSession(SessionType.StructuralIdentifier.Level1, SessionType.StructuralIdentifier.DiscoverPageSessionInfo, SessionType.StructuralIdentifier.DiscoverPageSessionInfo)
		end

		local Signal = ChartsPageSession:GetSignal()

		return Signals.createEffect(function(p1) -- line: 83
			-- upvalues: Signal (copy), FFlagSduiChartsResetSessionOnRefresh (copy), v42 (copy), SessionType (copy)
			local v58 = Signal(p1)

			if v58 == "" then
				return
			end

			if FFlagSduiChartsResetSessionOnRefresh then
				v42:SetSession(SessionType.StructuralIdentifier.Level1, SessionType.StructuralIdentifier.DiscoverPageSessionInfo, SessionType.StructuralIdentifier.DiscoverPageSessionInfo)
			end

			v42:SetMetadata(SessionType.StructuralIdentifier.DiscoverPageSessionInfo, SessionType.Metadata.DiscoverPage.DiscoverSessionId, v58)
		end)
	end, { v42 })

	local v44 = useUiStatus(ChartsConstants.ConfigKey)

	React.useEffect(function() -- line: 109
		-- upvalues: v43 (copy), v44 (copy), UiStatus (copy)
		if v43 and v44 == UiStatus.Resolved then
			v43:ActionEnabled(Enum.AppShellActionType.GamePageLoaded)
		end
	end, {
		v43,
		v44
	})

	local v45 = if not FFlagLuaAppEnableChartsPageProfileLink then nil else useAppPolicy(function(p2) -- line: 118
		return p2.useGridPageLayout()
	end)
	local v46 = useTokens()
	local Surface_0Color3 = v46.Color.Surface.Surface_0.Color3
	local Surface_0Transparency = v46.Color.Surface.Surface_0.Transparency
	local v49 = FFlagAppIaHomeSubTab and FlyoutSidePanelIXP.isHomeSubTabEnabled()
	local v50 = useChartsTitleText()
	local v51 = useSelector(function(p3) -- line: 131
		return p3.TopBar.topBarHeight
	end)
	local v52 = FFlagAppIaScrollAway and AppNavBar.getScrollAwayEnabled()
	local v53 = if not v49 or not t1.screenProps then if not v52 then nil else v51 else t1.screenProps.headerHeight

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Surface_0Color3,
		BackgroundTransparency = Surface_0Transparency,
		BorderSizePixel = 0,
		[React.Tag] = if not FFlagLuaAppAddTestIdsForArrow then nil else getTestId("page-discover")
	}, {
		TopBar = if not v49 then React.createElement(PersonalizationTopBar, {
			sideMarginOverride = 0,
			zIndexOverride = 3,
			tag = CompositionTags.ContentRegion.Header,
			titleText = v50,
			useGridPageLayout = if not FFlagLuaAppEnableChartsPageProfileLink then nil else v45,
			profileSource = if not FFlagLuaAppEnableChartsPageProfileLink then nil else Sources.ChartsPageSelfWidget
		}) else nil,
		Content = React.createElement(if not v49 then TopBar.PageContent else TopBar.PageWrapper, {
			ZIndex = 1,
			BackgroundColor3 = Surface_0Color3,
			BackgroundTransparency = Surface_0Transparency
		}, {
			ChartsContent = React.createElement(ChartsContentEntryPoint, {
				navigation = t1.navigation,
				pageTopPadding = v53
			})
		}),
		Prompts = if not v39 then nil else React.createElement(PromptsHandler, {
			entryPoint = PromptsEntryPoint.ChartsLaunch
		})
	})
end

return SduiChartsPage
