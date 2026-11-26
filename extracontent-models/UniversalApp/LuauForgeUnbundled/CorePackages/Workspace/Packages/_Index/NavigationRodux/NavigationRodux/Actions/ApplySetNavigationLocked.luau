local makeActionCreator = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/Rodux").makeActionCreator
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/ArgCheck")

return makeActionCreator("ApplySetNavigationLocked", function(p2)
	return {
		locked = ArgCheck.isType(p2, "boolean", "locked")
	}
end)
