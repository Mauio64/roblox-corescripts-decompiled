local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createMonetizationOptionsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MonetizationOptions/createMonetizationOptionsStore")

return Signals.createComputed(function()
	return createMonetizationOptionsStore()
end)
