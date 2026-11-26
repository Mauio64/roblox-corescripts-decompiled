local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createMomentsShareLinkStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/createMomentsShareLinkStore")

return Signals.createComputed(function(p2)
	return createMomentsShareLinkStore()
end)
