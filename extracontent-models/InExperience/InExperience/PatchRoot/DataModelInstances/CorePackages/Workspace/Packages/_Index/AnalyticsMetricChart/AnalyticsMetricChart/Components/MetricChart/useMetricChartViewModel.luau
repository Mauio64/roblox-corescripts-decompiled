local AnalyticsMetricChart = script:FindFirstAncestor("AnalyticsMetricChart")
local parent = AnalyticsMetricChart.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

require(script.Parent.MetricChartTypes)
require(script.Parent.MetricChartView)
local deriveChartAxes = require(AnalyticsMetricChart.Utils.deriveChartAxes)

local function useMetricChartViewModel(data)
	local v = Foundation.Hooks.useTokens()
	local v2 = Foundation.Hooks.useTextSizeOffset()

	local bodySmall = v.Typography.BodySmall
	local font = bodySmall.Font

	local labelFontSize = bodySmall.FontSize + (v2 or 0)

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)
	local v3

	if data.series ~= nil then
		v3 = data.series[1]
	end

	local points

	if v3 == nil then
		points = nil
	else
		points = v3.points
	end

	local v4 = React.useMemo(function()
		return deriveChartAxes(points)
	end, { points })
	local count = #v4.points

	local v5 = React.useCallback(function(vector2: Vector2)
		if count == 0 then
			return
		end

		setState((math.clamp(math.round(vector2.X) + 1, 1, count)))
	end, { count })

	local onHoverEnded = React.useCallback(function()
		if not state2 then
			setState(nil)
		end
	end, { state2 })

	local onDragStart = React.useCallback(function(vector2: Vector2)
		setState2(true)
		v5(vector2)
	end, { v5 })

	local onDragEnded = React.useCallback(function()
		setState2(false)
		setState(nil)
	end, {})

	local v6 = { data.plotId }

	if points ~= nil then
		for _, point in points do
			table.insert(v6, `{point.time}:{point.value}`)
		end
	end

	local joined = table.concat(v6, "|")

	local yTicks = {}

	for k, yTick in v4.yTicks do
		yTicks[k] = {
			position = yTick,
			label = data.yAxisFormatter({ value = yTick })
		}
	end

	local xAxisLabels = {}

	if points ~= nil then
		for k, point in points do
			xAxisLabels[k] = data.xAxisFormatter({ value = point.time })
		end
	end

	local tooltip

	if not (state == nil or points == nil or not (state >= 1 and state <= #points)) then
		local point = points[state]
		tooltip = {
			date = data.tooltipFormatters.formatXForPoint(point.time),
			valueText = 0
		}
		local formatSeriesValueForPoint = data.tooltipFormatters.formatSeriesValueForPoint
		local v7 = { y = point.value, seriesId = 0 }
		local seriesId

		if v3 ~= nil then
			seriesId = v3.id
		end

		v7.seriesId = seriesId
		tooltip.valueText = formatSeriesValueForPoint(v7)
	end

	local success = v.Color.System.Success

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
		points = v4.points,
		minX = v4.minX,
		maxX = v4.maxX,
		minY = v4.minY,
		maxY = v4.maxY,
		yTicks = yTicks,
		xAxisLabels = xAxisLabels,
		labelFont = font,
		labelFontSize = labelFontSize,
		inspectedIndex = state,
		tooltip = tooltip,
		onHoverStart = v5,
		onHoverMoved = v5,
		onHoverEnded = onHoverEnded,
		onPress = v5,
		onDragStart = onDragStart,
		onDragMoved = v5,
		onDragEnded = onDragEnded,
		colors = {
			line = v.Color.System.Emphasis,
			grid = v.Color.Stroke.Default,
			axisLabel = v.Color.Content.Default,
			muted = v.Color.Content.Muted,
			emphasis = v.Color.Content.Emphasis,
			surface = v.Color.Surface.Surface_100,
			positive = success,
			positiveBackground = {
				Color3 = success.Color3,
				Transparency = v.Color.Shift.Shift_300.Transparency
			},
			tooltipBackground = v.Color.System.Contrast,
			tooltipContent = v.Inverse.Content.Emphasis
		},
		testId = data.testId
	}
end

return useMetricChartViewModel
