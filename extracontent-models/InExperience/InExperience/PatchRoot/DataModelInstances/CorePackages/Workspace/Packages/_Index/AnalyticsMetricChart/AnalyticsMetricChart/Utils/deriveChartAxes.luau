local AnalyticsMetricChart = script:FindFirstAncestor("AnalyticsMetricChart")

require(AnalyticsMetricChart.Components.MetricChart.MetricChartTypes)

local v = {
	points = {},
	minX = 0,
	maxX = 1,
	minY = 0,
	maxY = 1,
	yTicks = {}
}

local function niceNum(p: number, flag: boolean)
	if p <= 0 then
		return 1
	end

	local v2 = math.floor((math.log(p, 10)))
	local v3 = p / 10 ^ v2
	local v4

	if flag then
		if v3 < 1.5 then
			v4 = 1
		elseif v3 < 3 then
			v4 = 2
		else
			v4 = if v3 < 7 then 5 else 10
		end
	elseif v3 <= 1 then
		v4 = 1
	elseif v3 <= 2 then
		v4 = 2
	else
		v4 = if v3 <= 5 then 5 else 10
	end

	return v4 * 10 ^ v2
end

local function computeYAxis(value: number, value2: number)
	if value2 == value then
		local v2 = value == 0 and 1 or math.abs(value) * 0.5
		return value - v2, value + v2, { value }
	end

	local v2 = (value2 - value) / 2
	local v3

	if v2 <= 0 then
		v3 = 1
	else
		local v4 = math.floor((math.log(v2, 10)))
		local v5 = v2 / 10 ^ v4

		v3 = (v5 < 1.5 and 1 or v5 < 3 and 2 or v5 < 7 and 5 or 10) * 10 ^ v4
	end

	local v4 = math.floor(value / v3) * v3
	local selected = math.ceil(value2 / v3) * v3

	if selected - v4 < v3 * 2 then
		selected = v4 + v3 * 2
	end

	return v4, selected, { v4, (v4 + selected) / 2, selected }
end

local function deriveChartAxes(list)
	if list == nil or #list == 0 then
		return v
	end

	local value = list[1].value
	local value2 = list[1].value
	local vector2s = {}

	for k, item in list do
		vector2s[k] = Vector2.new(k - 1, item.value)
		value = math.min(value, item.value)
		value2 = math.max(value2, item.value)
	end

	local v2 = #list
	local v3, v4, yTicks = computeYAxis(value, value2)

	local v5 = (v4 - v3) * 0.1

	return {
		points = vector2s,
		minX = 0,
		maxX = math.max(v2 - 1, 1),
		minY = v3 - v5,
		maxY = v4 + v5,
		yTicks = yTicks
	}
end

return deriveChartAxes
