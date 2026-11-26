local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createPlaceDetailsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/PlaceDetails/createPlaceDetailsStore")

return Signals.createComputed(function()
	return createPlaceDetailsStore()
end)
