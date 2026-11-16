local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Breakpoint = require(Foundation.Enums.Breakpoint)
local HeaderBarContext = require(Foundation.Components.HeaderBar.HeaderBarContext)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useViewportBreakpoint = require(Foundation.Providers.Responsive.Hooks.useViewportBreakpoint)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = {
	[Breakpoint.XSmall] = "size-full-1400",
	[Breakpoint.Small] = "size-full-1400",
	[Breakpoint.Medium] = "size-full-1600",
	[Breakpoint.Large] = "size-full-1600",
	[Breakpoint.XLarge] = "size-full-1800",
	[Breakpoint.XXLarge] = "size-full-1800"
}

local v2 = { hasBackground = true, testId = "--foundation-header-bar" }

local function HeaderBar(p)
	local v3 = withDefaults(p, v2)

	local v4 = useViewportBreakpoint()

	return React.createElement(View, withCommonProps(v3, {
		tag = {
			["row flex-between gap-small padding-medium"] = true,
			["bg-surface-0"] = v3.hasBackground,
			[v[v4]] = true
		}
	}), React.createElement(HeaderBarContext.Provider, { testId = v3.testId }, v3.children))
end

return React.memo(HeaderBar)
