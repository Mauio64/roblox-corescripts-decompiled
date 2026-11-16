local parent = script:FindFirstAncestor("BuildExperience").Parent

local CreatorAnalytics = require(parent.DataHydration.CreatorAnalytics)
local MetricGranularity = CreatorAnalytics.MetricGranularity

local function toIsoDay(p: number) -- 1 equivalent call inferred from this helper
	return DateTime.fromUnixTimestamp(p):ToIsoDate()
end

local function fillMetricSeriesGaps(p, p2)
	if p == nil or p2 == nil or p.granularity ~= MetricGranularity.OneDay then
		return p
	end

	local v = p2.endUnix - p2.endUnix % 86400
	local v2 = v - p2.lookbackSeconds + 86400

	if v < v2 or (v - v2) / 86400 + 1 > 2000 then
		return p
	end

	local dataPoints = {}

	for _, dataPoint in p.dataPoints do
		local dateTime = DateTime.fromIsoDate(dataPoint.time)

		if dateTime ~= nil then
			dataPoints[dateTime.UnixTimestamp - dateTime.UnixTimestamp % 86400] = dataPoint
		end
	end

	local dataPoints2 = {}

	while v2 <= v do
		local v3 = dataPoints[v2]
		table.insert(dataPoints2, v3 == nil and { time = toIsoDay(v2), value = 0 } or v3) -- inferred equivalent call
		v2 += 86400
	end

	return { dataPoints = dataPoints2, granularity = p.granularity }
end

return fillMetricSeriesGaps
