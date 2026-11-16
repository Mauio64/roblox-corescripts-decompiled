local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorAnalytics = require(parent.DataHydration.CreatorAnalytics)
local MetricGranularity = CreatorAnalytics.MetricGranularity
local fillMetricSeriesGaps = require(BuildExperience.Analytics.fillMetricSeriesGaps)

local v = { hasData = false, latest = nil, trendPct = 0, priorValue = nil }

local function deriveSimpleSummary(dataPoints)
	local clone = table.clone(dataPoints)
	table.sort(clone, function(a, b): boolean
		return a.time < b.time
	end)

	local value = clone[1].value
	local latest = clone[#clone].value

	return {
		hasData = true,
		latest = latest,
		trendPct = (value == nil or value == 0) and 0 or (latest - value) / value,
		priorValue = nil
	}
end

local function averageRange(list, p: number, p2: number) -- 2 equivalent calls inferred from this helper
	local v2 = p2 - p + 1

	if v2 < 1 then
		return 0
	end

	local total = 0

	for i = p, p2 do
		total += list[i].value
	end

	return total / v2
end

local function deriveMetricSummary(p, p2)
	local dataPoints

	if p ~= nil then
		dataPoints = p.dataPoints
	end

	if dataPoints == nil or #dataPoints == 0 then
		return v
	end

	if p2 == nil or p ~= nil and p.granularity ~= MetricGranularity.OneDay then
		return deriveSimpleSummary(dataPoints)
	end

	local v2 = fillMetricSeriesGaps(p, {
		lookbackSeconds = p2.lookbackSeconds * 2,
		endUnix = p2.endUnix
	})

	local v3 = if v2 == nil then dataPoints else v2.dataPoints
	local count = #v3
	local v4 = math.floor(count / 2)

	if v4 < 1 then
		return deriveSimpleSummary(dataPoints)
	end

	local priorValue = averageRange(v3, 1, v4) -- inferred equivalent call
	local latest = averageRange(v3, count - v4 + 1, count) -- inferred equivalent call

	return {
		hasData = true,
		latest = latest,
		trendPct = priorValue == 0 and 0 or (latest - priorValue) / priorValue,
		priorValue = priorValue
	}
end

return deriveMetricSummary
