require("@game/CorePackages/Workspace/Packages/_Index/AnalyticsMetricChart/AnalyticsMetricChart/Components/MetricChart/MetricChartTypes")

local v5 = {
	points = {},
	minX = 0,
	maxX = 1,
	minY = 0,
	maxY = 1,
	yTicks = {}
}

local function niceNum(p2, p3)
	if p2 <= 0 then
		return 1
	end

	local v6 = math.floor((math.log(p2, 10)))
	local v7 = p2 / 10 ^ v6

	return (if p3 then v7 < 1.5 and 1 or v7 < 3 and 2 or v7 < 7 and 5 or 10 else v7 <= 1 and 1 or v7 <= 2 and 2 or v7 <= 5 and 5 or 10) * 10 ^ v6
end

local function computeYAxis(value, value2)
	if value2 == value then
		local v6 = value == 0 and 1 or math.abs(value) * 0.5
		return value - v6, value + v6, { value }
	end

	local v6 = (value2 - value) / 2
	local v7

	if v6 <= 0 then
		v7 = 1
	else
		local v8 = math.floor((math.log(v6, 10)))
		local v9 = v6 / 10 ^ v8

		v7 = (v9 < 1.5 and 1 or v9 < 3 and 2 or v9 < 7 and 5 or 10) * 10 ^ v8
	end

	local v8 = math.floor(value / v7) * v7
	local v9 = math.ceil(value2 / v7) * v7

	if v9 - v8 < 2 * v7 then
		v9 = v8 + 2 * v7
	end

	return v8, v9, { v8, (v8 + v9) / 2, v9 }
end

local function deriveChartAxes(list)
	if list == nil or #list == 0 then
		return v5
	end

	local value = list[1].value
	local value2 = list[1].value
	local vector2s = {}

	for k, item in list do
		vector2s[k] = Vector2.new(k - 1, item.value)
		value = math.min(value, item.value)
		value2 = math.max(value2, item.value)
	end

	local v6 = #list
	local v7, v8, v9 = computeYAxis(value, value2)

	local v10 = (v8 - v7) * 0.1

	return {
		points = vector2s,
		minX = 0,
		maxX = math.max(v6 - 1, 1),
		minY = v7 - v10,
		maxY = v8 + v10,
		yTicks = v9
	}
end

return deriveChartAxes
