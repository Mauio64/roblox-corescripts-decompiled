local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Cryo = require(DiscoveryMonolithParent.Cryo)

require(DiscoveryMonolithParent.DiscoveryTypes)

local TopicContentsRodux = require(DiscoveryMonolithParent.TopicContentsRodux)
local TopicContentsModel = TopicContentsRodux.TopicContentsModel
local AddTopicContents = TopicContentsRodux.AddTopicContents
local Modules = DiscoveryMonolith.Modules
local OmniUtils = require(Modules.LuaApp.Util.Omni.OmniUtils)

local function getContentStoreFunc(p1) -- line: 12
	-- upvalues: OmniUtils (copy)
	return function(p2) -- line: 13
		-- upvalues: p1 (copy), OmniUtils (copy)
		local v21 = p1:getState()

		return OmniUtils.storeForContentType(v21, p2)
	end
end
local function generateFullContentEntryFunc() -- line: 19
	-- upvalues: Cryo (copy)
	return function(p3, p4) -- line: 20
		-- upvalues: Cryo (copy)
		local v24 = p4[p3.contentId]

		if v24 ~= nil then
			return (Cryo.Dictionary.join(v24, p3))
		end

		return nil
	end
end
local function createTopicContentsModel(p5, p6, p7, n1: number?) -- line: 32
	-- upvalues: TopicContentsModel (copy)
	if p5 then
		return TopicContentsModel.fromContentList(p5, p6, p7, n1)
	end

	return nil
end

return function(p8, p9, n2: number?) -- line: 50
	-- upvalues: OmniUtils (copy), Cryo (copy), TopicContentsModel (copy), AddTopicContents (copy)
	return function(p10) -- line: 51
		-- upvalues: OmniUtils (copy), Cryo (copy), p8 (copy), p9 (copy), n2 (copy), TopicContentsModel (copy), AddTopicContents (copy)
		local v26 = p10:getState().OmniRecommendations[p8]
		local t1 = {}

		for _, v in ipairs(v26.sorts) do
			if v.topicId then
				local str = tostring(v.topicId)

				if p9 == nil or p9 == v.topicId then
					local recommendations = v.recommendations
					local v32 = n2
					local v33 = if not recommendations then nil else TopicContentsModel.fromContentList(recommendations, function(p11) -- line: 13
						-- upvalues: p10 (copy), OmniUtils (copy)
						local v35 = p10:getState()

						return OmniUtils.storeForContentType(v35, p11)
					end, function(p12, p13) -- line: 20
						-- upvalues: Cryo (copy)
						local v38 = p13[p12.contentId]

						if v38 ~= nil then
							return (Cryo.Dictionary.join(v38, p12))
						end

						return nil
					end, v32)

					if v33 then
						if t1[str] then
							p10:dispatch(AddTopicContents(str, v33, true))
						else
							p10:dispatch(AddTopicContents(str, v33))
							t1[str] = true
						end
					end
				end
			end
		end
	end
end
