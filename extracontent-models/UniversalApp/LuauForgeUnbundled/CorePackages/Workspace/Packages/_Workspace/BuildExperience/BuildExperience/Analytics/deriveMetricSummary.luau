local metricGranularity = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics").MetricGranularity
local fillMetricSeriesGaps = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/fillMetricSeriesGaps")

local v5 = { hasData = false, latest = nil, trendPct = 0, priorValue = nil }

local function deriveSimpleSummary(dataPoints)
	local clone = table.clone(dataPoints)
	table.sort(clone, function(a, b): boolean
		return a.time < b.time
	end)

	local value = clone[1].value
	local value2 = clone[#clone].value

	return {
		hasData = true,
		latest = value2,
		trendPct = (value == nil or value == 0) and 0 or (value2 - value) / value,
		priorValue = nil
	}
end

local function averageRange(list, p2, p3)
	local v6 = p3 - p2 + 1

	if v6 < 1 then
		return 0
	end

	local total = 0

	for i = p2, p3 do
		total += list[i].value
	end

	return total / v6
end

local function deriveMetricSummary(p2, p3)
	local dataPoints = if p2 ~= nil then p2.dataPoints else nil

	if dataPoints == nil or #dataPoints == 0 then
		return v5
	end

	if p3 == nil or p2 ~= nil and p2.granularity ~= metricGranularity.OneDay then
		return deriveSimpleSummary(dataPoints)
	end

	local v6 = fillMetricSeriesGaps(p2, {
		lookbackSeconds = p3.lookbackSeconds * 2,
		endUnix = p3.endUnix
	})

	local v7 = if v6 == nil then dataPoints else v6.dataPoints
	local count = #v7
	local v8 = math.floor(count / 2)

	if v8 < 1 then
		return deriveSimpleSummary(dataPoints)
	end

	local v9 = v8 - 1 + 1
	local v10

	if v9 < 1 then
		v10 = 0
	else
		local total = 0

		for i = 1, v8 do
			total += v7[i].value
		end

		v10 = total / v9
	end

	local v11 = count - v8 + 1
	local v12 = count - v11 + 1
	local v13

	if v12 < 1 then
		v13 = 0
	else
		local total = 0

		for i = v11, count do
			total += v7[i].value
		end

		v13 = total / v12
	end

	return {
		hasData = true,
		latest = v13,
		trendPct = v10 == 0 and 0 or (v13 - v10) / v10,
		priorValue = v10
	}
end

return deriveMetricSummary
