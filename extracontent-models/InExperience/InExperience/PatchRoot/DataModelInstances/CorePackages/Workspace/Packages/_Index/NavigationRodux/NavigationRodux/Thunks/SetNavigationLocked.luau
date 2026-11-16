local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local parent = NavigationRodux.Parent

local ApplySetNavigationLocked = require(NavigationRodux.Actions.ApplySetNavigationLocked)
local ArgCheck = require(parent.ArgCheck)

return function(p)
	ArgCheck.isType(p, "boolean", "locked")

	return function(object)
		object:dispatch(ApplySetNavigationLocked(p))
	end
end
