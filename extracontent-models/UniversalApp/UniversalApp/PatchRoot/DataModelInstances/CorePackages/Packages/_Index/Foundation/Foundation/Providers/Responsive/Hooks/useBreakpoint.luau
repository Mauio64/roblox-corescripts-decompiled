local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local usePrevious = ReactUtils.usePrevious
local Wrappers = require(Foundation.Utility.Wrappers)
local instance = Wrappers.Instance

require(Foundation.Enums.Breakpoint)
local Constants = require(Foundation.Constants)
require(Foundation.Providers.Responsive.ResponsiveContext)
local useResponsive = require(Foundation.Providers.Responsive.useResponsive)
local withDefaults = require(Foundation.Utility.withDefaults)

local function calculateBreakpointFromWidth(breakpoint, x: number) -- 1 equivalent call inferred from this helper
	local v = breakpoint.order[#breakpoint.order]

	for _, v2 in breakpoint.order do
		if x <= breakpoint.widths[v2] then
			return v2
		end
	end

	return v
end

local function getBreakpointIndex(p, p2) -- 2 equivalent calls inferred from this helper
	return Dash.findIndex(p.order, function(p3): boolean
		return p3 == p2
	end)
end

local function shouldChangeBreakpoint(breakpoint, x: number, p, p2): boolean -- 1 equivalent call inferred from this helper
	if not p2 then
		return true
	end

	if p == p2 then
		return false
	end

	if getBreakpointIndex(breakpoint, p2) < getBreakpointIndex(breakpoint, p) then -- inferred equivalent call
		return breakpoint.widths[p2] + 5 < x
	end

	return x < breakpoint.widths[p] - 5
end

local function useBreakpoint(p, options)
	local v = withDefaults(options or {}, { throttleTime = Constants.DEFAULT_DELAY_TIME })

	local breakpoint = useResponsive().config.breakpoint

	local state, setState = React.useState(Vector2.zero)
	local breakpointFromWidth = calculateBreakpointFromWidth(breakpoint, state.X) -- inferred equivalent call

	local state2, setState2 = React.useState(breakpointFromWidth)
	local v2 = usePrevious(state2)

	local v3 = React.useMemo(function()
		return Dash.throttle(setState, v.throttleTime, { leading = true, trailing = true })
	end, { v.throttleTime })

	React.useEffect(function()
		local connection

		if p then
			connection = instance.GetPropertyChangedSignal(p, "AbsoluteSize"):Connect(function()
				v3(p.AbsoluteSize)
			end)
			setState(p.AbsoluteSize)
		else
			connection = nil
		end

		return function()
			if connection then
				connection:Disconnect()
			end
		end
	end, { p })

	React.useEffect(function()
		if shouldChangeBreakpoint(breakpoint, state.X, breakpointFromWidth, v2) then -- inferred equivalent call
			setState2(breakpointFromWidth)
		end
	end, { breakpoint, state.X, breakpointFromWidth, v2 })

	return state2, state
end

return useBreakpoint
