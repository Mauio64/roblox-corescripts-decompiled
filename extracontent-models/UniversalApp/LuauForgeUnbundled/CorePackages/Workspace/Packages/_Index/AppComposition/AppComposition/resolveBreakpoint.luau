local breakpoint = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/Foundation").Enums.Breakpoint

local v5 = {
	[breakpoint.XSmall] = 360,
	[breakpoint.Small] = 600,
	[breakpoint.Medium] = 1140,
	[breakpoint.Large] = 1520,
	[breakpoint.XLarge] = 1920,
	[breakpoint.XXLarge] = 1e999
}

local v6 = {
	breakpoint.XSmall,
	breakpoint.Small,
	breakpoint.Medium,
	breakpoint.Large,
	breakpoint.XLarge,
	breakpoint.XXLarge
}

local function resolveBreakpoint(p2)
	for k, v7 in v6 do
		if p2 <= (v5[v7] or 0) then
			return v7
		end
	end

	return breakpoint.XXLarge
end

return resolveBreakpoint
