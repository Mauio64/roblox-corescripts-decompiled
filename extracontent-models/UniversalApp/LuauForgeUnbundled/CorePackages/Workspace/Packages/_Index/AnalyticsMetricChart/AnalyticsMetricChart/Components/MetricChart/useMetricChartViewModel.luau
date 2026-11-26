local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AnalyticsMetricChart/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AnalyticsMetricChart/React")

require("@game/CorePackages/Workspace/Packages/_Index/AnalyticsMetricChart/AnalyticsMetricChart/Components/MetricChart/MetricChartTypes")
require("@game/CorePackages/Workspace/Packages/_Index/AnalyticsMetricChart/AnalyticsMetricChart/Components/MetricChart/MetricChartView")
local deriveChartAxes = require("@game/CorePackages/Workspace/Packages/_Index/AnalyticsMetricChart/AnalyticsMetricChart/Utils/deriveChartAxes")

local function useMetricChartViewModel(data)
	local v5 = Foundation.Hooks.useTokens()
	local v6 = Foundation.Hooks.useTextSizeOffset()

	local bodySmall = v5.Typography.BodySmall
	local font = bodySmall.Font

	local v7 = bodySmall.FontSize + (v6 or 0)

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)

	local v8 = if data.series ~= nil then data.series[1] else nil
	local points = if v8 ~= nil then v8.points else nil
	local v9 = React.useMemo(function()
		return deriveChartAxes(points)
	end, { points })
	local count = #v9.points

	local v10 = React.useCallback(function(p2)
		if count == 0 then
			return
		end

		setState((math.clamp(math.round(p2.X) + 1, 1, count)))
	end, { count })

	local v11 = React.useCallback(function()
		if not state2 then
			setState(nil)
		end
	end, { state2 })

	local v12 = React.useCallback(function(p2)
		setState2(true)
		v10(p2)
	end, { v10 })

	local v13 = React.useCallback(function()
		setState2(false)
		setState(nil)
	end, {})

	local v14 = { data.plotId }

	if points ~= nil then
		for k, point in points do
			table.insert(v14, `{point.time}:{point.value}`)
		end
	end

	local joined = table.concat(v14, "|")

	local v15 = {}

	for k, yTick in v9.yTicks do
		v15[k] = {
			position = yTick,
			label = data.yAxisFormatter({ value = yTick })
		}
	end

	local v16 = {}

	if points ~= nil then
		for k, point in points do
			v16[k] = data.xAxisFormatter({ value = point.time })
		end
	end

	local v17

	if not (state == nil or points == nil or not (state >= 1 and state <= #points)) then
		local point = points[state]
		v17 = {
			date = data.tooltipFormatters.formatXForPoint(point.time),
			valueText = 0
		}
		local formatSeriesValueForPoint = data.tooltipFormatters.formatSeriesValueForPoint
		local v18 = { y = point.value, seriesId = 0 }
		local v19 = if v8 ~= nil then v8.id else nil
		v18.seriesId = v19
		v17.valueText = formatSeriesValueForPoint(v18)
	end

	local success = v5.Color.System.Success

	return {
		layoutOrder = data.layoutOrder,
		plotKey = joined,
		title = data.title,
		summary = data.summary,
		valueText = data.valueText,
		icon = data.icon,
		deltaText = data.deltaText,
		isDeltaPositive = data.isDeltaPositive,
		hasData = data.hasData,
		hideHeader = data.hideHeader == true,
		points = v9.points,
		minX = v9.minX,
		maxX = v9.maxX,
		minY = v9.minY,
		maxY = v9.maxY,
		yTicks = v15,
		xAxisLabels = v16,
		labelFont = font,
		labelFontSize = v7,
		inspectedIndex = state,
		tooltip = v17,
		onHoverStart = v10,
		onHoverMoved = v10,
		onHoverEnded = v11,
		onPress = v10,
		onDragStart = v12,
		onDragMoved = v10,
		onDragEnded = v13,
		colors = {
			line = v5.Color.System.Emphasis,
			grid = v5.Color.Stroke.Default,
			axisLabel = v5.Color.Content.Default,
			muted = v5.Color.Content.Muted,
			emphasis = v5.Color.Content.Emphasis,
			surface = v5.Color.Surface.Surface_100,
			positive = success,
			positiveBackground = {
				Color3 = success.Color3,
				Transparency = v5.Color.Shift.Shift_300.Transparency
			},
			tooltipBackground = v5.Color.System.Contrast,
			tooltipContent = v5.Inverse.Content.Emphasis
		},
		testId = data.testId
	}
end

return useMetricChartViewModel
