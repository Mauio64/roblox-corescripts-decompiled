local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Enums.Breakpoint)
local useBreakpoint = require(Foundation.Providers.Responsive.Hooks.useBreakpoint)
local useScreen = require(Foundation.Providers.Overlay.useScreen)

local function useViewportBreakpoint()
	return (useBreakpoint((useScreen())))
end

return useViewportBreakpoint
