local DiscoveryUtils = script:FindFirstAncestor("DiscoveryUtils")
local DiscoveryClientAppStorage = require(DiscoveryUtils.DiscoveryClientAppStorage)
local DiscoveryEventErrorLogger = require(DiscoveryUtils.Telemetry.DiscoveryEventErrorLogger)
local v4 = game:DefineFastString("LuaAppOmniRecommendationsTopicIdAndNumberOfItemsToCache", `{ 100000000 }:20,{ 100000001 }:20,{ 100000003 }:20`)

return {
	HOME_OMNI_FEED_CACHE_VERSION = 2,
	cacheOmniRecommendationsData = function(p1) -- line: 20
		-- upvalues: v4 (copy), DiscoveryClientAppStorage (copy), DiscoveryEventErrorLogger (copy)
		assert(p1.pageType, "pageType is required")
		assert(p1.sorts, "sorts is required")
		assert(p1.contentMetadata, "contentMetadata is required")
		assert(p1.contentMetadata.Game, "contentMetadata.Game is required")
		task.spawn(function() -- line: 26
			-- upvalues: v4 (copy), p1 (copy), DiscoveryClientAppStorage (copy), DiscoveryEventErrorLogger (copy)
			local ok, result = pcall(function() -- line: 27
				-- upvalues: v4 (copy), p1 (copy), DiscoveryClientAppStorage (copy)
				local t1 = {}

				for _, v10 in (string.split(v4, ",")) do
					local parts = string.split(v10, ":")
					local num = tonumber(parts[1])
					local num2 = tonumber(parts[2])

					if num and num2 then
						t1[num] = {
							count = 0,
							cap = num2
						}
					end
				end

				local t2 = {}

				for _, v16 in p1.sorts do
					local v17 = t1[v16.topicId]

					if v17 ~= nil and v16.recommendationList ~= nil then
						local v18 = table.clone(v16)

						if not (v17.count >= v17.cap) then
							local t3 = {}

							for _, v21 in v16.recommendationList do
								if v17.count >= v17.cap then
									break
								end

								table.insert(t3, v21)
								v17.count = v17.count + 1
							end

							v18.recommendationList = t3
							table.insert(t2, v18)
						end
					end
				end

				local t4 = {}

				for _, v in ipairs(t2) do
					for _, v2 in ipairs(v.recommendationList) do
						if v2.contentType == "Game" then
							local str = tostring(v2.contentId)
							local v28 = p1.contentMetadata.Game[str]

							if v28 then
								local v29 = table.clone(v28)

								v29.playerCount = nil
								t4[str] = v29
							end
						end
					end
				end

				DiscoveryClientAppStorage.setJsonStorageData(DiscoveryClientAppStorage.CacheKey.HomeOmniFeedCache, {
					pageType = p1.pageType,
					sorts = t2,
					contentMetadata = {
						Game = t4
					}
				}, 2)
			end)

			if not ok then
				DiscoveryEventErrorLogger.reportError("HomeOmniFeedCacheError", result)
			end
		end)
	end
}
