local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createMomentsCommentsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/createMomentsCommentsStore")

return Signals.createComputed(function(p2)
	return createMomentsCommentsStore()
end)
