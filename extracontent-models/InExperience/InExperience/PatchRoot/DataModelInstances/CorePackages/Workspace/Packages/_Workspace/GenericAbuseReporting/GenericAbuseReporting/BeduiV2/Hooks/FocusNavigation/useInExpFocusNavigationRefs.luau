local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local React = require(parent.React)

local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local composeRefs = require(script.Parent.composeRefs)
local useScrollNavigationBindings = require(script.Parent.useScrollNavigationBindings)

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useInExpFocusNavigationRefs(surfaceIdentifier, p, flag: boolean?, flag2: boolean?)
	local v = useDefaultFocusBehavior()
	local v2 = useScrollNavigationBindings()

	local v3 = useFocusRoot({
		surfaceIdentifier = surfaceIdentifier,
		eventHandlers = {
			[FocusNavigationEventNameEnum.NavigateBack] = { handler = InputHandlers.onRelease(p) }
		},
		eventMap = navigateBacks,
		isFocusable = flag2 == nil or flag2,
		isAutoFocusRoot = flag == nil or flag
	})

	return (React.useMemo(function()
		return composeRefs(v3, v, v2)
	end, { v3, v, v2 }))
end

return useInExpFocusNavigationRefs
