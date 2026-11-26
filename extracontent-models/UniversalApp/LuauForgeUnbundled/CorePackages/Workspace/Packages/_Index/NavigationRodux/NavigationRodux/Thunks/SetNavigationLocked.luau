local ApplySetNavigationLocked = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/Actions/ApplySetNavigationLocked")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/ArgCheck")

return function(p2)
	ArgCheck.isType(p2, "boolean", "locked")

	return function(object)
		object:dispatch(ApplySetNavigationLocked(p2))
	end
end
