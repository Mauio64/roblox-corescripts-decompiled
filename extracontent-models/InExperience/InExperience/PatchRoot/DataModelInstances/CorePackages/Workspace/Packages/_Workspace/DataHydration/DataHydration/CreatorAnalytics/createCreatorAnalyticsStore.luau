local HttpService = game:GetService("HttpService")

local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Cryo = require(parent.Cryo)
require(parent.HttpClient)

local FFlagBuildExperienceAnalyticsBreakdowns = require(DataHydration.CreatorAnalytics.FFlagBuildExperienceAnalyticsBreakdowns)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

local fetchResourceMetric = require(script.Parent.fetchResourceMetric)
local fetchMetricMetadata = require(script.Parent.fetchMetricMetadata)
local CreatorAnalyticsStoreTypes = require(script.Parent.CreatorAnalyticsStoreTypes)

local function encodeFilters(filters)
	local sorted = Cryo.List.sort(filters, function(p, p2): boolean
		if p.dimension == p2.dimension then
			return p.operation < p2.operation
		end

		return p.dimension < p2.dimension
	end)

	local result = {}

	for _, v in sorted do
		table.insert(result, { v.dimension, Cryo.List.sort(v.values), v.operation })
	end

	return result
end

local function decodeFilters(items)
	local result = {}

	for _, item in items do
		table.insert(result, { dimension = item[1], values = item[2], operation = item[3] })
	end

	return result
end

local function encodeBreakdowns(breakdowns)
	local result = {}

	for _, item in breakdowns do
		table.insert(result, { item.dimensions })
	end

	return result
end

local function decodeBreakdowns(items)
	local result = {}

	for _, item in items do
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

local function paramsFromKey(json: string)
	local jsonDecode = HttpService:JSONDecode(json)
	local v = {
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
	local filters

	if jsonDecode[7] then
		filters = decodeFilters(jsonDecode[7])
	end

	v.filters = filters
	local breakdowns

	if jsonDecode[8] then
		breakdowns = decodeBreakdowns(jsonDecode[8])
	end

	v.breakdowns = breakdowns
	v.includeAdvancedFields = jsonDecode[9]
	v.analyticsKey = jsonDecode[10]
	return v
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
	local filters

	if FFlagBuildExperienceAnalyticsBreakdowns then
		filters = data.filters
	end

	cachedUniverseMetricParams.filters = filters
	local breakdowns

	if FFlagBuildExperienceAnalyticsBreakdowns then
		breakdowns = data.breakdowns
	end

	cachedUniverseMetricParams.breakdowns = breakdowns
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

local function metricsKey(p)
	local clone = table.clone(p)
	table.sort(clone)
	return HttpService:JSONEncode(clone)
end

local function createCreatorAnalyticsStore(options)
	local v = options or {}

	local v2 = {}
	local function trackPoll(object) -- 2 equivalent calls inferred from this helper
		v2[object] = true
		object:finally(function()
			v2[object] = nil
		end)
		return object
	end

	local dataResolver = createDataResolver({
		cache = createDataCache(v.seriesTtlSeconds or 86400, v.failedTtlSeconds),
		supportsMultiGet = false,
		fetchFn = function(p: string, _)
			local v3 = paramsFromKey(p)
			return trackPoll(fetchResourceMetric(v3, { -- inferred equivalent call
				network = v.network,
				baseUrl = v.baseUrl,
				delay = v.delay,
				includeAdvancedFields = v3.includeAdvancedFields,
				analyticsKey = v3.analyticsKey
			}))
		end
	})

	local function getAndFetchResourceMetric(p)
		return (dataResolver.getAndFetchItem(paramsKey(toCachedResourceMetricParams(p))))
	end

	local function getAndFetchMetric(p)
		return (dataResolver.getAndFetchItem(paramsKey(toCachedUniverseMetricParams(p))))
	end

	local function refetchResourceMetric(p)
		dataResolver.fetchItem(paramsKey(toCachedResourceMetricParams(p)))
	end

	local function refetchMetric(p)
		dataResolver.fetchItem(paramsKey(toCachedUniverseMetricParams(p)))
	end

	local dataResolver2 = createDataResolver({
		cache = createDataCache(v.metadataTtlSeconds or 600, v.failedTtlSeconds),
		supportsMultiGet = false,
		fetchFn = function(json: string, _)
			return trackPoll(fetchMetricMetadata(HttpService:JSONDecode(json), { -- inferred equivalent call
				network = v.network,
				baseUrl = v.baseUrl,
				delay = v.delay
			}))
		end
	})

	local function getAndFetchMetricMetadata(p)
		return (dataResolver2.getAndFetchItem(metricsKey(p)))
	end

	local function dispose()
		local v3 = {}

		for k in v2 do
			table.insert(v3, k)
		end

		v2 = {}

		for _, v4 in v3 do
			v4:cancel()
		end

		dataResolver.dispose()
		dataResolver2.dispose()
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
