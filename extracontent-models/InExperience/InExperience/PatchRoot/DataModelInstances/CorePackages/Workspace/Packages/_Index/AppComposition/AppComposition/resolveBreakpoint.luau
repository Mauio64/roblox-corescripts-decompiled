local parent = script:FindFirstAncestor("AppComposition").Parent
local Foundation = require(parent.Foundation)
local Breakpoint = Foundation.Enums.Breakpoint

local v = {
	[Breakpoint.XSmall] = 360,
	[Breakpoint.Small] = 600,
	[Breakpoint.Medium] = 1140,
	[Breakpoint.Large] = 1520,
	[Breakpoint.XLarge] = 1920,
	[Breakpoint.XXLarge] = 1e999
}

local v2 = {
	Breakpoint.XSmall,
	Breakpoint.Small,
	Breakpoint.Medium,
	Breakpoint.Large,
	Breakpoint.XLarge,
	Breakpoint.XXLarge
}

local function resolveBreakpoint(p: number)
	for _, v3 in v2 do
		if p <= (v[v3] or 0) then
			return v3
		end
	end

	return Breakpoint.XXLarge
end

return resolveBreakpoint
