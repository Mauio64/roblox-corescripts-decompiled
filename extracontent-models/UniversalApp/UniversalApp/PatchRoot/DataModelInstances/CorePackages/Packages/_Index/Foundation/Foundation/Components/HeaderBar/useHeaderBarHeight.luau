local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Enums.Breakpoint)
local constants = require(Foundation.Components.HeaderBar.constants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local useViewportBreakpoint = require(Foundation.Providers.Responsive.Hooks.useViewportBreakpoint)

local function useHeaderBarHeight()
	local v = useTokens()
	local v2 = useViewportBreakpoint()

	return v.Size[`Size_{constants.SIZE_BY_BREAKPOINT[v2]}`]
end

return useHeaderBarHeight
