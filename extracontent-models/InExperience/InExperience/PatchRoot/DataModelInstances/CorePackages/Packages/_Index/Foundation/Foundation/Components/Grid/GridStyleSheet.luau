local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local Dash = require(parent.Dash)
local React = require(parent.React)

local StyleSheetContext = require(Foundation.Providers.Style.StyleSheetContext)
local useStyleSheet = StyleSheetContext.useStyleSheet
require(Foundation.Enums.Breakpoint)
local createGridStyleRules = require(script.Parent.createGridStyleRules)
local getGridMetrics = require(Foundation.Utility.getGridMetrics)
local useResponsive = require(Foundation.Providers.Responsive.useResponsive)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = { containerWidth = 0 }

local function GridStyleSheet(p)
	local v2 = withDefaults(p, v)
	local ref = React.useRef(nil)
	local v3 = useResponsive()
	local v4 = useStyleSheet()
	local breakpoint = v3.config.breakpoint
	local grid = v3.config.grid

	local v5 = breakpoint.order[#breakpoint.order]
	local column = grid.columns[v5]
	local breakpoint2 = v2.breakpoint or v5

	local v6 = math.max(1, v2.containerWidth)

	local v7 = React.useMemo(function()
		return createGridStyleRules(v3.config)
	end, { v3.config })

	local v8 = React.useMemo(function()
		return Dash.join(v7.baseRules, v7.rulesByBreakpoint[breakpoint2])
	end, { v7, breakpoint2 })

	React.useLayoutEffect(function()
		if ref.current then
			local column2 = grid.columns[breakpoint2]

			for i = 0, column do
				local v9 = math.min(i, column2)
				local gridMetrics = getGridMetrics(v3.config, breakpoint2, v6, v9)
				local vector2 = Vector2.new(gridMetrics.cellWidth, 0)
				local vector2_2 = Vector2.new(gridMetrics.cellWidth, 1e999)

				ref.current:SetAttribute("Col" .. i, gridMetrics.cellSize)
				ref.current:SetAttribute("ColMin" .. i, vector2)
				ref.current:SetAttribute("ColMax" .. i, vector2_2)
			end
		end
	end, { v3.config, v6, breakpoint2 })

	React.useLayoutEffect(function()
		if ref.current then
			ref.current:SetDerives({ v4 })
		end
	end, { v4 })

	return React.createElement(React.Fragment, nil, {
		GridStyleSheet = React.createElement("StyleSheet", { ref = ref }, v8),
		GridStyleLink = React.createElement("StyleLink", { StyleSheet = ref.current })
	})
end

return React.memo(GridStyleSheet)
