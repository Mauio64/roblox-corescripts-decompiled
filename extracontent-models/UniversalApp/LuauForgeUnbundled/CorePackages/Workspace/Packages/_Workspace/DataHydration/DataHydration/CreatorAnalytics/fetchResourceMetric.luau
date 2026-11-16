local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBase

local FFlagBuildExperienceAnalyticsBreakdowns = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/FFlagBuildExperienceAnalyticsBreakdowns")

local pollAnalyticsOperation = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/pollAnalyticsOperation")
local CreatorAnalyticsStoreTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/CreatorAnalyticsStoreTypes")

local metricGranularity = CreatorAnalyticsStoreTypes.MetricGranularity
local filterOperation = CreatorAnalyticsStoreTypes.FilterOperation

local v5 = {
	[metricGranularity.OneMinute] = "METRIC_GRANULARITY_ONE_MINUTE",
	[metricGranularity.HalfHour] = "METRIC_GRANULARITY_HALF_HOUR",
	[metricGranularity.OneHour] = "METRIC_GRANULARITY_ONE_HOUR",
	[metricGranularity.OneDay] = "METRIC_GRANULARITY_ONE_DAY",
	[metricGranularity.OneWeek] = "METRIC_GRANULARITY_ONE_WEEK",
	[metricGranularity.OneMonth] = "METRIC_GRANULARITY_ONE_MONTH",
	[metricGranularity.None] = "METRIC_GRANULARITY_NONE"
}

local v6 = {
	[filterOperation.Contains] = "FILTER_OPERATION_CONTAINS",
	[filterOperation.NotContains] = "FILTER_OPERATION_NOT_CONTAINS",
	[filterOperation.GreaterThan] = "FILTER_OPERATION_GT",
	[filterOperation.GreaterThanOrEqual] = "FILTER_OPERATION_GTE",
	[filterOperation.LessThan] = "FILTER_OPERATION_LT",
	[filterOperation.LessThanOrEqual] = "FILTER_OPERATION_LTE",
	[filterOperation.Match] = "FILTER_OPERATION_MATCH",
	[filterOperation.Equals] = "FILTER_OPERATION_EQUALS",
	[filterOperation.NotEqual] = "FILTER_OPERATION_NOT_EQUAL"
}

local function toRfc3339(p2)
	return os.date("!%Y-%m-%dT%H:%M:%SZ", p2)
end

local function toSeries(p2, granularity, p3)
	if p2.queryResult == nil then
		error({ errorMessage = "analytics metric response missing queryResult" })
	end

	local values = p2.queryResult.values
	local v7 = if values ~= nil then values[1] else nil
	local dataPoints = if v7 ~= nil then v7.dataPoints else nil
	local v8

	if p3 then
		v8 = {}

		if values ~= nil then
			for k, value in values do
				table.insert(v8, {
					breakdownValues = value.breakdownValue or {},
					dataPoints = value.dataPoints or {}
				})
			end
		end
	end

	return {
		dataPoints = dataPoints or {},
		granularity = granularity,
		values = v8
	}
end

local function fetchResourceMetric(data, options)
	local v7 = options or {}
	local baseUrl = v7.baseUrl or urlBase.APIS

	local v8 = data.resourceType ~= nil
	local v9 = not v8 and "RESOURCE_TYPE_UNIVERSE" or data.resourceType
	local v10 = if v8 then data.resourceId else tostring(data.universeId)
	local filters = data.filters
	local breakdowns = data.breakdowns
	local v11 = if v7.includeAdvancedFields == nil then v8 or FFlagBuildExperienceAnalyticsBreakdowns else v7.includeAdvancedFields

	local dateTime = DateTime.fromIsoDate(data.endTime)

	if dateTime == nil then
		return Promise.reject({
			errorMessage = "invalid endTime for analytics metric query: " .. tostring(data.endTime)
		})
	end

	local unixTimestamp = dateTime.UnixTimestamp

	local v12 = {
		resourceType = v9,
		resourceId = v10,
		metric = data.metric,
		granularity = v5[data.granularity] or data.granularity,
		startTime = 0,
		endTime = 0
	}
	local v13 = unixTimestamp - data.lookbackSeconds
	v12.startTime = os.date("!%Y-%m-%dT%H:%M:%SZ", v13)
	local v14 = unixTimestamp + 86400
	v12.endTime = os.date("!%Y-%m-%dT%H:%M:%SZ", v14)

	if v11 then
		if filters ~= nil and #filters > 0 then
			local v15 = {}

			for k, filter in filters do
				table.insert(v15, {
					dimension = filter.dimension,
					values = filter.values,
					operation = v6[filter.operation] or filter.operation
				})
			end

			v12.filter = v15
		end

		if breakdowns ~= nil and #breakdowns > 0 then
			local v15 = {}

			for k, breakdown in breakdowns do
				table.insert(v15, { dimensions = breakdown.dimensions })
			end

			v12.breakdown = v15
		end
	end

	local v15 = baseUrl .. "/analytics-query-gateway/v1/metrics/resource/" .. v9 .. "/id/" .. v10
	return pollAnalyticsOperation({
		network = v7.network,
		url = v15,
		body = { query = v12 },
		analyticsKey = v7.analyticsKey or v8 and "data-hydration.resource-analytics-metric" or "build-experience.experience-analytics-metric",
		mapResult = function(p2)
			return toSeries(p2, data.granularity, v11)
		end,
		timeoutMessage = "analytics metric query did not complete after polling",
		delay = v7.delay
	})
end

return fetchResourceMetric
