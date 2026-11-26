local makeActionCreator = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Rodux").makeActionCreator
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/ArgCheck")

return makeActionCreator("SetBackNavigationDisabled", function(p2)
	return {
		disabled = ArgCheck.isType(p2, "boolean", "disabled")
	}
end)
