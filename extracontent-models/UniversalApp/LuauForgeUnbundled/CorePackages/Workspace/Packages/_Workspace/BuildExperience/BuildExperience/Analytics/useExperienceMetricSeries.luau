local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local getCreatorAnalyticsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics").getCreatorAnalyticsStore

local dataStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics").DataStatus
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsMetric")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")
local getMetricQueryParams = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/getMetricQueryParams")
local deriveMetricSummary = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/deriveMetricSummary")

local FFlagBuildAnalyticsCreatorHubWindowFix = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAnalyticsCreatorHubWindowFix")

local function useExperienceMetricSeries(p2, p3, p4, p5, value)
	local v5 = React.useMemo(function()
		return Signals.createComputed(function(p6)
			if p5 == nil then
				return { series = nil, status = dataStatus.NotReady }
			end

			local v6 = getMetricQueryParams(p2, p3, p4, p5)
			local fetchMetric = getCreatorAnalyticsStore(p6).getAndFetchMetric(v6)
			return { series = fetchMetric.data(p6), status = fetchMetric.status(p6) }
		end)
	end, { p2, p3, p4, p5 })
	local v6 = SignalsReact.useSignalState(v5)

	local v7 = value or 600
	React.useEffect(function()
		if not (FFlagBuildAnalyticsCreatorHubWindowFix and p5 ~= nil) then
			return
		end

		local v8 = getMetricQueryParams(p2, p3, p4, p5)
		local thread = nil
		local function scheduleRefresh()
			thread = task.delay(v7, function()
				getCreatorAnalyticsStore(false).refetchMetric(v8)
				scheduleRefresh()
			end)
		end

		thread = task.delay(v7, function()
			getCreatorAnalyticsStore(false).refetchMetric(v8)
			scheduleRefresh()
		end)

		return function()
			if thread ~= nil then
				task.cancel(thread)
			end
		end
	end, { p2, p3, p4, p5, v7 })

	local v8 = React.useMemo(function()
		local v9 = nil

		if p5 ~= nil then
			local dateTime = DateTime.fromIsoDate(p5)

			v9 = dateTime ~= nil
				and {
					lookbackSeconds = p4.lookbackSeconds,
					endUnix = dateTime.UnixTimestamp
				}
				or v9
		end

		return deriveMetricSummary(v6.series, v9)
	end, { v6.series, p4, p5 })

	return {
		series = v6.series,
		status = v6.status,
		hasData = v8.hasData,
		latest = v8.latest,
		trendPct = v8.trendPct,
		priorValue = v8.priorValue
	}
end

return useExperienceMetricSeries
