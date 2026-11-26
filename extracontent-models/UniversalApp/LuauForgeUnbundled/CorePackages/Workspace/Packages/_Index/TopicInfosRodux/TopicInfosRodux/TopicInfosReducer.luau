local AddTopicInfos = require("@game/CorePackages/Workspace/Packages/_Index/TopicInfosRodux/TopicInfosRodux/AddTopicInfos")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/TopicInfosRodux/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/TopicInfosRodux/DiscoveryTypes")

return {
	key = "TopicInfosKey",
	reducer = function(options, p2)
		local joined = options or {}
		assert(joined, "")

		if p2.type ~= AddTopicInfos.name then
			return joined
		end

		local topicInfosByUniqueKey = {}

		for k, topicInfo in p2.topicInfos do
			topicInfosByUniqueKey[topicInfo.uniqueKey] = topicInfo
		end

		joined = Cryo.Dictionary.join(joined, topicInfosByUniqueKey)

		return joined
	end
}
