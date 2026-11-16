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

local defineFastInt = game:DefineFastInt("ProfileInsightsStoreProcessDelaySec", 0)

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

return createProfileInsightsStore
