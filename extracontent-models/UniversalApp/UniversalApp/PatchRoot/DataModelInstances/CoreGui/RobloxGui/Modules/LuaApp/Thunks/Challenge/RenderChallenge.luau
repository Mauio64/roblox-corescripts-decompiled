local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local Type = require(Modules.LuaApp.Enum.Challenge.Type)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local GetFFlagDispatchHybridWebviewWithBypassNavigationLock = require(Modules.LuaApp.Flags.GetFFlagDispatchHybridWebviewWithBypassNavigationLock)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v8 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

return function(p1, p2, p3) -- line: 20
	-- upvalues: Type (copy), GetFFlagDispatchHybridWebviewWithBypassNavigationLock (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v8 (copy), NavigateDown (copy)
	return function(p4) -- line: 21
		-- upvalues: p1 (copy), Type (copy), p2 (copy), GetFFlagDispatchHybridWebviewWithBypassNavigationLock (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v8 (copy), p3 (copy), NavigateDown (copy)
		local v13 = p1.challengeType == Type.Captcha

		if p2 ~= nil then
			v13 = p2
		end

		if GetFFlagDispatchHybridWebviewWithBypassNavigationLock() then
			local t1 = {
				name = v13 and AppPage.ChallengeHybridOverlayPage or AppPage.ChallengeHybridWebView,
				extraProps = p1
			}

			if FFlagSignalsNavP3Dispatch then
				v8.down(v8.fromLegacyPage(t1), p3)

				return
			end

			p4:dispatch(NavigateDown(t1, p3))

			return
		end

		local t2 = {
			name = v13 and AppPage.ChallengeHybridOverlayPage or AppPage.ChallengeHybridWebView,
			extraProps = p1
		}

		if FFlagSignalsNavP3Dispatch then
			v8.down(v8.fromLegacyPage(t2))

			return
		end

		p4:dispatch(NavigateDown(t2))
	end
end
