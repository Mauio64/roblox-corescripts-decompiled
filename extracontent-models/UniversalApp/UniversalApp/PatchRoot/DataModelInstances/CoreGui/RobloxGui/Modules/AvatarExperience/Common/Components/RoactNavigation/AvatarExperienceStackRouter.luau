local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local StackRouter = require(CorePackages.Packages.RoactNavigation).StackRouter
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceActions = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AvatarExperienceActions)

return function(p1, p2) -- line: 16
	-- upvalues: Cryo (copy), AvatarExperienceActions (copy), StackRouter (copy)
	local v8 = Cryo.Dictionary.join(p2 or {}, {
		getCustomActionCreators = function(_, _) -- line: 18
			-- upvalues: AvatarExperienceActions (copy)
			return {
				clearScreens = AvatarExperienceActions.clearScreens
			}
		end
	})
	local v9 = StackRouter(p1, v8)
	local getStateForAction = v9.getStateForAction

	function v9.getStateForAction(p5, p6) -- line: 28
		-- upvalues: AvatarExperienceActions (copy), Cryo (copy), getStateForAction (copy)
		if p5.type == AvatarExperienceActions.ClearScreens then
			local v15 = Cryo.List.toSet(p5.routeNames)
			local v16 = Cryo.List.filter(p6.routes, function(p7) -- line: 31
				-- upvalues: v15 (copy)
				return not v15[p7.routeName]
			end)

			return (Cryo.Dictionary.join(p6, {
				routes = v16,
				index = #v16
			}))
		end

		return getStateForAction(p5, p6)
	end

	return v9
end
