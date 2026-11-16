local getFFlagEnableUnifiedWebViews = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagEnableUnifiedWebViews

local HttpService = game:GetService("HttpService")
local BrowserService = game:GetService("BrowserService")
local WebViewService = if getFFlagEnableUnifiedWebViews() then game:GetService("WebViewService") else nil

local navigateSideways = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/NavigationRodux").Thunks.NavigateSideways
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppNavigation").NavigationCommands else nil

local HandleAuthTicket = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Thunks/HandleAuthTicket")
local launchContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/AppStartup").Enums.LaunchContext
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppEnums").AppPage

local defineFastFlag = game:DefineFastFlag("EnableJoinV2PreAuthDeepLink", false)
local defineFastFlag2 = game:DefineFastFlag("EnableAccountRecoveryPreAuthDeepLink2", true)

local defineFastInt = game:DefineFastInt("WaitAfterCloseChallengeWebViewSeconds", 500)

local v5 = {
	{
		regexPattern = "roblox.*//testing/preauth.*",
		handler = function(items, items2): boolean
			print("preauth deeplink example called with query params:")

			for k, item in pairs(items) do
				print(k, "=", item)
			end

			print("context:")

			for k, item in pairs(items2) do
				print(k, "=", item)
			end

			return true
		end,
		preauthOnly = false
	}
}

if defineFastFlag then
	table.insert(v5, {
		regexPattern = "roblox.*://join_v2/join.*",
		handler = function(p2, data)
			local function fn()
				return data.dispatch(data.launchApp(
					data.networking,
					data.omniRecommendationsRequest,
					data.analytics,
					data.appPolicy,
					launchContext.Login
				))
			end

			return HandleAuthTicket(data.networking, p2.ticket, p2.placelauncherurl, fn, function()
				return data.dispatch(data.resetAppState())
			end)
		end,
		preauthOnly = false
	})
end

if defineFastFlag2 then
	table.insert(v5, {
		regexPattern = "roblox.*://navigation/account_recovery.*",
		handler = function(data, p2)
			local origin = data.origin
			local v6 = {}
			local v7

			if origin == "login2SV" then
				v7 = {
					continuingRecovery = false,
					recover2sv = true,
					recoverPassword = false,
					identifier = data.username
				}
			else
				v7 = origin == "passwordReset2SV" and {
					continuingRecovery = true,
					recover2sv = true,
					recoverPassword = true,
					recoverySessionID = data.recoverysessionid,
					identifier = data.username
				} or v6
			end

			if getFFlagEnableUnifiedWebViews() then
				WebViewService:CloseWindow()
			else
				BrowserService:CloseBrowserWindow()
			end

			if origin == "login2SV" then
				task.wait(defineFastInt / 1000)
			end

			local v8 = {
				name = appPage.AccountRecovery,
				detail = HttpService:GenerateGUID(false):lower(),
				extraProps = v7
			}

			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.sideways(navigationCommands.fromLegacyPage(v8))
			end

			return p2.dispatch(navigateSideways(v8))
		end,
		preauthOnly = false
	})
end

return v5
