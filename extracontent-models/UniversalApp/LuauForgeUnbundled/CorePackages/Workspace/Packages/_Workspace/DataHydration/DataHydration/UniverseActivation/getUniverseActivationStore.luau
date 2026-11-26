local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createUniverseActivationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseActivation/createUniverseActivationStore")

return Signals.createComputed(function()
	return createUniverseActivationStore()
end)
