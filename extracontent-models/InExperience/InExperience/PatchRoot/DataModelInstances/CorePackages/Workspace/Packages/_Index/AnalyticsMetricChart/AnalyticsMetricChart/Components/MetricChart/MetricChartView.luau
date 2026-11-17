local parent = script:FindFirstAncestor("AnalyticsMetricChart").Parent

local Foundation = require(parent.Foundation)
local Graphing = require(parent.Graphing)
local React = require(parent.React)
local Style = require(parent.Style)

local chartLayout = require(script.Parent.chartLayout)

local Canvas = Graphing.Canvas
local Curve = Graphing.Curve
local GridLine = Graphing.GridLine
local InputDetector = Graphing.InputDetector
local Point = Graphing.Point

local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View

local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant

local PLOT_HEIGHT = chartLayout.PLOT_HEIGHT

local v = PLOT_HEIGHT - 28
local v2 = v + -1

local function renderTooltip(mapped, tooltip, colors, testId: string, icon, onAbsoluteSizeChanged)
	local createElement = React.createElement
	local v3 = {
		Size = UDim2.fromOffset(0, 30),
		Position = mapped,
		ZIndex = 30,
		backgroundStyle = colors.tooltipBackground,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		tag = "row align-y-center gap-large anchor-top-center auto-x padding-x-xsmall radius-small",
		testId = `{testId}.Tooltip`
	}
	local v4 = {
		Date = React.createElement(Text, {
			LayoutOrder = 1,
			Text = tooltip.date,
			tag = "auto-xy text-caption-medium content-inverse-default",
			testId = `{testId}.TooltipDate`
		}),
		ValueGroup = 0
	}

	local createElement2 = React.createElement
	local icon2

	if icon ~= nil then
		icon2 = React.createElement(Icon, {
			LayoutOrder = 1,
			name = icon,
			size = IconSize.XSmall,
			style = colors.tooltipContent,
			testId = `{testId}.TooltipIcon`
		})
	end

	v4.ValueGroup = createElement2(View, {
		LayoutOrder = 2,
		tag = "row align-y-center gap-xsmall auto-xy"
	}, {
		Icon = icon2,
		Value = React.createElement(Text, {
			LayoutOrder = 2,
			Text = tooltip.valueText,
			tag = "auto-xy text-caption-medium content-inverse-emphasis",
			testId = `{testId}.TooltipValue`
		})
	})
	return createElement(View, v3, v4)
end

local function renderTitleBlock(props, testId: string) -- 1 equivalent call inferred from this helper
	return React.createElement(Text, {
		LayoutOrder = 1,
		Text = props.title,
		tag = "size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end content-default",
		testId = `{testId}.Title`
	})
end

local function renderSummary(props, testId: string) -- 1 equivalent call inferred from this helper
	return React.createElement(Text, {
		LayoutOrder = 2,
		Text = props.summary,
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
		testId = `{testId}.Summary`
	})
end

local function renderValueRow(props, testId: string)
	local colors = props.colors
	local createElement = React.createElement

	local createElement2 = React.createElement
	local icon

	if props.icon ~= nil then
		icon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = props.icon,
			size = IconSize.Medium,
			style = colors.emphasis,
			testId = `{testId}.Icon`
		})
	end

	local v3 = {
		Stat = createElement2(View, {
			LayoutOrder = 1,
			tag = "row align-y-center gap-xsmall auto-xy"
		}, {
			Icon = icon,
			Value = React.createElement(Text, {
				LayoutOrder = 2,
				Text = props.valueText,
				tag = "auto-xy text-heading-large content-emphasis",
				testId = `{testId}.Value`
			})
		}),
		Delta = 0
	}
	local delta

	if props.deltaText ~= nil then
		local createElement3 = React.createElement
		local v4 = {
			LayoutOrder = 2,
			tag = {
				["row align-y-center gap-xxsmall auto-xy padding-y-xxsmall padding-left-xsmall padding-right-small radius-small"] = true,
				["bg-shift-200"] = not props.isDeltaPositive
			},
			backgroundStyle = 0,
			testId = 0
		}
		local backgroundStyle

		if props.isDeltaPositive then
			backgroundStyle = colors.positiveBackground
		end

		v4.backgroundStyle = backgroundStyle
		v4.testId = `{testId}.Delta`

		local createElement4 = React.createElement
		local name

		if props.isDeltaPositive then
			name = IconName.ArrowWideShortUp
		else
			name = IconName.ArrowWideShortDown
		end

		local v5 = {
			LayoutOrder = 1,
			name = name,
			size = IconSize.XSmall,
			variant = IconVariant.Filled,
			style = 0
		}
		local style

		if props.isDeltaPositive then
			style = colors.positive
		else
			style = colors.muted
		end

		v5.style = style
		delta = createElement3(View, v4, {
			Arrow = createElement4(Icon, v5),
			Value = React.createElement(Text, {
				LayoutOrder = 2,
				Text = props.deltaText,
				tag = "auto-xy text-caption-medium content-default"
			})
		})
	end

	v3.Delta = delta
	return createElement(View, {
		LayoutOrder = 1,
		tag = "row align-y-center gap-small size-full-0 auto-y"
	}, v3)
end

local function measureGutter(yTicks, labelFontSize: number, labelFont)
	local maxX = 0

	for _, item in yTicks do
		maxX = math.max(
			maxX,
			Style.GetTextSize(item.label, labelFontSize, labelFont, Vector2.new(1000, 100), {
				addTemporaryPadding = false
			}).X
		)
	end

	return (math.max(60, math.ceil(maxX) + 2 + 12))
end

local function renderYAxisLabels(props)
	local axisLabel = props.colors.axisLabel
	local v3 = PLOT_HEIGHT - 12 - 28
	local v4 = math.max(props.maxY - props.minY, 1e-6)

	local children = {}

	for _, yTick in props.yTicks do
		local v5 = 12 + (props.maxY - yTick.position) / v4 * v3
		children[`YLabel_{yTick.position}`] = React.createElement(Text, {
			Position = UDim2.new(0, 2, 0, v5),
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

local function selectXAxisTicks(xAxisLabels, p: number, p2: number, p3)
	local count = #xAxisLabels

	if count <= 2 or p <= 0 then
		return {}
	end

	local maxX = 0

	for _, item in xAxisLabels do
		maxX = math.max(
			maxX,
			Style.GetTextSize(item, p2, p3, Vector2.new(1000, 100), { addTemporaryPadding = false }).X
		)
	end

	if p < maxX then
		return {}
	end

	local v3 = maxX + 24
	local v4 = p / (count - 1)

	for i = math.min(3, count - 2), 1, -1 do
		local set = {}
		local v5 = {}

		for j = 1, i do
			local v6 = math.clamp(math.round(count * j / (i + 1)), 1, count - 2)

			if set[v6] then
				continue
			end

			set[v6] = true
			table.insert(v5, v6)
		end

		local v6 = #v5 == i

		for j = 2, #v5 do
			if (v5[j] - v5[j - 1]) * v4 < v3 then
				v6 = false
				break
			end
		end

		if v6 then
			local result = {}

			for _, position in v5 do
				table.insert(result, {
					position = position,
					label = xAxisLabels[position + 1]
				})
			end

			return result
		end
	end

	return {}
end

local function renderXAxisLabels(props, p: number, p2: number, labelFontSize: number, labelFont)
	local axisLabel = props.colors.axisLabel
	local v3 = math.max(props.maxX - props.minX, 1e-6)

	local children = {}

	for _, v4 in selectXAxisTicks(props.xAxisLabels, p2, labelFontSize, labelFont) do
		local v5 = p + (v4.position - props.minX) / v3 * p2
		children[`XLabel_{v4.position}`] = React.createElement(Text, {
			Position = UDim2.new(0, v5, 0, v + 4),
			Text = v4.label,
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

	local v3, v4 = React.useBinding(0)
	local valueRow

	if not props.hideHeader then
		valueRow = renderValueRow(props, testId)
	end

	local v5 = { ValueRow = valueRow }

	if props.hasData then
		local v6 = measureGutter(props.yTicks, labelFontSize, labelFont)

		local points = {}

		for k, point in props.points do
			points[k] = { Position = point }
		end

		local children = {
			Curve = React.createElement(Curve, {
				Points = points,
				Color3 = colors.line.Color3,
				Thickness = 3,
				ZIndex = 3,
				Tag = `data-testid={testId}.Curve`
			}),
			Input = React.createElement(InputDetector, {
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

		for _, yTick in props.yTicks do
			children[`Grid_{yTick.position}`] = React.createElement(GridLine, {
				Orientation = "Horizontal",
				Position = yTick.position,
				Color3 = colors.grid.Color3,
				Transparency = colors.grid.Transparency,
				Thickness = 1,
				ZIndex = 1
			})
		end

		local v7 = renderYAxisLabels(props)

		for k, v8 in renderXAxisLabels(props, v6, state - v6 - 8, labelFontSize, labelFont) do
			v7[k] = v8
		end

		local children2 = {}

		local tooltip = nil
		local inspectedIndex = props.inspectedIndex

		if inspectedIndex ~= nil and inspectedIndex >= 1 and inspectedIndex <= #props.points then
			local point = props.points[inspectedIndex]

			children2.InspectionLine = React.createElement(GridLine, {
				Orientation = "Vertical",
				Position = point.X,
				Color3 = colors.emphasis.Color3,
				Transparency = 0,
				Thickness = 2,
				ZIndex = 5
			})

			children2.InspectionPoint = React.createElement(Point, {
				Position = point,
				Color3 = colors.line.Color3,
				OutlineColor3 = colors.surface.Color3,
				OutlineThickness = 2,
				Size = 7,
				ZIndex = 6,
				Tag = `data-testid={testId}.InspectionPoint`
			})

			if props.tooltip ~= nil then
				local v8 = (point.X - props.minX) / math.max(props.maxX - props.minX, 1e-6)

				local v9 = state - 8
				tooltip = renderTooltip(v3:map(function(p: number)
					local v10 = v6
					local v11 = v10 + v8 * (v9 - v10)
					local v12 = p / 2
					local v13 = v10 + v12
					local v14 = v9 - v12
					local v15

					if v13 <= v14 then
						v15 = math.clamp(v11, v13, v14)
					else
						v15 = (v10 + v9) / 2
					end

					return UDim2.new(0, v15, 0, v2)
				end), props.tooltip, colors, testId, props.icon, function(p)
					v4(p.AbsoluteSize.X)
				end)
			end
		end

		v7[`Canvas_{props.plotKey}`] = React.createElement(Canvas, {
			GraphRect = Rect.new(props.minX, props.minY, props.maxX, props.maxY),
			ViewportPaddingLeft = UDim.new(0, v6),
			ViewportPaddingRight = UDim.new(0, 8),
			ViewportPaddingTop = UDim.new(0, 12),
			ViewportPaddingBottom = UDim.new(0, 28),
			CanvasBackgroundTransparency = 1,
			ViewportBackgroundTransparency = 1,
			childrenUnclipped = children2
		}, children)

		v7.Tooltip = tooltip

		v5.Chart = React.createElement(View, {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, PLOT_HEIGHT),
			tag = "clip",
			testId = `{testId}.Chart`,
			onAbsoluteSizeChanged = function(p)
				setState(p.AbsoluteSize.X)
			end
		}, v7)
	end

	local createElement = React.createElement
	local v6 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-xsmall size-full-0 auto-y",
		testId = testId
	}
	local header

	if not props.hideHeader then
		local createElement2 = React.createElement

		local v7 = {
			Title = renderTitleBlock(props, testId), -- inferred equivalent call
			Summary = 0
		}
		local summary

		if props.summary ~= nil then
			summary = renderSummary(props, testId) -- inferred equivalent call
		end

		v7.Summary = summary
		header = createElement2(View, {
			LayoutOrder = 1,
			tag = "col gap-xxsmall size-full-0 auto-y"
		}, v7)
	end

	return createElement(View, v6, {
		Header = header,
		Slot = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col gap-large size-full-0 auto-y"
		}, v5)
	})
end

return MetricChartView
