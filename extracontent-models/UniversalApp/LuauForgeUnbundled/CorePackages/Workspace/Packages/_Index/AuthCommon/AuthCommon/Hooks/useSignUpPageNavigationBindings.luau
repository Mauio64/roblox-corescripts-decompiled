local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/ReactFocusNavigation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/InputHandlers")
local fFlagEnableConfirmSignifierOnSignUpPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagEnableConfirmSignifierOnSignUpPage

local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local v5 = {
	[Enum.KeyCode.ButtonA] = focusNavigationEventNameEnum.Confirm,
	[Enum.KeyCode.Return] = focusNavigationEventNameEnum.Confirm,
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function useSignUpPageNavigationBindings(callback)
	local v6 = React.useCallback(function(object)
		object:cancel()

		if object.eventData and object.eventData.KeyCode == Enum.KeyCode.None then
			return
		end

		if callback then
			callback()
		end
	end, callback and { callback } or {})

	if not fFlagEnableConfirmSignifierOnSignUpPage then
		return (ReactFocusNavigation.useEventHandler(focusNavigationEventNameEnum.NavigateBack, v6))
	end

	local v7 = ReactFocusNavigation.useEventMap(v5)
	local v8 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = { handler = v6 },
			[focusNavigationEventNameEnum.Confirm] = {
				handler = InputHandlers.onRelease(function() end)
			}
		}
	end, {})

	return ReactFocusNavigation.useEventHandlerMap(v8, v7)
end

return useSignUpPageNavigationBindings
