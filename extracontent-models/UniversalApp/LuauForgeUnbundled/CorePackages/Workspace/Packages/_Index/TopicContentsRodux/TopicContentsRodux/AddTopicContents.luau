local makeActionCreator = require("@game/CorePackages/Workspace/Packages/_Workspace/TopicContentsRodux/Rodux").makeActionCreator
require("@game/CorePackages/Workspace/Packages/_Workspace/TopicContentsRodux/DiscoveryTypes")

return makeActionCreator("AddTopicContents", function(p2, p3, p4)
	return { topicKey = p2, topicContents = p3, isAppend = p4 }
end)
