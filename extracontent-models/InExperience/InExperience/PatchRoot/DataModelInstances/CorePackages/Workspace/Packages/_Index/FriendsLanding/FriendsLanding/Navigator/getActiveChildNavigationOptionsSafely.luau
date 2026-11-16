local parent = script:FindFirstAncestor("FriendsLanding").Parent
local RoactNavigation = require(parent.RoactNavigation)

local function getUpdatedNavigation(p) -- 1 equivalent call inferred from this helper
	local dangerouslyGetParent = p._dangerouslyGetParent()
	return dangerouslyGetParent and p.state and p.state.key and dangerouslyGetParent.getChildNavigation(p.state.key)
		or p
end

return function(p)
	p = getUpdatedNavigation(p) -- inferred equivalent call
	return RoactNavigation.getActiveChildNavigationOptions(p)
end
