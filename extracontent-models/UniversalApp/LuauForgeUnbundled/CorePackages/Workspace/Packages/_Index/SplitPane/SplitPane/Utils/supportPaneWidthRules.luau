local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Foundation")
local AppComposition = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/AppComposition")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SharedFlags")

local breakpoint = Foundation.Enums.Breakpoint
local resolveBreakpoint = AppComposition.resolveBreakpoint
local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane

local large = breakpoint.Large

local v5 = {
	[breakpoint.XSmall] = 1,
	[breakpoint.Small] = 2,
	[breakpoint.Medium] = 3,
	[breakpoint.Large] = 4,
	[breakpoint.XLarge] = 5,
	[breakpoint.XXLarge] = 6
}

local function isBreakpointAtLeast(p2, p3): boolean
	return (v5[p2] or 0) >= (v5[p3] or 0)
end

return {
	isSplitEnabledForWidth = function(p2): boolean
		return p2 >= 800
	end,
	shouldDefaultToCollapsed = function(p2): boolean
		if not fFlagEnableSplitPane then
			return false
		end

		return not ((v5[resolveBreakpoint(p2)] or 0) >= (v5[large] or 0))
	end
}
