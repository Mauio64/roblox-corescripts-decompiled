local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createUniverseConfigurationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseConfiguration/createUniverseConfigurationStore")

return Signals.createComputed(function()
	return createUniverseConfigurationStore()
end)
