local SetLaunchContext = require("@game/CorePackages/Workspace/Packages/_Index/AppStartup/AppStartup/Actions/SetLaunchContext")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/Rodux")
require("@game/CorePackages/Workspace/Packages/_Index/AppStartup/AppStartup/Enums")

return Rodux.createReducer(nil, {
	[SetLaunchContext.name] = function(p2, p3)
		return p3.launchContext
	end
})
