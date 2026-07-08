local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local GetFFlagEnableUnifiedWebViews = require(AuthCommonParent.SharedFlags).GetFFlagEnableUnifiedWebViews
local HttpService = game:GetService("HttpService")
local BrowserService = game:GetService("BrowserService")
local v6 = if not GetFFlagEnableUnifiedWebViews() then nil else game:GetService("WebViewService")
local NavigateSideways = require(AuthCommonParent.NavigationRodux).Thunks.NavigateSideways
local FFlagSignalsNavP3Dispatch = require(AuthCommonParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v9 = if not FFlagSignalsNavP3Dispatch then nil else require(AuthCommonParent.RobloxAppNavigation).NavigationCommands
local HandleAuthTicket = require(AuthCommon.Thunks.HandleAuthTicket)
local LaunchContext = require(AuthCommonParent.AppStartup).Enums.LaunchContext
local AppPage = require(AuthCommonParent.RobloxAppEnums).AppPage
local v13 = game:DefineFastFlag("EnableJoinV2PreAuthDeepLink", false)
local v14 = game:DefineFastFlag("EnableAccountRecoveryPreAuthDeepLink2", true)
local v15 = game:DefineFastInt("WaitAfterCloseChallengeWebViewSeconds", 500)
local t1 = {{
	regexPattern = "roblox.*//testing/preauth.*",
	preauthOnly = false,
	handler = function(p1, p2) -- line: 62
		print("preauth deeplink example called with query params:")

		for k, v in pairs(p1) do
			print(k, "=", v)
		end

		print("context:")

		for k, v in pairs(p2) do
			print(k, "=", v)
		end

		return true
	end
}}

if v13 then
	table.insert(t1, {
		regexPattern = "roblox.*://join_v2/join.*",
		preauthOnly = false,
		handler = function(p3, p4) -- line: 82
			-- upvalues: LaunchContext (copy), HandleAuthTicket (copy)
			return HandleAuthTicket(p4.networking, p3.ticket, p3.placelauncherurl, function() -- line: 83
				-- upvalues: p4 (copy), LaunchContext (copy)
				return p4.dispatch(p4.launchApp(p4.networking, p4.omniRecommendationsRequest, p4.analytics, p4.appPolicy, LaunchContext.Login))
			end, function() -- line: 95
				-- upvalues: p4 (copy)
				return p4.dispatch(p4.resetAppState())
			end)
		end
	})
end

if v14 then
	table.insert(t1, {
		regexPattern = "roblox.*://navigation/account_recovery.*",
		preauthOnly = false,
		handler = function(p5, p6) -- line: 114
			-- upvalues: GetFFlagEnableUnifiedWebViews (copy), v6 (copy), BrowserService (copy), v15 (copy), AppPage (copy), HttpService (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateSideways (copy)
			local origin = p5.origin
			local t2 = {}

			if origin == "login2SV" then
				t2 = {
					continuingRecovery = false,
					recover2sv = true,
					recoverPassword = false,
					identifier = p5.username
				}
			elseif origin == "passwordReset2SV" then
				t2 = {
					continuingRecovery = true,
					recover2sv = true,
					recoverPassword = true,
					recoverySessionID = p5.recoverysessionid,
					identifier = p5.username
				}
			end

			if GetFFlagEnableUnifiedWebViews() then
				v6:CloseWindow()
			else
				BrowserService:CloseBrowserWindow()
			end

			if origin == "login2SV" then
				task.wait(v15 / 1000)
			end

			local t3 = {
				name = AppPage.AccountRecovery,
				detail = HttpService:GenerateGUID(false):lower(),
				extraProps = t2
			}

			if FFlagSignalsNavP3Dispatch then
				return v9.sideways(v9.fromLegacyPage(t3))
			end

			return p6.dispatch(NavigateSideways(t3))
		end
	})
end

return t1
