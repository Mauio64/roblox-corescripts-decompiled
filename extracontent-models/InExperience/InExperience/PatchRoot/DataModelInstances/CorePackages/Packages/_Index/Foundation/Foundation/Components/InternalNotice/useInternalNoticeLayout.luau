local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Breakpoint = require(Foundation.Enums.Breakpoint)
local BreakpointConfig = require(Foundation.Utility.Responsive.BreakpointConfig)
require(Foundation.Components.Types)
local useAbsoluteSize = require(Foundation.Utility.useAbsoluteSize)

local width = BreakpointConfig.widths[Breakpoint.XSmall]

local function useInternalNoticeLayout(callback)
	local v, onNoticeAbsoluteSizeChanged = useAbsoluteSize(callback)

	local state, setState = React.useState(0)
	local measureInlineLink = React.useCallback(function(p)
		setState(p.AbsoluteSize.X)
	end, {})

	local state2, setState2 = React.useState(0)
	local onStackedColumnAbsoluteSizeChanged = React.useCallback(function(p)
		setState2(p.AbsoluteSize.X)
	end, {})
	local v2

	if v.X > 0 then
		v2 = v.X <= width
	else
		v2 = false
	end

	local v3 = v.X * 0.30000000000000004
	local v4 = v3 > 0 and v3 < state
	local isStacked = v2 or v4

	if isStacked then
		measureInlineLink = nil
	end

	return {
		isStacked = isStacked,
		onNoticeAbsoluteSizeChanged = onNoticeAbsoluteSizeChanged,
		onStackedColumnAbsoluteSizeChanged = onStackedColumnAbsoluteSizeChanged,
		measureInlineLink = measureInlineLink,
		stackedLinkConstraint = isStacked and state2 > 0 and {
			MaxSize = Vector2.new(state2, 1e999)
		} or nil
	}
end

return useInternalNoticeLayout
