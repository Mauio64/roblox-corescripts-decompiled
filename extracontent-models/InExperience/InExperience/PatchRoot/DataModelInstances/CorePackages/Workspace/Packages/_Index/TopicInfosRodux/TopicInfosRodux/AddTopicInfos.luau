local parent = script:FindFirstAncestor("TopicInfosRodux").Parent
local Rodux = require(parent.Rodux)
local makeActionCreator = Rodux.makeActionCreator
require(parent.DiscoveryTypes)

return makeActionCreator(script.Name, function(topicInfos)
	return { topicInfos = topicInfos }
end)
