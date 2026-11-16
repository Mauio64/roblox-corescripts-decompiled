local parent = script:FindFirstAncestor("Moments").Parent

require(parent.AnalyticsMetricChart)
require(parent.DataHydration.CreatorAnalytics)

local function toRfc3339(p: number) -- 1 equivalent call inferred from this helper
	return (os.date("!%Y-%m-%dT%H:%M:%SZ", p))
end

local function metricSeriesToChartPoints(p, data)
	local v = {}

	if p ~= nil then
		for _, dataPoint in p.dataPoints do
			local dateTime = DateTime.fromIsoDate(dataPoint.time)

			if not (dateTime ~= nil and type(dataPoint.value) == "number") then
				continue
			end

			local v2 = math.floor(dateTime.UnixTimestamp / data.bucketSeconds) * data.bucketSeconds
			v[v2] = (v[v2] or 0) + dataPoint.value
		end
	end

	local v2 = math.floor(data.startUnix / data.bucketSeconds) * data.bucketSeconds
	local total = 0
	local points = {}
	local hasData = false

	while v2 < data.endUnix do
		local v3 = v[v2]

		if v3 == nil then
			v3 = 0
		else
			hasData = true
		end

		total += v3
		table.insert(points, { time = toRfc3339(v2), value = v3 }) -- inferred equivalent call
		v2 += data.bucketSeconds
	end

	return { points = points, total = total, hasData = hasData }
end

return metricSeriesToChartPoints
