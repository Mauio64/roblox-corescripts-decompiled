local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local SetAuthenticationStatus = require(CorePackages.Workspace.Packages.AuthenticationStatus).Actions.SetAuthenticationStatus
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)
local AppStorageUtilities = require(script.Parent.AppStorageUtilities)
local LoginStatus = require(Modules.LuaApp.Enum.LoginStatus)
local FetchLocale = require(Modules.LuaApp.Thunks.FetchLocale)
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FlagSettings = require(Modules.LuaApp.FlagSettings)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v13 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

return function(p1) -- line: 20
	-- upvalues: FetchLocale (copy), AppStorageUtilities (copy), SetAuthenticationStatus (copy), LoginStatus (copy), FlagSettings (copy), ResetNavigationHistory (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v13 (copy), NavigateDown (copy)
	return function(p2) -- line: 21
		-- upvalues: FetchLocale (copy), p1 (copy), AppStorageUtilities (copy), SetAuthenticationStatus (copy), LoginStatus (copy), FlagSettings (copy), ResetNavigationHistory (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v13 (copy), NavigateDown (copy)
		return FetchLocale(p1):andThen(function(p3) -- line: 22
			-- upvalues: AppStorageUtilities (copy), p2 (copy), SetAuthenticationStatus (copy), LoginStatus (copy), FlagSettings (copy), ResetNavigationHistory (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v13 (copy), NavigateDown (copy)
			AppStorageUtilities.setRobloxLocaleId(p3.signupAndLoginLocale)
			p2:dispatch(SetAuthenticationStatus(LoginStatus.LOGGED_OUT))

			if FlagSettings.WeChatLoginEnabled() then
				p2:dispatch(ResetNavigationHistory({{
					name = AppPage.WeChatLoginWrapper
				}}))

				return
			end

			if FlagSettings.LuaAppLoginUIEnabled() then
				p2:dispatch(ResetNavigationHistory({{
					name = AppPage.Landing
				}}))

				return
			end

			if FFlagSignalsNavP3Dispatch then
				v13.down(v13.fromLegacyPage({
					name = AppPage.LoginNative
				}))

				return
			end

			p2:dispatch(NavigateDown({
				name = AppPage.LoginNative
			}))
		end)
	end
end
