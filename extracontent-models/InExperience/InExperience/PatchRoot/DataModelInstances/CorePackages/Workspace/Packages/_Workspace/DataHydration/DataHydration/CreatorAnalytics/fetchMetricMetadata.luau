local parent = script:FindFirstAncestor("DataHydration").Parent

require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

local pollAnalyticsOperation = require(script.Parent.pollAnalyticsOperation)
require(script.Parent.CreatorAnalyticsStoreTypes)

local function toMap(p)
	if p.metricMetadataResult == nil then
		error({ errorMessage = "analytics metadata response missing metricMetadataResult" })
	end

	local metadata = p.metricMetadataResult.metadata
	local latestAvailableTimesByMetric = {}

	if metadata ~= nil then
		for _, v in metadata do
			if v.metric ~= nil and v.latestAvailableTime ~= nil then
				latestAvailableTimesByMetric[v.metric] = v.latestAvailableTime
			end
		end
	end

	return latestAvailableTimesByMetric
end

local function fetchMetricMetadata(metrics, options)
	local v = options or {}
	local url = (v.baseUrl or UrlBase.APIS) .. "/analytics-query-gateway/v1/metrics/metadata"
	return pollAnalyticsOperation({
		network = v.network,
		url = url,
		body = {
			query = { metrics = metrics }
		},
		analyticsKey = "build-experience.experience-analytics-metadata",
		mapResult = toMap,
		timeoutMessage = "analytics metadata query did not complete after polling",
		delay = v.delay
	})
end

return fetchMetricMetadata
