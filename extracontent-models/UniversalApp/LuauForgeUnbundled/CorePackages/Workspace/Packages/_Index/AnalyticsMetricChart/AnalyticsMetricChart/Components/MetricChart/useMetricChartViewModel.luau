local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AnalyticsMetricChart/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AnalyticsMetricChart/React")

local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

require("@game/CorePackages/Workspace/Packages/_Index/AnalyticsMetricChart/AnalyticsMetricChart/Components/MetricChart/MetricChartTypes")
require("@game/CorePackages/Workspace/Packages/_Index/AnalyticsMetricChart/AnalyticsMetricChart/Components/MetricChart/MetricChartView")
local deriveChartAxes = require("@game/CorePackages/Workspace/Packages/_Index/AnalyticsMetricChart/AnalyticsMetricChart/Utils/deriveChartAxes")

local function useMetricChartViewModel(data)
	local v5 = Foundation.Hooks.useTokens()
	local v6 = Foundation.Hooks.useTextSizeOffset()

	local bodySmall = v5.Typography.BodySmall
	local v7 = bodySmall.Font

	if not foundationFontFaceMigration and typeof(v7) ~= "EnumItem" then
		v7 = Enum.Font.BuilderSans
	end

	local v8 = bodySmall.FontSize + (v6 or 0)

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)

	local v9 = if data.series ~= nil then data.series[1] else nil
	local points = if v9 ~= nil then v9.points else nil
	local v10 = React.useMemo(function()
		return deriveChartAxes(points)
	end, { points })
	local count = #v10.points

	local v11 = React.useCallback(function(p2)
		if count == 0 then
			return
		end

		setState((math.clamp(math.round(p2.X) + 1, 1, count)))
	end, { count })

	local v12 = React.useCallback(function()
		if not state2 then
			setState(nil)
		end
	end, { state2 })

	local v13 = React.useCallback(function(p2)
		setState2(true)
		v11(p2)
	end, { v11 })

	local v14 = React.useCallback(function()
		setState2(false)
		setState(nil)
	end, {})

	local v15 = { data.plotId }

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
			label = data.yAxisFormatter({ value = yTick })
		}
	end

	local v17 = {}

	if points ~= nil then
		for k, point in points do
			v17[k] = data.xAxisFormatter({ value = point.time })
		end
	end

	local v18

	if not (state == nil or points == nil or not (state >= 1 and state <= #points)) then
		local point = points[state]
		v18 = {
			date = data.tooltipFormatters.formatXForPoint(point.time),
			valueText = 0
		}
		local formatSeriesValueForPoint = data.tooltipFormatters.formatSeriesValueForPoint
		local v19 = { y = point.value, seriesId = 0 }
		local v20 = if v9 ~= nil then v9.id else nil
		v19.seriesId = v20
		v18.valueText = formatSeriesValueForPoint(v19)
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
		points = v10.points,
		minX = v10.minX,
		maxX = v10.maxX,
		minY = v10.minY,
		maxY = v10.maxY,
		yTicks = v16,
		xAxisLabels = v17,
		labelFont = v7,
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
