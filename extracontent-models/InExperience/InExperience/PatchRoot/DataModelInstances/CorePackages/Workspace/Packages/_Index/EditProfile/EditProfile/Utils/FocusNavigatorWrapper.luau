local parent = script:FindFirstAncestor("EditProfile").Parent
local React = require(parent.React)
local InputHandlers = require(parent.InputHandlers)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local function FocusNavigatorWrapper(p, p2)
	return React.createElement(FocusNavigableSurfaceWrapper, {
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isIsolated = true,
		customEventHandlers = {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					p.onClose()
					object:cancel()
				end)
			}
		}
	}, p2)
end

return FocusNavigatorWrapper
