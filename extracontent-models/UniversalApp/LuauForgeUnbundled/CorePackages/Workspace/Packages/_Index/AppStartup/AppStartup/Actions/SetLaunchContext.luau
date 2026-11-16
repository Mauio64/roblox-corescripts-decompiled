local makeActionCreator = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/Rodux").makeActionCreator
require("@game/CorePackages/Workspace/Packages/_Index/AppStartup/AppStartup/Enums")

return makeActionCreator("SetLaunchContext", function(p2)
	return { launchContext = p2 }
end)
