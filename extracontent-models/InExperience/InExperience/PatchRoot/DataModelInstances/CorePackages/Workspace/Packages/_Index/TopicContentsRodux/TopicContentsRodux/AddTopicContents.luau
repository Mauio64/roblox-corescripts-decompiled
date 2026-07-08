local Parent = script:FindFirstAncestor("TopicContentsRodux").Parent
local makeActionCreator = require(Parent.Rodux).makeActionCreator

require(Parent.DiscoveryTypes)

return makeActionCreator(script.Name, function(s1: string, p1, b1: boolean?) -- line: 8
	return {
		topicKey = s1,
		topicContents = p1,
		isAppend = b1
	}
end)
