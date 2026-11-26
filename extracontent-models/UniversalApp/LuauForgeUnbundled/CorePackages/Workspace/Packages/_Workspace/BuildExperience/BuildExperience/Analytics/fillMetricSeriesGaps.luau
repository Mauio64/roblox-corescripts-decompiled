local metricGranularity = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics").MetricGranularity

local function toIsoDay(p2)
	return DateTime.fromUnixTimestamp(p2):ToIsoDate()
end

local function fillMetricSeriesGaps(p2, p3)
	if p2 == nil or p3 == nil or p2.granularity ~= metricGranularity.OneDay then
		return p2
	end

	local v5 = p3.endUnix - p3.endUnix % 86400
	local v6 = v5 - p3.lookbackSeconds + 86400

	if v5 < v6 or (v5 - v6) / 86400 + 1 > 2000 then
		return p2
	end

	local dataPoints = {}

	for k, dataPoint in p2.dataPoints do
		local dateTime = DateTime.fromIsoDate(dataPoint.time)

		if dateTime ~= nil then
			dataPoints[dateTime.UnixTimestamp - dateTime.UnixTimestamp % 86400] = dataPoint
		end
	end

	local v7 = {}

	while v6 <= v5 do
		local v8 = dataPoints[v6]
		table.insert(
			v7,
			v8 == nil and {
				time = DateTime.fromUnixTimestamp(v6):ToIsoDate(),
				value = 0
			} or v8
		)
		v6 += 86400
	end

	return { dataPoints = v7, granularity = p2.granularity }
end

return fillMetricSeriesGaps
