local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local NavigationRoduxParent = NavigationRodux.Parent
local ApplySetNavigationLocked = require(NavigationRodux.Actions.ApplySetNavigationLocked)
local ArgCheck = require(NavigationRoduxParent.ArgCheck)

return function(p1) -- line: 7
	-- upvalues: ArgCheck (copy), ApplySetNavigationLocked (copy)
	ArgCheck.isType(p1, "boolean", "locked")

	return function(p2) -- line: 10
		-- upvalues: ApplySetNavigationLocked (copy), p1 (copy)
		p2:dispatch(ApplySetNavigationLocked(p1))
	end
end
