local CreatorAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/CreatorAnalytics")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/metricSeriesToChartPoints")

local frozen = table.freeze({
	views = "MomentsLifetimeVideoViews",
	watchTime = "MomentsLifetimeWatchTime",
	joins = "MomentsLifetimeJoins"
})

local function toRfc3339(p2)
	return os.date("!%Y-%m-%dT%H:%M:%SZ", p2)
end

local function floorTo(p2, p3)
	return math.floor(p2 / p3) * p3
end

local function getPostInsightsQueryParams(data, p2)
	local recommendationMetadata = data.recommendationMetadata
	local feedItemId = if recommendationMetadata ~= nil then recommendationMetadata.feedItemId else nil

	if feedItemId == nil or feedItemId == "" or data.creatorId == nil then
		return nil
	end

	local v5 = math.floor(p2 / 3600) * 3600
	local v6 = os.date("!%Y-%m-%dT%H:%M:%SZ", v5)

	local dateTime = if data.createdAt ~= nil then DateTime.fromIsoDate(data.createdAt) else nil
	local unixTimestamp = if dateTime ~= nil then dateTime.UnixTimestamp else nil
	local v7

	if unixTimestamp == nil or not (p2 - unixTimestamp < 259200) then
		local v8 = math.ceil((v5 - 2592000) / 86400) * 86400

		if unixTimestamp ~= nil then
			v8 = math.max(v8, math.floor(unixTimestamp / 86400) * 86400)
		end

		v7 = {
			granularity = CreatorAnalytics.MetricGranularity.OneDay,
			bucketSeconds = 86400,
			startUnix = v8,
			endUnix = v5
		}
	else
		local v8 = math.min(math.floor(unixTimestamp / 3600) * 3600, v5 - 3600)
		v7 = {
			granularity = CreatorAnalytics.MetricGranularity.OneHour,
			bucketSeconds = 3600,
			startUnix = v8,
			endUnix = v5
		}
	end

	local v8 = {
		{
			dimension = "FeedItem",
			values = { feedItemId },
			operation = CreatorAnalytics.FilterOperation.Equals
		}
	}

	local function query(p3, p4, p5)
		return {
			resourceType = CreatorAnalytics.ResourceType.Creator,
			resourceId = tostring(data.creatorId),
			metric = p3,
			granularity = p4,
			lookbackSeconds = p5,
			endTime = v6,
			filters = v8
		}
	end

	local none = CreatorAnalytics.MetricGranularity.None

	local granularity = v7.granularity
	local v10 = v5 - v7.startUnix
	local v9 = {
		views = {
			resourceType = CreatorAnalytics.ResourceType.Creator,
			resourceId = tostring(data.creatorId),
			metric = "MomentsVideoViews",
			granularity = granularity,
			lookbackSeconds = v10,
			endTime = v6,
			filters = v8
		},
		window = v7,
		lifetime = 0
	}

	local views = frozen.views
	local v11 = {
		views = {
			resourceType = CreatorAnalytics.ResourceType.Creator,
			resourceId = tostring(data.creatorId),
			metric = views,
			granularity = none,
			lookbackSeconds = 2588400,
			endTime = v6,
			filters = v8
		},
		watchTime = 0,
		joins = 0
	}

	local watchTime = frozen.watchTime
	v11.watchTime = {
		resourceType = CreatorAnalytics.ResourceType.Creator,
		resourceId = tostring(data.creatorId),
		metric = watchTime,
		granularity = none,
		lookbackSeconds = 2588400,
		endTime = v6,
		filters = v8
	}
	local joins = frozen.joins
	v11.joins = {
		resourceType = CreatorAnalytics.ResourceType.Creator,
		resourceId = tostring(data.creatorId),
		metric = joins,
		granularity = none,
		lookbackSeconds = 2588400,
		endTime = v6,
		filters = v8
	}
	v9.lifetime = v11
	return v9
end

return getPostInsightsQueryParams
