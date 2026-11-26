local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createCreatorGroupsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorGroups/createCreatorGroupsStore")

return Signals.createComputed(function()
	return createCreatorGroupsStore()
end)
