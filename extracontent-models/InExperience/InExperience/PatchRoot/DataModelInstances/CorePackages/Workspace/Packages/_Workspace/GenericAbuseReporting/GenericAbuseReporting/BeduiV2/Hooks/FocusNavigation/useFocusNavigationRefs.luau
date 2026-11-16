local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local React = require(parent.React)

local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot

local composeRefs = require(script.Parent.composeRefs)
local useScrollNavigationBindings = require(script.Parent.useScrollNavigationBindings)

local function useFocusNavigationRefs(surfaceIdentifier, p)
	local v = useDefaultFocusBehavior()
	local v2 = useScrollNavigationBindings({ includeDiscreteScroll = false })

	local v3 = useAppFocusRoot({
		surfaceIdentifier = surfaceIdentifier,
		customEventHandlers = {
			[FocusNavigationEventNameEnum.NavigateBack] = { handler = InputHandlers.onRelease(p) }
		},
		isAutoFocusRoot = true
	})

	return (React.useMemo(function()
		return composeRefs(v3, v, v2)
	end, { v3, v, v2 }))
end

return useFocusNavigationRefs
