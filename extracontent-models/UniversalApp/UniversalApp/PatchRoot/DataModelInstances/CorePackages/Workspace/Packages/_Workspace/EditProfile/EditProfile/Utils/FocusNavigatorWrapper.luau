local Parent = script:FindFirstAncestor("EditProfile").Parent
local React = require(Parent.React)
local InputHandlers = require(Parent.InputHandlers)
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local function FocusNavigatorWrapper(t1: {[any]: any}, p1) -- line: 14
	-- upvalues: React (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	return React.createElement(FocusNavigableSurfaceWrapper, {
		isIsolated = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		customEventHandlers = {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p2) -- line: 20
					-- upvalues: t1 (copy)
					t1.onClose()
					p2:cancel()
				end)
			}
		}
	}, p1)
end

return FocusNavigatorWrapper
