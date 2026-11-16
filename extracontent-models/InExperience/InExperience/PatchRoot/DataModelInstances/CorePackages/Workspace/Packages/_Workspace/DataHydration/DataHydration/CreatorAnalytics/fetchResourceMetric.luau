local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Promise = require(parent.Promise)
require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

local FFlagBuildExperienceAnalyticsBreakdowns = require(DataHydration.CreatorAnalytics.FFlagBuildExperienceAnalyticsBreakdowns)

local pollAnalyticsOperation = require(script.Parent.pollAnalyticsOperation)
local CreatorAnalyticsStoreTypes = require(script.Parent.CreatorAnalyticsStoreTypes)

local MetricGranularity = CreatorAnalyticsStoreTypes.MetricGranularity
local FilterOperation = CreatorAnalyticsStoreTypes.FilterOperation

local v = {
	[MetricGranularity.OneMinute] = "METRIC_GRANULARITY_ONE_MINUTE",
	[MetricGranularity.HalfHour] = "METRIC_GRANULARITY_HALF_HOUR",
	[MetricGranularity.OneHour] = "METRIC_GRANULARITY_ONE_HOUR",
	[MetricGranularity.OneDay] = "METRIC_GRANULARITY_ONE_DAY",
	[MetricGranularity.OneWeek] = "METRIC_GRANULARITY_ONE_WEEK",
	[MetricGranularity.OneMonth] = "METRIC_GRANULARITY_ONE_MONTH",
	[MetricGranularity.None] = "METRIC_GRANULARITY_NONE"
}

local v2 = {
	[FilterOperation.Contains] = "FILTER_OPERATION_CONTAINS",
	[FilterOperation.NotContains] = "FILTER_OPERATION_NOT_CONTAINS",
	[FilterOperation.GreaterThan] = "FILTER_OPERATION_GT",
	[FilterOperation.GreaterThanOrEqual] = "FILTER_OPERATION_GTE",
	[FilterOperation.LessThan] = "FILTER_OPERATION_LT",
	[FilterOperation.LessThanOrEqual] = "FILTER_OPERATION_LTE",
	[FilterOperation.Match] = "FILTER_OPERATION_MATCH",
	[FilterOperation.Equals] = "FILTER_OPERATION_EQUALS",
	[FilterOperation.NotEqual] = "FILTER_OPERATION_NOT_EQUAL"
}

local function toRfc3339(p: number) -- 2 equivalent calls inferred from this helper
	return (os.date("!%Y-%m-%dT%H:%M:%SZ", p))
end

local function toSeries(p, granularity, flag: boolean)
	if p.queryResult == nil then
		error({ errorMessage = "analytics metric response missing queryResult" })
	end

	local values = p.queryResult.values
	local v3

	if values ~= nil then
		v3 = values[1]
	end

	local dataPoints

	if v3 ~= nil then
		dataPoints = v3.dataPoints
	end

	local values2

	if flag then
		values2 = {}

		if values ~= nil then
			for _, value in values do
				table.insert(values2, {
					breakdownValues = value.breakdownValue or {},
					dataPoints = value.dataPoints or {}
				})
			end
		end
	end

	return {
		dataPoints = dataPoints or {},
		granularity = granularity,
		values = values2
	}
end

local function fetchResourceMetric(data, options)
	local v3 = options or {}
	local baseUrl = v3.baseUrl or UrlBase.APIS

	local v4 = data.resourceType ~= nil
	local resourceType = not v4 and "RESOURCE_TYPE_UNIVERSE" or data.resourceType
	local resourceId

	if v4 then
		resourceId = data.resourceId
	else
		resourceId = tostring(data.universeId)
	end

	local filters = data.filters
	local breakdowns = data.breakdowns
	local v5

	if v3.includeAdvancedFields == nil then
		v5 = v4 or FFlagBuildExperienceAnalyticsBreakdowns
	else
		v5 = v3.includeAdvancedFields
	end

	local dateTime = DateTime.fromIsoDate(data.endTime)

	if dateTime == nil then
		return Promise.reject({
			errorMessage = "invalid endTime for analytics metric query: " .. tostring(data.endTime)
		})
	end

	local unixTimestamp = dateTime.UnixTimestamp

	local query = {
		resourceType = resourceType,
		resourceId = resourceId,
		metric = data.metric,
		granularity = v[data.granularity] or data.granularity,
		startTime = toRfc3339(unixTimestamp - data.lookbackSeconds), -- inferred equivalent call
		endTime = toRfc3339(unixTimestamp + 86400) -- inferred equivalent call
	}

	if v5 then
		if filters ~= nil and #filters > 0 then
			local filter2 = {}

			for _, filter in filters do
				table.insert(filter2, {
					dimension = filter.dimension,
					values = filter.values,
					operation = v2[filter.operation] or filter.operation
				})
			end

			query.filter = filter2
		end

		if breakdowns ~= nil and #breakdowns > 0 then
			local breakdown2 = {}

			for _, breakdown in breakdowns do
				table.insert(breakdown2, { dimensions = breakdown.dimensions })
			end

			query.breakdown = breakdown2
		end
	end

	local url = baseUrl .. "/analytics-query-gateway/v1/metrics/resource/" .. resourceType .. "/id/" .. resourceId
	return pollAnalyticsOperation({
		network = v3.network,
		url = url,
		body = { query = query },
		analyticsKey = v3.analyticsKey or v4 and "data-hydration.resource-analytics-metric" or "build-experience.experience-analytics-metric",
		mapResult = function(p)
			return toSeries(p, data.granularity, v5)
		end,
		timeoutMessage = "analytics metric query did not complete after polling",
		delay = v3.delay
	})
end

return fetchResourceMetric
