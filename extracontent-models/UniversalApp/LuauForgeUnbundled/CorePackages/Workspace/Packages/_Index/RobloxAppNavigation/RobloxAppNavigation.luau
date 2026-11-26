local module = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/NavigationCommands")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/AppNavigationRegistry")

local fFlagEnableOnScreenAPIIntegration = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/SharedFlags").FFlagEnableOnScreenAPIIntegration
local fFlagSignalsNavP3hMisc = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/SharedFlags").FFlagSignalsNavP3hMisc

local v5 = {
	AppNavigationRegistry = module2,
	isNavigationAvailable = module2.isRegistered,
	NavigationCommands = module,
	useNavigationProps = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/useNavigationProps"),
	withNavigationProps = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/withNavigationProps"),
	withNavigationFocusIgnoringNavigation = 0,
	CurrentTabContext = 0,
	TopBarContext = 0,
	resolveNavigationTarget = 0,
	useIsRouteOnScreen = 0,
	OnScreenContext = 0,
	useOnScreenNavigationListener = 0
}

local v6 = if fFlagSignalsNavP3hMisc then require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/withNavigationFocusIgnoringNavigation") else nil
v5.withNavigationFocusIgnoringNavigation = v6

v5.CurrentTabContext = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/CurrentTabContext")
v5.TopBarContext = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/TopBarContext")
v5.resolveNavigationTarget = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/resolveNavigationTarget")
local v7 = if fFlagEnableOnScreenAPIIntegration then require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/useIsRouteOnScreen") else nil
v5.useIsRouteOnScreen = v7
local v8 = if fFlagEnableOnScreenAPIIntegration then require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/OnScreenContext") else nil
v5.OnScreenContext = v8

local v9 = if fFlagEnableOnScreenAPIIntegration then require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/useOnScreenNavigationListener") else nil
v5.useOnScreenNavigationListener = v9
return v5
