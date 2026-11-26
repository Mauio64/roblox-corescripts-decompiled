local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createDeveloperProductStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DeveloperProduct/createDeveloperProductStore")

return Signals.createComputed(function()
	return createDeveloperProductStore()
end)
