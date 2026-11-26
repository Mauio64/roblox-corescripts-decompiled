local TopicContentsModel = require("@game/CorePackages/Workspace/Packages/_Index/TopicContentsRodux/TopicContentsRodux/TopicContentsModel")
local AddTopicContents = require("@game/CorePackages/Workspace/Packages/_Index/TopicContentsRodux/TopicContentsRodux/AddTopicContents")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/TopicContentsRodux/Cryo")
local addTopicInfos = require("@game/CorePackages/Workspace/Packages/_Workspace/TopicContentsRodux/TopicInfosRodux").AddTopicInfos
require("@game/CorePackages/Workspace/Packages/_Workspace/TopicContentsRodux/DiscoveryTypes")

return {
	key = "TopicContentsKey",
	reducer = function(options, data)
		local v5 = options or {}

		if data.type == addTopicInfos.name then
			local v6 = {}

			for k, topicInfo in pairs(data.topicInfos) do
				v6[topicInfo.uniqueKey] = v5[topicInfo.uniqueKey] or TopicContentsModel.new()
			end

			return (Cryo.Dictionary.join(v5, v6))
		else
			if data.type ~= AddTopicContents.name then
				return v5
			end

			local topicContents = data.topicContents
			local v6 = v5[data.topicKey]

			if v6 ~= nil then
				if data.isAppend then
					topicContents.entries = Cryo.List.join(v6.entries, topicContents.entries)
				end

				if topicContents.updatedTimestamp == nil then
					topicContents.updatedTimestamp = v6.updatedTimestamp
				end
			end

			if topicContents.updatedTimestamp == nil then
				topicContents.updatedTimestamp = tick()
			end

			v5 = Cryo.Dictionary.join(v5, { [data.topicKey] = topicContents })

			return v5
		end
	end
}
