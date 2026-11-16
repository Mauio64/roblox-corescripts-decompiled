local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/InputHandlers")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/ReactFocusNavigation")
local focusNavigationEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/FocusNavigationUtils").FocusNavigationEventNameEnum
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function useCloseWithBackButton(p2, callback)
	local v5 = React.useMemo(function()
		return InputHandlers.onRelease(function(object)
			if callback then
				callback()
				object:cancel()
			end
		end)
	end, { callback })

	local v6 = ReactFocusNavigation.useEventMap(navigateBacks, p2)
	return (ReactFocusNavigation.useEventHandler(focusNavigationEventNameEnum.NavigateBack, v5, nil, v6))
end

return useCloseWithBackButton
