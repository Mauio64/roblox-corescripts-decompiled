local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local useForwardRef = require(FoundationParent.ReactUtils).useForwardRef
local StyleRule = require(Foundation.StyleSheet.StyleRule)
local useStyleSheet = require(Foundation.Providers.Style.StyleSheetContext).useStyleSheet

require(Foundation.Enums.Breakpoint)
require(Foundation.Enums.BreakpointShortName)

local useResponsive = require(Foundation.Providers.Responsive.useResponsive)

local function GridDebugStyleSheet(t1: {[any]: any}, p1) -- line: 19
	-- upvalues: useResponsive (copy), useStyleSheet (copy), React (copy), useForwardRef (copy), StyleRule (copy)
	local v11 = useResponsive()
	local v12 = useStyleSheet()
	local v13, v14 = React.useState(nil)
	local v15 = useForwardRef(p1, v14)
	local breakpoint = v11.config.breakpoint
	local grid = v11.config.grid
	local v18 = breakpoint.order[#breakpoint.order]
	local v19 = t1.breakpoint or v18
	local v20 = React.useMemo(function() -- line: 31
		-- upvalues: breakpoint (copy), v19 (copy), grid (copy), React (copy), StyleRule (copy)
		local v21 = breakpoint.shortNames[v19]
		local v22 = grid.columns[v19]
		local t2 = {}

		for i = 0, v22 do
			local v25 = if not v21 then `.col-{ i }` else `.{ v21 }-col-{ i }`

			t2[`DebugColColor${ i }`] = React.createElement(StyleRule, {
				Selector = v25,
				properties = {
					BackgroundColor3 = Color3.fromRGB(math.floor(i / math.max(1, v22) * 255), math.floor((1 - i / math.max(1, v22)) * 255), (math.floor(i % 3 / 2 * 255)))
				}
			})
		end

		return t2
	end, {
		v19,
		breakpoint,
		grid
	})

	React.useLayoutEffect(function() -- line: 54
		-- upvalues: v13 (copy), v12 (copy)
		if v13 then
			v13:SetDerives({ v12 })
		end
	end, {
		v13,
		v12
	})

	return React.createElement(React.Fragment, nil, {
		GridDebugStyleSheet = React.createElement("StyleSheet", {
			ref = v15
		}, v20),
		GridDebugStyleLink = React.createElement("StyleLink", {
			StyleSheet = v13
		})
	})
end

return React.memo(React.forwardRef(GridDebugStyleSheet))
