local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local FocusNavigationUtils = require(GenericAbuseReportingParent.FocusNavigationUtils)
local InputHandlers = require(GenericAbuseReportingParent.InputHandlers)
local React = require(GenericAbuseReportingParent.React)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useDefaultFocusBehavior = require(GenericAbuseReportingParent.ReactFocusNavigation).useDefaultFocusBehavior
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot
local composeRefs = require(script.Parent.composeRefs)
local useScrollNavigationBindings = require(script.Parent.useScrollNavigationBindings)
local FFlagAbuseReportV2ScrollNavigation = require(GenericAbuseReporting.Flags.FFlagAbuseReportV2ScrollNavigation)

local function mergeRefs(p1, p2) -- line: 22
	return function(p3) -- line: 23
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
local function useFocusNavigationRefs(p4, p5) -- line: 49
	-- upvalues: useDefaultFocusBehavior (copy), FFlagAbuseReportV2ScrollNavigation (copy), useScrollNavigationBindings (copy), useAppFocusRoot (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), React (copy), composeRefs (copy)
	local v18 = useDefaultFocusBehavior()
	local u19 = nil

	if FFlagAbuseReportV2ScrollNavigation then
		u19 = useScrollNavigationBindings({
			includeDiscreteScroll = false
		})
	end

	local v20 = useAppFocusRoot({
		isAutoFocusRoot = true,
		surfaceIdentifier = p4,
		customEventHandlers = {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(p5)
			}
		}
	})

	return (React.useMemo(function() -- line: 68
		-- upvalues: FFlagAbuseReportV2ScrollNavigation (copy), composeRefs (copy), v20 (copy), v18 (copy), u19 (ref)
		if FFlagAbuseReportV2ScrollNavigation then
			return composeRefs(v20, v18, u19)
		end

		local v22 = v20
		local v23 = v18

		return function(p6) -- line: 23
			-- upvalues: v22 (copy), v23 (copy)
			if type(v22) == "function" then
				v22(p6)
			elseif v22 ~= nil then
				v22.current = p6
			end

			if type(v23) == "function" then
				v23(p6)

				return
			end

			if v23 ~= nil then
				v23.current = p6
			end
		end
	end, {
		v20,
		v18,
		if not FFlagAbuseReportV2ScrollNavigation then nil else u19
	}))
end

return useFocusNavigationRefs
