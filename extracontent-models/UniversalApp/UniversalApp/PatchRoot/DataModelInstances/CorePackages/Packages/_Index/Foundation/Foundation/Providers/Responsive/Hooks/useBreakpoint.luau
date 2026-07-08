local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)
local usePrevious = require(FoundationParent.ReactUtils).usePrevious
local Instance = require(Foundation.Utility.Wrappers).Instance

require(Foundation.Enums.Breakpoint)

local Constants = require(Foundation.Constants)

require(Foundation.Providers.Responsive.ResponsiveContext)

local useResponsive = require(Foundation.Providers.Responsive.useResponsive)
local withDefaults = require(Foundation.Utility.withDefaults)

local function calculateBreakpointFromWidth(p1, n1: number) -- line: 28
	local v16 = p1.order[#p1.order]

	for _, v18 in p1.order do
		if n1 <= p1.widths[v18] then
			return v18
		end
	end

	return v16
end
local function getBreakpointIndex(p2, p3) -- line: 41
	-- upvalues: Dash (copy)
	return Dash.findIndex(p2.order, function(p4) -- line: 42
		-- upvalues: p3 (copy)
		return p4 == p3
	end)
end
local function shouldChangeBreakpoint(p5, n2: number, p6, p7) -- line: 47
	-- upvalues: Dash (copy)
	if not p7 then
		return true
	end

	if p6 == p7 then
		return false
	end

	if Dash.findIndex(p5.order, function(p8) -- line: 42
		-- upvalues: p7 (copy)
		return p8 == p7
	end) < Dash.findIndex(p5.order, function(p9) -- line: 42
		-- upvalues: p6 (copy)
		return p9 == p6
	end) then
		return n2 > p5.widths[p7] + 5
	end

	return n2 < p5.widths[p6] - 5
end
local function useBreakpoint(p10, t1: {[any]: any}?) -- line: 74
	-- upvalues: withDefaults (copy), Constants (copy), useResponsive (copy), React (copy), usePrevious (copy), Dash (copy), Instance (copy)
	local v27 = withDefaults(t1 or {}, {
		throttleTime = Constants.DEFAULT_DELAY_TIME
	})
	local breakpoint = useResponsive().config.breakpoint
	local v29, v30 = React.useState(Vector2.zero)
	local X = v29.X
	local v32 = breakpoint.order[#breakpoint.order]

	for _, v34 in breakpoint.order do
		if X <= breakpoint.widths[v34] then
			v32 = v34

			break
		end
	end

	local v35 = v32
	local v36, v37 = React.useState(v35)
	local v38 = usePrevious(v36)
	local v39 = React.useMemo(function() -- line: 87
		-- upvalues: Dash (copy), v30 (copy), v27 (copy)
		return Dash.throttle(v30, v27.throttleTime, {
			leading = true,
			trailing = true
		})
	end, { v27.throttleTime })

	React.useEffect(function() -- line: 94
		-- upvalues: p10 (copy), Instance (copy), v39 (copy), v30 (copy)
		local connection = nil

		if p10 then
			connection = Instance.GetPropertyChangedSignal(p10, "AbsoluteSize"):Connect(function() -- line: 98
				-- upvalues: v39 (copy), p10 (copy)
				v39(p10.AbsoluteSize)
			end)
			v30(p10.AbsoluteSize)
		end

		return function() -- line: 104
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, { p10 })
	React.useEffect(function() -- line: 111
		-- upvalues: breakpoint (copy), v29 (copy), v35 (copy), v38 (copy), Dash (copy), v37 (copy)
		local v44 = breakpoint
		local X2 = v29.X
		local v46 = v35
		local v47 = v38

		if not v47 or v46 ~= v47 and if not (Dash.findIndex(v44.order, function(p11) -- line: 42
			-- upvalues: v47 (copy)
			return p11 == v47
		end) < Dash.findIndex(v44.order, function(p12) -- line: 42
			-- upvalues: v46 (copy)
			return p12 == v46
		end)) then X2 < v44.widths[v46] - 5 else X2 > v44.widths[v47] + 5 then
			v37(v35)
		end
	end, {
		breakpoint,
		v29.X,
		v35,
		v38
	})

	return v36, v29
end

return useBreakpoint
