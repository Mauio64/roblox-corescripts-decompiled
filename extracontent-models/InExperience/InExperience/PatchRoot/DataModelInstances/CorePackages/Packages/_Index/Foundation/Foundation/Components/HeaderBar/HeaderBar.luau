local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Breakpoint = require(Foundation.Enums.Breakpoint)
local Flags = require(Foundation.Utility.Flags)
local HeaderBarContext = require(Foundation.Components.HeaderBar.HeaderBarContext)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useBreakpoint = require(Foundation.Providers.Responsive.Hooks.useBreakpoint)
local useViewportBreakpoint = require(Foundation.Providers.Responsive.Hooks.useViewportBreakpoint)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local t1 = {
	[Breakpoint.XSmall] = "size-full-1400",
	[Breakpoint.Small] = "size-full-1400",
	[Breakpoint.Medium] = "size-full-1600",
	[Breakpoint.Large] = "size-full-1600",
	[Breakpoint.XLarge] = "size-full-1800",
	[Breakpoint.XXLarge] = "size-full-1800"
}
local t2 = {
	hasBackground = true,
	testId = "--foundation-header-bar"
}

local function HeaderBar(p1) -- line: 37
	-- upvalues: withDefaults (copy), t2 (copy), Flags (copy), React (copy), useViewportBreakpoint (copy), useBreakpoint (copy), View (copy), withCommonProps (copy), t1 (copy), HeaderBarContext (copy)
	local v16 = withDefaults(p1, t2)
	local v17 = nil
	local v18 = nil

	if not Flags.FoundationHeaderBarDualPaneBreakpointsStaySynced then
		v17, v18 = React.useState(nil)
	end

	local v19 = if not Flags.FoundationHeaderBarDualPaneBreakpointsStaySynced then useBreakpoint(v17) else useViewportBreakpoint()

	return React.createElement(View, withCommonProps(v16, {
		tag = {
			["row flex-between gap-small padding-medium"] = true,
			["bg-surface-0"] = v16.hasBackground,
			[t1[v19]] = true
		},
		ref = if not Flags.FoundationHeaderBarDualPaneBreakpointsStaySynced then v18 else nil
	}), React.createElement(HeaderBarContext.Provider, {
		testId = v16.testId
	}, v16.children))
end

return React.memo(HeaderBar)
