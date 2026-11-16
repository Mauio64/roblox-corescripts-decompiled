local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createMomentsUserStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/createMomentsUserStore")

return Signals.createComputed(function(p2)
	return createMomentsUserStore()
end)
