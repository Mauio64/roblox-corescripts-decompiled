local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default

default:logEventOnce("start_up_page_require_begin")

local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local AppPrefetch = require(CorePackages.Workspace.Packages.RoactServiceTags).AppPrefetch
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local LoadingBar = require(Modules.LuaApp.Components.LoadingBar)
local Constants = require(Modules.LuaApp.Constants)
local LaunchApp = require(Modules.LuaApp.Thunks.Authentication.LaunchApp)
local LaunchLuobuApp = require(Modules.Luobu.Thunks.LaunchLuobuApp)
local AppLogging = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLogging
local AppStartupSequenceTag = require(CorePackages.Workspace.Packages.RoactServiceTags).AppStartupSequenceTag
local AccountSwitcherConstants = require(CorePackages.Workspace.Packages.AuthCommon).Common.AccountSwitcherConstants
local LoginStatus = require(Modules.LuaApp.Enum.LoginStatus)
local FlagSettings = require(Modules.LuaApp.FlagSettings)
local AppStorageUtilities = require(Modules.LuaApp.Thunks.Authentication.AppStorageUtilities)
local Cryo = require(CorePackages.Packages.Cryo)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableLuaAccountSwitch = SharedFlags.FFlagEnableLuaAccountSwitch
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3eAuth = SharedFlags.FFlagSignalsNavP3eAuth
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v28 = if not FFlagSignalsNavP3eAuth then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local FFlagApplyLaunchContextForNewAccountSwitches = SharedFlags.FFlagApplyLaunchContextForNewAccountSwitches
local FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues = SharedFlags.FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues
local LaunchContext = require(Modules.LuaApp.Enum.LaunchContext)
local v32 = React.PureComponent:extend("StartupPage")

function v32.didMount(p1) -- line: 51
	-- upvalues: LoginStatus (copy)
	local networking = p1.props.networking
	local analytics = p1.props.analytics
	local appPolicy = p1.props.appPolicy
	local loggingProtocol = p1.props.loggingProtocol
	local prefetchProtocol = p1.props.prefetchProtocol

	if p1.props.authStatus == LoginStatus.UNKNOWN then
		p1.props.launchApp(networking, p1.props.omniRecommendationsRequest, analytics, appPolicy, loggingProtocol, p1.props.appStartupSequence, prefetchProtocol)
	end

	p1.props.loggingProtocol:logEventOnce("startup_page_did_mount")
end
function v32.render(_) -- line: 72
	-- upvalues: React (copy), Constants (copy), LoadingBar (copy)
	return React.createElement("Frame", {
		[React.Tag] = "app-screen.startup",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Constants.Color.GRAY4,
		ZIndex = 1
	}, {
		LoadingBar = React.createElement(LoadingBar)
	})
end

local v33 = RoactRodux.connect(function(p3, _) -- line: 83
	-- upvalues: FFlagSignalsNavP3eAuth (copy), FFlagUseNavigationSelectors (copy), Selectors (copy)
	local v46 = nil

	if not FFlagSignalsNavP3eAuth then
		if FFlagUseNavigationSelectors then
			v46 = Selectors.selectCurrentPageName(p3)
		else
			local v47 = p3.Navigation.history[#p3.Navigation.history]

			v46 = v47[#v47].name
		end
	end

	return {
		authStatus = p3.AuthenticationStatus.status,
		currentPageName = if not FFlagSignalsNavP3eAuth then v46 else nil
	}
end, function(p5) -- line: 98
	-- upvalues: FlagSettings (copy), LaunchLuobuApp (copy), LaunchContext (copy), FFlagEnableLuaAccountSwitch (copy), FFlagApplyLaunchContextForNewAccountSwitches (copy), FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues (copy), AppStorageUtilities (copy), AccountSwitcherConstants (copy), LaunchApp (copy)
	return {
		launchApp = function(p6, p7, p8, p9, p10, p11, p12) -- line: 100
			-- upvalues: FlagSettings (copy), p5 (copy), LaunchLuobuApp (copy), LaunchContext (copy), FFlagEnableLuaAccountSwitch (copy), FFlagApplyLaunchContextForNewAccountSwitches (copy), FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues (copy), AppStorageUtilities (copy), AccountSwitcherConstants (copy), LaunchApp (copy)
			if FlagSettings.LuaAuthEnabledForLuobu() and p9.useLuobuAuthentication() then
				p5(LaunchLuobuApp(p6, p8, p9, LaunchContext.Startup))

				return
			end

			local Startup = LaunchContext.Startup

			if FFlagEnableLuaAccountSwitch and (FFlagApplyLaunchContextForNewAccountSwitches or FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues) then
				local v63 = AppStorageUtilities.getAccountSwitchStatus()

				if v63 == AccountSwitcherConstants.AccountSwitcherSwitchedFromLoginStatus then
					Startup = LaunchContext.Login
				elseif v63 == AccountSwitcherConstants.AccountSwitcherSwitchedFromSignupStatus then
					Startup = LaunchContext.SignUp
				end
			end

			p5(LaunchApp(p6, p7, p8, p9, Startup, p10, p11, p12))
		end
	}
end)(v32)

if FFlagSignalsNavP3eAuth then
	local v34 = v33

	function v33(p13) -- line: 147
		-- upvalues: v28 (copy), useSignalState (copy), React (copy), v34 (copy), Cryo (copy)
		local v50 = v28(false)
		local v51 = useSignalState(v50.getCurrentPage)
		local v52 = v51 and v51.name

		return React.createElement(v34, Cryo.Dictionary.union(p13, {
			currentPageName = v52
		}))
	end
end

local v35 = RoactServices.connect({
	networking = RoactNetworking,
	analytics = RoactAnalytics,
	loggingProtocol = AppLogging,
	appStartupSequence = AppStartupSequenceTag,
	prefetchProtocol = AppPrefetch
})(v33)
local v36 = RoactAppPolicy.connect(function(p14, _) -- line: 169
	return {
		appPolicy = p14
	}
end)(v35)

default:logEventOnce("start_up_page_require_end")

return v36
