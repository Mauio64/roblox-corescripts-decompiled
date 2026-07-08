local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)
local useStyleSheet = require(Foundation.Providers.Style.StyleSheetContext).useStyleSheet

require(Foundation.Enums.Breakpoint)

local createGridStyleRules = require(script.Parent.createGridStyleRules)
local getGridMetrics = require(Foundation.Utility.getGridMetrics)
local useResponsive = require(Foundation.Providers.Responsive.useResponsive)
local withDefaults = require(Foundation.Utility.withDefaults)
local t1 = {
	containerWidth = 0
}

local function GridStyleSheet(t2: {[any]: any}) -- line: 25
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), useResponsive (copy), useStyleSheet (copy), createGridStyleRules (copy), Dash (copy), getGridMetrics (copy)
	local v13 = withDefaults(t2, t1)
	local v14 = React.useRef(nil)
	local v15 = useResponsive()
	local v16 = useStyleSheet()
	local breakpoint = v15.config.breakpoint
	local grid = v15.config.grid
	local v19 = breakpoint.order[#breakpoint.order]
	local v20 = grid.columns[v19]
	local v21 = v13.breakpoint or v19
	local v22 = math.max(1, v13.containerWidth)
	local v23 = React.useMemo(function() -- line: 39
		-- upvalues: createGridStyleRules (copy), v15 (copy)
		return createGridStyleRules(v15.config)
	end, { v15.config })
	local v24 = React.useMemo(function() -- line: 43
		-- upvalues: Dash (copy), v23 (copy), v21 (copy)
		return Dash.join(v23.baseRules, v23.rulesByBreakpoint[v21])
	end, {
		v23,
		v21
	})

	React.useLayoutEffect(function() -- line: 47
		-- upvalues: v14 (copy), grid (copy), v21 (copy), v20 (copy), getGridMetrics (copy), v15 (copy), v22 (copy)
		if v14.current then
			local v25 = grid.columns[v21]

			for i = 0, v20 do
				local v27 = math.min(i, v25)
				local v28 = getGridMetrics(v15.config, v21, v22, v27)
				local vector2 = Vector2.new(v28.cellWidth, 0)
				local vector2_2 = Vector2.new(v28.cellWidth, 1e999)

				v14.current:SetAttribute("Col" .. i, v28.cellSize)
				v14.current:SetAttribute("ColMin" .. i, vector2)
				v14.current:SetAttribute("ColMax" .. i, vector2_2)
			end
		end
	end, {
		v15.config,
		v22,
		v21
	})
	React.useLayoutEffect(function() -- line: 70
		-- upvalues: v14 (copy), v16 (copy)
		if v14.current then
			v14.current:SetDerives({ v16 })
		end
	end, { v16 })

	return React.createElement(React.Fragment, nil, {
		GridStyleSheet = React.createElement("StyleSheet", {
			ref = v14
		}, v24),
		GridStyleLink = React.createElement("StyleLink", {
			StyleSheet = v14.current
		})
	})
end

return React.memo(GridStyleSheet)
