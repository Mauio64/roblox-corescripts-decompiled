local CorePackages = game:GetService("CorePackages")

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
require("@game/CorePackages/Workspace/Packages/Navigation")
local module = require("@luauforge/bundled/dCw")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default
local createLazyComponent = require("@game/CorePackages/Workspace/Packages/RoactUtils").Components.createLazyComponent

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local fFlagAppIaHomeCampaignSubTab = SharedFlags.FFlagAppIaHomeCampaignSubTab

local defineFastFlag = game:DefineFastFlag("AppIaHomeSubTabLazy", false)

local v7 = {
	{
		[appPage.Home] = {
			screen = createLazyComponent(function()
				default:logEventOnce("lazily_require_home_page")

				if fFlagLuaAppEnableSduiHomePage then
					return require("@luauforge/bundled/hFC")
				end

				return require("@luauforge/bundled/hGi")
			end)
		}
	},
	{
		[appPage.Games] = {
			screen = createLazyComponent(function()
				return require("@luauforge/deferred/hGs")
			end)
		}
	}
}

if fFlagAppIaHomeCampaignSubTab then
	local v8 = {
		[appPage.Campaign] = {
			screen = createLazyComponent(function()
				return require("@luauforge/bundled/hGt")
			end)
		}
	}
	table.insert(v7, v8)
end

local v8 = { initialRouteName = appPage.Home }

local function createHomeSubTabNavigator()
	local v9 = if defineFastFlag then module.createLazySwitchRouter(v7, v8) else RoactNavigation.SwitchRouter(v7, v8)
	return RoactNavigation.createNavigator(module.AppSwitchView, v9, v8)
end

return createHomeSubTabNavigator
