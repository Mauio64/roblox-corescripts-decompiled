local CorePackages = game:GetService("CorePackages")
local Navigation = require(CorePackages.Workspace.Packages.Navigation)
local RobloxAppNavigation = require(CorePackages.Workspace.Packages.RobloxAppNavigation)
local RootNavigator = require(script.Parent.RootNavigator)
local FFlagSignalsNavP2NavigationPrimitives = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP2NavigationPrimitives
local v6 = Navigation.createSignalsNavigationObject(RootNavigator.router)

if FFlagSignalsNavP2NavigationPrimitives then
	RobloxAppNavigation.AppNavigationRegistry.register(v6)
end

return v6
