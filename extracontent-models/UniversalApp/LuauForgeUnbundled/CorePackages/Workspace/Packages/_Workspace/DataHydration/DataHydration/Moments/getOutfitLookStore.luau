local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createOutfitLookStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/createOutfitLookStore")

return Signals.createComputed(function(p2)
	return createOutfitLookStore()
end)
