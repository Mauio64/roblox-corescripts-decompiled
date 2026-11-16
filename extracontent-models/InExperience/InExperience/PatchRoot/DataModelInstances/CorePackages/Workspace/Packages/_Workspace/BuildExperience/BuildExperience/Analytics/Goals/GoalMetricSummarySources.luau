local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorAnalytics = require(parent.DataHydration.CreatorAnalytics)
local deriveMetricSummary = require(BuildExperience.Analytics.deriveMetricSummary)
require(BuildExperience.Analytics.Goals.GoalTypes)

local MetricGranularity = CreatorAnalytics.MetricGranularity

local function retentionRatio(p, durationSeconds: number, p2: number, p3: number)
	local v = nil
	local v2 = nil

	for _, v3 in p.values or {} do
		local breakdownValue = v3.breakdownValues[1]

		if not (breakdownValue ~= nil and breakdownValue.dimension == "SessionTimeBucket") then
			continue
		end

		local value = tonumber(breakdownValue.value)

		if not (value == 0 or value == durationSeconds) then
			continue
		end

		for _, dataPoint in v3.dataPoints do
			local dateTime = DateTime.fromIsoDate(dataPoint.time)

			if dateTime == nil or (dateTime.UnixTimestamp <= p2 or p3 < dateTime.UnixTimestamp) then
				continue
			end

			if value == 0 then
				v2 = (v2 or 0) + dataPoint.value
			end

			if value == durationSeconds then
				v = (v or 0) + dataPoint.value
			end
		end
	end

	if v2 == nil or v2 <= 0 or v == nil then
		return nil
	end

	return v / v2
end

local GoalMetricSummarySources = {}

function GoalMetricSummarySources.summary(data)
	return {
		query = {
			metric = data.metric,
			lookbackWindows = 2,
			endOffsetDays = data.endOffsetDays,
			filters = data.filters
		},
		derive = function(p, p2)
			local v = deriveMetricSummary(p, p2)

			if v.hasData and v.latest ~= nil then
				return {
					kind = "number",
					value = v.latest,
					trendPct = v.trendPct,
					priorValue = v.priorValue
				}
			end

			return nil
		end
	}
end

function GoalMetricSummarySources.topBreakdown(data)
	local dimension = data.dimension

	return {
		query = {
			metric = data.metric,
			granularity = MetricGranularity.None,
			lookbackWindows = 1,
			filters = data.filters,
			breakdowns = {
				{
					dimensions = { dimension }
				}
			}
		},
		derive = function(p, _)
			local v = -1e999
			local breakdown = nil

			for _, v2 in p.values or {} do
				for _, breakdownValue in v2.breakdownValues do
					if breakdownValue.dimension == dimension then
						local total = 0

						for _, dataPoint in v2.dataPoints do
							total += dataPoint.value
						end

						if v <= total then
							breakdown = breakdownValue
							v = total
						end

						break
					end
				end
			end

			if breakdown == nil then
				return nil
			end

			return { kind = "breakdown", metric = data.metric, breakdown = breakdown }
		end
	}
end

function GoalMetricSummarySources.firstSessionRetention(p)
	local durationSeconds = p.durationSeconds

	return {
		query = {
			metric = CreatorAnalytics.MetricId.TotalSessionsEndedInBucket,
			granularity = MetricGranularity.OneDay,
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
		derive = function(p2, p3)
			local v = p3.endUnix - p3.lookbackSeconds
			local v2 = retentionRatio(p2, durationSeconds, v, p3.endUnix)

			if v2 == nil then
				return nil
			end

			local priorValue = retentionRatio(p2, durationSeconds, v - p3.lookbackSeconds, v)
			local trendPct

			if not (priorValue == nil or not (priorValue > 0)) then
				trendPct = (v2 - priorValue) / priorValue
			end

			return { kind = "number", value = v2, priorValue = priorValue, trendPct = trendPct }
		end
	}
end

return GoalMetricSummarySources
