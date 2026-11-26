local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/InputHandlers")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useDefaultFocusBehavior = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/ReactFocusNavigation").useDefaultFocusBehavior
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local composeRefs = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/FocusNavigation/composeRefs")
local useScrollNavigationBindings = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/FocusNavigation/useScrollNavigationBindings")

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function useInExpFocusNavigationRefs(p2, p3, p4, p5)
	local v5 = useDefaultFocusBehavior()
	local v6 = useScrollNavigationBindings()

	local v8 = useFocusRoot({
		surfaceIdentifier = p2,
		eventHandlers = {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(p3)
			}
		},
		eventMap = navigateBacks,
		isFocusable = p5 == nil or p5,
		isAutoFocusRoot = p4 == nil or p4
	})

	return (React.useMemo(function()
		return composeRefs(v8, v5, v6)
	end, { v8, v5, v6 }))
end

return useInExpFocusNavigationRefs
