local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createMomentsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/createMomentsStore")

return Signals.createComputed(function(p2)
	return createMomentsStore()
end)
