local Parent = script:FindFirstAncestor("GameFilters").Parent
local makeActionCreator = require(Parent.Rodux).makeActionCreator

require(Parent.DiscoveryTypes)

return makeActionCreator(script.Name, function(s1: string, t1: {[any]: any}, n1: number) -- line: 9
	return {
		groupId = s1,
		filters = t1,
		updatedTimestamp = n1
	}
end)
