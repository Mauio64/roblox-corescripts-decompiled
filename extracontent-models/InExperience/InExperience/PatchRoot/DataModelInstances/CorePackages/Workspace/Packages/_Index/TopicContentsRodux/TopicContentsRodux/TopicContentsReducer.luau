local TopicContentsRodux = script:FindFirstAncestor("TopicContentsRodux")
local TopicContentsModel = require(TopicContentsRodux.TopicContentsModel)
local AddTopicContents = require(TopicContentsRodux.AddTopicContents)
local TopicContentsRoduxParent = TopicContentsRodux.Parent
local Cryo = require(TopicContentsRoduxParent.Cryo)
local AddTopicInfos = require(TopicContentsRoduxParent.TopicInfosRodux).AddTopicInfos

require(TopicContentsRoduxParent.DiscoveryTypes)

return {
	key = "TopicContentsKey",
	reducer = function(p1, p2) -- line: 12
		-- upvalues: AddTopicInfos (copy), TopicContentsModel (copy), Cryo (copy), AddTopicContents (copy)
		local v9 = p1 or {}

		if p2.type == AddTopicInfos.name then
			local t1 = {}

			for _, v in pairs(p2.topicInfos) do
				t1[v.uniqueKey] = v9[v.uniqueKey] or TopicContentsModel.new()
			end

			return (Cryo.Dictionary.join(v9, t1))
		end

		if p2.type == AddTopicContents.name then
			local topicContents = p2.topicContents
			local v14 = v9[p2.topicKey]

			if v14 ~= nil then
				if p2.isAppend then
					topicContents.entries = Cryo.List.join(v14.entries, topicContents.entries)
				end

				if topicContents.updatedTimestamp == nil then
					topicContents.updatedTimestamp = v14.updatedTimestamp
				end
			end

			if topicContents.updatedTimestamp == nil then
				topicContents.updatedTimestamp = tick()
			end

			v9 = Cryo.Dictionary.join(v9, {
				[p2.topicKey] = topicContents
			})
		end

		return v9
	end
}
