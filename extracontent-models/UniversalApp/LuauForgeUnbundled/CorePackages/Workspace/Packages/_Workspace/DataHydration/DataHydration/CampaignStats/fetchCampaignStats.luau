require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBase

local pollAnalyticsOperation = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/pollAnalyticsOperation")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CampaignStats/CampaignStatsTypes")
local WINDOW_DAYS = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CampaignStats/CampaignStatsConstants").WINDOW_DAYS

local function sumByCampaign(queryResult)
	local result = {}

	if queryResult == nil or queryResult.values == nil then
		return result
	end

	for k, value in queryResult.values do
		local value2 = nil

		if value.breakdownValue ~= nil then
			for k2, v7 in value.breakdownValue do
				if v7.dimension == "CampaignId" then
					value2 = v7.value
					break
				end
			end
		end

		if not (value2 ~= nil and value2 ~= "RAQI_RESERVED_DIMENSION_VALUES_NO_VALUE") then
			continue
		end

		local total = 0

		if value.dataPoints ~= nil then
			for k2, dataPoint in value.dataPoints do
				total += dataPoint.value or 0
			end
		end

		result[value2] = (result[value2] or 0) + total
	end

	return result
end

local function queryMetricByCampaign(p2, p3, data, p4)
	local formatted = ("%s/analytics-query-gateway/v1/metrics/resource/%s/id/%d"):format(
		p4.baseUrl or urlBase.APIS,
		"RESOURCE_TYPE_UNIVERSE",
		p3
	)

	local v6 = {
		resourceType = "RESOURCE_TYPE_UNIVERSE",
		resourceId = tostring(p3),
		query = {
			metric = p2,
			granularity = "METRIC_GRANULARITY_NONE",
			startTime = data.startIso,
			endTime = data.queryEndIso,
			breakdown = {
				{
					dimensions = { "CampaignId" }
				}
			},
			filter = {
				{
					dimension = "AttributionDateHour",
					operation = "FILTER_OPERATION_GTE",
					values = { (tostring(data.startMs)) }
				},
				{
					dimension = "AttributionDateHour",
					operation = "FILTER_OPERATION_LT",
					values = { (tostring(data.endMs)) }
				}
			}
		}
	}

	return pollAnalyticsOperation({
		network = p4.network,
		url = formatted,
		body = v6,
		analyticsKey = "ads-campaign-stats.query",
		mapResult = function(p5)
			return sumByCampaign(p5.queryResult)
		end,
		timeoutMessage = "analytics-query-gateway: campaign stats query did not complete"
	})
end

local function captureMetricOutcome(object)
	return object:andThen(function(p2)
		return { succeeded = true, value = p2 }
	end, function(p2)
		return { succeeded = false, value = {} }
	end)
end

return {
	fetchCampaignStats = function(p2, options)
		local v6 = options or {}
		local v7 = if v6.nowMs == nil then DateTime.now().UnixTimestampMillis else v6.nowMs

		local v8 = v7 - v7 % 3600000
		local v9 = v8 - WINDOW_DAYS * 86400000
		local v10 = {
			startMs = v9,
			endMs = v8,
			startIso = DateTime.fromUnixTimestampMillis(v9):ToIsoDate(),
			queryEndIso = DateTime.fromUnixTimestampMillis(v8 + 2592000000):ToIsoDate()
		}

		local function fn(p3)
			return { succeeded = true, value = p3 }
		end

		local function fn2(p3)
			return { succeeded = false, value = {} }
		end

		return Promise.all({
			queryMetricByCampaign("AdsUANumPlaysDefaultViewByUniverse", p2, v10, v6):andThen(fn, fn2),
			queryMetricByCampaign("AdsUANumClicksDefaultViewByUniverse", p2, v10, v6):andThen(fn, fn2),
			queryMetricByCampaign("AdsUANumImpressionsDefaultViewByUniverse", p2, v10, v6):andThen(fn, fn2),
			captureMetricOutcome(queryMetricByCampaign("AdsUAPlaytimeDefaultViewByUniverse", p2, v10, v6))
		}):andThen(function(list)
			local item = list[1]
			local item2 = list[2]
			local item3 = list[3]
			local item4 = list[4]

			local v11 = {}
			local function entryFor(p3)
				local v12 = v11[p3]

				if v12 == nil then
					v12 = { plays = 0, adClicks = 0, adViews = 0, playtimeSeconds = 0 }
					v11[p3] = v12
				end

				return v12
			end

			for k, v12 in item.value do
				local v13 = v11[k]

				if v13 == nil then
					v13 = { plays = 0, adClicks = 0, adViews = 0, playtimeSeconds = 0 }
					v11[k] = v13
				end

				v13.plays = v12
			end

			for k, v12 in item2.value do
				local v13 = v11[k]

				if v13 == nil then
					v13 = { plays = 0, adClicks = 0, adViews = 0, playtimeSeconds = 0 }
					v11[k] = v13
				end

				v13.adClicks = v12
			end

			for k, v12 in item3.value do
				local v13 = v11[k]

				if v13 == nil then
					v13 = { plays = 0, adClicks = 0, adViews = 0, playtimeSeconds = 0 }
					v11[k] = v13
				end

				v13.adViews = v12
			end

			for k, v12 in item4.value do
				local v13 = v11[k]

				if v13 == nil then
					v13 = { plays = 0, adClicks = 0, adViews = 0, playtimeSeconds = 0 }
					v11[k] = v13
				end

				v13.playtimeSeconds = v12
			end

			return {
				byCampaign = v11,
				failedMetrics = {
					plays = not item.succeeded,
					adClicks = not item2.succeeded,
					adViews = not item3.succeeded,
					playtimeSeconds = not item4.succeeded
				}
			}
		end)
	end
}
