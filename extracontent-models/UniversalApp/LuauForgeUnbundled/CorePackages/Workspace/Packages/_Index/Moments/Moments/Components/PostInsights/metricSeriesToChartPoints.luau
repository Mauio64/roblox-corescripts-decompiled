require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/AnalyticsMetricChart")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/CreatorAnalytics")

local function toRfc3339(p2)
	return os.date("!%Y-%m-%dT%H:%M:%SZ", p2)
end

local function metricSeriesToChartPoints(p2, data)
	local v5 = {}

	if p2 ~= nil then
		for k, dataPoint in p2.dataPoints do
			local dateTime = DateTime.fromIsoDate(dataPoint.time)

			if not (dateTime ~= nil and type(dataPoint.value) == "number") then
				continue
			end

			local v6 = math.floor(dateTime.UnixTimestamp / data.bucketSeconds) * data.bucketSeconds
			v5[v6] = (v5[v6] or 0) + dataPoint.value
		end
	end

	local v6 = math.floor(data.startUnix / data.bucketSeconds) * data.bucketSeconds
	local total = 0
	local v7 = {}
	local v8 = false

	while v6 < data.endUnix do
		local v9 = v5[v6]

		if v9 == nil then
			v9 = 0
		else
			v8 = true
		end

		total += v9
		table.insert(v7, {
			time = os.date("!%Y-%m-%dT%H:%M:%SZ", v6),
			value = v9
		})
		v6 += data.bucketSeconds
	end

	return { points = v7, total = total, hasData = v8 }
end

return metricSeriesToChartPoints
