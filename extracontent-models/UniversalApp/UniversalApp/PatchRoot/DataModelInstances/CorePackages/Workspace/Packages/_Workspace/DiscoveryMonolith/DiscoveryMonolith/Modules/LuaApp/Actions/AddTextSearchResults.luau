local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local makeActionCreator = require(DiscoveryMonolithParent.Rodux).makeActionCreator

require(DiscoveryMonolith.Modules.LuaApp.Models.DiscoveryApi.TextSearchEntry)

return makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 12
	return {
		searchUuid = t1.searchUuid,
		topicId = t1.topicId,
		entry = t1.entry
	}
end)
