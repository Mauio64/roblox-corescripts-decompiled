local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local useForwardRef = ReactUtils.useForwardRef
local StyleRule = require(Foundation.StyleSheet.StyleRule)
local StyleSheetContext = require(Foundation.Providers.Style.StyleSheetContext)
local useStyleSheet = StyleSheetContext.useStyleSheet
require(Foundation.Enums.Breakpoint)
require(Foundation.Enums.BreakpointShortName)
local useResponsive = require(Foundation.Providers.Responsive.useResponsive)

local function GridDebugStyleSheet(p, p2)
	local v = useResponsive()
	local v2 = useStyleSheet()
	local state, setState = React.useState(nil)
	local ref = useForwardRef(p2, setState)

	local breakpoint = v.config.breakpoint
	local grid = v.config.grid

	local v3 = breakpoint.order[#breakpoint.order]
	local breakpoint2 = p.breakpoint or v3

	local v4 = React.useMemo(function()
		local shortName = breakpoint.shortNames[breakpoint2]
		local column = grid.columns[breakpoint2]
		local children = {}

		for i = 0, column do
			local selector

			if shortName then
				selector = `.{shortName}-col-{i}`
			else
				selector = `.col-{i}`
			end

			children[`DebugColColor${i}`] = React.createElement(StyleRule, {
				Selector = selector,
				properties = {
					BackgroundColor3 = Color3.fromRGB(
						math.floor(i / math.max(1, column) * 255),
						math.floor((1 - i / math.max(1, column)) * 255),
						(math.floor(i % 3 / 2 * 255))
					)
				}
			})
		end

		return children
	end, { breakpoint2, breakpoint, grid })

	React.useLayoutEffect(function()
		if state then
			state:SetDerives({ v2 })
		end
	end, { state, v2 })

	return React.createElement(React.Fragment, nil, {
		GridDebugStyleSheet = React.createElement("StyleSheet", { ref = ref }, v4),
		GridDebugStyleLink = React.createElement("StyleLink", { StyleSheet = state })
	})
end

return React.memo(React.forwardRef(GridDebugStyleSheet))
