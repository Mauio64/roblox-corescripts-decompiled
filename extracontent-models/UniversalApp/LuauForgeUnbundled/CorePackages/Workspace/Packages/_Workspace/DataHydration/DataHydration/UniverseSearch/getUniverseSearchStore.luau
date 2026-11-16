local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createUniverseSearchStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseSearch/createUniverseSearchStore")

return Signals.createComputed(function()
	return createUniverseSearchStore()
end)
