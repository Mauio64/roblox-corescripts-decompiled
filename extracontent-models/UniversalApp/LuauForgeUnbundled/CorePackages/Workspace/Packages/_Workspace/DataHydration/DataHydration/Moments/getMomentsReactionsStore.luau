local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createMomentsReactionsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/createMomentsReactionsStore")

return Signals.createComputed(function(p2)
	return createMomentsReactionsStore()
end)
