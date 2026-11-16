local parent = script:FindFirstAncestor("BuildExperience").Parent

local AnalyticsMetricChart = require(parent.AnalyticsMetricChart)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useMetricChartContent = require(script.Parent.useMetricChartContent)

local deriveChartAxes = AnalyticsMetricChart.deriveChartAxes

local function useMetricChartViewModel(p)
	local v = useMetricChartContent(p)
	local v2 = Foundation.Hooks.useTokens()
	local v3 = Foundation.Hooks.useTextSizeOffset()

	local bodySmall = v2.Typography.BodySmall
	local labelFont = bodySmall.Font

	if not FoundationFontFaceMigration and typeof(labelFont) ~= "EnumItem" then
		labelFont = Enum.Font.BuilderSans
	end

	local labelFontSize = bodySmall.FontSize + (v3 or 0)

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)
	local v4

	if v.series ~= nil then
		v4 = v.series[1]
	end

	local points

	if v4 == nil then
		points = nil
	else
		points = v4.points
	end

	local v5 = React.useMemo(function()
		return deriveChartAxes(points)
	end, { points })
	local count = #v5.points

	local v6 = React.useCallback(function(vector2: Vector2)
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
		v6(vector2)
	end, { v6 })

	local onDragEnded = React.useCallback(function()
		setState2(false)
		setState(nil)
	end, {})

	local v7 = { v.plotId }

	if points ~= nil then
		for _, point in points do
			table.insert(v7, `{point.time}:{point.value}`)
		end
	end

	local joined = table.concat(v7, "|")

	local yTicks = {}

	for k, yTick in v5.yTicks do
		yTicks[k] = {
			position = yTick,
			label = v.yAxisFormatter({ value = yTick })
		}
	end

	local xAxisLabels = {}

	if points ~= nil then
		for k, point in points do
			xAxisLabels[k] = v.xAxisFormatter({ value = point.time })
		end
	end

	local tooltip

	if not (state == nil or points == nil or not (state >= 1 and state <= #points)) then
		local point = points[state]
		tooltip = {
			date = v.tooltipFormatters.formatXForPoint(point.time),
			valueText = 0
		}
		local formatSeriesValueForPoint = v.tooltipFormatters.formatSeriesValueForPoint
		local v8 = { y = point.value, seriesId = 0 }
		local seriesId

		if v4 ~= nil then
			seriesId = v4.id
		end

		v8.seriesId = seriesId
		tooltip.valueText = formatSeriesValueForPoint(v8)
	end

	local success = v2.Color.System.Success

	return {
		layoutOrder = v.layoutOrder,
		plotKey = joined,
		title = v.title,
		summary = v.summary,
		valueText = v.valueText,
		icon = v.icon,
		deltaText = v.deltaText,
		isDeltaPositive = v.isDeltaPositive,
		hasData = v.hasData,
		points = v5.points,
		minX = v5.minX,
		maxX = v5.maxX,
		minY = v5.minY,
		maxY = v5.maxY,
		yTicks = yTicks,
		xAxisLabels = xAxisLabels,
		labelFont = labelFont,
		labelFontSize = labelFontSize,
		inspectedIndex = state,
		tooltip = tooltip,
		onHoverStart = v6,
		onHoverMoved = v6,
		onHoverEnded = onHoverEnded,
		onPress = v6,
		onDragStart = onDragStart,
		onDragMoved = v6,
		onDragEnded = onDragEnded,
		colors = {
			line = v2.Color.System.Emphasis,
			grid = v2.Color.Stroke.Default,
			axisLabel = v2.Color.Content.Default,
			muted = v2.Color.Content.Muted,
			emphasis = v2.Color.Content.Emphasis,
			surface = v2.Color.Surface.Surface_100,
			positive = success,
			positiveBackground = {
				Color3 = success.Color3,
				Transparency = v2.Color.Shift.Shift_300.Transparency
			},
			tooltipBackground = v2.Color.System.Contrast,
			tooltipContent = v2.Inverse.Content.Emphasis
		},
		testId = v.testId
	}
end

return useMetricChartViewModel
