local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local FocusNavigationUtils = require(GenericAbuseReportingParent.FocusNavigationUtils)
local InputHandlers = require(GenericAbuseReportingParent.InputHandlers)
local React = require(GenericAbuseReportingParent.React)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useDefaultFocusBehavior = require(GenericAbuseReportingParent.ReactFocusNavigation).useDefaultFocusBehavior
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local composeRefs = require(script.Parent.composeRefs)
local useScrollNavigationBindings = require(script.Parent.useScrollNavigationBindings)
local FFlagAbuseReportV2ScrollNavigation = require(GenericAbuseReporting.Flags.FFlagAbuseReportV2ScrollNavigation)
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function mergeRefs(p1, p2) -- line: 26
	return function(p3) -- line: 27
		-- upvalues: p1 (copy), p2 (copy)
		if type(p1) == "function" then
			p1(p3)
		elseif p1 ~= nil then
			p1.current = p3
		end

		if type(p2) == "function" then
			p2(p3)

			return
		end

		if p2 ~= nil then
			p2.current = p3
		end
	end
end
local function useInExpFocusNavigationRefs(p4, p5, b1: boolean?, b2: boolean?) -- line: 55
	-- upvalues: useDefaultFocusBehavior (copy), FFlagAbuseReportV2ScrollNavigation (copy), useScrollNavigationBindings (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), useFocusRoot (copy), t1 (copy), React (copy), composeRefs (copy)
	local v21 = useDefaultFocusBehavior()
	local u22 = nil

	if FFlagAbuseReportV2ScrollNavigation then
		u22 = useScrollNavigationBindings()
	end

	local t2 = {
		[FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(p5)
		}
	}
	local v24 = useFocusRoot({
		surfaceIdentifier = p4,
		eventHandlers = t2,
		eventMap = t1,
		isFocusable = b2 == nil or b2,
		isAutoFocusRoot = b1 == nil or b1
	})

	return (React.useMemo(function() -- line: 82
		-- upvalues: FFlagAbuseReportV2ScrollNavigation (copy), composeRefs (copy), v24 (copy), v21 (copy), u22 (ref)
		if FFlagAbuseReportV2ScrollNavigation then
			return composeRefs(v24, v21, u22)
		end

		local v26 = v24
		local v27 = v21

		return function(p6) -- line: 27
			-- upvalues: v26 (copy), v27 (copy)
			if type(v26) == "function" then
				v26(p6)
			elseif v26 ~= nil then
				v26.current = p6
			end

			if type(v27) == "function" then
				v27(p6)

				return
			end

			if v27 ~= nil then
				v27.current = p6
			end
		end
	end, {
		v24,
		v21,
		if not FFlagAbuseReportV2ScrollNavigation then nil else u22
	}))
end

return useInExpFocusNavigationRefs
