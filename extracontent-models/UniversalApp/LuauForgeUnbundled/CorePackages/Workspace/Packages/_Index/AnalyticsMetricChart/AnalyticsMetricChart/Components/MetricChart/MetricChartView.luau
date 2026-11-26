local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AnalyticsMetricChart/Foundation")
local Graphing = require("@game/CorePackages/Workspace/Packages/_Workspace/AnalyticsMetricChart/Graphing")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AnalyticsMetricChart/React")
local Style = require("@game/CorePackages/Workspace/Packages/_Workspace/AnalyticsMetricChart/Style")

local chartLayout = require("@game/CorePackages/Workspace/Packages/_Index/AnalyticsMetricChart/AnalyticsMetricChart/Components/MetricChart/chartLayout")

local canvas = Graphing.Canvas
local curve = Graphing.Curve
local gridLine = Graphing.GridLine
local inputDetector = Graphing.InputDetector
local point = Graphing.Point

local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local iconVariant = Foundation.Enums.IconVariant

local PLOT_HEIGHT = chartLayout.PLOT_HEIGHT

local v5 = PLOT_HEIGHT - 28
local v6 = v5 + -1

local function renderTooltip(mapped, tooltip, colors, testId, icon2, onAbsoluteSizeChanged)
	local createElement = React.createElement
	local v8 = {
		Size = UDim2.fromOffset(0, 30),
		Position = mapped,
		ZIndex = 30,
		backgroundStyle = colors.tooltipBackground,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		tag = "row align-y-center gap-large anchor-top-center auto-x padding-x-xsmall radius-small",
		testId = `{testId}.Tooltip`
	}
	local v9 = {
		Date = React.createElement(text, {
			LayoutOrder = 1,
			Text = tooltip.date,
			tag = "auto-xy text-caption-medium content-inverse-default",
			testId = `{testId}.TooltipDate`
		}),
		ValueGroup = 0
	}

	local createElement2 = React.createElement

	local v13 = if icon2 ~= nil then React.createElement(icon, {
		LayoutOrder = 1,
		name = icon2,
		size = iconSize.XSmall,
		style = colors.tooltipContent,
		testId = `{testId}.TooltipIcon`
	}) else nil
	v9.ValueGroup = createElement2(
		view,
		{ LayoutOrder = 2, tag = "row align-y-center gap-xsmall auto-xy" },
		{
			Icon = v13,
			Value = React.createElement(text, {
				LayoutOrder = 2,
				Text = tooltip.valueText,
				tag = "auto-xy text-caption-medium content-inverse-emphasis",
				testId = `{testId}.TooltipValue`
			})
		}
	)
	return createElement(view, v8, v9)
end

local function renderTitleBlock(p2, p3)
	return React.createElement(text, {
		LayoutOrder = 1,
		Text = p2.title,
		tag = "size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end content-default",
		testId = `{p3}.Title`
	})
end

local function renderSummary(p2, p3)
	return React.createElement(text, {
		LayoutOrder = 2,
		Text = p2.summary,
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
		testId = `{p3}.Summary`
	})
end

local function renderValueRow(props, testId)
	local colors = props.colors
	local createElement = React.createElement

	local createElement2 = React.createElement

	local v13 = if props.icon ~= nil then React.createElement(icon, {
		LayoutOrder = 1,
		name = props.icon,
		size = iconSize.Medium,
		style = colors.emphasis,
		testId = `{testId}.Icon`
	}) else nil
	local v9 = {
		Stat = createElement2(view, {
			LayoutOrder = 1,
			tag = "row align-y-center gap-xsmall auto-xy"
		}, {
			Icon = v13,
			Value = React.createElement(text, {
				LayoutOrder = 2,
				Text = props.valueText,
				tag = "auto-xy text-heading-large content-emphasis",
				testId = `{testId}.Value`
			})
		}),
		Delta = 0
	}
	local v14

	if props.deltaText ~= nil then
		local createElement3 = React.createElement
		local v16 = {
			LayoutOrder = 2,
			tag = {
				["row align-y-center gap-xxsmall auto-xy padding-y-xxsmall padding-left-xsmall padding-right-small radius-small"] = true,
				["bg-shift-200"] = not props.isDeltaPositive
			},
			backgroundStyle = 0,
			testId = 0
		}

		local v17 = if props.isDeltaPositive then colors.positiveBackground else nil
		v16.backgroundStyle = v17
		v16.testId = `{testId}.Delta`

		local createElement4 = React.createElement

		local v20 = if props.isDeltaPositive then iconName.ArrowWideShortUp else iconName.ArrowWideShortDown
		local v19 = {
			LayoutOrder = 1,
			name = v20,
			size = iconSize.XSmall,
			variant = iconVariant.Filled,
			style = 0
		}
		local v21 = if props.isDeltaPositive then colors.positive else colors.muted
		v19.style = v21
		v14 = createElement3(view, v16, {
			Arrow = createElement4(icon, v19),
			Value = React.createElement(text, {
				LayoutOrder = 2,
				Text = props.deltaText,
				tag = "auto-xy text-caption-medium content-default"
			})
		})
	end

	v9.Delta = v14
	return createElement(
		view,
		{ LayoutOrder = 1, tag = "row align-y-center gap-small size-full-0 auto-y" },
		v9
	)
end

local function measureGutter(yTicks, labelFontSize, labelFont)
	local maxX = 0

	for k, item in yTicks do
		maxX = math.max(
			maxX,
			Style.GetTextSize(item.label, labelFontSize, labelFont, Vector2.new(1000, 100), {
				addTemporaryPadding = false
			}).X
		)
	end

	return (math.max(60, (math.ceil)(maxX) + 2 + 12))
end

local function renderYAxisLabels(props)
	local axisLabel = props.colors.axisLabel
	local v7 = PLOT_HEIGHT - 12 - 28
	local v8 = math.max(props.maxY - props.minY, 1e-6)

	local children = {}

	for k, yTick in props.yTicks do
		local v9 = 12 + (props.maxY - yTick.position) / v8 * v7
		children[`YLabel_{yTick.position}`] = React.createElement(text, {
			Position = UDim2.new(0, 2, 0, v9),
			Text = yTick.label,
			textStyle = axisLabel,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			tag = "anchor-center-left auto-xy text-body-small",
			ZIndex = 4
		})
	end

	return children
end

local function selectXAxisTicks(xAxisLabels, p2, p3, p4)
	local count = #xAxisLabels

	if count <= 2 or p2 <= 0 then
		return {}
	end

	local maxX = 0

	for k, item in xAxisLabels do
		maxX = math.max(
			maxX,
			Style.GetTextSize(item, p3, p4, Vector2.new(1000, 100), {
				addTemporaryPadding = false
			}).X
		)
	end

	if p2 < maxX then
		return {}
	end

	local v7 = maxX + 24
	local v8 = p2 / (count - 1)

	for i = math.min(3, count - 2), 1, -1 do
		local set = {}
		local v9 = {}

		for j = 1, i do
			local v10 = math.clamp(math.round(count * j / (i + 1)), 1, count - 2)

			if set[v10] then
				continue
			end

			set[v10] = true
			table.insert(v9, v10)
		end

		local v10 = #v9 == i

		for j = 2, #v9 do
			if (v9[j] - v9[j - 1]) * v8 < v7 then
				v10 = false
				break
			end
		end

		if v10 then
			local result = {}

			for k, v11 in v9 do
				table.insert(result, {
					position = v11,
					label = xAxisLabels[v11 + 1]
				})
			end

			return result
		end
	end

	return {}
end

local function renderXAxisLabels(props, p2, p3, labelFontSize, labelFont)
	local axisLabel = props.colors.axisLabel
	local v7 = math.max(props.maxX - props.minX, 1e-6)

	local children = {}

	for k, v8 in selectXAxisTicks(props.xAxisLabels, p3, labelFontSize, labelFont) do
		local v9 = p2 + (v8.position - props.minX) / v7 * p3
		children[`XLabel_{v8.position}`] = React.createElement(text, {
			Position = UDim2.new(0, v9, 0, v5 + 4),
			Text = v8.label,
			textStyle = axisLabel,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Top,
			tag = "anchor-top-center auto-xy text-body-small",
			ZIndex = 4
		})
	end

	return children
end

local function MetricChartView(props)
	local testId = props.testId or "MetricChartView"
	local colors = props.colors
	local labelFont = props.labelFont
	local labelFontSize = props.labelFontSize

	local state, setState = React.useState(0)

	local v7, v8 = React.useBinding(0)

	local v10 = if not props.hideHeader then renderValueRow(props, testId) else nil
	local v9 = { ValueRow = v10 }

	if props.hasData then
		local v11 = measureGutter(props.yTicks, labelFontSize, labelFont)

		local v12 = {}

		for k, point2 in props.points do
			v12[k] = { Position = point2 }
		end

		local children = {
			Curve = React.createElement(curve, {
				Points = v12,
				Color3 = colors.line.Color3,
				Thickness = 3,
				ZIndex = 3,
				Tag = `data-testid={testId}.Curve`
			}),
			Input = React.createElement(inputDetector, {
				OnHoverStart = props.onHoverStart,
				OnHoverMoved = props.onHoverMoved,
				OnHoverEnded = props.onHoverEnded,
				OnPress = props.onPress,
				OnDragStart = props.onDragStart,
				OnDragMoved = props.onDragMoved,
				OnDragEnded = props.onDragEnded,
				TreatMouseAsAnchor = true,
				ZIndex = 20
			})
		}

		for k, yTick in props.yTicks do
			children[`Grid_{yTick.position}`] = React.createElement(gridLine, {
				Orientation = "Horizontal",
				Position = yTick.position,
				Color3 = colors.grid.Color3,
				Transparency = colors.grid.Transparency,
				Thickness = 1,
				ZIndex = 1
			})
		end

		local v13 = renderYAxisLabels(props)

		for k, v15 in renderXAxisLabels(props, v11, state - v11 - 8, labelFontSize, labelFont) do
			v13[k] = v15
		end

		local children2 = {}

		local v15 = nil
		local inspectedIndex = props.inspectedIndex

		if inspectedIndex ~= nil and inspectedIndex >= 1 and inspectedIndex <= #props.points then
			local point2 = props.points[inspectedIndex]

			children2.InspectionLine = React.createElement(gridLine, {
				Orientation = "Vertical",
				Position = point2.X,
				Color3 = colors.emphasis.Color3,
				Transparency = 0,
				Thickness = 2,
				ZIndex = 5
			})

			children2.InspectionPoint = React.createElement(point, {
				Position = point2,
				Color3 = colors.line.Color3,
				OutlineColor3 = colors.surface.Color3,
				OutlineThickness = 2,
				Size = 7,
				ZIndex = 6,
				Tag = `data-testid={testId}.InspectionPoint`
			})

			if props.tooltip ~= nil then
				local v16 = (point2.X - props.minX) / math.max(props.maxX - props.minX, 1e-6)

				local v17 = state - 8
				v15 = renderTooltip(v7:map(function(p2)
					local v18 = v11
					local v19 = v18 + v16 * (v17 - v18)
					local v20 = p2 / 2
					local v21 = v18 + v20
					local v22 = v17 - v20
					local v23 = if v21 <= v22 then math.clamp(v19, v21, v22) else (v18 + v17) / 2
					return UDim2.new(0, v23, 0, v6)
				end), props.tooltip, colors, testId, props.icon, function(p2)
					v8(p2.AbsoluteSize.X)
				end)
			end
		end

		v13[`Canvas_{props.plotKey}`] = React.createElement(canvas, {
			GraphRect = Rect.new(props.minX, props.minY, props.maxX, props.maxY),
			ViewportPaddingLeft = UDim.new(0, v11),
			ViewportPaddingRight = UDim.new(0, 8),
			ViewportPaddingTop = UDim.new(0, 12),
			ViewportPaddingBottom = UDim.new(0, 28),
			CanvasBackgroundTransparency = 1,
			ViewportBackgroundTransparency = 1,
			childrenUnclipped = children2
		}, children)

		v13.Tooltip = v15

		v9.Chart = React.createElement(view, {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, PLOT_HEIGHT),
			tag = "clip",
			testId = `{testId}.Chart`,
			onAbsoluteSizeChanged = function(p2)
				setState(p2.AbsoluteSize.X)
			end
		}, v13)
	end

	local createElement = React.createElement
	local v12 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-xsmall size-full-0 auto-y",
		testId = testId
	}
	local v14

	if not props.hideHeader then
		local createElement2 = React.createElement
		local v17 = {
			Title = React.createElement(text, {
				LayoutOrder = 1,
				Text = props.title,
				tag = "size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end content-default",
				testId = `{testId}.Title`
			}),
			Summary = 0
		}
		local v18 = if props.summary ~= nil then React.createElement(text, {
			LayoutOrder = 2,
			Text = props.summary,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
			testId = `{testId}.Summary`
		}) else nil
		v17.Summary = v18
		v14 = createElement2(view, {
			LayoutOrder = 1,
			tag = "col gap-xxsmall size-full-0 auto-y"
		}, v17)
	end

	return createElement(view, v12, {
		Header = v14,
		Slot = React.createElement(
			view,
			{ LayoutOrder = 2, tag = "col gap-large size-full-0 auto-y" },
			v9
		)
	})
end

return MetricChartView
