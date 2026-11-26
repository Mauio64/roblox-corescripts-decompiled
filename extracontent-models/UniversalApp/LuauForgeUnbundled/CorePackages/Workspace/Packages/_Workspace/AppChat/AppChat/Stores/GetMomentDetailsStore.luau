local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local createMomentDetailsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetMomentDetailsStore/createMomentDetailsStore")

return Signals.createComputed(function(p2)
	return createMomentDetailsStore()
end)
