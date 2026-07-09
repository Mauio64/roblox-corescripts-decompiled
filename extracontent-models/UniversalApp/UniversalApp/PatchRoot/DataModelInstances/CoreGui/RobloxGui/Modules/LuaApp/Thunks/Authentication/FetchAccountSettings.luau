local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Modules = CoreGui.RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local AppPage = require(Modules.LuaApp.AppPage)
local GetAccountInfo = require(Modules.LuaApp.Http.Requests.GetAccountInfo)
local SetAuthenticationStatus = require(CorePackages.Workspace.Packages.AuthenticationStatus).Actions.SetAuthenticationStatus
local LoginStatus = require(Modules.LuaApp.Enum.LoginStatus)
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)
local PreloadApplicationData = require(Modules.LuaApp.Thunks.PreloadApplicationData)

return function(p1, p2, p3) -- line: 17
	-- upvalues: GetAccountInfo (copy), Players (copy), SetAuthenticationStatus (copy), LoginStatus (copy), ResetNavigationHistory (copy), AppPage (copy), PreloadApplicationData (copy), Promise (copy)
	return function(p4) -- line: 18
		-- upvalues: GetAccountInfo (copy), p1 (copy), Players (copy), SetAuthenticationStatus (copy), LoginStatus (copy), ResetNavigationHistory (copy), AppPage (copy), PreloadApplicationData (copy), p2 (copy), p3 (copy), Promise (copy)
		return GetAccountInfo(p1):andThen(function(p5) -- line: 19
			-- upvalues: Players (copy), p4 (copy), SetAuthenticationStatus (copy), LoginStatus (copy), ResetNavigationHistory (copy), AppPage (copy), PreloadApplicationData (copy), p1 (copy), p2 (copy), p3 (copy), Promise (copy)
			local Username = p5.responseBody.Username
			local DisplayName = p5.responseBody.DisplayName
			local UserId = p5.responseBody.UserId
			local num = tonumber(p5.responseBody.MembershipType)
			local v21 = p5.responseBody.AgeBracket == 1

			Players:SetLocalPlayerInfo(UserId, Username, DisplayName, num, v21)
			p4:dispatch(SetAuthenticationStatus(LoginStatus.LOGGED_IN))
			p4:dispatch(ResetNavigationHistory({{
				name = AppPage.Home
			}}))
			p4:dispatch(PreloadApplicationData(p1, p2, p3))

			return Promise.resolve()
		end, function(p6) -- line: 30
			-- upvalues: p4 (copy), SetAuthenticationStatus (copy), LoginStatus (copy), ResetNavigationHistory (copy), AppPage (copy), Promise (copy)
			p4:dispatch(SetAuthenticationStatus(LoginStatus.LOGGED_OUT))
			p4:dispatch(ResetNavigationHistory({{
				name = AppPage.WeChatLoginWrapper
			}}))

			return Promise.reject(p6)
		end)
	end
end
