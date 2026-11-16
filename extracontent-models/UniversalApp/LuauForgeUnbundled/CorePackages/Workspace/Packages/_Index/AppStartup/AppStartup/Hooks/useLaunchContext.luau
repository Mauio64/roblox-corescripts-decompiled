local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/RoactUtils")
require("@game/CorePackages/Workspace/Packages/_Index/AppStartup/AppStartup/Enums")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

return function()
	return useSelector(function(p2)
		return p2.LaunchContext
	end)
end
