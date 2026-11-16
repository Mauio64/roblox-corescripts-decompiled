local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Breakpoint = require(Foundation.Enums.Breakpoint)
local GridDebugStyleSheet = require(script.Parent.GridDebugStyleSheet)
local React = require(parent.React)
local StyleSheetContext = require(Foundation.Providers.Style.StyleSheetContext)
local Text = require(Foundation.Components.Text)
local View = require(Foundation.Components.View)
local getGridMetrics = require(Foundation.Utility.getGridMetrics)
local useBreakpoint = require(Foundation.Providers.Responsive.Hooks.useBreakpoint)
local useResponsive = require(Foundation.Providers.Responsive.useResponsive)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)

local function DebugCol(props)
	return React.createElement(View, {
		Size = props.size or UDim2.new(0, props.width or 0, 1, 0),
		backgroundStyle = props.backgroundStyle,
		LayoutOrder = props.LayoutOrder,
		tag = props.tag
	})
end

local v = { debugTransparency = 0.7 }

local function GridDebug(p)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local state, setState = React.useState(nil)
	local v4 = useResponsive()
	local state2, setState2 = React.useState(nil)
	local breakpoint, v5 = useBreakpoint(state2)
	local gridMetrics = getGridMetrics(v4.config, breakpoint, v5.X)
	local width = v4.config.breakpoint.widths[Breakpoint.XLarge]

	local v6 = ({
		[Enum.ItemLineAlignment.Start] = "position-top-left anchor-top-left",
		[Enum.ItemLineAlignment.Center] = "position-top-center anchor-top-center",
		[Enum.ItemLineAlignment.End] = "position-top-right anchor-top-right"
	})[v2.align]
	local children = {}

	for i = 1, gridMetrics.full.colCount - 1 do
		if i < gridMetrics.full.colCount then
			table.insert(children, React.createElement(DebugCol, {
				key = `DebugCol{i}`,
				width = gridMetrics.gutterWidth,
				backgroundStyle = { Color3 = v3.Color.System.Alert.Color3, Transparency = 0.5 },
				LayoutOrder = i
			}))
		end
	end

	local createElement = React.createElement
	local v7 = { tag = `size-full-full {v6}` }
	local v8 = {
		GridDebugStyleSheet = React.createElement(GridDebugStyleSheet, {
			breakpoint = breakpoint,
			ref = setState
		}),
		GridDebugMeasureWrapper = React.createElement(View, { ref = setState2, tag = "size-full-0" }, {
			GridMeasureSizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(width, 1e999)
			})
		}),
		GridDebugMeasure = React.createElement(View, {
			Size = UDim2.new(1, 0, 0, 4),
			backgroundStyle = {
				Color3 = Color3.fromRGB(255, 0, 0),
				Transparency = v2.debugTransparency
			}
		}),
		GridDebugSizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(width, 1e999)
		}),
		GridDebugSizeLabel = React.createElement(Text, {
			tag = "position-top-center anchor-top-center auto-xy padding-xxsmall text-label-small text-truncate-end bg-over-media-300",
			Text = `breakpoint: {v4.config.breakpoint.shortNames[breakpoint]}, width: {v5.X}, columns: {gridMetrics.full.colCount}, maxWidth: {width}, margin: {gridMetrics.margin}, gapWidth: {gridMetrics.gutterWidth}`
		}),
		GridDebug = React.createElement(View, {
			tag = "row size-full-full",
			backgroundStyle = {
				Color3 = v3.Color.System.Emphasis.Color3,
				Transparency = v2.debugTransparency
			}
		}, {
			LeftMargin = React.createElement(DebugCol, {
				width = gridMetrics.margin,
				backgroundStyle = {
					Color3 = v3.Color.System.Warning.Color3,
					Transparency = v2.debugTransparency
				},
				LayoutOrder = 0
			}),
			Columns = React.createElement(View, {
				tag = "row flex-x-evenly fill size-0-full",
				backgroundStyle = {
					Color3 = v3.Color.System.Emphasis.Color3,
					Transparency = v2.debugTransparency
				},
				LayoutOrder = 1
			}, children),
			RightMargin = React.createElement(DebugCol, {
				width = gridMetrics.margin,
				backgroundStyle = {
					Color3 = v3.Color.System.Warning.Color3,
					Transparency = v2.debugTransparency
				},
				LayoutOrder = 2
			})
		}),
		GridDebugContent = 0
	}
	local gridDebugContent

	if state then
		gridDebugContent = React.createElement(
			StyleSheetContext.Provider,
			{ value = state },
			React.createElement(View, { tag = "size-full-full" }, {
				GridDebugPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, gridMetrics.gapHeight * 2)
				}),
				GridDebugChildren = React.createElement(React.Fragment, nil, p.children)
			})
		)
	end

	v8.GridDebugContent = gridDebugContent
	return createElement(View, v7, v8)
end

return GridDebug
