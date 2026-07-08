local TopicInfosRodux = script:FindFirstAncestor("TopicInfosRodux")
local AddTopicInfos = require(TopicInfosRodux.AddTopicInfos)
local TopicInfosRoduxParent = TopicInfosRodux.Parent
local Cryo = require(TopicInfosRoduxParent.Cryo)

require(TopicInfosRoduxParent.DiscoveryTypes)

return {
	key = "TopicInfosKey",
	reducer = function(t1: {[any]: any}?, p1) -- line: 14
		-- upvalues: AddTopicInfos (copy), Cryo (copy)
		local v7 = t1 or {}

		assert(v7, "")

		if p1.type == AddTopicInfos.name then
			local t2 = {}

			for _, v10 in p1.topicInfos do
				t2[v10.uniqueKey] = v10
			end

			v7 = Cryo.Dictionary.join(v7, t2)
		end

		return v7
	end
}
