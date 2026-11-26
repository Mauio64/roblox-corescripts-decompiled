local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/InputHandlers")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useDefaultFocusBehavior = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/ReactFocusNavigation").useDefaultFocusBehavior
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot

local composeRefs = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/FocusNavigation/composeRefs")
local useScrollNavigationBindings = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/FocusNavigation/useScrollNavigationBindings")

local function useFocusNavigationRefs(p2, p3)
	local v5 = useDefaultFocusBehavior()
	local v6 = useScrollNavigationBindings({ includeDiscreteScroll = false })

	local v10 = useAppFocusRoot({
		surfaceIdentifier = p2,
		customEventHandlers = {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(p3)
			}
		},
		isAutoFocusRoot = true
	})

	return (React.useMemo(function()
		return composeRefs(v10, v5, v6)
	end, { v10, v5, v6 }))
end

return useFocusNavigationRefs
