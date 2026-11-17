local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Enums.Breakpoint)
require(script.Parent.ViewportBreakpointContext)
local useBreakpoint = require(Foundation.Providers.Responsive.Hooks.useBreakpoint)
local useResponsive = require(Foundation.Providers.Responsive.useResponsive)

local function useSharedViewportBreakpoint(screen)
	local state, setState = React.useState(false)
	local ref = React.useRef(0)
	local breakpoint = useResponsive().config.breakpoint
	local v

	if state then
		v = screen
	end

	local breakpoint2 = useBreakpoint(v)

	local register = React.useCallback(function()
		ref.current += 1
		setState(true)

		return function()
			ref.current -= 1

			if ref.current == 0 then
				setState(false)
			end
		end
	end, {})

	return React.useMemo(function()
		return {
			screen = screen,
			breakpointConfig = breakpoint,
			breakpoint = breakpoint2,
			register = register
		}
	end, { screen, breakpoint, breakpoint2, register })
end

return useSharedViewportBreakpoint
