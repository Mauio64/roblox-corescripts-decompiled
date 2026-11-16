local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local CreatorAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics")
local getCreatorAnalyticsStore = CreatorAnalytics.getCreatorAnalyticsStore
local dataStatus = CreatorAnalytics.DataStatus
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/Goals/GoalTypes")
local FFlagBuildAnalyticsGoals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAnalyticsGoals")

local function toParams(p2, query, p3, p4)
	local endOffsetDays = query.endOffsetDays

	if endOffsetDays ~= nil then
		local dateTime = DateTime.fromIsoDate(p4)

		if dateTime ~= nil then
			p4 = os.date("!%Y-%m-%dT%H:%M:%SZ", dateTime.UnixTimestamp - endOffsetDays * 86400)
		end
	end

	local v5 = p3.lookbackSeconds * (query.lookbackWindows or 1)

	if FFlagBuildAnalyticsGoals and query.metric == CreatorAnalytics.MetricId.TotalSessionsEndedInBucket then
		v5 -= 86400
	end

	return {
		universeId = p2,
		metric = query.metric,
		granularity = query.granularity or p3.granularity,
		lookbackSeconds = v5,
		endTime = p4,
		filters = query.filters,
		breakdowns = query.breakdowns
	}
end

local function useGoalMetricSummary(p2, p3, p4, p5)
	local query = p3.query

	local v5 = React.useMemo(function()
		return Signals.createComputed(function(p6)
			if p5 == nil then
				return { series = nil, status = dataStatus.NotReady }
			end

			local fetchMetric = getCreatorAnalyticsStore(p6).getAndFetchMetric(toParams(p2, query, p4, p5))
			return { series = fetchMetric.data(p6), status = fetchMetric.status(p6) }
		end)
	end, { p2, query, p4, p5 })

	local v6 = SignalsReact.useSignalState(v5)

	local v7 = React.useMemo(function()
		if v6.series == nil or p5 == nil then
			return nil
		end

		local dateTime = DateTime.fromIsoDate(p5)

		if dateTime then
			return p3.derive(v6.series, {
				lookbackSeconds = p4.lookbackSeconds,
				endUnix = dateTime.UnixTimestamp - (query.endOffsetDays or 0) * 86400
			})
		end

		return nil
	end, { v6.series, p3, query, p4, p5 })

	return { status = v6.status, value = v7 }
end

return useGoalMetricSummary
