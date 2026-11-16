local module = require("@luauforge/bundled/dqd")
local module2 = require("@luauforge/bundled/dqp")
local omniRecommendationsContentType = require("@luauforge/bundled/dqn").OmniRecommendationsContentType
local toLegacyGameInfoModel = require("@luauforge/bundled/dqm").toLegacyGameInfoModel
local module3 = require("@luauforge/bundled/dqs")
local topicContentsModel = module3.TopicContentsModel
local addTopicContents = module3.AddTopicContents
local oneByTwoTileTelemetry = require("@luauforge/bundled/drw").OneByTwoTileTelemetry

local module4 = require("@luauforge/bundled/drx")

local module5 = require("@luauforge/bundled/dqB")
local fFlagMigrateGameInfoToStore = module5.FFlagMigrateGameInfoToStore
local fFlagLuaAppEnableOneByTwoTileFunnelTelemetry = module5.FFlagLuaAppEnableOneByTwoTileFunnelTelemetry

local function getContentStoreFunc(object)
	return function(p2)
		local state = object:getState()
		return module4.storeForContentType(state, p2)
	end
end

local function generateFullContentEntryFunc()
	return function(p2, p3)
		local v5 = p3[p2.contentId]

		if v5 == nil then
			return nil
		end

		return (module.Dictionary.join(v5, p2))
	end
end

local function generateMigratedFullContentEntryFunc()
	return function(p2, p3)
		local contentId = p2.contentId
		local v5 = p3[contentId]

		if v5 ~= nil and p2.contentType == omniRecommendationsContentType.Game then
			local data = module2.Game.getGameInfoStore(false).getGameInfo(contentId).data(false)

			if data and data.name ~= nil and not data.isUnavailable then
				return module.Dictionary.join(v5, toLegacyGameInfoModel(data), p2)
			end
		end

		if v5 == nil then
			return nil
		end

		return module.Dictionary.join(v5, p2)
	end
end

local function createTopicContentsModel(p2, p3, p4, p5, p6)
	if not p2 then
		return nil
	end

	local fromContentList = topicContentsModel.fromContentList

	if not fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
		p6 = nil
	end

	return fromContentList(p2, p3, p4, p5, p6)
end

return function(p2, p3, p4)
	return function(object)
		local state = object:getState()

		local function fn(p5)
			local state2 = object:getState()
			return module4.storeForContentType(state2, p5)
		end

		local fn2

		if fFlagMigrateGameInfoToStore then
			fn2 = function(p5, p6)
				local contentId = p5.contentId
				local v5 = p6[contentId]

				if v5 ~= nil and p5.contentType == omniRecommendationsContentType.Game then
					local data = module2.Game.getGameInfoStore(false).getGameInfo(contentId).data(false)

					if data and data.name ~= nil and not data.isUnavailable then
						return module.Dictionary.join(v5, toLegacyGameInfoModel(data), p5)
					end
				end

				if v5 == nil then
					return nil
				end

				return module.Dictionary.join(v5, p5)
			end
		else
			fn2 = function(p5, p6)
				local v5 = p6[p5.contentId]

				if v5 == nil then
					return nil
				end

				return (module.Dictionary.join(v5, p5))
			end
		end

		local omniRecommendation = state.OmniRecommendations[p2]
		local topicIdSet = {}

		for i, sort in ipairs(omniRecommendation.sorts) do
			if not sort.topicId then
				continue
			end

			local topicId = tostring(sort.topicId)

			if not (p3 == nil or p3 == sort.topicId) then
				continue
			end

			local recommendations = sort.recommendations

			local v5 = p4
			local recommendationsId

			if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
				recommendationsId = omniRecommendation.recommendationsId
			end

			local v6

			if recommendations then
				local fromContentList = topicContentsModel.fromContentList

				if not fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
					recommendationsId = nil
				end

				v6 = fromContentList(recommendations, fn, fn2, v5, recommendationsId)
			end

			if not v6 then
				continue
			end

			if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
				for k, entry in v6.entries do
					if entry.oneByTwoTileFlowId then
						oneByTwoTileTelemetry.logOneByTwoTileResponseReceived({
							oneByTwoTileFlowId = entry.oneByTwoTileFlowId,
							recommendationsRequestId = entry.recommendationsRequestId,
							topicId = topicId,
							contentType = entry.contentType,
							adId = entry.adId,
							componentType = "OneByTwoTile",
							alignmentType = entry.alignmentType,
							isSdui = false
						})
					end
				end
			end

			if topicIdSet[topicId] then
				object:dispatch(addTopicContents(topicId, v6, true))
			else
				object:dispatch(addTopicContents(topicId, v6))
				topicIdSet[topicId] = true
			end
		end
	end
end
