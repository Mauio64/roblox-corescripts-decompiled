local AnalyticsMetricChart = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/AnalyticsMetricChart")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local useMetricChartContent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Chart/useMetricChartContent")

local deriveChartAxes = AnalyticsMetricChart.deriveChartAxes

local function useMetricChartViewModel(p2)
	local v5 = useMetricChartContent(p2)
	local v6 = Foundation.Hooks.useTokens()
	local v7 = Foundation.Hooks.useTextSizeOffset()

	local bodySmall = v6.Typography.BodySmall
	local font = bodySmall.Font

	local v8 = bodySmall.FontSize + (v7 or 0)

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)

	local v9 = if v5.series ~= nil then v5.series[1] else nil
	local points = if v9 ~= nil then v9.points else nil
	local v10 = React.useMemo(function()
		return deriveChartAxes(points)
	end, { points })
	local count = #v10.points

	local v11 = React.useCallback(function(p3)
		if count == 0 then
			return
		end

		setState((math.clamp(math.round(p3.X) + 1, 1, count)))
	end, { count })

	local v12 = React.useCallback(function()
		if not state2 then
			setState(nil)
		end
	end, { state2 })

	local v13 = React.useCallback(function(p3)
		setState2(true)
		v11(p3)
	end, { v11 })

	local v14 = React.useCallback(function()
		setState2(false)
		setState(nil)
	end, {})

	local v15 = { v5.plotId }

	if points ~= nil then
		for k, point in points do
			table.insert(v15, `{point.time}:{point.value}`)
		end
	end

	local joined = table.concat(v15, "|")

	local v16 = {}

	for k, yTick in v10.yTicks do
		v16[k] = {
			position = yTick,
			label = v5.yAxisFormatter({ value = yTick })
		}
	end

	local v17 = {}

	if points ~= nil then
		for k, point in points do
			v17[k] = v5.xAxisFormatter({ value = point.time })
		end
	end

	local v18

	if not (state == nil or points == nil or not (state >= 1 and state <= #points)) then
		local point = points[state]
		v18 = {
			date = v5.tooltipFormatters.formatXForPoint(point.time),
			valueText = 0
		}
		local formatSeriesValueForPoint = v5.tooltipFormatters.formatSeriesValueForPoint
		local v19 = { y = point.value, seriesId = 0 }
		local v20 = if v9 ~= nil then v9.id else nil
		v19.seriesId = v20
		v18.valueText = formatSeriesValueForPoint(v19)
	end

	local success = v6.Color.System.Success

	return {
		layoutOrder = v5.layoutOrder,
		plotKey = joined,
		title = v5.title,
		summary = v5.summary,
		valueText = v5.valueText,
		icon = v5.icon,
		deltaText = v5.deltaText,
		isDeltaPositive = v5.isDeltaPositive,
		hasData = v5.hasData,
		points = v10.points,
		minX = v10.minX,
		maxX = v10.maxX,
		minY = v10.minY,
		maxY = v10.maxY,
		yTicks = v16,
		xAxisLabels = v17,
		labelFont = font,
		labelFontSize = v8,
		inspectedIndex = state,
		tooltip = v18,
		onHoverStart = v11,
		onHoverMoved = v11,
		onHoverEnded = v12,
		onPress = v11,
		onDragStart = v13,
		onDragMoved = v11,
		onDragEnded = v14,
		colors = {
			line = v6.Color.System.Emphasis,
			grid = v6.Color.Stroke.Default,
			axisLabel = v6.Color.Content.Default,
			muted = v6.Color.Content.Muted,
			emphasis = v6.Color.Content.Emphasis,
			surface = v6.Color.Surface.Surface_100,
			positive = success,
			positiveBackground = {
				Color3 = success.Color3,
				Transparency = v6.Color.Shift.Shift_300.Transparency
			},
			tooltipBackground = v6.Color.System.Contrast,
			tooltipContent = v6.Inverse.Content.Emphasis
		},
		testId = v5.testId
	}
end

return useMetricChartViewModel
