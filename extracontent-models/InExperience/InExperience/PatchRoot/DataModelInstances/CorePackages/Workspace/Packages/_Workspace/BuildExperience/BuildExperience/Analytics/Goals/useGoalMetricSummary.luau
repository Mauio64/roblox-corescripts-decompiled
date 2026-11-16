local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local CreatorAnalytics = require(parent.DataHydration.CreatorAnalytics)
local getCreatorAnalyticsStore = CreatorAnalytics.getCreatorAnalyticsStore
local DataStatus = CreatorAnalytics.DataStatus
require(BuildExperience.Analytics.AnalyticsWindow)
require(BuildExperience.Analytics.Goals.GoalTypes)
local FFlagBuildAnalyticsGoals = require(BuildExperience.Flags.FFlagBuildAnalyticsGoals)

local function toParams(universeId: number, query, p, endTime: string)
	local endOffsetDays = query.endOffsetDays

	if endOffsetDays ~= nil then
		local dateTime = DateTime.fromIsoDate(endTime)

		if dateTime ~= nil then
			endTime = os.date("!%Y-%m-%dT%H:%M:%SZ", dateTime.UnixTimestamp - endOffsetDays * 86400)
		end
	end

	local lookbackSeconds = p.lookbackSeconds * (query.lookbackWindows or 1)

	if FFlagBuildAnalyticsGoals and query.metric == CreatorAnalytics.MetricId.TotalSessionsEndedInBucket then
		lookbackSeconds -= 86400
	end

	return {
		universeId = universeId,
		metric = query.metric,
		granularity = query.granularity or p.granularity,
		lookbackSeconds = lookbackSeconds,
		endTime = endTime,
		filters = query.filters,
		breakdowns = query.breakdowns
	}
end

local function useGoalMetricSummary(p: number, p2, p3, p4: string?)
	local query = p2.query

	local v = React.useMemo(function()
		return Signals.createComputed(function(p5)
			if p4 == nil then
				return { series = nil, status = DataStatus.NotReady }
			end

			local fetchMetric = getCreatorAnalyticsStore(p5).getAndFetchMetric(toParams(p, query, p3, p4))
			return { series = fetchMetric.data(p5), status = fetchMetric.status(p5) }
		end)
	end, { p, query, p3, p4 })

	local v2 = SignalsReact.useSignalState(v)

	local v3 = React.useMemo(function()
		if v2.series == nil or p4 == nil then
			return nil
		end

		local dateTime = DateTime.fromIsoDate(p4)

		if dateTime then
			return p2.derive(v2.series, {
				lookbackSeconds = p3.lookbackSeconds,
				endUnix = dateTime.UnixTimestamp - (query.endOffsetDays or 0) * 86400
			})
		end

		return nil
	end, { v2.series, p2, query, p3, p4 })

	return { status = v2.status, value = v3 }
end

return useGoalMetricSummary
