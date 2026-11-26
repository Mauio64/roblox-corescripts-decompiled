local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createMomentsTrendingStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/createMomentsTrendingStore")

return Signals.createComputed(function(p2)
	return createMomentsTrendingStore()
end)
