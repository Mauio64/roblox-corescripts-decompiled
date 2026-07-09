local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v7 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

local function openRefundPolicyLearnMorePage(p1) -- line: 13
	-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy)
	return function(p2) -- line: 14
		-- upvalues: AppPage (copy), p1 (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy)
		local t1 = {
			name = AppPage.GenericWebPage,
			detail = p1,
			extraProps = {
				title = ""
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v7.down(v7.fromLegacyPage(t1))

			return
		end

		p2:dispatch(NavigateDown(t1))
	end
end

return openRefundPolicyLearnMorePage
