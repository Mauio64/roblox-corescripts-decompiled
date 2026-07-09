local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local NavigateToRoute = require(Modules.LuaApp.Thunks.NavigateToRoute)
local ApplyNavigateIntoAvatarExperience = require(Modules.AvatarExperience.Common.Actions.ApplyNavigateIntoAvatarExperience)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v7 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local t1 = {{
	name = AvatarScreen.AvatarExperienceRoot
}}

return function(p1, p2, p3) -- line: 20
	-- upvalues: ApplyNavigateIntoAvatarExperience (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), t1 (copy), NavigateToRoute (copy)
	return function(p4) -- line: 21
		-- upvalues: ApplyNavigateIntoAvatarExperience (copy), p1 (copy), p2 (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), t1 (copy), p3 (copy), NavigateToRoute (copy)
		p4:dispatch(ApplyNavigateIntoAvatarExperience(p1, p2))

		if FFlagSignalsNavP3Dispatch then
			v7.to(v7.fromLegacyPage(t1[#t1]), p3)

			return
		end

		p4:dispatch(NavigateToRoute(t1, p3))
	end
end
