local CorePackages = game:GetService("CorePackages")

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local stackRouter = RoactNavigation.StackRouter
local Cryo = require(CorePackages.Packages.Cryo)

local avatarExperienceActions = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Actions.AvatarExperienceActions

local defineFastFlag = game:DefineFastFlag("AXFixClearScreensEmptyStack", false)

return function(p2, options)
	local v5 = stackRouter(p2, (Cryo.Dictionary.join(options or {}, {
		getCustomActionCreators = function(p3, p4)
			return { clearScreens = avatarExperienceActions.clearScreens }
		end
	})))

	local getStateForAction = v5.getStateForAction
	function v5.getStateForAction(p3, p4)
		if p3.type ~= avatarExperienceActions.ClearScreens then
			return getStateForAction(p3, p4)
		end

		local set = Cryo.List.toSet(p3.routeNames)
		local filtered = Cryo.List.filter(p4.routes, function(p5): boolean
			return not set[p5.routeName]
		end)

		if defineFastFlag and #filtered == 0 then
			return p4
		end

		return (Cryo.Dictionary.join(p4, {
			routes = filtered,
			index = #filtered
		}))
	end

	return v5
end
