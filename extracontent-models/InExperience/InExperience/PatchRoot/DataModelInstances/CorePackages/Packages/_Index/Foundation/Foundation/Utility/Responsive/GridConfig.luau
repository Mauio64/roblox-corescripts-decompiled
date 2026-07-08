local Foundation = script:FindFirstAncestor("Foundation")
local Breakpoint = require(Foundation.Enums.Breakpoint)
local t1 = {
	[Breakpoint.XSmall] = 3,
	[Breakpoint.Small] = 6,
	[Breakpoint.Medium] = 12,
	[Breakpoint.Large] = 12,
	[Breakpoint.XLarge] = 12,
	[Breakpoint.XXLarge] = 12
}
local t2 = {
	[Breakpoint.XSmall] = 12,
	[Breakpoint.Small] = 20,
	[Breakpoint.Medium] = 24,
	[Breakpoint.Large] = 24,
	[Breakpoint.XLarge] = 32,
	[Breakpoint.XXLarge] = 48
}
local t3 = {
	[Breakpoint.XSmall] = 8,
	[Breakpoint.Small] = 12,
	[Breakpoint.Medium] = 16,
	[Breakpoint.Large] = 16,
	[Breakpoint.XLarge] = 20,
	[Breakpoint.XXLarge] = 20
}
local t4 = {
	[Breakpoint.XSmall] = 8,
	[Breakpoint.Small] = 12,
	[Breakpoint.Medium] = 16,
	[Breakpoint.Large] = 16,
	[Breakpoint.XLarge] = 20,
	[Breakpoint.XXLarge] = 20
}

return {
	columns = t1,
	margins = t2,
	gutters = t3,
	gaps = t4
}
