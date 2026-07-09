local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors

return function(p1) -- line: 14
	-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy), NotificationType (copy)
	return function(p2) -- line: 15
		-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy), p1 (copy), NotificationType (copy)
		local v8 = p2:getState()
		local v9 = if not FFlagUseNavigationSelectors then v8.Navigation.history[#v8.Navigation.history] else Selectors.selectCurrentLegacyRoute(v8)
		local v10 = v9[#v9]

		p1:BroadcastNotification(v10.name, NotificationType.APP_READY)
	end
end
