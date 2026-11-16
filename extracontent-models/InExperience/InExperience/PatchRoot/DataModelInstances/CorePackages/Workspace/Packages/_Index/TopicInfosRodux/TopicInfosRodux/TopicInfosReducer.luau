local TopicInfosRodux = script:FindFirstAncestor("TopicInfosRodux")
local AddTopicInfos = require(TopicInfosRodux.AddTopicInfos)

local parent = TopicInfosRodux.Parent
local Cryo = require(parent.Cryo)
require(parent.DiscoveryTypes)

return {
	key = "TopicInfosKey",
	reducer = function(options, p)
		local joined = options or {}
		assert(joined, "")

		if p.type ~= AddTopicInfos.name then
			return joined
		end

		local topicInfosByUniqueKey = {}

		for _, topicInfo in p.topicInfos do
			topicInfosByUniqueKey[topicInfo.uniqueKey] = topicInfo
		end

		joined = Cryo.Dictionary.join(joined, topicInfosByUniqueKey)

		return joined
	end
}
