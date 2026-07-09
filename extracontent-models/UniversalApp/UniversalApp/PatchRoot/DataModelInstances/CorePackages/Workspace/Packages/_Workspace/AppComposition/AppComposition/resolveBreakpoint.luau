local Parent = script:FindFirstAncestor("AppComposition").Parent
local Breakpoint = require(Parent.Foundation).Enums.Breakpoint
local t1 = {
	[Breakpoint.XSmall] = 360,
	[Breakpoint.Small] = 600,
	[Breakpoint.Medium] = 1140,
	[Breakpoint.Large] = 1520,
	[Breakpoint.XLarge] = 1920,
	[Breakpoint.XXLarge] = 1e999
}
local t2 = {
	Breakpoint.XSmall,
	Breakpoint.Small,
	Breakpoint.Medium,
	Breakpoint.Large,
	Breakpoint.XLarge,
	Breakpoint.XXLarge
}

local function resolveBreakpoint(n1: number) -- line: 26
	-- upvalues: t2 (copy), t1 (copy), Breakpoint (copy)
	for _, v8 in t2 do
		if n1 <= (t1[v8] or 0) then
			return v8
		end
	end

	return Breakpoint.XXLarge
end

return resolveBreakpoint
