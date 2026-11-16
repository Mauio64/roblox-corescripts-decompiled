local parent = script:FindFirstAncestor("AppBlox").Parent

local InputHandlers = require(parent.InputHandlers)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local React = require(parent.React)

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useCloseWithBackButton(p, callback)
	local v = React.useMemo(function()
		return InputHandlers.onRelease(function(object)
			if callback then
				callback()
				object:cancel()
			end
		end)
	end, { callback })

	local v2 = ReactFocusNavigation.useEventMap(navigateBacks, p)
	return (ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.NavigateBack, v, nil, v2))
end

return useCloseWithBackButton
