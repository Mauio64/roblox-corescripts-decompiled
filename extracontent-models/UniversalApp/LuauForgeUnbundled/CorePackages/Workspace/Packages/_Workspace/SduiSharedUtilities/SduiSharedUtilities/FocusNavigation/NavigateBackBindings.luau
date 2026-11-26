local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/ReactFocusNavigation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/InputHandlers")
local focusNavigationEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/FocusNavigationUtils").FocusNavigationEventNameEnum

local function useOnNavigateBack(onNavigateBack, p2)
	local v6 = React.useCallback(InputHandlers.onRelease(function(object)
		object:cancel()
		onNavigateBack()
	end), { onNavigateBack })

	return ReactFocusNavigation.useEventHandler(focusNavigationEventNameEnum.NavigateBack, v6, nil, p2)
end

return {
	["useOnNavigateBack"] = useOnNavigateBack,
	OnNavigateBackWrapper = function(p2)
		local v6 = useOnNavigateBack(p2.onNavigateBack)

		return React.createElement(
			"Frame",
			{
				ref = v6,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			},
			p2.children
		)
	end
}
