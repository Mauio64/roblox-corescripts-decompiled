local parent = script:FindFirstAncestor("AuthCommon").Parent

local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableConfirmSignifierOnSignUpPage = SharedFlags.FFlagEnableConfirmSignifierOnSignUpPage

local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local v = {
	[Enum.KeyCode.ButtonA] = FocusNavigationEventNameEnum.Confirm,
	[Enum.KeyCode.Return] = FocusNavigationEventNameEnum.Confirm,
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useSignUpPageNavigationBindings(callback)
	local handler = React.useCallback(function(object)
		object:cancel()

		if object.eventData and object.eventData.KeyCode == Enum.KeyCode.None then
			return
		end

		if callback then
			callback()
		end
	end, callback and { callback } or {})

	if not FFlagEnableConfirmSignifierOnSignUpPage then
		return (ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.NavigateBack, handler))
	end

	local v2 = ReactFocusNavigation.useEventMap(v)
	local v3 = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = { handler = handler },
			[FocusNavigationEventNameEnum.Confirm] = {
				handler = InputHandlers.onRelease(function() end)
			}
		}
	end, {})

	return ReactFocusNavigation.useEventHandlerMap(v3, v2)
end

return useSignUpPageNavigationBindings
