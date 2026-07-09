local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local makeActionCreator = require(Parent.Rodux).makeActionCreator

require(Parent.DiscoveryTypes)

return makeActionCreator(script.Name, function(s1: string, t1: {[any]: any}, b1: boolean, p1) -- line: 8
	return {
		appPage = s1,
		topicInfos = t1,
		isAppend = b1,
		omniFeedPageSection = p1
	}
end)
