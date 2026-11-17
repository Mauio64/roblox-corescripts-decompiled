local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Enums.Breakpoint)
local Flags = require(Foundation.Utility.Flags)
local ViewportBreakpointContext = require(Foundation.Providers.Overlay.ViewportBreakpointContext)
local useBreakpoint = require(Foundation.Providers.Responsive.Hooks.useBreakpoint)
local useResponsive = require(Foundation.Providers.Responsive.useResponsive)
local useScreen = require(Foundation.Providers.Overlay.useScreen)

local function useViewportBreakpoint()
	local v = useScreen()

	if not Flags.FoundationSharedViewportBreakpoint then
		return (useBreakpoint(v))
	end

	local v2 = React.useContext(ViewportBreakpointContext)
	local breakpoint = useResponsive().config.breakpoint

	if not v2 or v2.screen ~= v or v2.breakpointConfig ~= breakpoint then
		v2 = nil
	end

	local register

	if v2 then
		register = v2.register
	else
		register = nil
	end

	React.useLayoutEffect(function()
		if register then
			return (register())
		end

		return nil
	end, { register })

	if v2 then
		v = nil
	end

	local v3 = useBreakpoint(v)

	return if v2 then v2.breakpoint else v3
end

return useViewportBreakpoint
