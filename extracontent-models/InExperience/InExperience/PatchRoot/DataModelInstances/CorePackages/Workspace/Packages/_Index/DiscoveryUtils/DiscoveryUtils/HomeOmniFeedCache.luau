local DiscoveryUtils = script:FindFirstAncestor("DiscoveryUtils")
local DiscoveryClientAppStorage = require(DiscoveryUtils.DiscoveryClientAppStorage)
local DiscoveryEventErrorLogger = require(DiscoveryUtils.Telemetry.DiscoveryEventErrorLogger)

local defineFastString = game:DefineFastString(
	"LuaAppOmniRecommendationsTopicIdAndNumberOfItemsToCache",
	`{100000000}:20,{100000001}:20,{100000003}:20`
)
local HomeOmniFeedCache = {}

function HomeOmniFeedCache.cacheOmniRecommendationsData(data)
	assert(data.pageType, "pageType is required")
	assert(data.sorts, "sorts is required")
	assert(data.contentMetadata, "contentMetadata is required")
	assert(data.contentMetadata.Game, "contentMetadata.Game is required")

	task.spawn(function()
		local success, result = pcall(function()
			local v = string.split(defineFastString, ",")
			local v2 = {}

			for _, v3 in v do
				local v4 = string.split(v3, ":")
				local v5 = tonumber(v4[1])
				local cap = tonumber(v4[2])

				if v5 and cap then
					v2[v5] = { cap = cap, count = 0 }
				end
			end

			local clones = {}

			for _, sort in data.sorts do
				local v3 = v2[sort.topicId]

				if not (v3 ~= nil and sort.recommendationList ~= nil) then
					continue
				end

				local clone = table.clone(sort)

				if v3.count >= v3.cap then
					continue
				end

				local recommendations = {}

				for _, recommendation in sort.recommendationList do
					if v3.count >= v3.cap then
						break
					end

					table.insert(recommendations, recommendation)
					v3.count += 1
				end

				clone.recommendationList = recommendations

				table.insert(clones, clone)
			end

			local clonesByContentId = {}

			for _, v3 in ipairs(clones) do
				for _, recommendation in ipairs(v3.recommendationList) do
					if recommendation.contentType ~= "Game" then
						continue
					end

					local contentId = tostring(recommendation.contentId)
					local v4 = data.contentMetadata.Game[contentId]

					if not v4 then
						continue
					end

					local clone = table.clone(v4)
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
end

function HomeOmniFeedCache.getTopicIdToNumCacheItems()
	local v = string.split(defineFastString, ",")
	local topicIdToNumCacheItems = {}

	for _, v2 in v do
		local v3 = string.split(v2, ":")
		local v4 = tonumber(v3[1])
		local cap = tonumber(v3[2])

		if v4 and cap then
			topicIdToNumCacheItems[tostring(v4)] = { cap = cap, count = 0 }
		end
	end

	return topicIdToNumCacheItems
end

HomeOmniFeedCache.HOME_OMNI_FEED_CACHE_VERSION = 2

function HomeOmniFeedCache.cacheSduiHomePageData(p: string)
	task.spawn(function()
		local success, result = pcall(function()
			DiscoveryClientAppStorage.setJsonStorageData(DiscoveryClientAppStorage.CacheKey.HomeOmniFeedCache, p, 3)
		end)

		if not success then
			DiscoveryEventErrorLogger.reportError("HomeSduiFeedCacheError", result)
		end
	end)
end

function HomeOmniFeedCache.getCachedSduiHomePageData()
	local jsonStorageData = DiscoveryClientAppStorage.getJsonStorageData(
		DiscoveryClientAppStorage.CacheKey.HomeOmniFeedCache,
		3
	)

	if type(jsonStorageData) == "string" then
		return jsonStorageData
	end

	return nil
end

HomeOmniFeedCache.HOME_SDUI_FEED_CACHE_VERSION = 3
return HomeOmniFeedCache
