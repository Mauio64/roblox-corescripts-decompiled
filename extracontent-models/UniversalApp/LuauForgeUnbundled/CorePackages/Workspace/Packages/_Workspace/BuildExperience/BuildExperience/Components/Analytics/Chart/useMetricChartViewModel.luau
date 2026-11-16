local AnalyticsMetricChart = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/AnalyticsMetricChart")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useMetricChartContent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Chart/useMetricChartContent")

local deriveChartAxes = AnalyticsMetricChart.deriveChartAxes

local function useMetricChartViewModel(p2)
	local v5 = useMetricChartContent(p2)
	local v6 = Foundation.Hooks.useTokens()
	local v7 = Foundation.Hooks.useTextSizeOffset()

	local bodySmall = v6.Typography.BodySmall
	local v8 = bodySmall.Font

	if not foundationFontFaceMigration and typeof(v8) ~= "EnumItem" then
		v8 = Enum.Font.BuilderSans
	end

	local v9 = bodySmall.FontSize + (v7 or 0)

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)

	local v10 = if v5.series ~= nil then v5.series[1] else nil
	local points = if v10 ~= nil then v10.points else nil
	local v11 = React.useMemo(function()
		return deriveChartAxes(points)
	end, { points })
	local count = #v11.points

	local v12 = React.useCallback(function(p3)
		if count == 0 then
			return
		end

		setState((math.clamp(math.round(p3.X) + 1, 1, count)))
	end, { count })

	local v13 = React.useCallback(function()
		if not state2 then
			setState(nil)
		end
	end, { state2 })

	local v14 = React.useCallback(function(p3)
		setState2(true)
		v12(p3)
	end, { v12 })

	local v15 = React.useCallback(function()
		setState2(false)
		setState(nil)
	end, {})

	local v16 = { v5.plotId }

	if points ~= nil then
		for k, point in points do
			table.insert(v16, `{point.time}:{point.value}`)
		end
	end

	local joined = table.concat(v16, "|")

	local v17 = {}

	for k, yTick in v11.yTicks do
		v17[k] = {
			position = yTick,
			label = v5.yAxisFormatter({ value = yTick })
		}
	end

	local v18 = {}

	if points ~= nil then
		for k, point in points do
			v18[k] = v5.xAxisFormatter({ value = point.time })
		end
	end

	local v19

	if not (state == nil or points == nil or not (state >= 1 and state <= #points)) then
		local point = points[state]
		v19 = {
			date = v5.tooltipFormatters.formatXForPoint(point.time),
			valueText = 0
		}
		local formatSeriesValueForPoint = v5.tooltipFormatters.formatSeriesValueForPoint
		local v20 = { y = point.value, seriesId = 0 }
		local v21 = if v10 ~= nil then v10.id else nil
		v20.seriesId = v21
		v19.valueText = formatSeriesValueForPoint(v20)
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
		points = v11.points,
		minX = v11.minX,
		maxX = v11.maxX,
		minY = v11.minY,
		maxY = v11.maxY,
		yTicks = v17,
		xAxisLabels = v18,
		labelFont = v8,
		labelFontSize = v9,
		inspectedIndex = state,
		tooltip = v19,
		onHoverStart = v12,
		onHoverMoved = v12,
		onHoverEnded = v13,
		onPress = v12,
		onDragStart = v14,
		onDragMoved = v12,
		onDragEnded = v15,
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
