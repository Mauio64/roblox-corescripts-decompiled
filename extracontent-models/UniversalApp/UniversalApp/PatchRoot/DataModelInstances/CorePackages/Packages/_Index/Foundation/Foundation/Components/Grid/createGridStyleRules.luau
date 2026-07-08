local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent

require(Foundation.Enums.Breakpoint)
require(Foundation.Enums.BreakpointShortName)

local React = require(FoundationParent.React)

require(Foundation.Providers.Responsive.ResponsiveContext)

local StyleRule = require(Foundation.StyleSheet.StyleRule)

local function createGridStyleRule(n1: number, p1) -- line: 13
	-- upvalues: React (copy), StyleRule (copy)
	local v9 = if not p1 then `.col-{ n1 }` else `.{ p1 }-col-{ n1 }`

	return React.createElement(StyleRule, {
		Selector = `{ v9 } ::UISizeConstraint`,
		properties = {
			MinSize = `$ColMin{ n1 }`,
			MaxSize = `$ColMax{ n1 }`
		}
	})
end
local function createGridStyleRules(p2) -- line: 24
	-- upvalues: createGridStyleRule (copy), React (copy), StyleRule (copy)
	local breakpoint = p2.breakpoint
	local grid = p2.grid
	local v13 = breakpoint.order[#breakpoint.order]
	local t1 = {}
	local t2 = {}

	for i = 0, grid.columns[v13] do
		t2[`Col{ i }`] = createGridStyleRule(i)

		if i == 0 then
			t2.ColVisible0 = React.createElement(StyleRule, {
				Selector = ".col-0",
				properties = {
					Visible = false
				}
			})
		end
	end

	for _, v18 in breakpoint.order do
		local v19 = breakpoint.shortNames[v18]
		local t3 = {}

		for i = 0, grid.columns[v18] do
			t3[`{ v18 }Col{ i }`] = createGridStyleRule(i, v19)

			if i == 0 then
				t3[`{ v18 }ColVisible0`] = React.createElement(StyleRule, {
					Selector = `.{ v19 }-col-0`,
					properties = {
						Visible = false
					}
				})
			end
		end

		t1[v18] = t3
	end

	return {
		baseRules = t2,
		rulesByBreakpoint = t1
	}
end

return createGridStyleRules
