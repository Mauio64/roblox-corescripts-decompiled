require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBase

local pollAnalyticsOperation = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/pollAnalyticsOperation")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/CreatorAnalyticsStoreTypes")

local function toMap(p2)
	if p2.metricMetadataResult == nil then
		error({
			errorMessage = "analytics metadata response missing metricMetadataResult"
		})
	end

	local metadata = p2.metricMetadataResult.metadata
	local latestAvailableTimesByMetric = {}

	if metadata ~= nil then
		for k, v5 in metadata do
			if v5.metric ~= nil and v5.latestAvailableTime ~= nil then
				latestAvailableTimesByMetric[v5.metric] = v5.latestAvailableTime
			end
		end
	end

	return latestAvailableTimesByMetric
end

local function fetchMetricMetadata(p2, options)
	local v5 = options or {}
	local v6 = (v5.baseUrl or urlBase.APIS) .. "/analytics-query-gateway/v1/metrics/metadata"
	return pollAnalyticsOperation({
		network = v5.network,
		url = v6,
		body = {
			query = { metrics = p2 }
		},
		analyticsKey = "build-experience.experience-analytics-metadata",
		mapResult = toMap,
		timeoutMessage = "analytics metadata query did not complete after polling",
		delay = v5.delay
	})
end

return fetchMetricMetadata
