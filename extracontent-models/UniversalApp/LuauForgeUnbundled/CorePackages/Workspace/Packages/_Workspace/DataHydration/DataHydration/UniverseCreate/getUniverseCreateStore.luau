local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createUniverseCreateStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseCreate/createUniverseCreateStore")

return Signals.createComputed(function()
	return createUniverseCreateStore()
end)
