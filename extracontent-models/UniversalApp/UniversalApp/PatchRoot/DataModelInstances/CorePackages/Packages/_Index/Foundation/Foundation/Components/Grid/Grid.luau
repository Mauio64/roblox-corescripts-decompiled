local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Breakpoint = require(Foundation.Enums.Breakpoint)
local GridStyleSheet = require(script.Parent.GridStyleSheet)
local React = require(FoundationParent.React)

require(Foundation.Providers.Responsive.ResponsiveContext)
require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local getGridMetrics = require(Foundation.Utility.getGridMetrics)
local useBreakpoint = require(Foundation.Providers.Responsive.Hooks.useBreakpoint)
local useResponsive = require(Foundation.Providers.Responsive.useResponsive)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local t1 = {
	[Enum.ItemLineAlignment.Start] = "items-start",
	[Enum.ItemLineAlignment.Center] = "items-center",
	[Enum.ItemLineAlignment.End] = "items-end"
}
local t2 = {
	tag = "size-full-0 auto-y",
	Wraps = true,
	testId = "--foundation-grid",
	align = Enum.ItemLineAlignment.Start,
	SortOrder = Enum.SortOrder.LayoutOrder
}

local function Grid(p1, p2) -- line: 44
	-- upvalues: withDefaults (copy), t2 (copy), useResponsive (copy), React (copy), useBreakpoint (copy), getGridMetrics (copy), Breakpoint (copy), t1 (copy), View (copy), withCommonProps (copy), GridStyleSheet (copy)
	local v17 = withDefaults(p1, t2)
	local v18 = useResponsive()
	local v19, v20 = React.useState(nil)
	local v21, v22 = useBreakpoint(v19)
	local v23 = getGridMetrics(v18.config, v21, v22.X)
	local v24 = v18.config.breakpoint.widths[Breakpoint.XLarge]
	local v25 = t1[v17.align]

	return React.createElement(View, withCommonProps(v17, {
		tag = v17.tag,
		ref = p2
	}), {
		GridMeasure = React.createElement(View, {
			tag = "size-full-0",
			ref = v20
		}, {
			GridMeasureSizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(v24, 1e999)
			})
		}),
		GridAlignment = React.createElement(View, {
			tag = `col flex-x-fill size-full-0 auto-y { v25 }`
		}, {
			GridStyleSheet = React.createElement(GridStyleSheet, {
				breakpoint = v21,
				containerWidth = v22.X
			}),
			Grid = React.createElement(View, {
				tag = "auto-y",
				Size = UDim2.fromOffset(v22.X, 0),
				layout = {
					Padding = if v17.Wraps then nil else UDim.new(0, v23.gutterWidth),
					SortOrder = v17.SortOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = if not v17.Wraps then nil else Enum.UIFlexAlignment.SpaceBetween,
					Wraps = v17.Wraps
				}
			}, {
				GridSizeConstraint = React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(v24, 1e999)
				}),
				GridMargin = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v23.margin),
					PaddingRight = UDim.new(0, v23.margin)
				})
			}, v17.children)
		})
	})
end

return React.memo(React.forwardRef(Grid))
