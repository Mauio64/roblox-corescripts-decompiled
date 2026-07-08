local Parent = script:FindFirstAncestor("TopicInfosRodux").Parent
local makeActionCreator = require(Parent.Rodux).makeActionCreator

require(Parent.DiscoveryTypes)

return makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 12
	return {
		topicInfos = t1
	}
end)
