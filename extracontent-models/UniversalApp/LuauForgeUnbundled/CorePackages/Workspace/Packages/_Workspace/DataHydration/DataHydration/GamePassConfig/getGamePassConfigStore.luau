local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createGamePassConfigStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePassConfig/createGamePassConfigStore")

return Signals.createComputed(function()
	return createGamePassConfigStore()
end)
