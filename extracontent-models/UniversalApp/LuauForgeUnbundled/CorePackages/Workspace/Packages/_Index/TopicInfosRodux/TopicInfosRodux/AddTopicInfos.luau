local makeActionCreator = require("@game/CorePackages/Workspace/Packages/_Workspace/TopicInfosRodux/Rodux").makeActionCreator
require("@game/CorePackages/Workspace/Packages/_Workspace/TopicInfosRodux/DiscoveryTypes")

return makeActionCreator("AddTopicInfos", function(p2)
	return { topicInfos = p2 }
end)
