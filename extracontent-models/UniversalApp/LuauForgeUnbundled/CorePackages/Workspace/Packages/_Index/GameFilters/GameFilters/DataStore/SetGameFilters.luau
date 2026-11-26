local makeActionCreator = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/Rodux").makeActionCreator
require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/DiscoveryTypes")

return makeActionCreator("SetGameFilters", function(p2, p3, p4)
	return { groupId = p2, filters = p3, updatedTimestamp = p4 }
end)
