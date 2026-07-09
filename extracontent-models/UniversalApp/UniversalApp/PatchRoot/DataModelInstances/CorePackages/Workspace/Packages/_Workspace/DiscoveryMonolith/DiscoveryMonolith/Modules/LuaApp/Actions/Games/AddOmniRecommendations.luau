local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local makeActionCreator = require(Parent.Rodux).makeActionCreator

require(Parent.DiscoveryTypes)

return makeActionCreator(script.Name, function(p1, b1: boolean?) -- line: 9
	return {
		recommendations = {
			[p1.pageType] = p1
		},
		isAppend = b1
	}
end)
