local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)
local Promise = require(parent.Promise)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

local pollAnalyticsOperation = require(DataHydration.pollAnalyticsOperation)
require(script.Parent.CampaignStatsTypes)
local CampaignStatsConstants = require(script.Parent.CampaignStatsConstants)

local WINDOW_DAYS = CampaignStatsConstants.WINDOW_DAYS

local function sumByCampaign(queryResult)
	local result = {}

	if queryResult == nil or queryResult.values == nil then
		return result
	end

	for _, value in queryResult.values do
		local value2 = nil

		if value.breakdownValue ~= nil then
			for _, v in value.breakdownValue do
				if v.dimension == "CampaignId" then
					value2 = v.value
					break
				end
			end
		end

		if not (value2 ~= nil and value2 ~= "RAQI_RESERVED_DIMENSION_VALUES_NO_VALUE") then
			continue
		end

		local total = 0

		if value.dataPoints ~= nil then
			for _, dataPoint in value.dataPoints do
				total += dataPoint.value or 0
			end
		end

		result[value2] = (result[value2] or 0) + total
	end

	return result
end

local function queryMetricByCampaign(metric: string, p: number, data, p2)
	local formatted = ("%s/analytics-query-gateway/v1/metrics/resource/%s/id/%d"):format(
		p2.baseUrl or UrlBase.APIS,
		"RESOURCE_TYPE_UNIVERSE",
		p
	)

	local body = {
		resourceType = "RESOURCE_TYPE_UNIVERSE",
		resourceId = tostring(p),
		query = {
			metric = metric,
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
		network = p2.network,
		url = formatted,
		body = body,
		analyticsKey = "ads-campaign-stats.query",
		mapResult = function(p3)
			return sumByCampaign(p3.queryResult)
		end,
		timeoutMessage = "analytics-query-gateway: campaign stats query did not complete"
	})
end

local function captureMetricOutcome(object)
	return object:andThen(function(p)
		return { succeeded = true, value = p }
	end, function(_)
		return { succeeded = false, value = {} }
	end)
end

return {
	fetchCampaignStats = function(p: number, options)
		local v = options or {}
		local v2

		if v.nowMs == nil then
			v2 = DateTime.now().UnixTimestampMillis
		else
			v2 = v.nowMs
		end

		local endMs = v2 - v2 % 3600000
		local startMs = endMs - WINDOW_DAYS * 86400000
		local v3 = {
			startMs = startMs,
			endMs = endMs,
			startIso = DateTime.fromUnixTimestampMillis(startMs):ToIsoDate(),
			queryEndIso = DateTime.fromUnixTimestampMillis(endMs + 2592000000):ToIsoDate()
		}

		local function fn(p2)
			return { succeeded = true, value = p2 }
		end

		local function fn2(_)
			return { succeeded = false, value = {} }
		end

		return Promise.all({
			queryMetricByCampaign("AdsUANumPlaysDefaultViewByUniverse", p, v3, v):andThen(fn, fn2),
			queryMetricByCampaign("AdsUANumClicksDefaultViewByUniverse", p, v3, v):andThen(fn, fn2),
			queryMetricByCampaign("AdsUANumImpressionsDefaultViewByUniverse", p, v3, v):andThen(fn, fn2),
			captureMetricOutcome(queryMetricByCampaign("AdsUAPlaytimeDefaultViewByUniverse", p, v3, v))
		}):andThen(function(list)
			local item = list[1]
			local item2 = list[2]
			local item3 = list[3]
			local item4 = list[4]

			local byCampaign = {}
			local function entryFor(k: string) -- 4 equivalent calls inferred from this helper
				local v4 = byCampaign[k]

				if v4 == nil then
					v4 = { plays = 0, adClicks = 0, adViews = 0, playtimeSeconds = 0 }
					byCampaign[k] = v4
				end

				return v4
			end

			for k, plays in item.value do
				local v4 = entryFor(k) -- inferred equivalent call
				v4.plays = plays
			end

			for k, adClicks in item2.value do
				local v4 = entryFor(k) -- inferred equivalent call
				v4.adClicks = adClicks
			end

			for k, adViews in item3.value do
				local v4 = entryFor(k) -- inferred equivalent call
				v4.adViews = adViews
			end

			for k, playtimeSeconds in item4.value do
				local v4 = entryFor(k) -- inferred equivalent call
				v4.playtimeSeconds = playtimeSeconds
			end

			return {
				byCampaign = byCampaign,
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
