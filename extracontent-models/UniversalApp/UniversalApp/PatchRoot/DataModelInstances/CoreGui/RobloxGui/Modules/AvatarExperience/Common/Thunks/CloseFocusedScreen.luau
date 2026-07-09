local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local isRootRouteInRN = require(Modules.LuaApp.Navigation.isRootRouteInRN)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v8 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

return function(p1) -- line: 23
	-- upvalues: NavigationUtils (copy), isRootRouteInRN (copy), FFlagSignalsNavP3Dispatch (copy), v8 (copy), NavigateBack (copy), RoactNavigation (copy)
	return function(p2) -- line: 24
		-- upvalues: NavigationUtils (copy), p1 (copy), isRootRouteInRN (copy), FFlagSignalsNavP3Dispatch (copy), v8 (copy), NavigateBack (copy), RoactNavigation (copy)
		local v11 = NavigationUtils.getRootNavigation(p1)

		if isRootRouteInRN(v11.state) then
			if FFlagSignalsNavP3Dispatch then
				v8.back(false)

				return
			end

			p2:dispatch(NavigateBack(false))

			return
		end

		p1.dispatch(RoactNavigation.Actions.back(nil))
	end
end
