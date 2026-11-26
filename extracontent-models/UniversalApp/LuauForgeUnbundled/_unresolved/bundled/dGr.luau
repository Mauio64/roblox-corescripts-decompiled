local module = require("@luauforge/bundled/dGs")
require("@luauforge/bundled/dFH")

local StackRouter = require("@game/CorePackages/Packages/_Index/RoactNavigation/RoactNavigation/routers/StackRouter")
local module3 = require("@luauforge/bundled/dGx")

return function(p2, options)
	local v5 = StackRouter(p2, (module.Dictionary.join(options or {}, {
		getCustomActionCreators = function(p3, p4)
			return { clearAppScreens = module3.clearAppScreens }
		end
	})))

	local getStateForAction = v5.getStateForAction
	function v5.getStateForAction(p3, p4)
		if p3.type ~= module3.ClearAppScreensAction then
			return getStateForAction(p3, p4)
		end

		local set = module.List.toSet(p3.routeNames)
		local filtered = module.List.filter(p4.routes, function(p5): boolean
			return not set[p5.routeName]
		end)

		return (module.Dictionary.join(p4, {
			routes = filtered,
			index = #filtered
		}))
	end

	return v5
end
