local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Breakpoint = require(Foundation.Enums.Breakpoint)
local HeaderBarContext = require(Foundation.Components.HeaderBar.HeaderBarContext)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useBreakpoint = require(Foundation.Providers.Responsive.Hooks.useBreakpoint)
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

local function HeaderBar(p1) -- line: 35
	-- upvalues: withDefaults (copy), t2 (copy), React (copy), useBreakpoint (copy), View (copy), withCommonProps (copy), t1 (copy), HeaderBarContext (copy)
	local v14 = withDefaults(p1, t2)
	local v15, v16 = React.useState(nil)
	local v17 = useBreakpoint(v15)

	return React.createElement(View, withCommonProps(v14, {
		tag = {
			["row flex-between gap-small padding-medium"] = true,
			["bg-surface-0"] = v14.hasBackground,
			[t1[v17]] = true
		},
		ref = v16
	}), React.createElement(HeaderBarContext.Provider, {
		testId = v14.testId
	}, v14.children))
end

return React.memo(HeaderBar)
