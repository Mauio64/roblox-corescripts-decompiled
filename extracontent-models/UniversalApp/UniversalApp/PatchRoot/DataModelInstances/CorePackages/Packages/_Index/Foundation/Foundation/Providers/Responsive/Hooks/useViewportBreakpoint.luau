local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Enums.Breakpoint)

local useBreakpoint = require(Foundation.Providers.Responsive.Hooks.useBreakpoint)
local useScreen = require(Foundation.Providers.Overlay.useScreen)

local function useViewportBreakpoint() -- line: 9
	-- upvalues: useScreen (copy), useBreakpoint (copy)
	local v5 = useScreen()

	return (useBreakpoint(v5))
end

return useViewportBreakpoint
