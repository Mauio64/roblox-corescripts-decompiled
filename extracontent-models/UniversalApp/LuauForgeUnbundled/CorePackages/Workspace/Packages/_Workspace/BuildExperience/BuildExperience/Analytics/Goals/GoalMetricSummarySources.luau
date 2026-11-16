local CreatorAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics")
local deriveMetricSummary = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/deriveMetricSummary")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/Goals/GoalTypes")

local metricGranularity = CreatorAnalytics.MetricGranularity

local function retentionRatio(p2, durationSeconds, p3, p4)
	local v5 = nil
	local v6 = nil

	for k, v7 in p2.values or {} do
		local breakdownValue = v7.breakdownValues[1]

		if not (breakdownValue ~= nil and breakdownValue.dimension == "SessionTimeBucket") then
			continue
		end

		local value = tonumber(breakdownValue.value)

		if not (value == 0 or value == durationSeconds) then
			continue
		end

		for k2, dataPoint in v7.dataPoints do
			local dateTime = DateTime.fromIsoDate(dataPoint.time)

			if dateTime == nil or (dateTime.UnixTimestamp <= p3 or p4 < dateTime.UnixTimestamp) then
				continue
			end

			if value == 0 then
				v6 = (v6 or 0) + dataPoint.value
			end

			if value == durationSeconds then
				v5 = (v5 or 0) + dataPoint.value
			end
		end
	end

	if v6 == nil or v6 <= 0 or v5 == nil then
		return nil
	end

	return v5 / v6
end

return {
	summary = function(data)
		return {
			query = {
				metric = data.metric,
				lookbackWindows = 2,
				endOffsetDays = data.endOffsetDays,
				filters = data.filters
			},
			derive = function(p2, p3)
				local v5 = deriveMetricSummary(p2, p3)

				if v5.hasData and v5.latest ~= nil then
					return {
						kind = "number",
						value = v5.latest,
						trendPct = v5.trendPct,
						priorValue = v5.priorValue
					}
				end

				return nil
			end
		}
	end,
	topBreakdown = function(data)
		local dimension = data.dimension

		return {
			query = {
				metric = data.metric,
				granularity = metricGranularity.None,
				lookbackWindows = 1,
				filters = data.filters,
				breakdowns = {
					{
						dimensions = { dimension }
					}
				}
			},
			derive = function(p2, p3)
				local v5 = -1e999
				local v6 = nil

				for k, v7 in p2.values or {} do
					for k2, breakdownValue in v7.breakdownValues do
						if breakdownValue.dimension == dimension then
							local total = 0

							for k3, dataPoint in v7.dataPoints do
								total += dataPoint.value
							end

							if v5 <= total then
								v6 = breakdownValue
								v5 = total
							end

							break
						end
					end
				end

				if v6 == nil then
					return nil
				end

				return { kind = "breakdown", metric = data.metric, breakdown = v6 }
			end
		}
	end,
	firstSessionRetention = function(p2)
		local durationSeconds = p2.durationSeconds

		return {
			query = {
				metric = CreatorAnalytics.MetricId.TotalSessionsEndedInBucket,
				granularity = metricGranularity.OneDay,
				lookbackWindows = 2,
				breakdowns = {
					{
						dimensions = { "SessionTimeBucket" }
					}
				},
				filters = {
					{
						dimension = "SessionTimeBucket",
						operation = "Equals",
						values = { "0", (tostring(durationSeconds)) }
					}
				}
			},
			derive = function(p3, p4)
				local v5 = p4.endUnix - p4.lookbackSeconds
				local v6 = retentionRatio(p3, durationSeconds, v5, p4.endUnix)

				if v6 == nil then
					return nil
				end

				local v7 = retentionRatio(p3, durationSeconds, v5 - p4.lookbackSeconds, v5)

				local v9 = if v7 ~= nil and v7 > 0 then (v6 - v7) / v7 else nil
				return { kind = "number", value = v6, priorValue = v7, trendPct = v9 }
			end
		}
	end
}
