local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/Signals")
local createHomePageAutoRefreshStore = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/createHomePageAutoRefreshStore")

return Signals.createComputed(function()
	return createHomePageAutoRefreshStore()
end)
