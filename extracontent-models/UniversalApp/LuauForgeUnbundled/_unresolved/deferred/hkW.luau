local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/deferred/hkX")

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices

local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local appNotificationService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppNotificationService
local appUserInputService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppUserInputService
local module2 = require("@luauforge/deferred/hGf")

local module3 = require("@luauforge/bundled/ecq")
local module4 = require("@luauforge/bundled/ecr")
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useEarlyIsFocused = require("@game/CorePackages/Workspace/Packages/Navigation").useEarlyIsFocused
local useNavigationProps = require("@luauforge/bundled/dFz").useNavigationProps
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local fFlagSignalsNavP3Final = SharedFlags.FFlagSignalsNavP3Final
local fFlagSocialTabWrapperStableNavigationProps = SharedFlags.FFlagSocialTabWrapperStableNavigationProps
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local compose = LuaSocialLibrariesDeps.SocialLibraries.config({}).RoduxTools.compose

local module6 = require("@luauforge/deferred/hGh")
local module7 = require("@luauforge/deferred/hGj")
local module8 = require("@luauforge/deferred/hGK")

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getLegacyNavigationStore

if fFlagSignalsNavP3hMisc then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local useTTINavigationTracking = require("@luauforge/bundled/fEs").useTTINavigationTracking
local useThemeBackground = require("@luauforge/bundled/ehR").useThemeBackground

local module9 = require("@luauforge/bundled/hGL")

local function Container(p2)
	useTTINavigationTracking("NavigateTo_Chat")

	local v5 = useNavigation()
	local v6 = {
		isVisible = useEarlyIsFocused(),
		parameters = useNavigationProps(function(p3)
			if p3 then
				return { conversationId = p3 }
			end

			return nil
		end),
		pageType = v5.state.routeName
	}

	local v7 = useDesignTokens()
	local v8 = useUiModeInfo().uiMode == uiMode.TenFoot

	v6.BackgroundColor = v7.LuaApps.App.Page.BackgroundColor
	v6.BackgroundTransparency = v7.LuaApps.App.Page.BackgroundTransparency
	v6.useFullScalePage = v8

	if module9 and useThemeBackground() then
		v6.BackgroundTransparency = 1
	end

	if fFlagSignalsNavP3hMisc and not fFlagSignalsNavP3Final then
		local legacyNavigationStore = getLegacyNavigationStore(false)
		v6.currentAppPage = useSignalState(legacyNavigationStore.getCurrentPageName)
		v6.canGoBack = useSignalState(legacyNavigationStore.getCanGoBack)
	end

	if fFlagSignalsNavP3Final then
		v6.getAndroidBackButtonHandlerDisabled = React.useCallback(function()
			return module8(getLegacyNavigationStore(false).getCurrentPageName(false))
		end, {})
	end

	if fFlagSocialTabWrapperStableNavigationProps and not fFlagSignalsNavP3Final then
		local v9 = if fFlagSignalsNavP3hMisc then v6.currentAppPage else p2.currentAppPage
		v6.androidBackButtonHandlerDisabled = module8(v9)
		v6.currentAppPage = Cryo.None
		v6.canGoBack = Cryo.None
	end

	return Roact.createElement(module, Cryo.Dictionary.join(p2, v6))
end

return (compose(RoactRodux.connect(module6, module7), roactServices.connect({
	analytics = module2,
	guiService = appGuiService,
	notificationService = appNotificationService,
	userInputService = appUserInputService,
	roactAnalytics = module3,
	eventIngestService = module4
}))(Container))
