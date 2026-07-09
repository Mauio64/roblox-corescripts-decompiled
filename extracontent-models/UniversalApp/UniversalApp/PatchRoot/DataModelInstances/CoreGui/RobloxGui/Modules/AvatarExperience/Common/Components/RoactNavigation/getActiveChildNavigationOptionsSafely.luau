local CorePackages = game:GetService("CorePackages")
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)

local function getUpdatedNavigation(p1) -- line: 13
	local v5 = p1._dangerouslyGetParent()

	return v5 and (not not p1.state and (not not p1.state.key and v5.getChildNavigation(p1.state.key))) or p1
end

return function(p2) -- line: 28
	-- upvalues: RoactNavigation (copy)
	local v7 = p2._dangerouslyGetParent()
	local v8 = v7 and (not not p2.state and (not not p2.state.key and v7.getChildNavigation(p2.state.key))) or p2

	return RoactNavigation.getActiveChildNavigationOptions(v8)
end
