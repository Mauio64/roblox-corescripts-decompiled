local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createGamePermissionsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePermissions/createGamePermissionsStore")

return Signals.createComputed(function()
	return createGamePermissionsStore()
end)
