local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
local createMomentsFollowingStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/createMomentsFollowingStore")

return Signals.createComputed(function(p2)
	return createMomentsFollowingStore()
end)
