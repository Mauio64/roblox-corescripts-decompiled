local parent = script:FindFirstAncestor("GameFilters").Parent
local Rodux = require(parent.Rodux)
local makeActionCreator = Rodux.makeActionCreator
require(parent.DiscoveryTypes)

return makeActionCreator(script.Name, function(groupId: string, filters, updatedTimestamp: number)
	return { groupId = groupId, filters = filters, updatedTimestamp = updatedTimestamp }
end)
