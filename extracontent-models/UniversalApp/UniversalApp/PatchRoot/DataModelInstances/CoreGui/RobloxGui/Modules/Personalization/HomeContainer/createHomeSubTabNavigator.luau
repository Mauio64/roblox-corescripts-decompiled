local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)

require(CorePackages.Workspace.Packages.Navigation)

local RobloxAppNavigationCore = require(CorePackages.Workspace.Packages.RobloxAppNavigationCore)
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local createLazyComponent = require(CorePackages.Workspace.Packages.RoactUtils).Components.createLazyComponent
local Modules = CoreGui.RobloxGui.Modules
local FFlagLuaAppChartsAppPage = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppChartsAppPage
local v10 = game:DefineFastFlag("AppIaHomeSubTabLazy", false)
local t1 = {
	{
		[AppPage.Home] = {
			screen = createLazyComponent(function() -- line: 26
				-- upvalues: default (copy), Modules (copy)
				default:logEventOnce("lazily_require_home_page")

				return require(Modules.Personalization.Home.HomePage)
			end)
		}
	},
	{
		[AppPage.Games] = {
			screen = createLazyComponent(function() -- line: 34
				-- upvalues: FFlagLuaAppChartsAppPage (copy), Modules (copy)
				if FFlagLuaAppChartsAppPage then
					return require(Modules.Personalization.Games.SduiChartsPage)
				end

				return require(Modules.Personalization.Games.GamesPage)
			end)
		}
	}
}
local t2 = {
	initialRouteName = AppPage.Home
}

local function createHomeSubTabNavigator() -- line: 48
	-- upvalues: v10 (copy), RobloxAppNavigationCore (copy), t1 (copy), t2 (copy), RoactNavigation (copy)
	local v14 = if not v10 then RoactNavigation.SwitchRouter(t1, t2) else RobloxAppNavigationCore.createLazySwitchRouter(t1, t2)

	return RoactNavigation.createNavigator(RobloxAppNavigationCore.AppSwitchView, v14, t2)
end

return createHomeSubTabNavigator
