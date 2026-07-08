local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Breakpoint = require(Foundation.Enums.Breakpoint)
local GridDebugStyleSheet = require(script.Parent.GridDebugStyleSheet)
local React = require(FoundationParent.React)
local StyleSheetContext = require(Foundation.Providers.Style.StyleSheetContext)
local Text = require(Foundation.Components.Text)
local View = require(Foundation.Components.View)
local getGridMetrics = require(Foundation.Utility.getGridMetrics)
local useBreakpoint = require(Foundation.Providers.Responsive.Hooks.useBreakpoint)
local useResponsive = require(Foundation.Providers.Responsive.useResponsive)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)

local function DebugCol(t1: {[any]: any}) -- line: 29
	-- upvalues: React (copy), View (copy)
	return React.createElement(View, {
		Size = t1.size or UDim2.new(0, t1.width or 0, 1, 0),
		backgroundStyle = t1.backgroundStyle,
		LayoutOrder = t1.LayoutOrder,
		tag = t1.tag
	})
end

local t2 = {
	debugTransparency = 0.7
}

local function GridDebug(t3: {[any]: any}) -- line: 48
	-- upvalues: withDefaults (copy), t2 (copy), useTokens (copy), React (copy), useResponsive (copy), useBreakpoint (copy), getGridMetrics (copy), Breakpoint (copy), DebugCol (copy), View (copy), GridDebugStyleSheet (copy), Text (copy), StyleSheetContext (copy)
	local v19 = withDefaults(t3, t2)
	local v20 = useTokens()
	local v21, v22 = React.useState(nil)
	local v23 = useResponsive()
	local v24, v25 = React.useState(nil)
	local v26, v27 = useBreakpoint(v24)
	local v28 = getGridMetrics(v23.config, v26, v27.X)
	local v29 = v23.config.breakpoint.widths[Breakpoint.XLarge]
	local t4 = {}
	local v31 = ({
		[Enum.ItemLineAlignment.Start] = "position-top-left anchor-top-left",
		[Enum.ItemLineAlignment.Center] = "position-top-center anchor-top-center",
		[Enum.ItemLineAlignment.End] = "position-top-right anchor-top-right"
	})[v19.align]

	for i = 1, v28.full.colCount - 1 do
		if i < v28.full.colCount then
			table.insert(t4, React.createElement(DebugCol, {
				key = `DebugCol{ i }`,
				width = v28.gutterWidth,
				backgroundStyle = {
					Transparency = 0.5,
					Color3 = v20.Color.System.Alert.Color3
				},
				LayoutOrder = i
			}))
		end
	end

	return React.createElement(View, {
		tag = `size-full-full { v31 }`
	}, {
		GridDebugStyleSheet = React.createElement(GridDebugStyleSheet, {
			breakpoint = v26,
			ref = v22
		}),
		GridDebugMeasureWrapper = React.createElement(View, {
			tag = "size-full-0",
			ref = v25
		}, {
			GridMeasureSizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(v29, 1e999)
			})
		}),
		GridDebugMeasure = React.createElement(View, {
			Size = UDim2.new(1, 0, 0, 4),
			backgroundStyle = {
				Color3 = Color3.fromRGB(255, 0, 0),
				Transparency = v19.debugTransparency
			}
		}),
		GridDebugSizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(v29, 1e999)
		}),
		GridDebugSizeLabel = React.createElement(Text, {
			tag = "position-top-center anchor-top-center auto-xy padding-xxsmall text-label-small text-truncate-end bg-over-media-300",
			Text = `breakpoint: { v23.config.breakpoint.shortNames[v26] }, width: { v27.X }, columns: { v28.full.colCount }, maxWidth: { v29 }, margin: { v28.margin }, gapWidth: { v28.gutterWidth }`
		}),
		GridDebug = React.createElement(View, {
			tag = "row size-full-full",
			backgroundStyle = {
				Color3 = v20.Color.System.Emphasis.Color3,
				Transparency = v19.debugTransparency
			}
		}, {
			LeftMargin = React.createElement(DebugCol, {
				LayoutOrder = 0,
				width = v28.margin,
				backgroundStyle = {
					Color3 = v20.Color.System.Warning.Color3,
					Transparency = v19.debugTransparency
				}
			}),
			Columns = React.createElement(View, {
				tag = "row flex-x-evenly fill size-0-full",
				LayoutOrder = 1,
				backgroundStyle = {
					Color3 = v20.Color.System.Emphasis.Color3,
					Transparency = v19.debugTransparency
				}
			}, t4),
			RightMargin = React.createElement(DebugCol, {
				LayoutOrder = 2,
				width = v28.margin,
				backgroundStyle = {
					Color3 = v20.Color.System.Warning.Color3,
					Transparency = v19.debugTransparency
				}
			})
		}),
		GridDebugContent = if not v21 then nil else React.createElement(StyleSheetContext.Provider, {
			value = v21
		}, React.createElement(View, {
			tag = "size-full-full"
		}, {
			GridDebugPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v28.gapHeight * 2)
			}),
			GridDebugChildren = React.createElement(React.Fragment, nil, t3.children)
		}))
	})
end

return GridDebug
