local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Breakpoint = require(Foundation.Enums.Breakpoint)
local GridStyleSheet = require(script.Parent.GridStyleSheet)
local React = require(parent.React)
require(Foundation.Providers.Responsive.ResponsiveContext)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local getGridMetrics = require(Foundation.Utility.getGridMetrics)
local useBreakpoint = require(Foundation.Providers.Responsive.Hooks.useBreakpoint)
local useResponsive = require(Foundation.Providers.Responsive.useResponsive)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = {
	[Enum.ItemLineAlignment.Start] = "items-start",
	[Enum.ItemLineAlignment.Center] = "items-center",
	[Enum.ItemLineAlignment.End] = "items-end"
}

local v2 = {
	tag = "size-full-0 auto-y",
	align = Enum.ItemLineAlignment.Start,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Wraps = true,
	testId = "--foundation-grid"
}

local function Grid(p, ref)
	local v3 = withDefaults(p, v2)
	local v4 = useResponsive()
	local state, setState = React.useState(nil)
	local breakpoint, v5 = useBreakpoint(state)
	local gridMetrics = getGridMetrics(v4.config, breakpoint, v5.X)
	local width = v4.config.breakpoint.widths[Breakpoint.XLarge]
	local v6 = v[v3.align]

	local createElement = React.createElement

	local v7 = withCommonProps(v3, { tag = v3.tag, ref = ref })

	local v8 = {
		GridMeasure = React.createElement(View, { ref = setState, tag = "size-full-0" }, {
			GridMeasureSizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(width, 1e999)
			})
		}),
		GridAlignment = 0
	}

	local createElement2 = React.createElement
	local v9 = {
		tag = `col flex-x-fill size-full-0 auto-y {v6}`
	}
	local v10 = {
		GridStyleSheet = React.createElement(GridStyleSheet, {
			breakpoint = breakpoint,
			containerWidth = v5.X
		}),
		Grid = 0
	}

	local createElement3 = React.createElement
	local v11 = { tag = "auto-y", Size = UDim2.fromOffset(v5.X, 0), layout = 0 }
	local padding

	if not v3.Wraps then
		padding = UDim.new(0, gridMetrics.gutterWidth)
	end

	local layout = {
		Padding = padding,
		SortOrder = v3.SortOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalFlex = 0,
		Wraps = 0
	}
	local horizontalFlex

	if v3.Wraps then
		horizontalFlex = Enum.UIFlexAlignment.SpaceBetween
	end

	layout.HorizontalFlex = horizontalFlex
	layout.Wraps = v3.Wraps
	v11.layout = layout
	v10.Grid = createElement3(View, v11, {
		GridSizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(width, 1e999)
		}),
		GridMargin = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, gridMetrics.margin),
			PaddingRight = UDim.new(0, gridMetrics.margin)
		})
	}, v3.children)
	v8.GridAlignment = createElement2(View, v9, v10)
	return createElement(View, v7, v8)
end

return React.memo(React.forwardRef(Grid))
