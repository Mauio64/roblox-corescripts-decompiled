local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent

local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local InputHandlers = require(parent.InputHandlers)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local function useOnNavigateBack(onNavigateBack, p)
	local v = React.useCallback(InputHandlers.onRelease(function(object)
		object:cancel()
		onNavigateBack()
	end), { onNavigateBack })

	return ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.NavigateBack, v, nil, p)
end

return {
	["useOnNavigateBack"] = useOnNavigateBack,
	OnNavigateBackWrapper = function(p)
		local ref = useOnNavigateBack(p.onNavigateBack)

		return React.createElement(
			"Frame",
			{
				ref = ref,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			},
			p.children
		)
	end
}
