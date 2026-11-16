local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
require(Foundation.Enums.Breakpoint)
require(Foundation.Enums.BreakpointShortName)
local React = require(parent.React)
require(Foundation.Providers.Responsive.ResponsiveContext)
local StyleRule = require(Foundation.StyleSheet.StyleRule)

local function createGridStyleRule(i: number, p)
	local v

	if p then
		v = `.{p}-col-{i}`
	else
		v = `.col-{i}`
	end

	return React.createElement(StyleRule, {
		Selector = `{v} ::UISizeConstraint`,
		properties = { MinSize = `$ColMin{i}`, MaxSize = `$ColMax{i}` }
	})
end

local function createGridStyleRules(p)
	local breakpoint = p.breakpoint
	local grid = p.grid
	local v = breakpoint.order[#breakpoint.order]

	local children = {}
	local children2 = {}

	for i = 0, grid.columns[v] do
		children[`Col{i}`] = createGridStyleRule(i)

		if i == 0 then
			children.ColVisible0 = React.createElement(StyleRule, {
				Selector = ".col-0",
				properties = { Visible = false }
			})
		end
	end

	for _, v2 in breakpoint.order do
		local shortName = breakpoint.shortNames[v2]

		local children3 = {}

		for i = 0, grid.columns[v2] do
			children3[`{v2}Col{i}`] = createGridStyleRule(i, shortName)

			if i == 0 then
				children3[`{v2}ColVisible0`] = React.createElement(StyleRule, {
					Selector = `.{shortName}-col-0`,
					properties = { Visible = false }
				})
			end
		end

		children2[v2] = children3
	end

	return { baseRules = children, rulesByBreakpoint = children2 }
end

return createGridStyleRules
