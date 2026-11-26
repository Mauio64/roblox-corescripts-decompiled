local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Cryo")
local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local profileInsightsModel = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/ProfileInsights").ProfileInsightsModel

local MultiGetProfileInsights = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ProfileInsights/Requests/MultiGetProfileInsights")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ProfileInsights/ProfileInsightsStoreTypes")

local fFlagProfileInsightsKeyByRankingStrategy = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagProfileInsightsKeyByRankingStrategy

local defineFastInt = game:DefineFastInt("ProfileInsightsStoreProcessDelaySec", 0)

local function createInsightBucket()
	local v6 = {}
	return {
		resolver = createDataResolver({
			cache = createDataCache(),
			queueProcessDelaySec = defineFastInt,
			replaceItems = true,
			onClear = function()
				table.clear(v6)
			end,
			fetchFn = function(p2)
				local keys = Cryo.Dictionary.keys(p2)
				local rankingStrategy = nil
				local count = nil

				for k, key in keys do
					local v7 = v6[key]

					if not v7 then
						continue
					end

					if rankingStrategy == nil then
						rankingStrategy = v7.rankingStrategy
					end

					if count == nil then
						count = v7.count
					end

					v6[key] = nil
				end

				return MultiGetProfileInsights({
					userIds = keys,
					count = count,
					rankingStrategy = rankingStrategy
				}):andThen(function(p3)
					local createProfileInsightsList = profileInsightsModel.createProfileInsightsList
					local v7 = if p3 then p3.userInsights else nil
					local profileInsightsList = createProfileInsightsList(v7)

					local result = {}

					for k, key in keys do
						result[key] = {
							targetUserId = key,
							isOfflineFrequents = false,
							mutualFriends = {}
						}
					end

					for k, profileInsight in profileInsightsList do
						if result[profileInsight.targetUserId] ~= nil then
							result[profileInsight.targetUserId] = profileInsight
						end
					end

					return result
				end)
			end
		}),
		pendingFetchOptions = v6
	}
end

local function createProfileInsightsStoreKeyedByRankingStrategy()
	local v5 = {}

	local function getBucket(value)
		local v6 = value or ""
		local bucket = v5[v6]

		if bucket == nil then
			bucket = createInsightBucket()
			v5[v6] = bucket
		end

		return bucket
	end

	return {
		GetProfileInsight = function(p2, data)
			local v7 = (if data then data.rankingStrategy else nil) or ""
			local v8 = v5[v7]

			if v8 == nil then
				v8 = createInsightBucket()
				v5[v7] = v8
			end

			if data and data.skipFetch then
				return v8.resolver.getCachedItem(p2)
			end

			if data then
				v8.pendingFetchOptions[p2] = {
					rankingStrategy = data.rankingStrategy,
					count = data.count
				}
			end

			return v8.resolver.getAndFetchItem(p2)
		end,
		clear = function()
			for k, v6 in v5 do
				v6.resolver.clear()
			end
		end,
		dispose = function()
			for k, v6 in v5 do
				v6.resolver.dispose()
			end
		end
	}
end

local function createProfileInsightsStore()
	local v5 = createDataCache()

	local v6 = {}

	local v7 = createDataResolver({
		cache = v5,
		queueProcessDelaySec = defineFastInt,
		fetchFn = function(p2)
			local keys = Cryo.Dictionary.keys(p2)
			local rankingStrategy = nil
			local count = nil

			for k, key in keys do
				local v8 = v6[key]

				if not v8 then
					continue
				end

				if rankingStrategy == nil then
					rankingStrategy = v8.rankingStrategy
				end

				if count == nil then
					count = v8.count
				end

				v6[key] = nil
			end

			return MultiGetProfileInsights({
				userIds = keys,
				count = count,
				rankingStrategy = rankingStrategy
			}):andThen(function(p3)
				local createProfileInsightsList = profileInsightsModel.createProfileInsightsList
				local v8 = if p3 then p3.userInsights else nil
				local profileInsightsList = createProfileInsightsList(v8)

				local result = {}

				for k, key in keys do
					result[key] = {
						targetUserId = key,
						isOfflineFrequents = false,
						mutualFriends = {}
					}
				end

				for k, profileInsight in profileInsightsList do
					if result[profileInsight.targetUserId] ~= nil then
						result[profileInsight.targetUserId] = profileInsight
					end
				end

				return result
			end)
		end
	})

	return {
		GetProfileInsight = function(p2, data)
			if data and data.skipFetch then
				return v7.getCachedItem(p2)
			end

			if data then
				v6[p2] = { rankingStrategy = data.rankingStrategy, count = data.count }
			end

			return v7.getAndFetchItem(p2)
		end,
		clear = v5.clear,
		dispose = v5.dispose
	}
end

if fFlagProfileInsightsKeyByRankingStrategy then
	return createProfileInsightsStoreKeyedByRankingStrategy
end

return createProfileInsightsStore
