local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createPlaceVersionHistoryStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/PlaceVersionHistory/createPlaceVersionHistoryStore")

return Signals.createComputed(function()
	return createPlaceVersionHistoryStore()
end)
