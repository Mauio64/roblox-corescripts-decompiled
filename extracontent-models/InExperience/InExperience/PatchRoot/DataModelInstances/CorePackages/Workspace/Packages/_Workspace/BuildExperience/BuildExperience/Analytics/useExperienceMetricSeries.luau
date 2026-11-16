local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local CreatorAnalytics = require(parent.DataHydration.CreatorAnalytics)
local getCreatorAnalyticsStore = CreatorAnalytics.getCreatorAnalyticsStore

local CreatorAnalytics2 = require(parent.DataHydration.CreatorAnalytics)
local DataStatus = CreatorAnalytics2.DataStatus
require(BuildExperience.Analytics.AnalyticsMetric)
require(BuildExperience.Analytics.AnalyticsWindow)
local getMetricQueryParams = require(BuildExperience.Analytics.getMetricQueryParams)
local deriveMetricSummary = require(BuildExperience.Analytics.deriveMetricSummary)

local FFlagBuildAnalyticsCreatorHubWindowFix = require(BuildExperience.Flags.FFlagBuildAnalyticsCreatorHubWindowFix)

local function useExperienceMetricSeries(p: number, p2, p3, p4: string?, value: number?)
	local v = React.useMemo(function()
		return Signals.createComputed(function(p5)
			if p4 == nil then
				return { series = nil, status = DataStatus.NotReady }
			end

			local metricQueryParams = getMetricQueryParams(p, p2, p3, p4)
			local fetchMetric = getCreatorAnalyticsStore(p5).getAndFetchMetric(metricQueryParams)
			return { series = fetchMetric.data(p5), status = fetchMetric.status(p5) }
		end)
	end, { p, p2, p3, p4 })
	local v2 = SignalsReact.useSignalState(v)

	local v3 = value or 600
	React.useEffect(function()
		if not (FFlagBuildAnalyticsCreatorHubWindowFix and p4 ~= nil) then
			return
		end

		local metricQueryParams = getMetricQueryParams(p, p2, p3, p4)
		local thread = nil
		local function scheduleRefresh()
			thread = task.delay(v3, function()
				getCreatorAnalyticsStore(false).refetchMetric(metricQueryParams)
				scheduleRefresh()
			end)
		end

		thread = task.delay(v3, function()
			getCreatorAnalyticsStore(false).refetchMetric(metricQueryParams)
			scheduleRefresh()
		end)

		return function()
			if thread ~= nil then
				task.cancel(thread)
			end
		end
	end, { p, p2, p3, p4, v3 })

	local v4 = React.useMemo(function()
		local v4 = nil

		if p4 ~= nil then
			local dateTime = DateTime.fromIsoDate(p4)

			v4 = dateTime ~= nil and {
				lookbackSeconds = p3.lookbackSeconds,
				endUnix = dateTime.UnixTimestamp
			} or v4
		end

		return deriveMetricSummary(v2.series, v4)
	end, { v2.series, p3, p4 })

	return {
		series = v2.series,
		status = v2.status,
		hasData = v4.hasData,
		latest = v4.latest,
		trendPct = v4.trendPct,
		priorValue = v4.priorValue
	}
end

return useExperienceMetricSeries
