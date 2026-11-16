local DiscoveryClientAppStorage = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryUtils/DiscoveryUtils/DiscoveryClientAppStorage")
local DiscoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryUtils/DiscoveryUtils/Telemetry/DiscoveryEventErrorLogger")

local defineFastString = game:DefineFastString(
	"LuaAppOmniRecommendationsTopicIdAndNumberOfItemsToCache",
	`{100000000}:20,{100000001}:20,{100000003}:20`
)

return {
	cacheOmniRecommendationsData = function(data)
		assert(data.pageType, "pageType is required")
		assert(data.sorts, "sorts is required")
		assert(data.contentMetadata, "contentMetadata is required")
		assert(data.contentMetadata.Game, "contentMetadata.Game is required")

		task.spawn(function()
			local success, result = pcall(function()
				local v5 = string.split(defineFastString, ",")
				local v6 = {}

				for k, v7 in v5 do
					local v8 = string.split(v7, ":")
					local v9 = tonumber(v8[1])
					local v10 = tonumber(v8[2])

					if v9 and v10 then
						v6[v9] = { cap = v10, count = 0 }
					end
				end

				local clones = {}

				for k, sort in data.sorts do
					local v7 = v6[sort.topicId]

					if not (v7 ~= nil and sort.recommendationList ~= nil) then
						continue
					end

					local clone = table.clone(sort)

					if v7.count >= v7.cap then
						continue
					end

					local recommendations = {}

					for k2, recommendation in sort.recommendationList do
						if v7.count >= v7.cap then
							break
						end

						table.insert(recommendations, recommendation)
						v7.count += 1
					end

					clone.recommendationList = recommendations

					table.insert(clones, clone)
				end

				local clonesByContentId = {}

				for i, v7 in ipairs(clones) do
					for j, recommendation in ipairs(v7.recommendationList) do
						if recommendation.contentType ~= "Game" then
							continue
						end

						local contentId = tostring(recommendation.contentId)
						local v8 = data.contentMetadata.Game[contentId]

						if not v8 then
							continue
						end

						local clone = table.clone(v8)
						clone.playerCount = nil

						clonesByContentId[contentId] = clone
					end
				end

				DiscoveryClientAppStorage.setJsonStorageData(DiscoveryClientAppStorage.CacheKey.HomeOmniFeedCache, {
					pageType = data.pageType,
					sorts = clones,
					contentMetadata = { Game = clonesByContentId }
				}, 2)
			end)

			if not success then
				DiscoveryEventErrorLogger.reportError("HomeOmniFeedCacheError", result)
			end
		end)
	end,
	getTopicIdToNumCacheItems = function()
		local v5 = string.split(defineFastString, ",")
		local topicIdToNumCacheItems = {}

		for k, v6 in v5 do
			local v7 = string.split(v6, ":")
			local v8 = tonumber(v7[1])
			local v9 = tonumber(v7[2])

			if v8 and v9 then
				topicIdToNumCacheItems[tostring(v8)] = { cap = v9, count = 0 }
			end
		end

		return topicIdToNumCacheItems
	end,
	HOME_OMNI_FEED_CACHE_VERSION = 2,
	cacheSduiHomePageData = function(p2)
		task.spawn(function()
			local success, result = pcall(function()
				DiscoveryClientAppStorage.setJsonStorageData(DiscoveryClientAppStorage.CacheKey.HomeOmniFeedCache, p2, 3)
			end)

			if not success then
				DiscoveryEventErrorLogger.reportError("HomeSduiFeedCacheError", result)
			end
		end)
	end,
	getCachedSduiHomePageData = function()
		local jsonStorageData = DiscoveryClientAppStorage.getJsonStorageData(DiscoveryClientAppStorage.CacheKey.HomeOmniFeedCache, 3)

		if type(jsonStorageData) == "string" then
			return jsonStorageData
		end

		return nil
	end,
	HOME_SDUI_FEED_CACHE_VERSION = 3
}
