local module = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/NavigationCommands")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/AppNavigationRegistry")

local fFlagEnableOnScreenAPIIntegration = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/SharedFlags").FFlagEnableOnScreenAPIIntegration

local v5 = {
	AppNavigationRegistry = module2,
	isNavigationAvailable = module2.isRegistered,
	NavigationCommands = module,
	useNavigationProps = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/useNavigationProps"),
	withNavigationProps = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/withNavigationProps"),
	CurrentTabContext = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/CurrentTabContext"),
	TopBarContext = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/TopBarContext"),
	useIsRouteOnScreen = 0,
	OnScreenContext = 0,
	useOnScreenNavigationListener = 0
}
local v6 = if fFlagEnableOnScreenAPIIntegration then require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/useIsRouteOnScreen") else nil
v5.useIsRouteOnScreen = v6
local v7 = if fFlagEnableOnScreenAPIIntegration then require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/OnScreenContext") else nil
v5.OnScreenContext = v7

local v8 = if fFlagEnableOnScreenAPIIntegration then require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/useOnScreenNavigationListener") else nil
v5.useOnScreenNavigationListener = v8
return v5
