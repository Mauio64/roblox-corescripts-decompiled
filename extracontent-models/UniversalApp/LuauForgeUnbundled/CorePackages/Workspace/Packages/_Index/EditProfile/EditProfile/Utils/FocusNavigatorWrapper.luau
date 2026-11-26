local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/InputHandlers")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/FocusNavigationUtils")
local focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local function FocusNavigatorWrapper(p2, p3)
	return React.createElement(focusNavigableSurfaceWrapper, {
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isIsolated = true,
		customEventHandlers = {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					p2.onClose()
					object:cancel()
				end)
			}
		}
	}, p3)
end

return FocusNavigatorWrapper
