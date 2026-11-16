local CorePackages = game:GetService("CorePackages")
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)

local function getUpdatedNavigation(p2)
	local dangerouslyGetParent = p2._dangerouslyGetParent()
	return dangerouslyGetParent
		and p2.state
		and p2.state.key
		and dangerouslyGetParent.getChildNavigation(p2.state.key)
		or p2
end

return function(p2)
	local dangerouslyGetParent = p2._dangerouslyGetParent()
	p2 = dangerouslyGetParent
		and p2.state
		and p2.state.key
		and dangerouslyGetParent.getChildNavigation(p2.state.key)
		or p2

	return RoactNavigation.getActiveChildNavigationOptions(p2)
end
