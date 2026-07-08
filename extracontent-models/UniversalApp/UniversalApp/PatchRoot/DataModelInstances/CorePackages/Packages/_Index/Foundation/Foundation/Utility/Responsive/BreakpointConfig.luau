local Foundation = script:FindFirstAncestor("Foundation")
local Breakpoint = require(Foundation.Enums.Breakpoint)
local BreakpointShortName = require(Foundation.Enums.BreakpointShortName)
local t1 = {
	[Breakpoint.XSmall] = BreakpointShortName.xs,
	[Breakpoint.Small] = BreakpointShortName.sm,
	[Breakpoint.Medium] = BreakpointShortName.md,
	[Breakpoint.Large] = BreakpointShortName.lg,
	[Breakpoint.XLarge] = BreakpointShortName.xl,
	[Breakpoint.XXLarge] = BreakpointShortName.xxl
}
local t2 = {
	[Breakpoint.XSmall] = 360,
	[Breakpoint.Small] = 600,
	[Breakpoint.Medium] = 1140,
	[Breakpoint.Large] = 1520,
	[Breakpoint.XLarge] = 1920,
	[Breakpoint.XXLarge] = 1e999
}
local t3 = {
	Breakpoint.XSmall,
	Breakpoint.Small,
	Breakpoint.Medium,
	Breakpoint.Large,
	Breakpoint.XLarge,
	Breakpoint.XXLarge
}

return {
	shortNames = t1,
	widths = t2,
	order = t3
}
