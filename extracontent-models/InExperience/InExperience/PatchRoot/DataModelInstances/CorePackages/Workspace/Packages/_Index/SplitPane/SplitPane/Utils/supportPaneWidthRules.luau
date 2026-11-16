local parent = script:FindFirstAncestor("SplitPane").Parent

local Foundation = require(parent.Foundation)
local AppComposition = require(parent.AppComposition)
local SharedFlags = require(parent.SharedFlags)

local Breakpoint = Foundation.Enums.Breakpoint
local resolveBreakpoint = AppComposition.resolveBreakpoint
local FFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane

local Large = Breakpoint.Large

local v = {
	[Breakpoint.XSmall] = 1,
	[Breakpoint.Small] = 2,
	[Breakpoint.Medium] = 3,
	[Breakpoint.Large] = 4,
	[Breakpoint.XLarge] = 5,
	[Breakpoint.XXLarge] = 6
}

local function isBreakpointAtLeast(p, large): boolean -- 1 equivalent call inferred from this helper
	return (v[p] or 0) >= (v[large] or 0)
end

local SupportPaneWidthRules = {}

function SupportPaneWidthRules.isSplitEnabledForWidth(p: number): boolean
	return p >= 800
end

function SupportPaneWidthRules.shouldDefaultToCollapsed(p: number): boolean
	return not not FFlagEnableSplitPane and not isBreakpointAtLeast(resolveBreakpoint(p), Large) -- inferred equivalent call
end

return SupportPaneWidthRules
