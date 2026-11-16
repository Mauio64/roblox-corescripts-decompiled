local TopicContentsRodux = script:FindFirstAncestor("TopicContentsRodux")
local TopicContentsModel = require(TopicContentsRodux.TopicContentsModel)
local AddTopicContents = require(TopicContentsRodux.AddTopicContents)

local parent = TopicContentsRodux.Parent
local Cryo = require(parent.Cryo)
local TopicInfosRodux = require(parent.TopicInfosRodux)
local AddTopicInfos = TopicInfosRodux.AddTopicInfos
require(parent.DiscoveryTypes)

return {
	key = "TopicContentsKey",
	reducer = function(options, data)
		local v = options or {}

		if data.type == AddTopicInfos.name then
			local v2 = {}

			for _, topicInfo in pairs(data.topicInfos) do
				v2[topicInfo.uniqueKey] = v[topicInfo.uniqueKey] or TopicContentsModel.new()
			end

			return (Cryo.Dictionary.join(v, v2))
		else
			if data.type ~= AddTopicContents.name then
				return v
			end

			local topicContents = data.topicContents
			local v2 = v[data.topicKey]

			if v2 ~= nil then
				if data.isAppend then
					topicContents.entries = Cryo.List.join(v2.entries, topicContents.entries)
				end

				if topicContents.updatedTimestamp == nil then
					topicContents.updatedTimestamp = v2.updatedTimestamp
				end
			end

			if topicContents.updatedTimestamp == nil then
				topicContents.updatedTimestamp = tick()
			end

			return (Cryo.Dictionary.join(v, { [data.topicKey] = topicContents }))
		end
	end
}
