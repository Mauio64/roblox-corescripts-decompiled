local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v6 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

return function(s1: string, n1: number, n2: number, s2: string, s3: string?, p1: ((...any) -> ...any), s4: string?) -- line: 14
	-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v6 (copy), NavigateDown (copy)
	return function(p2) -- line: 23
		-- upvalues: AppPage (copy), s1 (copy), n1 (copy), n2 (copy), s2 (copy), s3 (copy), p1 (copy), s4 (copy), FFlagSignalsNavP3Dispatch (copy), v6 (copy), NavigateDown (copy)
		local t1 = {
			detail = "",
			name = AppPage.RobuxUpsell,
			extraProps = {
				triggerContext = s1,
				priceInRobux = n1,
				userRobux = n2,
				itemName = s2,
				itemIcon = s3,
				purchaseItem = p1,
				itemProductId = s4
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v6.down(v6.fromLegacyPage(t1))

			return
		end

		p2:dispatch(NavigateDown(t1))
	end
end
