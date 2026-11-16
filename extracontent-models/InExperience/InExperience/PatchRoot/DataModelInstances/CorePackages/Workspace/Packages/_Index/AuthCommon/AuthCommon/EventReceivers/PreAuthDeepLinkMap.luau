local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableUnifiedWebViews = SharedFlags.GetFFlagEnableUnifiedWebViews

local HttpService = game:GetService("HttpService")
local BrowserService = game:GetService("BrowserService")
local WebViewService

if GetFFlagEnableUnifiedWebViews() then
	WebViewService = game:GetService("WebViewService")
else
	WebViewService = nil
end

local NavigationRodux = require(parent.NavigationRodux)
local NavigateSideways = NavigationRodux.Thunks.NavigateSideways
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags2.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local HandleAuthTicket = require(AuthCommon.Thunks.HandleAuthTicket)
local AppStartup = require(parent.AppStartup)
local LaunchContext = AppStartup.Enums.LaunchContext
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local defineFastFlag = game:DefineFastFlag("EnableJoinV2PreAuthDeepLink", false)
local defineFastFlag2 = game:DefineFastFlag("EnableAccountRecoveryPreAuthDeepLink2", true)

local defineFastInt = game:DefineFastInt("WaitAfterCloseChallengeWebViewSeconds", 500)

local PreAuthDeepLinkMap = {
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
	table.insert(PreAuthDeepLinkMap, {
		regexPattern = "roblox.*://join_v2/join.*",
		handler = function(p, data)
			local function fn()
				return data.dispatch(data.launchApp(
					data.networking,
					data.omniRecommendationsRequest,
					data.analytics,
					data.appPolicy,
					LaunchContext.Login
				))
			end

			return HandleAuthTicket(data.networking, p.ticket, p.placelauncherurl, fn, function()
				return data.dispatch(data.resetAppState())
			end)
		end,
		preauthOnly = false
	})
end

if defineFastFlag2 then
	table.insert(PreAuthDeepLinkMap, {
		regexPattern = "roblox.*://navigation/account_recovery.*",
		handler = function(data, p)
			local origin = data.origin
			local v = {}
			local extraProps

			if origin == "login2SV" then
				extraProps = {
					continuingRecovery = false,
					recover2sv = true,
					recoverPassword = false,
					identifier = data.username
				}
			else
				extraProps = origin == "passwordReset2SV" and {
					continuingRecovery = true,
					recover2sv = true,
					recoverPassword = true,
					recoverySessionID = data.recoverysessionid,
					identifier = data.username
				} or v
			end

			if GetFFlagEnableUnifiedWebViews() then
				WebViewService:CloseWindow()
			else
				BrowserService:CloseBrowserWindow()
			end

			if origin == "login2SV" then
				task.wait(defineFastInt / 1000)
			end

			local v2 = {
				name = AppPage.AccountRecovery,
				detail = HttpService:GenerateGUID(false):lower(),
				extraProps = extraProps
			}

			if FFlagSignalsNavP3Dispatch then
				return navigationCommands.sideways(navigationCommands.fromLegacyPage(v2))
			end

			return p.dispatch(NavigateSideways(v2))
		end,
		preauthOnly = false
	})
end

return PreAuthDeepLinkMap
