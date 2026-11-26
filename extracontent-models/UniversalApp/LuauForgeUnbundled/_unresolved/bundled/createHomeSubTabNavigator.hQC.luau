local CorePackages = game:GetService("CorePackages")

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
require("@game/CorePackages/Workspace/Packages/Navigation")
local module = require("@luauforge/bundled/dFB")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default
local createLazyComponent = require("@game/CorePackages/Workspace/Packages/RoactUtils").Components.createLazyComponent

local flyoutSidePanelIXP = require("@luauforge/bundled/dKM").FlyoutSidePanelIXP

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local fFlagAppIaHomeCampaignSubTab = SharedFlags.FFlagAppIaHomeCampaignSubTab
local fFlagEnableIsChartsInSubTab = SharedFlags.FFlagEnableIsChartsInSubTab

local defineFastFlag = game:DefineFastFlag("AppIaHomeSubTabLazy", false)

local v6 = {
	{
		[appPage.Home] = {
			screen = createLazyComponent(function()
				default:logEventOnce("lazily_require_home_page")

				if fFlagLuaAppEnableSduiHomePage then
					return require("@luauforge/bundled/hQD")
				end

				return require("@luauforge/bundled/hRe")
			end)
		}
	}
}

if not fFlagEnableIsChartsInSubTab or flyoutSidePanelIXP.isChartsInSubTab() then
	local v7 = {
		[appPage.Games] = {
			screen = createLazyComponent(function()
				return require("@luauforge/deferred/hRo")
			end)
		}
	}
	table.insert(v6, v7)
end

if fFlagAppIaHomeCampaignSubTab then
	local v7 = {
		[appPage.Campaign] = {
			screen = createLazyComponent(function()
				return require("@luauforge/bundled/hRp")
			end)
		}
	}
	table.insert(v6, v7)
end

local v7 = { initialRouteName = appPage.Home }

local function createHomeSubTabNavigator()
	local v8 = if defineFastFlag then module.createLazySwitchRouter(v6, v7) else RoactNavigation.SwitchRouter(v6, v7)
	return RoactNavigation.createNavigator(module.AppSwitchView, v8, v7)
end

return createHomeSubTabNavigator
