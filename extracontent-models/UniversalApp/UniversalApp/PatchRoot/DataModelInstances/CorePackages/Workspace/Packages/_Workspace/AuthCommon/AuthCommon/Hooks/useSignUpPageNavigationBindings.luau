local Parent = script:FindFirstAncestor("AuthCommon").Parent
local React = require(Parent.React)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local InputHandlers = require(Parent.InputHandlers)
local FFlagEnableConfirmSignifierOnSignUpPage = require(Parent.SharedFlags).FFlagEnableConfirmSignifierOnSignUpPage
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local t1 = {
	[Enum.KeyCode.ButtonA] = FocusNavigationEventNameEnum.Confirm,
	[Enum.KeyCode.Return] = FocusNavigationEventNameEnum.Confirm,
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useSignUpPageNavigationBindings(p1: ((...any) -> ...any)?) -- line: 20
	-- upvalues: React (copy), FFlagEnableConfirmSignifierOnSignUpPage (copy), ReactFocusNavigation (copy), t1 (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v11 = React.useCallback(function(p2) -- line: 22
		-- upvalues: p1 (copy)
		p2:cancel()

		if p2.eventData and p2.eventData.KeyCode == Enum.KeyCode.Unknown then
			return
		end

		if p1 then
			p1()
		end
	end, if not p1 then {} else { p1 })

	if FFlagEnableConfirmSignifierOnSignUpPage then
		local v12 = ReactFocusNavigation.useEventMap(t1)
		local v13 = React.useMemo(function() -- line: 35
			-- upvalues: FocusNavigationEventNameEnum (copy), v11 (copy), InputHandlers (copy)
			return {
				[FocusNavigationEventNameEnum.NavigateBack] = {
					handler = v11
				},
				[FocusNavigationEventNameEnum.Confirm] = {
					handler = InputHandlers.onRelease(function() -- line: 41
					end)
				}
			}
		end, {})

		return ReactFocusNavigation.useEventHandlerMap(v13, v12)
	end

	return (ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.NavigateBack, v11))
end

return useSignUpPageNavigationBindings
