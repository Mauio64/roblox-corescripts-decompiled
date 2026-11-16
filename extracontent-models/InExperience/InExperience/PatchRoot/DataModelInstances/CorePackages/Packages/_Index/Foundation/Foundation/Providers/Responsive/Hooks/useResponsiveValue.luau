local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Enums.Breakpoint)
require(Foundation.Providers.Responsive.ResponsiveContext)
require(Foundation.Components.Types)
local useBreakpoint = require(script.Parent.useBreakpoint)
local useResponsive = require(Foundation.Providers.Responsive.useResponsive)

local function useResponsiveValue(p, p2)
	local v = useBreakpoint(p)
	return p2[useResponsive().config.breakpoint.shortNames[v]]
end

return useResponsiveValue
