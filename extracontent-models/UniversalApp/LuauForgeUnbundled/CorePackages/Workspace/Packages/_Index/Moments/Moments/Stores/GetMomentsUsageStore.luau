local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local createMomentsUsageStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsUsageStore/createMomentsUsageStore")

return Signals.createComputed(function(p2)
	return createMomentsUsageStore()
end)
