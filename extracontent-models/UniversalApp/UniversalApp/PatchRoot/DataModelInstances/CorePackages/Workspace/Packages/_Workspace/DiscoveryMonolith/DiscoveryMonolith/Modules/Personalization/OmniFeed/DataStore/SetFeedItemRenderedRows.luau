local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local makeActionCreator = require(Parent.Rodux).makeActionCreator

require(Parent.DiscoveryTypes)

return makeActionCreator(script.Name, function(s1: string, s2: string?, n1: number, p1, n2: number?) -- line: 8
	return {
		appPage = s1,
		secondaryKey = s2,
		feedItemPosition = n1,
		feedItem = p1,
		actualNumberOfRows = n2
	}
end)
