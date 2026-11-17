local parent = script:FindFirstAncestor("Moments").Parent

local CreatorAnalytics = require(parent.DataHydration.CreatorAnalytics)
require(parent.MomentsTypes)

require(script.Parent.metricSeriesToChartPoints)

local frozen = table.freeze({
	views = "MomentsLifetimeVideoViews",
	watchTime = "MomentsLifetimeWatchTime",
	watchTimeNoReplay = "MomentsLifetimeWatchTimeNoReplay",
	joins = "MomentsLifetimeJoins"
})

local function toRfc3339(p: number) -- 1 equivalent call inferred from this helper
	return (os.date("!%Y-%m-%dT%H:%M:%SZ", p))
end

local function floorTo(p: number, p2: number) -- 3 equivalent calls inferred from this helper
	return math.floor(p / p2) * p2
end

local function getPostInsightsQueryParams(data, p: number)
	local recommendationMetadata = data.recommendationMetadata
	local feedItemId

	if recommendationMetadata ~= nil then
		feedItemId = recommendationMetadata.feedItemId
	end

	if feedItemId == nil or feedItemId == "" or data.creatorId == nil then
		return nil
	end

	local endUnix = floorTo(p, 3600) -- inferred equivalent call
	local endTime = toRfc3339(endUnix) -- inferred equivalent call
	local dateTime

	if data.createdAt ~= nil then
		dateTime = DateTime.fromIsoDate(data.createdAt)
	end

	local unixTimestamp

	if dateTime ~= nil then
		unixTimestamp = dateTime.UnixTimestamp
	end

	local window

	if unixTimestamp == nil or not (p - unixTimestamp < 259200) then
		local startUnix = math.ceil((endUnix - 2592000) / 86400) * 86400

		if unixTimestamp ~= nil then
			startUnix = math.max(startUnix, floorTo(unixTimestamp, 86400)) -- inferred equivalent call
		end

		window = {
			granularity = CreatorAnalytics.MetricGranularity.OneDay,
			bucketSeconds = 86400,
			startUnix = startUnix,
			endUnix = endUnix
		}
	else
		local startUnix = math.min(floorTo(unixTimestamp, 3600), endUnix - 3600) -- inferred equivalent call
		window = {
			granularity = CreatorAnalytics.MetricGranularity.OneHour,
			bucketSeconds = 3600,
			startUnix = startUnix,
			endUnix = endUnix
		}
	end

	local filters = {
		{
			dimension = "FeedItem",
			values = { feedItemId },
			operation = CreatorAnalytics.FilterOperation.Equals
		}
	}

	local function query(metric: string, granularity, lookbackSeconds: number) -- 5 equivalent calls inferred from this helper
		return {
			resourceType = CreatorAnalytics.ResourceType.Creator,
			resourceId = tostring(data.creatorId),
			metric = metric,
			granularity = granularity,
			lookbackSeconds = lookbackSeconds,
			endTime = endTime,
			filters = filters
		}
	end

	local none = CreatorAnalytics.MetricGranularity.None

	return {
		views = query("MomentsVideoViews", window.granularity, endUnix - window.startUnix), -- inferred equivalent call
		window = window,
		lifetime = {
			views = query(frozen.views, none, 2588400), -- inferred equivalent call
			watchTime = query(frozen.watchTime, none, 2588400), -- inferred equivalent call
			watchTimeNoReplay = query(frozen.watchTimeNoReplay, none, 2588400), -- inferred equivalent call
			joins = query(frozen.joins, none, 2588400) -- inferred equivalent call
		}
	}
end

return getPostInsightsQueryParams
