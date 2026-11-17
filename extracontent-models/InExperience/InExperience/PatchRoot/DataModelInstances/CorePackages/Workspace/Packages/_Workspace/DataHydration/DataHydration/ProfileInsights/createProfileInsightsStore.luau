local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Cryo = require(parent.Cryo)
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
local ProfileInsights = require(parent.ProfileInsights)
local ProfileInsightsModel = ProfileInsights.ProfileInsightsModel

local MultiGetProfileInsights = require(script.Parent.Requests.MultiGetProfileInsights)
require(script.Parent.ProfileInsightsStoreTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagProfileInsightsKeyByRankingStrategy = SharedFlags.FFlagProfileInsightsKeyByRankingStrategy

local defineFastInt = game:DefineFastInt("ProfileInsightsStoreProcessDelaySec", 0)

local function createInsightBucket()
	local pendingFetchOptions = {}
	return {
		resolver = createDataResolver({
			cache = createDataCache(),
			queueProcessDelaySec = defineFastInt,
			replaceItems = true,
			onClear = function()
				table.clear(pendingFetchOptions)
			end,
			fetchFn = function(p)
				local keys = Cryo.Dictionary.keys(p)
				local rankingStrategy = nil
				local count = nil

				for _, key in keys do
					local v = pendingFetchOptions[key]

					if not v then
						continue
					end

					if rankingStrategy == nil then
						rankingStrategy = v.rankingStrategy
					end

					if count == nil then
						count = v.count
					end

					pendingFetchOptions[key] = nil
				end

				return MultiGetProfileInsights({
					userIds = keys,
					count = count,
					rankingStrategy = rankingStrategy
				}):andThen(function(p2)
					local createProfileInsightsList = ProfileInsightsModel.createProfileInsightsList
					local v

					if p2 then
						v = p2.userInsights
					end

					local profileInsightsList = createProfileInsightsList(v)

					local result = {}

					for _, key in keys do
						result[key] = {
							targetUserId = key,
							isOfflineFrequents = false,
							mutualFriends = {}
						}
					end

					for _, profileInsight in profileInsightsList do
						if result[profileInsight.targetUserId] ~= nil then
							result[profileInsight.targetUserId] = profileInsight
						end
					end

					return result
				end)
			end
		}),
		pendingFetchOptions = pendingFetchOptions
	}
end

local function createProfileInsightsStoreKeyedByRankingStrategy()
	local buckets = {}

	local function getBucket(value: string?) -- 1 equivalent call inferred from this helper
		local v = value or ""
		local bucket = buckets[v]

		if bucket == nil then
			bucket = createInsightBucket()
			buckets[v] = bucket
		end

		return bucket
	end

	return {
		GetProfileInsight = function(p, data)
			local v

			if data then
				v = data.rankingStrategy
			end

			local bucket = getBucket(v) -- inferred equivalent call

			if data and data.skipFetch then
				return bucket.resolver.getCachedItem(p)
			end

			if data then
				bucket.pendingFetchOptions[p] = {
					rankingStrategy = data.rankingStrategy,
					count = data.count
				}
			end

			return bucket.resolver.getAndFetchItem(p)
		end,
		clear = function()
			for _, v in buckets do
				v.resolver.clear()
			end
		end,
		dispose = function()
			for _, v in buckets do
				v.resolver.dispose()
			end
		end
	}
end

local function createProfileInsightsStore()
	local dataCache = createDataCache()

	local v = {}

	local dataResolver = createDataResolver({
		cache = dataCache,
		queueProcessDelaySec = defineFastInt,
		fetchFn = function(p)
			local keys = Cryo.Dictionary.keys(p)
			local rankingStrategy = nil
			local count = nil

			for _, key in keys do
				local v2 = v[key]

				if not v2 then
					continue
				end

				if rankingStrategy == nil then
					rankingStrategy = v2.rankingStrategy
				end

				if count == nil then
					count = v2.count
				end

				v[key] = nil
			end

			return MultiGetProfileInsights({
				userIds = keys,
				count = count,
				rankingStrategy = rankingStrategy
			}):andThen(function(p2)
				local createProfileInsightsList = ProfileInsightsModel.createProfileInsightsList
				local v2

				if p2 then
					v2 = p2.userInsights
				end

				local profileInsightsList = createProfileInsightsList(v2)

				local result = {}

				for _, key in keys do
					result[key] = {
						targetUserId = key,
						isOfflineFrequents = false,
						mutualFriends = {}
					}
				end

				for _, profileInsight in profileInsightsList do
					if result[profileInsight.targetUserId] ~= nil then
						result[profileInsight.targetUserId] = profileInsight
					end
				end

				return result
			end)
		end
	})

	return {
		GetProfileInsight = function(p, data)
			if data and data.skipFetch then
				return dataResolver.getCachedItem(p)
			end

			if data then
				v[p] = { rankingStrategy = data.rankingStrategy, count = data.count }
			end

			return dataResolver.getAndFetchItem(p)
		end,
		clear = dataCache.clear,
		dispose = dataCache.dispose
	}
end

if FFlagProfileInsightsKeyByRankingStrategy then
	return createProfileInsightsStoreKeyedByRankingStrategy
end

return createProfileInsightsStore
