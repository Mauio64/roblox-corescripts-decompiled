local CorePackages = game:GetService("CorePackages")
local createRootNavigator = require(CorePackages.Workspace.Packages.RobloxAppNavigationCore).createRootNavigator
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local getAppRoutes = require(Modules.LuaApp.Navigation.getAppRoutes)
local getSwitchRoutesArray = require(Modules.LuaApp.Navigation.getSwitchRoutesArray)

return require(Modules.LuaApp.Navigation.wrapWithSwitchVisibility)(createRootNavigator(getAppRoutes(), getSwitchRoutesArray()))
