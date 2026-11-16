local Foundation = script:FindFirstAncestor("Foundation")

local Breakpoint = require(Foundation.Enums.Breakpoint)

return {
	columns = {
		[Breakpoint.XSmall] = 3,
		[Breakpoint.Small] = 6,
		[Breakpoint.Medium] = 12,
		[Breakpoint.Large] = 12,
		[Breakpoint.XLarge] = 12,
		[Breakpoint.XXLarge] = 12
	},
	margins = {
		[Breakpoint.XSmall] = 12,
		[Breakpoint.Small] = 20,
		[Breakpoint.Medium] = 24,
		[Breakpoint.Large] = 24,
		[Breakpoint.XLarge] = 32,
		[Breakpoint.XXLarge] = 48
	},
	gutters = {
		[Breakpoint.XSmall] = 8,
		[Breakpoint.Small] = 12,
		[Breakpoint.Medium] = 16,
		[Breakpoint.Large] = 16,
		[Breakpoint.XLarge] = 20,
		[Breakpoint.XXLarge] = 20
	},
	gaps = {
		[Breakpoint.XSmall] = 8,
		[Breakpoint.Small] = 12,
		[Breakpoint.Medium] = 16,
		[Breakpoint.Large] = 16,
		[Breakpoint.XLarge] = 20,
		[Breakpoint.XXLarge] = 20
	}
}
