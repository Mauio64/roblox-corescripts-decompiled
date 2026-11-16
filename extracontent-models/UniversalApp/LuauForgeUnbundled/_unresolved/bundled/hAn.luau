local CorePackages = game:GetService("CorePackages")

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default
default:logEventOnce("start_up_page_require_begin")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/eda")
local module2 = require("@luauforge/bundled/dYT")
local appPrefetch = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppPrefetch
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy

local LoadingModal = require("@game/CoreGui/RobloxGui/Modules/Settings/Pages/ShareGame/Components/LoadingModal")

local module4 = require("@luauforge/bundled/dwA")
local module5 = require("@luauforge/bundled/fAH")
local module6 = require("@luauforge/bundled/fNZ")

local appLogging = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLogging
local appStartupSequenceTag = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppStartupSequenceTag

local accountSwitcherConstants = require("@game/CorePackages/Workspace/Packages/AuthCommon").Common.AccountSwitcherConstants
local module7 = require("@luauforge/bundled/fBQ")
local module8 = require("@luauforge/bundled/dCo")

local module9 = require("@luauforge/bundled/fBn")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEnableLuaAccountSwitch = SharedFlags.FFlagEnableLuaAccountSwitch
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3eAuth = SharedFlags.FFlagSignalsNavP3eAuth
local fFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/fBO").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local fFlagApplyLaunchContextForNewAccountSwitches = SharedFlags.FFlagApplyLaunchContextForNewAccountSwitches

local fFlagLuaEnableLoginAndSignupDifferentiatedStatusValues = SharedFlags.FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues

local module11 = require("@luauforge/bundled/fBo")

local extended = React.PureComponent:extend("StartupPage")

function extended.didMount(p2)
	local networking = p2.props.networking
	local analytics = p2.props.analytics

	local appPolicy = p2.props.appPolicy
	local loggingProtocol = p2.props.loggingProtocol
	local prefetchProtocol = p2.props.prefetchProtocol

	if p2.props.authStatus == module7.UNKNOWN then
		p2.props.launchApp(
			networking,
			p2.props.omniRecommendationsRequest,
			analytics,
			appPolicy,
			loggingProtocol,
			p2.props.appStartupSequence,
			prefetchProtocol
		)
	end

	p2.props.loggingProtocol:logEventOnce("startup_page_did_mount")
end

function extended.render(p2)
	return React.createElement(
		"Frame",
		{
			[React.Tag] = "app-screen.startup",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = module4.Color.GRAY4,
			ZIndex = 1
		},
		{ LoadingBar = React.createElement(LoadingModal) }
	)
end

local v5 = RoactRodux.connect(function(p2, p3)
	local v6

	if not fFlagSignalsNavP3eAuth then
		if fFlagUseNavigationSelectors then
			v6 = selectors.selectCurrentPageName(p2)
		else
			local v7 = p2.Navigation.history[#p2.Navigation.history]
			v6 = v7[#v7].name
		end
	end

	local v8 = if not fFlagUseSignalsForAuthenticationStatus then p2.AuthenticationStatus.status else nil

	if fFlagSignalsNavP3eAuth then
		v6 = nil
	end

	return { authStatus = v8, currentPageName = v6 }
end, function(callback)
	return {
		launchApp = function(p2, p3, p4, p5, p6, p7, p8)
			if module8.LuaAuthEnabledForLuobu() and p5.useLuobuAuthentication() then
				callback(module6(p2, p4, p5, module11.Startup))
				return
			end

			local v6 = module11.Startup

			if
				fFlagEnableLuaAccountSwitch
				and (fFlagApplyLaunchContextForNewAccountSwitches or fFlagLuaEnableLoginAndSignupDifferentiatedStatusValues)
			then
				local accountSwitchStatus = module9.getAccountSwitchStatus()

				if accountSwitchStatus == accountSwitcherConstants.AccountSwitcherSwitchedFromLoginStatus then
					v6 = module11.Login
				elseif accountSwitchStatus == accountSwitcherConstants.AccountSwitcherSwitchedFromSignupStatus then
					v6 = module11.SignUp
				end
			end

			callback(module5(p2, p3, p4, p5, v6, p6, p7, p8))
		end
	}
end)(extended)
local v6

if fFlagUseSignalsForAuthenticationStatus then
	v6 = React.memo(function(p2)
		return React.createElement(
			v5,
			Cryo.Dictionary.union(p2, {
				authStatus = useSignalState(getAuthenticationStatusStore(false).getStatus)
			})
		)
	end)
else
	v6 = v5
end

local v7 = roactServices.connect({
	networking = module,
	analytics = module2,
	loggingProtocol = appLogging,
	appStartupSequence = appStartupSequenceTag,
	prefetchProtocol = appPrefetch
})(v6)

local v8 = roactAppPolicy.connect(function(p2, p3)
	return { appPolicy = p2 }
end)(v7)

default:logEventOnce("start_up_page_require_end")

return v8
