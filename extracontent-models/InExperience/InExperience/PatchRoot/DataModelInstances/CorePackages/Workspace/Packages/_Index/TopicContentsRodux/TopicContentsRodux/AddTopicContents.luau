local parent = script:FindFirstAncestor("TopicContentsRodux").Parent
local Rodux = require(parent.Rodux)
local makeActionCreator = Rodux.makeActionCreator
require(parent.DiscoveryTypes)

return makeActionCreator(script.Name, function(topicKey: string, topicContents, isAppend: boolean?)
	return { topicKey = topicKey, topicContents = topicContents, isAppend = isAppend }
end)
