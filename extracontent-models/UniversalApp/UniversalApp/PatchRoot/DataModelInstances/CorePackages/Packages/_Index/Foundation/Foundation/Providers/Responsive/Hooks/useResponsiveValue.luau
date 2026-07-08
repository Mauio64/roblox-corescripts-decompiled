local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Enums.Breakpoint)
require(Foundation.Providers.Responsive.ResponsiveContext)
require(Foundation.Components.Types)

local useBreakpoint = require(script.Parent.useBreakpoint)
local useResponsive = require(Foundation.Providers.Responsive.useResponsive)

local function useResponsiveValue(p1, p2) -- line: 14
	-- upvalues: useBreakpoint (copy), useResponsive (copy)
	local v7 = useBreakpoint(p1)

	return p2[useResponsive().config.breakpoint.shortNames[v7]]
end

return useResponsiveValue
