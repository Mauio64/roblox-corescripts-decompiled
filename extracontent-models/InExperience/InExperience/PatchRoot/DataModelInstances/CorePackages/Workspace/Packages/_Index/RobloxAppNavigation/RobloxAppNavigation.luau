local NavigationCommands = require(script.NavigationCommands)
local AppNavigationRegistry = require(script.AppNavigationRegistry)

local parent = script.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableOnScreenAPIIntegration = SharedFlags.FFlagEnableOnScreenAPIIntegration

local RobloxAppNavigation = {}
RobloxAppNavigation.AppNavigationRegistry = AppNavigationRegistry
RobloxAppNavigation.isNavigationAvailable = AppNavigationRegistry.isRegistered
RobloxAppNavigation.NavigationCommands = NavigationCommands
RobloxAppNavigation.useNavigationProps = require(script.useNavigationProps)
RobloxAppNavigation.withNavigationProps = require(script.withNavigationProps)
RobloxAppNavigation.CurrentTabContext = require(script.CurrentTabContext)
RobloxAppNavigation.TopBarContext = require(script.TopBarContext)
local useIsRouteOnScreen

if FFlagEnableOnScreenAPIIntegration then
	useIsRouteOnScreen = require(script.useIsRouteOnScreen)
end

RobloxAppNavigation.useIsRouteOnScreen = useIsRouteOnScreen
local onScreenContext

if FFlagEnableOnScreenAPIIntegration then
	onScreenContext = require(script.OnScreenContext)
end

RobloxAppNavigation.OnScreenContext = onScreenContext
local useOnScreenNavigationListener

if FFlagEnableOnScreenAPIIntegration then
	useOnScreenNavigationListener = require(script.useOnScreenNavigationListener)
end

RobloxAppNavigation.useOnScreenNavigationListener = useOnScreenNavigationListener

RobloxAppNavigation["jest.config"] = script["jest.config"]
return RobloxAppNavigation
