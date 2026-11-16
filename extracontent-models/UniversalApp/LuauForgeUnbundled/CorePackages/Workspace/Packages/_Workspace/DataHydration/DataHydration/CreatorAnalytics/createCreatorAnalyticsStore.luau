local HttpService = game:GetService("HttpService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local FFlagBuildExperienceAnalyticsBreakdowns = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/FFlagBuildExperienceAnalyticsBreakdowns")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local fetchResourceMetric = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/fetchResourceMetric")
local fetchMetricMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/fetchMetricMetadata")
local CreatorAnalyticsStoreTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/CreatorAnalyticsStoreTypes")

local function encodeFilters(filters)
	local sorted = Cryo.List.sort(filters, function(p2, p3): boolean
		if p2.dimension == p3.dimension then
			return p2.operation < p3.operation
		end

		return p2.dimension < p3.dimension
	end)

	local result = {}

	for k, v5 in sorted do
		table.insert(result, { v5.dimension, Cryo.List.sort(v5.values), v5.operation })
	end

	return result
end

local function decodeFilters(items)
	local result = {}

	for k, item in items do
		table.insert(result, {
			dimension = item[1],
			values = item[2],
			operation = item[3]
		})
	end

	return result
end

local function encodeBreakdowns(breakdowns)
	local result = {}

	for k, item in breakdowns do
		table.insert(result, { item.dimensions })
	end

	return result
end

local function decodeBreakdowns(items)
	local result = {}

	for k, item in items do
		table.insert(result, { dimensions = item[1] })
	end

	return result
end

local function paramsKey(data)
	return HttpService:JSONEncode({
		data.resourceType,
		data.resourceId,
		data.metric,
		data.granularity,
		data.lookbackSeconds,
		data.endTime,
		encodeFilters(data.filters or {}),
		encodeBreakdowns(data.breakdowns or {}),
		data.includeAdvancedFields,
		data.analyticsKey
	})
end

local function paramsFromKey(json)
	local jsonDecode = HttpService:JSONDecode(json)
	local v5 = {
		resourceType = jsonDecode[1],
		resourceId = jsonDecode[2],
		metric = jsonDecode[3],
		granularity = jsonDecode[4],
		lookbackSeconds = jsonDecode[5],
		endTime = jsonDecode[6],
		filters = 0,
		breakdowns = 0,
		includeAdvancedFields = 0,
		analyticsKey = 0
	}
	local v6 = if jsonDecode[7] then decodeFilters(jsonDecode[7]) else nil
	v5.filters = v6
	local v7 = if jsonDecode[8] then decodeBreakdowns(jsonDecode[8]) else nil
	v5.breakdowns = v7
	v5.includeAdvancedFields = jsonDecode[9]
	v5.analyticsKey = jsonDecode[10]
	return v5
end

local function toCachedUniverseMetricParams(data)
	local cachedUniverseMetricParams = {
		resourceType = CreatorAnalyticsStoreTypes.ResourceType.Universe,
		resourceId = tostring(data.universeId),
		metric = data.metric,
		granularity = data.granularity,
		lookbackSeconds = data.lookbackSeconds,
		endTime = data.endTime,
		filters = 0,
		breakdowns = 0,
		includeAdvancedFields = 0,
		analyticsKey = "build-experience.experience-analytics-metric"
	}
	local v5 = if FFlagBuildExperienceAnalyticsBreakdowns then data.filters else nil
	cachedUniverseMetricParams.filters = v5
	local v6 = if FFlagBuildExperienceAnalyticsBreakdowns then data.breakdowns else nil
	cachedUniverseMetricParams.breakdowns = v6
	cachedUniverseMetricParams.includeAdvancedFields = FFlagBuildExperienceAnalyticsBreakdowns
	return cachedUniverseMetricParams
end

local function toCachedResourceMetricParams(data)
	return {
		resourceType = data.resourceType,
		resourceId = data.resourceId,
		metric = data.metric,
		granularity = data.granularity,
		lookbackSeconds = data.lookbackSeconds,
		endTime = data.endTime,
		filters = data.filters,
		breakdowns = data.breakdowns,
		includeAdvancedFields = true,
		analyticsKey = "data-hydration.resource-analytics-metric"
	}
end

local function metricsKey(p2)
	local clone = table.clone(p2)
	table.sort(clone)
	return HttpService:JSONEncode(clone)
end

local function createCreatorAnalyticsStore(options)
	local v5 = options or {}

	local v6 = {}
	local function trackPoll(object)
		v6[object] = true
		object:finally(function()
			v6[object] = nil
		end)
		return object
	end

	local v8 = createDataResolver({
		cache = createDataCache(v5.seriesTtlSeconds or 86400, v5.failedTtlSeconds),
		supportsMultiGet = false,
		fetchFn = function(p2, p3)
			local v9 = paramsFromKey(p2)
			local fn = fetchResourceMetric(v9, {
				network = v5.network,
				baseUrl = v5.baseUrl,
				delay = v5.delay,
				includeAdvancedFields = v9.includeAdvancedFields,
				analyticsKey = v9.analyticsKey
			})
			v6[fn] = true
			fn:finally(function()
				v6[fn] = nil
			end)
			return fn
		end
	})

	local function getAndFetchResourceMetric(p2)
		return (v8.getAndFetchItem(paramsKey(toCachedResourceMetricParams(p2))))
	end

	local function getAndFetchMetric(p2)
		return (v8.getAndFetchItem(paramsKey(toCachedUniverseMetricParams(p2))))
	end

	local function refetchResourceMetric(p2)
		v8.fetchItem(paramsKey(toCachedResourceMetricParams(p2)))
	end

	local function refetchMetric(p2)
		v8.fetchItem(paramsKey(toCachedUniverseMetricParams(p2)))
	end

	local v10 = createDataResolver({
		cache = createDataCache(v5.metadataTtlSeconds or 600, v5.failedTtlSeconds),
		supportsMultiGet = false,
		fetchFn = function(json, p2)
			local fn = fetchMetricMetadata(HttpService:JSONDecode(json), {
				network = v5.network,
				baseUrl = v5.baseUrl,
				delay = v5.delay
			})
			v6[fn] = true
			fn:finally(function()
				v6[fn] = nil
			end)
			return fn
		end
	})

	local function getAndFetchMetricMetadata(p2)
		return (v10.getAndFetchItem(metricsKey(p2)))
	end

	local function dispose()
		local v11 = {}

		for k in v6 do
			table.insert(v11, k)
		end

		v6 = {}

		for k, v12 in v11 do
			v12:cancel()
		end

		v8.dispose()
		v10.dispose()
	end

	return {
		getAndFetchResourceMetric = getAndFetchResourceMetric,
		refetchResourceMetric = refetchResourceMetric,
		getAndFetchMetric = getAndFetchMetric,
		refetchMetric = refetchMetric,
		getAndFetchMetricMetadata = getAndFetchMetricMetadata,
		dispose = dispose
	}
end

return createCreatorAnalyticsStore
