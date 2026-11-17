local NavigationCommands = require(script.NavigationCommands)
local AppNavigationRegistry = require(script.AppNavigationRegistry)

local parent = script.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableOnScreenAPIIntegration = SharedFlags.FFlagEnableOnScreenAPIIntegration
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSignalsNavP3hMisc = SharedFlags2.FFlagSignalsNavP3hMisc

local RobloxAppNavigation = {}
RobloxAppNavigation.AppNavigationRegistry = AppNavigationRegistry
RobloxAppNavigation.isNavigationAvailable = AppNavigationRegistry.isRegistered
RobloxAppNavigation.NavigationCommands = NavigationCommands
RobloxAppNavigation.useNavigationProps = require(script.useNavigationProps)
RobloxAppNavigation.withNavigationProps = require(script.withNavigationProps)
local withNavigationFocusIgnoringNavigation

if FFlagSignalsNavP3hMisc then
	withNavigationFocusIgnoringNavigation = require(script.withNavigationFocusIgnoringNavigation)
end

RobloxAppNavigation.withNavigationFocusIgnoringNavigation = withNavigationFocusIgnoringNavigation

RobloxAppNavigation.CurrentTabContext = require(script.CurrentTabContext)
RobloxAppNavigation.TopBarContext = require(script.TopBarContext)
RobloxAppNavigation.resolveNavigationTarget = require(script.resolveNavigationTarget)
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
