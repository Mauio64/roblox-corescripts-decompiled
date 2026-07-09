local Modules = script:FindFirstAncestor("Modules")
local CorePackages = game:GetService("CorePackages")
local SocialTabUniversalAppWrapper = require(script.Parent.SocialTabUniversalAppWrapper)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local AppNotificationService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppNotificationService
local AppUserInputService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppUserInputService
local RoactAnalyticsAppStageLoaded = require(Modules.LuaApp.Services.RoactAnalyticsAppStageLoaded)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local AppEventIngestService = require(Modules.LuaApp.Services.AppEventIngestService)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useEarlyIsFocused = require(CorePackages.Workspace.Packages.Navigation).useEarlyIsFocused
local useNavigationProps = require(CorePackages.Workspace.Packages.RobloxAppNavigation).useNavigationProps
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local compose = require(CorePackages.Packages.LuaSocialLibrariesDeps).SocialLibraries.config({}).RoduxTools.compose
local mapStateToProps = require(script.Parent.mapStateToProps)
local mapDispatchToProps = require(script.Parent.mapDispatchToProps)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v26 = if not FFlagSignalsNavP3hMisc then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local useTTINavigationTracking = require(CorePackages.Workspace.Packages.TTINavigationTracking).useTTINavigationTracking

local function Container(p1) -- line: 41
	-- upvalues: SharedFlags (copy), useTTINavigationTracking (copy), useNavigation (copy), useEarlyIsFocused (copy), useNavigationProps (copy), useDesignTokens (copy), useUiModeInfo (copy), UiMode (copy), FFlagSignalsNavP3hMisc (copy), v26 (copy), useSignalState (copy), Roact (copy), SocialTabUniversalAppWrapper (copy), Cryo (copy)
	if SharedFlags.FFlagLuaAppNavigationTTITracking then
		useTTINavigationTracking("NavigateTo_Chat")
	end

	local v30 = useNavigation()
	local v31 = useEarlyIsFocused()
	local v32 = useNavigationProps(function(p2) -- line: 48
		if p2 then
			return {
				conversationId = p2
			}
		end

		return nil
	end)
	local t1 = {
		isVisible = v31,
		parameters = v32,
		pageType = v30.state.routeName
	}
	local v34 = useDesignTokens()
	local v35 = useUiModeInfo().uiMode == UiMode.TenFoot

	t1.BackgroundColor = v34.LuaApps.App.Page.BackgroundColor
	t1.BackgroundTransparency = v34.LuaApps.App.Page.BackgroundTransparency
	t1.useFullScalePage = v35

	if FFlagSignalsNavP3hMisc then
		local v36 = v26(false)
		local v37 = useSignalState(v36.getCurrentLegacyRoute)

		t1.currentAppPage = v37 and (v37[#v37] and v37[#v37].name)
		t1.canGoBack = v37 and #v37 > 1
	end

	return Roact.createElement(SocialTabUniversalAppWrapper, Cryo.Dictionary.join(p1, t1))
end

return (compose(RoactRodux.connect(mapStateToProps, mapDispatchToProps), RoactServices.connect({
	analytics = RoactAnalyticsAppStageLoaded,
	guiService = AppGuiService,
	notificationService = AppNotificationService,
	userInputService = AppUserInputService,
	roactAnalytics = RoactAnalytics,
	eventIngestService = AppEventIngestService
}))(Container))
